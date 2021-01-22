#include "pch.h"

EXPORT
int compile(char *fname)
{
	printf("Compiling %s...\n", fname);

	load_apl(0, 0, NULL);
	APL_CHAR_ARRAY_PARAM(aplfn, fname, 0, AP_NULLTERM);
	int res = call_apl(L"#.codfns.Compile", &aplfn, PARAM_END);

	return res;
}