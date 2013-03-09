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

enum function_type {
	FUNCTION_VAR, FUNCTION_LIT
};

typedef struct ast_function {
	enum function_type type;
	void *body;
} Function;

typedef struct ast_variable {
	char *name;
} Variable;

typedef struct ast_integer {
	long value;
} Integer;

void print_module(Module *);
void print_global(Global *);
void print_function(Function *);
void print_constant(Constant *);
void print_variable(Variable *);

Module *new_module(Pool *, int);
Global *new_global(Pool *, Variable *, enum global_type, void *);
Constant *new_constant(Pool *, int);
Function *new_function(Pool *, enum function_type, void *);
Variable *new_variable(Pool *, char *, int);
Integer *new_int(Pool *, long int);

Module *copy_module(Pool *, Module *);
Global *copy_global(Pool *, Global *);
Constant *copy_constant(Pool *, Constant *);
Function *copy_function(Pool *, Function *);
Variable *copy_variable(Pool *, Variable *);
Integer *copy_int(Pool *, Integer *);

