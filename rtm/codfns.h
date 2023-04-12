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
	CELL_MOPER,
	CELL_MOPER_BOX,
	CELL_DOPER,
	CELL_DOPER_BOX,
	CELL_ENV_BOX,
	CELL_MAX
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
	STG_HOST, STG_DEVICE, STG_MAX
};

typedef int (*func_mon)(struct cell_array **,
    struct cell_array *, struct cell_func *);

typedef int (*func_dya)(struct cell_array **,
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
	func_mon fptr_mon;
	func_dya fptr_dya;
	void **opts;
	void **fv;
	unsigned int fs;
	void *fv_[];
};

struct cell_moper {
	enum cell_type ctyp;
	unsigned int refc;
	func_mon fptr_am;
	func_dya fptr_ad;
	func_mon fptr_fm;
	func_dya fptr_fd;
	unsigned int fs;
	void *fv[];
};

struct cell_doper {
	enum cell_type ctyp;
	unsigned int refc;
	func_mon fptr_aam;
	func_dya fptr_aad;
	func_mon fptr_afm;
	func_dya fptr_afd;
	func_mon fptr_fam;
	func_dya fptr_fad;
	func_mon fptr_ffm;
	func_dya fptr_ffd;
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

/* Error Handling */
DECLSPEC struct cell_array *debug_info;
DECLSPEC void debug_trace(int, const char *, int, const char *, const wchar_t *);

#define CHK(expr, fail, msg)					\
if (0 < (err = (expr))) {					\
	debug_trace(err, __FILE__, __LINE__, __func__, msg);	\
	goto fail;						\
}								\

#define CHKAF(expr, fail)					\
if (0 < (err = (expr))) {					\
	wchar_t *msg = get_aferr_msg(err);			\
	debug_trace(err, __FILE__, __LINE__, __func__, msg);	\
	free(msg);						\
	goto fail;						\
}								\

#define TRC(expr, msg)						\
if (0 < (err = (expr))) {					\
	debug_trace(err, __FILE__, __LINE__, __func__, msg);	\
}								\

#define TRCAF(expr)					\
if (0 < (err = (expr))) {					\
	wchar_t *msg = get_aferr_msg(err);			\
	debug_trace(err, __FILE__, __LINE__, __func__, msg);	\
	free(msg);						\
}								\

/* DWA and Interface */
DECLSPEC int set_dwafns(void *);
DECLSPEC int call_dwa(topfn_ptr, void *, void *, void *, const wchar_t *);

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
DECLSPEC int release_array(struct cell_array *);
DECLSPEC int mk_array_box(struct cell_array_box **, struct cell_array *);
DECLSPEC void release_array_box(struct cell_array_box *);
DECLSPEC int alloc_array(struct cell_array *);
DECLSPEC int fill_array(struct cell_array *, void *);
DECLSPEC int chk_array_valid(struct cell_array *);

/* FUNC types */
DECLSPEC int mk_func_box(struct cell_func_box **, struct cell_func *);
DECLSPEC void release_func_box(struct cell_func_box *);
DECLSPEC int mk_func(struct cell_func **, func_mon, func_dya, unsigned int);
DECLSPEC void release_func(struct cell_func *);
DECLSPEC int guard_check(struct cell_array *);
DECLSPEC void release_env(void **, void **);
DECLSPEC int mk_moper(struct cell_moper **, 
    func_mon, func_dya, func_mon, func_dya,
    unsigned int);
DECLSPEC int mk_doper(struct cell_doper **, 
    func_mon, func_dya, func_mon, func_dya,
    func_mon, func_dya, func_mon, func_dya,
    unsigned int);
DECLSPEC void release_moper(struct cell_moper *);
DECLSPEC void release_doper(struct cell_doper *);
DECLSPEC int mk_moper_box(struct cell_moper_box **, struct cell_moper *);
DECLSPEC void release_moper_box(struct cell_moper_box *);
DECLSPEC int mk_doper_box(struct cell_doper_box **, struct cell_doper *);
DECLSPEC void release_doper_box(struct cell_doper_box *);
DECLSPEC int apply_mop(struct cell_func **, struct cell_moper *, 
    func_mon, func_dya, void *);
DECLSPEC int apply_dop(struct cell_func **, struct cell_doper *, 
    func_mon, func_dya, void *, void *);
DECLSPEC int derive_func_opts(struct cell_func **, struct cell_func *, int);

/* Runtime initialization function */
DECLSPEC int cdf_prim_init(void);

/* Runtime primitives */
#ifndef EXPORTING
DECLSPEC struct cdf_prim_loc {
	unsigned int __count;
	wchar_t **__names;
	struct cell_func *q_signal;
	struct cell_func *q_dr;
	struct cell_func_box *squeeze;
	struct cell_func_box *is_simple;
	struct cell_func_box *is_numeric;
	struct cell_func_box *is_char;
	struct cell_func_box *is_integer;
	struct cell_func_box *is_bool;
	struct cell_func_box *max_shp;
	struct cell_func_box *has_nat_vals;
	struct cell_func_box *chk_scl;
	struct cell_func_box *chk_valid_shape;
	struct cell_func_box *both_simple;
	struct cell_func_box *both_numeric;
	struct cell_func_box *both_integer;
	struct cell_func_box *both_char;
	struct cell_func_box *both_bool;
	struct cell_func_box *any;
	struct cell_moper *numeric;
	struct cell_doper *ambiv;
	struct cell_func_box *same;
	struct cell_moper_box *veach;
	struct cell_moper *scalar;
	struct cell_func *set;
	struct cell_func *brk;
	struct cell_func *rgt;
	struct cell_func *lft;
	struct cell_func *reshape;
	struct cell_func *rho;
	struct cell_func *cat;
	struct cell_func *depth;
	struct cell_func *eqv;
	struct cell_func *nqv;
	struct cell_func_box *index;
	struct cell_func *sqd;
	struct cell_func *index_gen;
	struct cell_func *index_of;
	struct cell_func *iot;
	struct cell_func *dis;
	struct cell_func *enclose;
	struct cell_func *par;
	struct cell_func *conjugate;
	struct cell_func *add;
	struct cell_func *sub;
	struct cell_func *sign;
	struct cell_func *mul;
	struct cell_func *div;
	struct cell_func *absolute;
	struct cell_func *residue;
	struct cell_func *res;
	struct cell_func *floor_array;
	struct cell_func *min;
	struct cell_func *ceil_array;
	struct cell_func *max;
	struct cell_func *exp;
	struct cell_func *log;
	struct cell_func *pitimes;
	struct cell_func *trig;
	struct cell_func *cir;
	struct cell_func *binomial;
	struct cell_func *fac;
	struct cell_func *notscl;
	struct cell_func *without;
	struct cell_func *not;
	struct cell_func *logand;
	struct cell_func *and;
	struct cell_func *logor;
	struct cell_func *lor;
	struct cell_func *nan;
	struct cell_func *nor;
	struct cell_func *lessthan;
	struct cell_func *lth;
	struct cell_func *lesseql;
	struct cell_func *lte;
	struct cell_func_box *eql_vec;
	struct cell_func *equal;
	struct cell_func *eql;
	struct cell_func *greatereql;
	struct cell_func *gte;
	struct cell_func *greaterthan;
	struct cell_func *gth;
	struct cell_func *firstocc;
	struct cell_func_box *neq_vec;
	struct cell_func *noteq;
	struct cell_func *neq;
	struct cell_func *mix;
	struct cell_func *take;
	struct cell_func *tke;
	struct cell_func *split;
	struct cell_func *drop;
	struct cell_func *drp;
	struct cell_func *reverse_last;
	struct cell_func *rotate_last;
	struct cell_func *rot;
	struct cell_moper *com;
	struct cell_moper *map;
	struct cell_moper_box *reduce;
	struct cell_moper_box *nwreduce;
	struct cell_moper *rdf;
	struct cell_func *rpf;
	struct cell_doper *dot;
	struct cell_moper *oup;
	struct cell_doper *pow;
	struct cell_doper *jot;
} cdf_prim;

#endif

