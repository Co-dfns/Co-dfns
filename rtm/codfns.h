#pragma once

#include <stddef.h>

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
	ARR_NESTED
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
        unsigned int rank;
        unsigned long long shape[];
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
DECL_BOX_STRUCT(moper);
DECL_BOX_STRUCT(doper);
DECL_BOX_STRUCT(env);

/* DWA and Interface */
DECLSPEC void set_codfns_error(void *);
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
DECLSPEC int mk_array(struct cell_array **, ...);
DECLSPEC void release_array(struct cell_array *);
DECLSPEC int mk_array_box(struct cell_array_box **, struct cell_array *);
DECLSPEC void release_array_box(struct cell_array_box *);

/* FUNC type */
DECLSPEC int mk_func_box(struct cell_func_box **, struct cell_func *);
DECLSPEC void release_func_box(struct cell_func_box *);
DECLSPEC int mk_func(struct cell_func **, func_ptr, unsigned int);
DECLSPEC void release_func(struct cell_func *);

/* MOPER type */
DECLSPEC int mk_moper_box(struct cell_moper_box **, struct cell_moper *);
DECLSPEC void release_moper_box(struct cell_moper_box *);

/* DOPER type */
DECLSPEC int mk_doper_box(struct cell_doper_box **, struct cell_doper *);
DECLSPEC void release_doper_box(struct cell_doper_box *);

/* ENV type */
DECLSPEC int mk_env_box(struct cell_env_box **, struct cell_env *);
DECLSPEC void release_env_box(struct cell_env_box *);

/* Runtime initialization function */
DECLSPEC int cdf_prim_init(void);

/* Runtime structure */
#ifndef EXPORTING
DECLSPEC struct cdf_prim_loc {
	int __count;
	wchar_t **__names;
	struct cell_func *rgt;
} cdf_prim;
#endif
