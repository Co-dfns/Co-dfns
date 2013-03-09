#include <stdio.h>
#include <stdlib.h>

#include "pool.h"
#include "ast.h"
#include "parser.h"
#include "lift_constants.h"

#define INIT_POOL_SIZE 1024

char *usage = {
	"Invalid options. Command line summary:\n"
	"\t%s :: inputfile outputfile\n"
};

void
print_usage(char *progname) 
{
	fprintf(stderr, usage, progname);
	exit(EXIT_FAILURE);
}

void
run_passes(Module **ast, Pool **p)
{
	print_module (*ast);
	lift_constants(ast, p);

	return;
}

int
main(int argc, char *argv[])
{
	FILE *ifile;
	Module *m;
	Pool *p;

	if (argc != 3) print_usage(*argv);

	if ((ifile = fopen(argv[1], "r")) == NULL) {
		perror(*argv);
		exit(EXIT_FAILURE);
	}

	if ((p = new_pool(INIT_POOL_SIZE)) == NULL) {
		fprintf(stderr, "%s: failed to create memory pool for parsing", *argv);
		exit(EXIT_FAILURE);
	}

	if ((m = parse_file(p, ifile)) == NULL) {
		fprintf(stderr, "%s: failed to parse %s", *argv, argv[1]);
		exit(EXIT_FAILURE);
	}

	run_passes(&m, &p);
	print_module(m);
	pool_dispose(p);

	return 0;
}
