#include "stdafx.h"

#include <boost/spirit/include/qi.hpp>
#include <boost/spirit/include/phoenix.hpp>
#include <boost/spirit/include/support.hpp>

#include "ast.h"

namespace qi = boost::spirit::qi;

using qi::standard_wide::blank_type;
using qi::standard_wide::alpha;
using qi::standard_wide::alnum;
using qi::standard_wide::digit;
using qi::lit;
using qi::standard_wide::char_;
using qi::uint_;
using qi::double_;
using qi::lexeme;
using qi::labels::_val;
using qi::labels::_1;
using qi::labels::_2;
using qi::labels::_3;
using qi::labels::_4;
using qi::labels::_a;
using qi::eps;
using boost::phoenix::val;
using boost::phoenix::construct;

template <typename Iterator>
struct Grammar : qi::grammar<Iterator, Module(), blank_type>
{
	Grammar() : Grammar::base_type(module, "Module") 
	{
		module      %= -splitters >> definitions >> -splitters;
		definitions %= assignment % splitters;
		assignment  %= var_assign | fn_assign | strnd_assgn;
		fn_assign   %= variable >> L'←' >> function;
		function    %= L'{' >> -splitters >> -statements >> -splitters >> L'}';
		statements  %= (cond_stmt | fn_assign | expression) % splitters;
		cond_stmt   %= expression >> L':' >> (var_assign | fn_assign | expression);

		expression  %= dyadicapp | monadicapp | var_assign | strnd_assgn | singlevalue;
		strnd_assgn %= ((L'(' >> var_strand >> L')') | var_strand) >> L'←' >> expression;
		var_assign  %= variable >> L'←' >> expression;
		dyadicapp   %= singlevalue >> fnval >> expression;
		monadicapp  %= fnval >> expression;
		fnval       %= fnprim | function | L'(' >> fnval >> L')';

		singlevalue %= indexed | nonindexed; 
		nonindexed  %= literal | variable | L'(' >> expression >> L')';
		indexed      = nonindexed [_val = _1] >> +bracket [_val = construct<IndexRef>(_val, _1)];
		bracket     %= L'[' >> (idxexp % L';') >> L']';
		idxexp       = expression [_val = _1] | eps [_val = EmptyIndex()];
		literal     %= array;
		var_strand  %= +(variable | par_strand);
		par_strand  %= L'(' >> var_strand >> L')';
		array       %= array_par | array_strnd | empty | array_mixed | array_num | array_char;
		array_strnd %= *(empty | number | array_char) >> array_par 
			>> *(array_par | empty | number | array_char);
		array_par   %= (L'(' >> number >> L')') | (L'(' >> empty >> L')')
			| (L'(' >> array_char >> L')')
			| (L'(' >> array >> L')');
		array_mixed %= (+number >> array_char >> *(number | array_char))
			| (+array_char >> number >> *(number | array_char));
		array_char  %= lexeme[L'\'' >> *~char_(L'\'') >> L'\''];
		array_num   %= +number;

		empty        = lit(L'⍬') [_val = std::vector<Value>()];
		variable    %= varstring | alpha | omega;
		varstring   %= lexeme[char_("a-zA-Z_") >> *char_("a-zA-Z_0-9")];
		alpha        = lit(L'⍺') [_val = L"⍺"];
		omega        = lit(L'⍵') [_val = L"⍵"];
		number      %= floating | integer;
		integer      = lexeme[L'¯' >> uint_][_val = -1 * _1] | uint_ [_val = _1];
		floating     = &dblstr >> ((lit(L'¯') >> double_)[_val = - _1] | double_[_val = _1]);
		dblstr      %= lexeme[-lit(L'¯') >> +digit >> char_(L'.') >> +digit];
		splitters    = +(newline | lit(L'⋄'));
		newline      = (lit(L'\r') >> L'\n') | L'\n';

		fnprim.add
			(L"+", PRIM_FN_PLUS)
			(L"!", PRIM_FN_BANG)
			(L"×", PRIM_FN_TIMES)
			(L"÷", PRIM_FN_DIVIDE)
			(L"⍴", PRIM_FN_RHO)
			(L"⊂", PRIM_FN_ENCLOSE)
			(L"=", PRIM_FN_EQUAL)
			(L",", PRIM_FN_COMMA)
			(L"⍳", PRIM_FN_IOTA)
			;

		module.name("Module");
		definitions.name("Top-level Definitions");
		assignment.name("Assignment");
		var_assign.name("Variable Assignment");
		fn_assign.name("Function Definition");
		strnd_assgn.name("Stranded Assignment");
		var_strand.name("Stranded Variables");
		function.name("Function");
		statements.name("Statements");
		expression.name("Expression");
		indexed.name("Indexed Expression");
		bracket.name("Bracket index");
		idxexp.name("Dimension index expression");
		monadicapp.name("Monadic Application");
		dyadicapp.name("Dyadic Application");
		fnval.name("Function Value");
		fnprim.name("Primitive Function");
		array_strnd.name("Stranded Array");
		array_mixed.name("Mixed Array");
		array_char.name("Character Array or Scalar");
		array_num.name("Number Array");
		empty.name("Empty Array");
		variable.name("Variable");
		varstring.name("Variable Name/String");
		alpha.name("Alpha");
		omega.name("Omega");
		number.name("Number");
		integer.name("Integer");
		floating.name("Floating-point");
		dblstr.name("Floating-point format check");
		splitters.name("Statement separators");
		newline.name("Newline");

		qi::on_error<qi::rethrow>(
			module, 
			std::cerr << val("Failed to parse ") 
				<< _4
				<< val(" here \"")
				<< construct<std::string>(_3, _2)
				<< val("\"") << std::endl
		);

	}

