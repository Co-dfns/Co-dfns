#include "pch.h"

#include <iostream>
#include <string>

EXPORT
int compile(char *fname)
{
	std::cout << "Compiling " << fname << "..." << std::endl;

	APL_CHAR_ARRAY_PARAM(aplfn, fname, 0, AP_NULLTERM);
	int res = call_apl(L"codfns.Compile", &aplfn, PARAM_END);

	return res;
}