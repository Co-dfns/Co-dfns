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

enum primitive {
	PRM_MINUS,	/* - */
	PRM_PLUS,	/* + */
	PRM_LT,		/* < */
	PRM_LTE,	/* ≤ */
	PRM_EQ,		/* = */
	PRM_GTE,	/* ≥ */
	PRM_GT,		/* > */
	PRM_NEQ,	/* ≠ */
	PRM_AND,	/* ∧ */
	PRM_OR,		/* ∨ */
	PRM_TIMES,	/* × */
	PRM_DIV,	/* ÷ */
	PRM_HOOK,	/* ? */
	PRM_MEM,	/* ∊ */
	PRM_RHO,	/* ⍴ */
	PRM_NOT,	/* ~ */
	PRM_TAKE,	/* ↑ */
	PRM_DROP,	/* ↓ */
	PRM_IOTA,	/* ⍳ */
	PRM_CIRC,	/* ○ */
	PRM_POW,	/* * */
	PRM_CEIL,	/* ⌈ */
	PRM_FLOOR,	/* ⌊ */
	PRM_DEL,	/* ∇ */
	PRM_RGT,	/* ⊢ */
	PRM_LFT,	/* ⊣ */
	PRM_ENCL,	/* ⊂ */
	PRM_DIS,	/* ⊃ */
	PRM_INTER,	/* ∩ */
	PRM_UNION,	/* ∪ */
	PRM_ENC,	/* ⊤ */
	PRM_DEC,	/* ⊥ */
	PRM_ABS,	/* | */
	PRM_EXPNF,	/* ⍀ */
	PRM_FILF,	/* ⌿ */
	PRM_GRDD,	/* ⍒ */
	PRM_GRDU,	/* ⍋ */
	PRM_ROT,	/* ⌽ */
	PRM_TRANS,	/* ⍉ */
	PRM_ROTF,	/* ⊖ */
	PRM_LOG,	/* ⍟ */
	PRM_NAND,	/* ⍲ */
	PRM_NOR,	/* ⍱ */
	PRM_BANG,	/* ! */
	PRM_MDIV,	/* ⌹ */
	PRM_FIND,	/* ⍸ */
	PRM_SQUAD,	/* ⌷ */
	PRM_EQV,	/* ≡ */
	PRM_NEQV,	/* ≢ */
	PRM_CATF,	/* ⍪ */
	PRM_FIL,	/* / */
	PRM_EXPND,	/* \ */
	PRM_CAT,	/* , */
	PRM_HAT		/* ^ */
};

typedef struct ast_application {
	enum primitive fn;
	struct ast_expr *lft;
	struct ast_expr *rgt;
} Application;

typedef struct ast_primitive {
	enum primitive value;
} Primitive;

typedef struct ast_variable {
	char *name;
} Variable;

typedef struct ast_integer {
	long value;
} Integer;

void print_module(FILE *, Module *);
void print_global(FILE *, Global *);
void print_function(FILE *, Function *);
void print_expression(FILE *, Expression *);
void print_application(FILE *, Application *);
void print_constant(FILE *, Constant *);
void print_variable(FILE *, Variable *);
void print_primitive(FILE *, enum primitive);

Module *new_module(Pool *, int);
Global *new_global(Pool *, Variable *, enum global_type, void *);
Constant *new_constant(Pool *, int);
Function *new_function(Pool *, Expression **, int);
Application *new_application(Pool *, enum primitive, Expression *, Expression *);
Expression *new_expression(Pool *, enum expr_type, Variable *, void *);
Variable *new_variable(Pool *, char *, int);
Integer *new_int(Pool *, long int);
Primitive *new_primitive(Pool *, enum primitive);

Module *copy_module(Pool *, Module *);
Global *copy_global(Pool *, Global *);
Constant *copy_constant(Pool *, Constant *);
Function *copy_function(Pool *, Function *);
Application *copy_application(Pool *, Application *);
Expression *copy_expression(Pool *, Expression *);
Variable *copy_variable(Pool *, Variable *);
Integer *copy_int(Pool *, Integer *);
Primitive *copy_primitive(Pool *, Primitive *);

