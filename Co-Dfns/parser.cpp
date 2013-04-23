#include "stdafx.h"

#include <boost/spirit/include/qi.hpp>
#include <boost/spirit/include/phoenix.hpp>

#include "Parser.h"
#include "Grammar.h"

using boost::spirit::qi::standard_wide::blank;

Module Parser::parse()
{
	Module m;
	Grammar<std::wstring::const_iterator> grammar;
	auto iter = input.begin();
	auto end = input.end();
	
	bool res = phrase_parse(iter, end, grammar, blank, m);

	if (res && iter == end)
		return m;
	else
		throw SyntaxError("Failed to parse", iter);
}

Parser::Parser(std::wstring str)
{
	input = str;
}

SyntaxError::SyntaxError(std::string msg, std::wstring::const_iterator dat)
{
	message = msg;
	unparsed = dat;
}