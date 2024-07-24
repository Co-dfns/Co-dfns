#pragma once

#include <stddef.h>
#include <stdint.h>
#include <stdio.h>

#define UNICODE
#define _UNICODE

#ifdef _WIN32
 #define EXPORT __declspec(dllexport)
 #ifdef BUILD_CODFNS
	#define DECLSPEC EXPORT
 #else
	#define DECLSPEC __declspec(dllimport)
 #endif
#elif defined(__GNUC__)
 #define EXPORT __attribute__ ((visibility ("default")))
 #ifdef BUILD_CODFNS
	#define DECLSPEC EXPORT
 #else
	#define DECLSPEC extern __attribute__ ((visibility ("default")))
 #endif
#else
 #define EXPORT
 #define DECLSPEC
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
	CELL_DERF,
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

struct cell_func;
struct cell_array;

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

#define STATIC_RANK_MAX 5

struct cell_array {
	enum cell_type ctyp;
	unsigned int refc;
	enum array_storage storage;
	enum array_type type;
	void *values;
	unsigned int *vrefc;
	unsigned int rank;
	size_t shape[STATIC_RANK_MAX];
};

struct cell_func {
	enum cell_type ctyp;
	unsigned int refc;
	func_mon fptr_mon;
	func_dya fptr_dya;
	void **fv;
	unsigned int fs;
	void **opts;
	void *fv_[];
};

