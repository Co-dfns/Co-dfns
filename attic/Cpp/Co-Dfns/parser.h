#pragma once

#include "stdafx.h"
#include "ast.h"

struct SyntaxError : std::exception
{
	std::string message;
	std::wstring::const_iterator unparsed;
	SyntaxError(std::string, std::wstring::const_iterator);
};

class Parser
{
public:
	Module parse();
	Parser(std::wstring str);
private:
	std::wstring input;
};

