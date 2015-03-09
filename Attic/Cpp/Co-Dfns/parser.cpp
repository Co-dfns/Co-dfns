#include "stdafx.h"

#include <boost/spirit/include/qi.hpp>
#include <boost/spirit/include/phoenix.hpp>

#include "Parser.h"
#include "Grammar.h"

Module Parser::parse()
{
	Module m;
	Grammar<std::wstring::const_iterator> grammar;
	Comment<std::wstring::const_iterator> comment;
	auto iter = input.begin();
	auto end = input.end();
	
	bool res = phrase_parse(iter, end, grammar, comment, m);

	if (res && iter == end)
		return m;
	else
		throw SyntaxError("Failed to parse", iter);
}

Parser::Parser(std::wstring str)
{
	if (str.back() != L'\n')
		str.push_back(L'\n');

	input = str;		
}

SyntaxError::SyntaxError(std::string msg, std::wstring::const_iterator dat)
{
	message = msg;
	unparsed = dat;
}