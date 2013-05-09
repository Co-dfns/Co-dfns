#include "stdafx.h"

#include <boost/spirit/include/qi.hpp>
#include <boost/spirit/include/phoenix.hpp>
#include <boost/spirit/include/support.hpp>

#include "ast.h"

namespace qi = boost::spirit::qi;

using qi::standard_wide::alpha;
using qi::standard_wide::alnum;
using qi::standard_wide::digit;
using qi::standard_wide::char_;
using qi::uint_;
using qi::double_;
using qi::lexeme;
using qi::_val;
using qi::_1;
using qi::_2;
using qi::_3;
using qi::_4;
using qi::_a;
using qi::_b;
using qi::_c;
using qi::_r1;
using qi::eps;
using qi::lit;
using qi::eol;
using qi::eoi;
using qi::omit;
using boost::phoenix::val;
using boost::phoenix::construct;
using qi::standard_wide::blank_type;
using qi::standard_wide::blank;

template <typename Iterator>
struct Comment : qi::grammar<Iterator>
{
	Comment() : Comment::base_type(start) 
	{
		start = blank | (L'⍝' >> *(char_ - eol));
	}

	qi::rule<Iterator> start;
};

template <typename Iterator>
struct Grammar : qi::grammar<Iterator, Module(), Comment<Iterator>>
{
	Grammar() : Grammar::base_type(module, "Module") 
	{
		module      %= -splitters >> definitions >> -splitters;
		definitions %= assignment % splitters;
		assignment  %= fn_assign | var_assign | strnd_assgn;
		fn_assign   %= variable >> L'←' >> fnval >> &splitters;
		function    %= L'{' >> -splitters >> -statements >> -splitters >> L'}';
		statements  %= (cond_stmt | fn_assign | expression) % splitters;
		cond_stmt   %= expression >> L':' >> (fn_assign | expression);

		expression  %= dyadicapp | monadicapp | var_assign | strnd_assgn | singlevalue;
		strnd_assgn %= ((L'(' >> var_strand >> L')') | var_strand) >> L'←' >> expression;
		var_assign  %= variable >> L'←' >> expression;
		dyadicapp   %= singlevalue >> fnval >> expression;
		monadicapp  %= fnval >> expression;
		fnbase      %= fnprim | function | L'(' >> fnval >> L')';
		fnval       %= fncase | outcase | valcase;
		fncase      %= omit[fnbase [_a = _1]] >> optail(_a);
		outcase     %= omit[outer [_b = _1] >> fnbase [_a = _1]] 
			>> optail(construct<MonadicOper>(_a, _b));
		valcase     %= omit[singlevalue [_a = _1] >> jot [_b = _1] >> fnbase [_c = _1]] 
			>> optail(construct<DyadicOper>(_a, _b, _c));
		optail      %= dyaopfn(_r1) | dyaopval(_r1) | monop(_r1) | nooper(_r1);
		dyaopfn     %= omit[(inner | jot | power) [_a = _1] >> fnbase [_b = _1]]
			>> optail(construct<DyadicOper>(_r1, _a, _b));
		dyaopval    %= omit[(jot | power) [_a = _1] >> singlevalue [_b = _1]]
			>> optail(construct<DyadicOper>(_r1, _a, _b));
		monop       %= omit[monopprim [_a = _1]] 
			>> optail(construct<MonadicOper>(_r1, _a));
		nooper       = eps [_val = _r1];

		singlevalue %= indexed | nonindexed; 
		nonindexed  %= literal | variable | L'(' >> expression >> L')';
		indexed      = nonindexed [_val = _1] >> +bracket [_val = construct<IndexRef>(_val, _1)];
		bracket     %= L'[' > (idxexp % L';') > L']';
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

		inner        = lit(L'.') [_val = PRIM_OP_INNER];
		outer        = (lit(L'∘') >> L'.') [_val = PRIM_OP_OUTER];
		jot          = lit(L'∘') [_val = PRIM_OP_COMPOSE];
		power        = lit(L'⍣') [_val = PRIM_OP_POWER];
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
			(L"⊃", PRIM_FN_DISCLOSE)
			(L"=", PRIM_FN_EQUAL)
			(L",", PRIM_FN_COMMA)
			(L"⍳", PRIM_FN_IOTA)
			(L"∇", PRIM_FN_NABLA)
			(L"-", PRIM_FN_MINUS)
			(L"?", PRIM_FN_HOOK)
			;

		monopprim.add
			(L"⍨", PRIM_OP_COMMUTE)
			(L"¨", PRIM_OP_EACH)
			(L"/", PRIM_OP_REDUCE)
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

	qi::rule<Iterator, Module(), Comment<Iterator>> module;
	qi::rule<Iterator, std::vector<Assignment>(), Comment<Iterator>> definitions;
	qi::rule<Iterator, Assignment(), Comment<Iterator>> assignment;
	qi::rule<Iterator, VarAssignment(), Comment<Iterator>> var_assign;
	qi::rule<Iterator, FnAssignment(), Comment<Iterator>> fn_assign;
	qi::rule<Iterator, StrandAssignment(), Comment<Iterator>> strnd_assgn;
	qi::rule<Iterator, std::vector<VariableStrand>(), Comment<Iterator>> var_strand;
	qi::rule<Iterator, VariableStrand(), Comment<Iterator>> par_strand;
	qi::rule<Iterator, FnDef(), Comment<Iterator>> function;
	qi::rule<Iterator, std::vector<Statement>(), Comment<Iterator>> statements;
	qi::rule<Iterator, CondStatement(), Comment<Iterator>> cond_stmt;
	qi::rule<Iterator, Expression(), Comment<Iterator>> expression;
	qi::rule<Iterator, Expression(), Comment<Iterator>> indexed;
	qi::rule<Iterator, std::vector<IndexExpression>(), Comment<Iterator>> bracket;
	qi::rule<Iterator, IndexExpression(), Comment<Iterator>> idxexp;
	qi::rule<Iterator, Expression(), Comment<Iterator>> nonindexed;
	qi::rule<Iterator, MonadicApp(), Comment<Iterator>> monadicapp;
	qi::rule<Iterator, DyadicApp(), Comment<Iterator>> dyadicapp;
	qi::rule<Iterator, FnValue(), Comment<Iterator>> fnval;
	qi::rule<Iterator, FnValue(), Comment<Iterator>> fnbase;
	qi::rule<Iterator, FnValue(), qi::locals<FnValue>, Comment<Iterator>> fncase;
	qi::rule<Iterator, FnValue(), qi::locals<FnValue, OpPrimitive>, Comment<Iterator>> outcase;
	qi::rule<Iterator, FnValue(), qi::locals<Expression, OpPrimitive, FnValue>, Comment<Iterator>> valcase;
	qi::rule<Iterator, FnValue(FnValue), qi::locals<OpPrimitive, FnValue>, Comment<Iterator>> dyaopfn;
	qi::rule<Iterator, FnValue(FnValue), qi::locals<OpPrimitive, Expression>, Comment<Iterator>> dyaopval;
	qi::rule<Iterator, FnValue(FnValue), qi::locals<OpPrimitive>, Comment<Iterator>> monop;
	qi::rule<Iterator, FnValue(FnValue), Comment<Iterator>> nooper;
	qi::rule<Iterator, FnValue(FnValue), Comment<Iterator>> optail;
	qi::rule<Iterator, Expression(), Comment<Iterator>> singlevalue;
	qi::rule<Iterator, Literal(), Comment<Iterator>> literal;
	qi::rule<Iterator, Value(), Comment<Iterator>> array;
	qi::rule<Iterator, std::vector<Value>(), Comment<Iterator>> array_strnd;
	qi::rule<Iterator, Value(), Comment<Iterator>> array_par;
	qi::rule<Iterator, std::vector<Value>(), Comment<Iterator>> array_mixed;
	qi::rule<Iterator, std::wstring(), Comment<Iterator>> array_char;
	qi::rule<Iterator, std::vector<Value>(), Comment<Iterator>> array_num;
	qi::rule<Iterator, std::vector<Value>(), Comment<Iterator>> empty;
	qi::rule<Iterator, Variable(), Comment<Iterator>> variable;
	qi::rule<Iterator, std::wstring(), Comment<Iterator>> varstring;
	qi::rule<Iterator, std::wstring(), Comment<Iterator>> alpha;
	qi::rule<Iterator, std::wstring(), Comment<Iterator>> omega;
	qi::rule<Iterator, Value(), Comment<Iterator>> number;
	qi::rule<Iterator, long(), Comment<Iterator>> integer;
	qi::rule<Iterator, double(), Comment<Iterator>> floating;
	qi::rule<Iterator, std::wstring(), Comment<Iterator>> dblstr;
	qi::rule<Iterator, OpPrimitive(), Comment<Iterator>> jot;
	qi::rule<Iterator, OpPrimitive(), Comment<Iterator>> inner;
	qi::rule<Iterator, OpPrimitive(), Comment<Iterator>> power;
	qi::rule<Iterator, OpPrimitive(), Comment<Iterator>> outer;
	qi::rule<Iterator, Comment<Iterator>> splitters;
	qi::rule<Iterator, Comment<Iterator>> newline;
	qi::symbols<wchar_t, FnPrimitive> fnprim;
	qi::symbols<wchar_t, OpPrimitive> monopprim;
};