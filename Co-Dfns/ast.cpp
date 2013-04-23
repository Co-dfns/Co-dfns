#include "ast.h"

bool operator==(const VarAssignment& a, const VarAssignment& b)
{
	bool tgts = a.target == b.target;
	bool exps = a.expr == b.expr;
	return tgts && exps;
}

bool operator==(const FnAssignment& a, const FnAssignment& b)
{
	bool tgts = a.target == b.target;
	bool fns = a.function == b.function;
	return tgts && fns;
}

bool operator==(const StrandAssignment& a, const StrandAssignment& b)
{
	bool tgts = a.target == b.target;
	bool exps = a.expr == b.expr;
	return tgts && exps;
}

bool operator==(const FnDef& a, const FnDef& b)
{
	return a.statements == b.statements;
}

bool operator==(const Variable& a, const Variable& b)
{
	return a.name == b.name;
}

bool operator==(const MonadicApp& a, const MonadicApp& b)
{
	bool right = a.right == b.right;
	bool fn = a.function == b.function;
	return right && fn;
}

bool operator==(const DyadicApp& a, const DyadicApp& b)
{
	bool left = a.left == b.left;
	bool right = a.right == b.right;
	bool fn = a.function == b.function;
	return left && right && fn;
}

bool operator==(const Module& a, const Module& b)
{
	return a.definitions == b.definitions;
}

bool operator==(const Literal& a, const Literal& b)
{
	return a.value == b.value;
}

bool operator==(const CondStatement& a, const CondStatement& b)
{
	bool ts = a.test == b.test;
	bool ss = a.statement == b.statement;
	return ts && ss;
}

bool operator==(const IndexRef& a, const IndexRef& b)
{
	bool s = a.source == b.source;
	bool i = a.indexes == b.indexes;
	return s && i;
}

bool operator==(const EmptyIndex& a, const EmptyIndex& b)
{
	return true;
}