struct cell_derf {
	enum cell_type ctyp;
	unsigned int refc;
	func_mon fptr_mon;
	func_dya fptr_dya;
	void **fv;
	unsigned int fs;
	void **opts;
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

/* Error Handling */
DECLSPEC struct cell_array *get_debug_info(void);
DECLSPEC void release_debug_info(void);
DECLSPEC void debug_trace(int, const char *, int, const char *, const char *);

#define CHK(expr, fail, msg)					\
if (0 < (err = (expr))) {					\
	debug_trace(err, __FILE__, __LINE__, __func__, msg);	\
	goto fail;						\
}								\

#define CHKFN(expr, fail) CHK(expr, fail, "" #expr)
#define CHKIG(expr, fail) if (0 < (err = (expr))) goto fail;

#define TRC(expr, msg)						\
if (0 < (err = (expr))) {					\
	debug_trace(err, __FILE__, __LINE__, __func__, msg);	\
}								\

/* DWA and Interface */
DECLSPEC int set_dwafns(void *);
DECLSPEC int call_dwa(topfn_ptr, void *, void *, void *, char *);
DECLSPEC void print_cell_stats(void);
DECLSPEC void print_ibeam_stats(void);

/* Generic cell handlers */
DECLSPEC void release_cell(void *);
DECLSPEC void *retain_cell(void *);

/* Basic VOID type */
DECLSPEC int mk_void(struct cell_void **);
DECLSPEC void release_void(struct cell_void *);

/* ARRAY type */
DECLSPEC int mk_array(struct cell_array **,
    enum array_type, enum array_storage, unsigned int);
DECLSPEC int release_array(struct cell_array *);
DECLSPEC int alloc_array(struct cell_array *);
DECLSPEC int fill_array(struct cell_array *, void *);
DECLSPEC int chk_array_valid(struct cell_array *);
DECLSPEC int squeeze_array(struct cell_array *);

/* FUNC types */
DECLSPEC int mk_func(struct cell_func **, func_mon, func_dya, unsigned int);
DECLSPEC int mk_derf(struct cell_derf **, func_mon, func_dya, unsigned int);
DECLSPEC void release_func(struct cell_func *);
DECLSPEC void release_derf(struct cell_derf *);
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
DECLSPEC int derive_func_opts(struct cell_func **, struct cell_func *, int);

/* Calling helpers */
DECLSPEC int mk_array_int32(struct cell_array **, int32_t);
DECLSPEC int mk_nested_array(struct cell_array **, size_t count);
DECLSPEC int var_ref(void *);
DECLSPEC int guard_check(struct cell_array *);

/* Runtime initialization function */
DECLSPEC int cdf_prim_init(void);

/* Runtime primitives */
#ifndef BUILD_CODFNS
struct cdf_prim_loc {
	unsigned int __count;
	char **__names;
	struct cell_func *cdf_q_print_memstats;
	struct cell_func *cdf_q_signal;
	struct cell_func *cdf_q_dr;
	struct cell_array *cdf_spn;
	struct cell_array *cdf_ZILDE;
	struct cell_array *cdf_NUM_0;
	struct cell_array *cdf_NUM_1;
	struct cell_array *cdf_NUM_11;
	struct cell_array *cdf_NUM_80;
	struct cell_array *cdf_NUM_160;
	struct cell_array *cdf_NUM_163;
	struct cell_array *cdf_NUM_320;
	struct cell_array *cdf_NUM_323;
	struct cell_array *cdf_NUM_326;
	struct cell_array *cdf_NUM_645;
	struct cell_array *cdf_NUM_1289;
	struct cell_array *cdf_VEC_0;
	struct cell_doper *cdf_eq;
	struct cell_func *cdf_squeeze;
	struct cell_func *cdf_is_simple;
	struct cell_func *cdf_is_numeric;
	struct cell_func *cdf_is_char;
	struct cell_func *cdf_is_integer;
	struct cell_func *cdf_is_bool;
	struct cell_func *cdf_is_cmpx;
	struct cell_func *cdf_is_span;
	struct cell_func *cdf_has_nat_vals;
	struct cell_func *cdf_both_simple;
	struct cell_func *cdf_both_numeric;
	struct cell_func *cdf_both_integer;
	struct cell_func *cdf_both_char;
	struct cell_func *cdf_both_bool;
	struct cell_func *cdf_bitand;
	struct cell_func *cdf_scl_and;
	struct cell_func *cdf_scl_or;
	struct cell_func *cdf_any;
	struct cell_moper *cdf_numeric;
	struct cell_func *cdf_chk_scl;
	struct cell_doper *cdf_ambiv;
	struct cell_func *cdf_same;
	struct cell_moper *cdf_veach;
	struct cell_moper *cdf_scalar;
	struct cell_moper *cdf_scl_mon;
	struct cell_moper *cdf_chk_axis;
	struct cell_func *cdf_shape;
	struct cell_func *cdf_chk_valid_shape;
	struct cell_func *cdf_prototype;
	struct cell_func *cdf_reshape;
	struct cell_func *cdf_rho;
	struct cell_func *cdf_idx_rnk_check;
	struct cell_func *cdf_idx_rng_check;
	struct cell_func *cdf_set;
	struct cell_doper *cdf_mst_vals;
	struct cell_moper *cdf_mst;
	struct cell_func *cdf_materialize;
	struct cell_func *cdf_sqd_idx;
	struct cell_func *cdf_sqd;
	struct cell_func *cdf_brkmon;
	struct cell_func *cdf_brk;
	struct cell_func *cdf_rgt;
	struct cell_func *cdf_lftid;
	struct cell_func *cdf_left;
	struct cell_func *cdf_lft;
	struct cell_func *cdf_ravel;
	struct cell_func *cdf_catenate;
	struct cell_func *cdf_cat;
	struct cell_func *cdf_table;
	struct cell_func *cdf_catenatefirst;
	struct cell_func *cdf_ctf;
	struct cell_func *cdf_depth;
	struct cell_func *cdf_eqv;
	struct cell_func *cdf_tally;
	struct cell_func *cdf_notsame;
	struct cell_func *cdf_nqv;
	struct cell_func *cdf_index_gen;
	struct cell_func *cdf_index_of;
	struct cell_func *cdf_iot;
	struct cell_func *cdf_first;
	struct cell_func *cdf_pick;
	struct cell_func *cdf_dis;
	struct cell_func *cdf_enclose;
	struct cell_func *cdf_part_enc;
	struct cell_func *cdf_par;
	struct cell_func *cdf_nest;
	struct cell_func *cdf_partition;
	struct cell_func *cdf_nst;
	struct cell_func *cdf_conjugate;
	struct cell_func *cdf_plus;
	struct cell_func *cdf_add;
	struct cell_func *cdf_negate;
	struct cell_func *cdf_minus;
	struct cell_func *cdf_sub;
	struct cell_func *cdf_sign;
	struct cell_func *cdf_times;
	struct cell_func *cdf_mul;
	struct cell_func *cdf_recip;
	struct cell_func *cdf_divide;
	struct cell_func *cdf_div;
	struct cell_func *cdf_exponent;
	struct cell_func *cdf_power;
	struct cell_func *cdf_exp;
	struct cell_func *cdf_natlog;
	struct cell_func *cdf_logarithm;
	struct cell_func *cdf_log;
	struct cell_func *cdf_absolute;
	struct cell_func *cdf_residue;
	struct cell_func *cdf_res;
	struct cell_func *cdf_floor_array;
	struct cell_func *cdf_minimum;
	struct cell_func *cdf_min;
	struct cell_func *cdf_ceil_array;
	struct cell_func *cdf_maximum;
	struct cell_func *cdf_max;
	struct cell_func *cdf_pitimes;
	struct cell_func *cdf_trig;
	struct cell_func *cdf_cir;
	struct cell_func *cdf_factorial;
	struct cell_func *cdf_binomial;
	struct cell_func *cdf_fac;
	struct cell_func *cdf_notscl;
	struct cell_func *cdf_without;
	struct cell_func *cdf_not;
	struct cell_func *cdf_andmon;
	struct cell_func *cdf_logand;
	struct cell_func *cdf_and;
	struct cell_func *cdf_lormon;
	struct cell_func *cdf_rational;
	struct cell_func *cdf_gcd;
	struct cell_func *cdf_lcm;
	struct cell_func *cdf_logor;
	struct cell_func *cdf_lor;
	struct cell_func *cdf_nanmon;
	struct cell_func *cdf_lognan;
	struct cell_func *cdf_nan;
	struct cell_func *cdf_normon;
	struct cell_func *cdf_lognor;
	struct cell_func *cdf_nor;
	struct cell_func *cdf_lthmon;
	struct cell_func *cdf_lessthan;
	struct cell_func *cdf_lth;
	struct cell_func *cdf_ltemon;
	struct cell_func *cdf_lesseql;
	struct cell_func *cdf_lte;
	struct cell_func *cdf_eqlmon;
	struct cell_func *cdf_eql_vec;
	struct cell_func *cdf_equal;
	struct cell_func *cdf_eql;
	struct cell_func *cdf_gtemon;
	struct cell_func *cdf_greatereql;
	struct cell_func *cdf_gte;
	struct cell_func *cdf_gthmon;
	struct cell_func *cdf_greaterthan;
	struct cell_func *cdf_gth;
	struct cell_func *cdf_firstocc;
	struct cell_func *cdf_neq_vec;
	struct cell_func *cdf_noteq;
	struct cell_func *cdf_neq;
	struct cell_func *cdf_mix;
	struct cell_func *cdf_take;
	struct cell_func *cdf_tke;
	struct cell_func *cdf_split;
	struct cell_func *cdf_drop;
	struct cell_func *cdf_drp;
	struct cell_func *cdf_reverse_axis;
	struct cell_func *cdf_rotate_axis;
	struct cell_func *cdf_reverse_first;
	struct cell_func *cdf_rotate_first;
	struct cell_func *cdf_rtf;
	struct cell_func *cdf_reverse_last;
	struct cell_func *cdf_rotate_last;
	struct cell_func *cdf_rot;
	struct cell_func *cdf_transpose;
	struct cell_func *cdf_transpose_target;
	struct cell_func *cdf_trn;
	struct cell_func *cdf_gdu;
	struct cell_func *cdf_gdd;
	struct cell_func *cdf_encmon;
	struct cell_func *cdf_enc;
	struct cell_func *cdf_decmon;
	struct cell_func *cdf_dec;
	struct cell_func *cdf_enlist;
	struct cell_func *cdf_member;
	struct cell_func *cdf_mem;
	struct cell_func *cdf_fnd;
	struct cell_func *cdf_unique;
	struct cell_func *cdf_union;
	struct cell_func *cdf_unq;
	struct cell_func *cdf_intmon;
	struct cell_func *cdf_int;
	struct cell_func *cdf_stn;
	struct cell_func *cdf_deal;
	struct cell_func *cdf_roll;
	struct cell_func *cdf_rol;
	struct cell_func *cdf_matinv;
	struct cell_func *cdf_matdiv;
	struct cell_func *cdf_mdv;
	struct cell_moper *cdf_com;
	struct cell_moper *cdf_is_scalar;
	struct cell_moper *cdf_is_scalar_mon;
	struct cell_moper *cdf_is_scalar_dya;
	struct cell_moper *cdf_map;
	struct cell_moper *cdf_identity;
	struct cell_doper *cdf_reduce_axis;
	struct cell_doper *cdf_nwreduce_axis;
	struct cell_moper *cdf_reduce_first;
	struct cell_moper *cdf_nwreduce_first;
	struct cell_moper *cdf_rdf;
	struct cell_moper *cdf_reduce_last;
	struct cell_moper *cdf_nwreduce_last;
	struct cell_moper *cdf_red;
	struct cell_func *cdf_where_nz;
	struct cell_func *cdf_where;
	struct cell_func *cdf_interval_idx;
	struct cell_func *cdf_iou;
	struct cell_func *cdf_rpfmon;
	struct cell_func *cdf_rpf;
	struct cell_func *cdf_repmon;
	struct cell_func *cdf_rep;
	struct cell_doper *cdf_scan;
	struct cell_func *cdf_scfdya;
	struct cell_moper *cdf_scf;
	struct cell_func *cdf_scndya;
	struct cell_moper *cdf_scn;
	struct cell_func *cdf_xpfmon;
	struct cell_func *cdf_xpf;
	struct cell_func *cdf_xpdmon;
	struct cell_func *cdf_xpd;
	struct cell_moper *cdf_oup;
	struct cell_func *cdf_dot_prod;
	struct cell_func *cdf_matmul;
	struct cell_doper *cdf_dot;
	struct cell_doper *cdf_pow;
	struct cell_doper *cdf_jot;
	struct cell_doper *cdf_rnk;
	struct cell_doper *cdf_at;
	struct cell_moper *cdf_key;
	struct cell_func *cdf_fmt;
	struct cell_func *cdf_println;
	struct cell_func *cdf_print;
	struct cell_func *cdf_q_ts;
};


DECLSPEC struct cdf_prim_loc cdf_prim;
#endif