	qi::rule<Iterator, Module(), blank_type> module;
	qi::rule<Iterator, std::vector<Assignment>(), blank_type> definitions;
	qi::rule<Iterator, Assignment(), blank_type> assignment;
	qi::rule<Iterator, VarAssignment(), blank_type> var_assign;
	qi::rule<Iterator, FnAssignment(), blank_type> fn_assign;
	qi::rule<Iterator, StrandAssignment(), blank_type> strnd_assgn;
	qi::rule<Iterator, std::vector<VariableStrand>(), blank_type> var_strand;
	qi::rule<Iterator, VariableStrand(), blank_type> par_strand;
	qi::rule<Iterator, FnDef(), blank_type> function;
	qi::rule<Iterator, std::vector<Statement>(), blank_type> statements;
	qi::rule<Iterator, CondStatement(), blank_type> cond_stmt;
	qi::rule<Iterator, Expression(), blank_type> expression;
	qi::rule<Iterator, Expression(), blank_type> indexed;
	qi::rule<Iterator, std::vector<IndexExpression>(), blank_type> bracket;
	qi::rule<Iterator, IndexExpression(), blank_type> idxexp;
	qi::rule<Iterator, Expression(), blank_type> nonindexed;
	qi::rule<Iterator, MonadicApp(), blank_type> monadicapp;
	qi::rule<Iterator, DyadicApp(), blank_type> dyadicapp;
	qi::rule<Iterator, FnValue(), blank_type> fnval;
	qi::rule<Iterator, Expression(), blank_type> singlevalue;
	qi::rule<Iterator, Literal(), blank_type> literal;
	qi::rule<Iterator, Value(), blank_type> array;
	qi::rule<Iterator, std::vector<Value>(), blank_type> array_strnd;
	qi::rule<Iterator, Value(), blank_type> array_par;
	qi::rule<Iterator, std::vector<Value>(), blank_type> array_mixed;
	qi::rule<Iterator, std::wstring(), blank_type> array_char;
	qi::rule<Iterator, std::vector<Value>(), blank_type> array_num;
	qi::rule<Iterator, std::vector<Value>(), blank_type> empty;
	qi::rule<Iterator, Variable(), blank_type> variable;
	qi::rule<Iterator, std::wstring(), blank_type> varstring;
	qi::rule<Iterator, std::wstring(), blank_type> alpha;
	qi::rule<Iterator, std::wstring(), blank_type> omega;
	qi::rule<Iterator, Value(), blank_type> number;
	qi::rule<Iterator, long(), blank_type> integer;
	qi::rule<Iterator, double(), blank_type> floating;
	qi::rule<Iterator, std::wstring(), blank_type> dblstr;
	qi::rule<Iterator, blank_type> splitters;
	qi::rule<Iterator, blank_type> newline;
	qi::symbols<wchar_t, FnPrimitive> fnprim;
};