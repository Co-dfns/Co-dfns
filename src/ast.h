typedef struct ast_module {
	int count;
	struct ast_global **globals;
} Module;

enum global_type {
	GLOBAL_FUNC, GLOBAL_CONST
};

typedef struct ast_global {
	enum global_type type;
	struct ast_variable *var;
	void *value;
} Global;

typedef struct ast_constant {
	int count;
	long *elems;
} Constant;

typedef struct ast_function {
	int count;
	struct ast_expr **stmts;
} Function;

enum expr_type {
	EXPR_LIT, EXPR_VAR, EXPR_APP
};

typedef struct ast_expr {
	enum expr_type type;
	struct ast_variable *tgt;
	void *value;
} Expression; 

typedef struct ast_application {
	struct ast_variable *fn;
	struct ast_expr *lft;
	struct ast_expr *rgt;
} Application;

typedef struct ast_variable {
	char *name;
} Variable;

typedef struct ast_integer {
	long value;
} Integer;

void print_module(Module *);
void print_global(Global *);
void print_function(Function *);
void print_expression(Expression *);
void print_application(Application *);
void print_constant(Constant *);
void print_variable(Variable *);

Module *new_module(Pool *, int);
Global *new_global(Pool *, Variable *, enum global_type, void *);
Constant *new_constant(Pool *, int);
Function *new_function(Pool *, Expression **, int);
Application *new_application(Pool *, Variable *, Expression *, Expression *);
Expression *new_expression(Pool *, enum expr_type, Variable *, void *);
Variable *new_variable(Pool *, char *, int);
Integer *new_int(Pool *, long int);

Module *copy_module(Pool *, Module *);
Global *copy_global(Pool *, Global *);
Constant *copy_constant(Pool *, Constant *);
Function *copy_function(Pool *, Function *);
Application *copy_application(Pool *, Application *);
Expression *copy_expression(Pool *, Expression *);
Variable *copy_variable(Pool *, Variable *);
Integer *copy_int(Pool *, Integer *);

