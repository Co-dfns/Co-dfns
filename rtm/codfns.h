#pragma once

#include <stddef.h>
#include <stdint.h>

#define EXPORT __declspec(dllexport)
#ifdef EXPORTING
	#define DECLSPEC EXPORT
#else
	#define DECLSPEC __declspec(dllimport)
#endif

enum cell_type {
	CELL_VOID,
	CELL_VOID_BOX,
	CELL_ARRAY, 
	CELL_ARRAY_BOX,
	CELL_FUNC,
	CELL_FUNC_BOX,
	CELL_MOPER_BOX,
	CELL_DOPER_BOX,
	CELL_ENV_BOX,
};

enum array_type {
	ARR_SPAN,
	ARR_BOOL, 
	ARR_SINT, 
	ARR_INT, 
	ARR_DBL, 
	ARR_CMPX,
	ARR_CHAR8, 
	ARR_CHAR16, 
	ARR_CHAR32,
	ARR_MIXED, 
	ARR_NESTED,
	ARR_MAX
};

enum array_storage {
	STG_HOST, STG_DEVICE
};

typedef int (*func_ptr)(struct cell_array **,
    struct cell_array *, struct cell_array *, struct cell_func *);
    
typedef int (*topfn_ptr)(struct cell_array **, 
    struct cell_array *, struct cell_array *);

struct cell_void {
	enum cell_type ctyp;
	unsigned int refc;
};

struct apl_cmpx {
	double real;
	double imag;
};

struct cell_array {
	enum cell_type ctyp;
	unsigned int refc;
	enum array_storage storage;
	enum array_type type;
	void *values;
	unsigned int *vrefc;
	unsigned int rank;
	size_t shape[];
};

struct cell_func {
	enum cell_type ctyp;
	unsigned int refc;
	func_ptr fptr;
	unsigned int fs;
	void *fv[];
};

#define DECL_BOX_STRUCT(type)		\
struct cell_##type##_box {		\
	enum cell_type ctyp;		\
	unsigned int refc;		\
	struct cell_##type *value;	\
};

DECL_BOX_STRUCT(void);
DECL_BOX_STRUCT(array);
DECL_BOX_STRUCT(func);

/* DWA and Interface */
DECLSPEC int set_dwafns(void *);
DECLSPEC int call_dwa(topfn_ptr, void *, void *, void *);

/* Generic cell handlers */
DECLSPEC void release_cell(void *);
DECLSPEC void *retain_cell(void *);

/* Basic VOID type */
DECLSPEC int mk_void(struct cell_void **);
DECLSPEC void release_void(struct cell_void *);
DECLSPEC int mk_void_box(struct cell_void_box **, struct cell_void *);
DECLSPEC void release_void_box(struct cell_void_box *);

/* ARRAY type */
DECLSPEC int mk_array(struct cell_array **, 
    enum array_type, enum array_storage, unsigned int);
DECLSPEC void release_array(struct cell_array *);
DECLSPEC int mk_array_box(struct cell_array_box **, struct cell_array *);
DECLSPEC void release_array_box(struct cell_array_box *);
DECLSPEC int fill_array(struct cell_array *, void *);

/* FUNC type */
DECLSPEC int mk_func_box(struct cell_func_box **, struct cell_func *);
DECLSPEC void release_func_box(struct cell_func_box *);
DECLSPEC int mk_func(struct cell_func **, func_ptr, unsigned int);
DECLSPEC void release_func(struct cell_func *);
DECLSPEC int apply_mop(struct cell_func **, struct cell_func *, void *);
DECLSPEC int apply_dop(struct cell_func **, struct cell_func *, void *, void *);
DECLSPEC int guard_check(struct cell_array *);
DECLSPEC void release_env(void **, void **);

/* Runtime initialization function */
DECLSPEC int cdf_prim_init(void);

/* Runtime structure */
#ifndef EXPORTING
DECLSPEC struct cdf_prim_loc {
	unsigned int __count;
	wchar_t **__names;
	struct cell_func *q_signal;
	struct cell_func *q_dr;
	struct cell_func *q_veach;
	struct cell_func *q_ambiv;
	struct cell_func *squeeze;
	struct cell_func *is_simple;
	struct cell_func *is_numeric;
	struct cell_func *is_integer;
	struct cell_func *max_shp;
	struct cell_func *has_nat_vals;
	struct cell_func *chk_scl;
	struct cell_func *chk_valid_shape;
	struct cell_func *both_simple;
	struct cell_func *both_numeric;
	struct cell_func *numeric;
	struct cell_func *scalar;
	struct cell_func *rgt;
	struct cell_func *lft;
	struct cell_func *reshape;
	struct cell_func *rho;
	struct cell_func *cat;
	struct cell_func *eqv;
	struct cell_func *nqv;
	struct cell_func *materialize;
	struct cell_func *index;
	struct cell_func *sqd;
	struct cell_func *index_gen;
	struct cell_func *index_of;
	struct cell_func *iot;
	struct cell_func *dis;
	struct cell_func *par;
	struct cell_func *conjugate;
	struct cell_func *add;
	struct cell_func *negate;
	struct cell_func *sub;
	struct cell_func *sign;
	struct cell_func *mul;
	struct cell_func *recip;
	struct cell_func *div;
	struct cell_func *exp;
	struct cell_func *split;
	struct cell_func *drop;
	struct cell_func *drp;
	struct cell_func *reverse_last;
	struct cell_func *rotate_last;
	struct cell_func *rot;
	struct cell_func *map_monadic;
	struct cell_func *map_dyadic;
	struct cell_func *map;
	struct cell_func *rdf;
	struct cell_func *dot;
} cdf_prim;
#endif

