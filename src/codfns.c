#include <stdio.h>
#include <stdlib.h>

#include <llvm-c/Core.h>

#include "pool.h"
#include "ast.h"
#include "parser.h"
#include "lift_constants.h"
#include "generate_llvm.h"

#define INIT_POOL_SIZE 1024

const char *usage = {
	"Invalid options. Command line summary:\n"
	"\t%s :: inputfile outputfile\n"
};

void
print_usage(char *progname) 
{
	fprintf(stderr, usage, progname);
	exit(EXIT_FAILURE);
}

LLVMModuleRef
run_passes(Module **ast, Pool **p)
{
	print_module (*ast);
	lift_constants(ast, p);
	printf("lift_constants:\n");
	print_module(*ast);
	return generate_llvm(*ast, *p);
}

int
main(int argc, char *argv[])
{
	char *emsg, *ofn, *ifn;
	Module *m;
	Pool *p;
	LLVMModuleRef vm;

	if (argc != 3) print_usage(*argv);

	ifn = argv[1];
	ofn = argv[2];

	if ((p = new_pool(INIT_POOL_SIZE)) == NULL) {
		fprintf(stderr, "%s: failed to create memory pool for parsing\n", *argv);
		exit(EXIT_FAILURE);
	}

	if ((m = parse_file(p, ifn)) == NULL) {
		fprintf(stderr, "%s: failed to parse %s\n", *argv, argv[1]);
		exit(EXIT_FAILURE);
	}

	vm = run_passes(&m, &p);
	
	if (LLVMPrintModuleToFile(vm, ofn, &emsg)) {
		fprintf(stderr, "LLVM: %s\n", emsg);
		LLVMDisposeMessage(emsg);
		exit(EXIT_FAILURE);
	}

	printf("generate_llvm:\n");
	LLVMDumpModule(vm);

	return 0;
}
