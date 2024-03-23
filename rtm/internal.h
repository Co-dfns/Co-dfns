#include <arrayfire.h>

#include "codfns.h"

#define STORAGE_DEVICE_THRESHOLD 1024

wchar_t *get_aferr_msg(int);

void print_cp8(uint8_t *, size_t);
void print_cp16(uint16_t *, size_t);
void print_cp32(uint32_t *, size_t);

#define type_pair(src, dst) ((src * ARR_MAX) + dst)

enum array_type array_max_type(enum array_type, enum array_type);
af_dtype array_type_af_dtype(enum array_type);
af_dtype array_af_dtype(struct cell_array *);
enum array_type closest_numeric_array_type(double);

int cast_values(struct cell_array *, enum array_type);

int is_integer_dbl(double);
int is_integer_device(unsigned char *, af_array);
int is_integer_array(struct cell_array *);
int is_real_array(struct cell_array *);
int is_numeric_array(struct cell_array *);
int is_char_array(struct cell_array *);

int array_get_host_buffer(void **, int *, struct cell_array *);

int get_scalar_int8(int8_t *, struct cell_array *, size_t);
int get_scalar_int16(int16_t *, struct cell_array *, size_t);
int get_scalar_int32(int32_t *, struct cell_array *, size_t);
int get_scalar_dbl(double *, struct cell_array *, size_t);
int get_scalar_cmpx(struct apl_cmpx *, struct cell_array *, size_t);
int get_scalar_u64(size_t *, struct cell_array *, size_t);
int get_scalar_char8(uint8_t *, struct cell_array *, size_t);
int get_scalar_char16(uint16_t *, struct cell_array *, size_t);
int get_scalar_char32(uint32_t *, struct cell_array *, size_t);

int mk_array_int8(struct cell_array **, int8_t);
int mk_array_int16(struct cell_array **, int16_t);
int mk_array_int32(struct cell_array **, int32_t);
int mk_array_dbl(struct cell_array **, double);
int mk_array_real(struct cell_array **, double);
int mk_array_cmpx(struct cell_array **, struct apl_cmpx);
int mk_array_char8(struct cell_array **, uint8_t);
int mk_array_char16(struct cell_array **, uint16_t);
int mk_array_char32(struct cell_array **, uint32_t);
int mk_array_nested(struct cell_array **, struct cell_array *);

int has_integer_values(int *, struct cell_array *);
int has_natural_values(int *, struct cell_array *);

size_t array_count(struct cell_array *);
size_t array_values_count(struct cell_array *);
size_t array_values_bytes(struct cell_array *);
size_t array_element_size(struct cell_array *);
size_t array_element_size_type(enum array_type);
af_dtype array_af_dtype(struct cell_array *);

int array_shallow_copy(struct cell_array **, struct cell_array *);
int retain_array_data(struct cell_array *);
int release_array_data(struct cell_array *);
int array_is_same(int8_t *, struct cell_array *, struct cell_array *);
int array_promote_storage(struct cell_array *, struct cell_array *);
int array_migrate_storage(struct cell_array *, enum array_storage);

struct apl_cmpx cast_cmpx(double x);

#define cast_real_real(x)	(x)
#define cast_real_cmpx(x)	(x).real
#define cast_real_char(x)	((double)(x))
#define cast_real_cell(x)	0
#define cast_cmpx_real(x)	cast_cmpx(x)
#define cast_cmpx_cmpx(x)	(x)
#define cast_cmpx_char(x)	cast_cmpx(x)
#define cast_cmpx_cell(x)	cast_cmpx(0)
#define cast_char_real(x)	(x)
#define cast_char_cmpx(x)	(x).real
#define cast_char_char(x)	(x)
#define cast_char_cell(x)	0
#define cast_cell_real(x)	NULL
#define cast_cell_cmpx(x)	NULL
#define cast_cell_char(x)	NULL
#define cast_cell_cell(x)	(x)

#define DECL_FUNC(name, mon, dya)						\
struct cell_func name##_closure = {CELL_FUNC, 1, mon, dya, NULL, NULL, 0};	\
struct cell_func *cdf_##name = &name##_closure;					\

#define DECL_MOPER(name, am, ad, fm, fd)				\
struct cell_moper name##_closure = {CELL_MOPER, 1, am, ad, fm, fd, 0};	\
struct cell_moper *cdf_##name = &name##_closure;				\

#define DECL_DOPER(name, aam, aad, afm, afd, fam, fad, ffm, ffd)	\
struct cell_doper name##_closure = {CELL_DOPER, 1,			\
	aam, aad, afm, afd, fam, fad, ffm, ffd, 0			\
};									\
struct cell_doper *cdf_##name = &name##_closure;				\

#define MONADIC_TYPE_SWITCH(tp, expr, oper, fail)				\
switch ((tp)) {									\
case ARR_BOOL:	expr(oper, real, int8_t,	      int8,   fail);break;	\
case ARR_SINT:	expr(oper, real, int16_t,	      int16,  fail);break;	\
case ARR_INT:	expr(oper, real, int32_t,	      int32,  fail);break;	\
case ARR_DBL:	expr(oper, real, double,	      dbl,    fail);break;	\
case ARR_CMPX:	expr(oper, cmpx, struct apl_cmpx,     cmpx,   fail);break;	\
case ARR_CHAR8: expr(oper, char, uint8_t,	      char8,  fail);break;	\
case ARR_CHAR16:expr(oper, char, uint16_t,	      char16, fail);break;	\
case ARR_CHAR32:expr(oper, char, uint32_t,	      char32, fail);break;	\
case ARR_NESTED:expr(oper, cell, struct cell_array *, nested, fail);break;	\
default:									\
	CHK(99, fail, L"Unknown array type.");					\
}										\

#define DYADIC_TYPE_SWITCH(lt, rt, expr, oper, fail)											\
switch (type_pair((lt), (rt))) {													\
case type_pair(ARR_BOOL,   ARR_BOOL):  expr(oper, real, int8_t,		     int8,   real, int8_t	      , int8  , fail);break;	\
case type_pair(ARR_BOOL,   ARR_SINT):  expr(oper, real, int8_t,		     int8,   real, int16_t	      , int16 , fail);break;	\
case type_pair(ARR_BOOL,   ARR_INT):   expr(oper, real, int8_t,		     int8,   real, int32_t	      , int32 , fail);break;	\
case type_pair(ARR_BOOL,   ARR_DBL):   expr(oper, real, int8_t,		     int8,   real, double	      , dbl   , fail);break;	\
case type_pair(ARR_BOOL,   ARR_CMPX):  expr(oper, real, int8_t,		     int8,   cmpx, struct apl_cmpx    , cmpx  , fail);break;	\
case type_pair(ARR_BOOL,   ARR_CHAR8): expr(oper, real, int8_t,		     int8,   char, uint8_t	      , char8 , fail);break;	\
case type_pair(ARR_BOOL,   ARR_CHAR16):expr(oper, real, int8_t,		     int8,   char, uint16_t	      , char16, fail);break;	\
case type_pair(ARR_BOOL,   ARR_CHAR32):expr(oper, real, int8_t,		     int8,   char, uint32_t	      , char32, fail);break;	\
case type_pair(ARR_BOOL,   ARR_NESTED):expr(oper, real, int8_t,		     int8,   cell, struct cell_array *, nested, fail);break;	\
case type_pair(ARR_SINT,   ARR_BOOL):  expr(oper, real, int16_t,	     int16,  real, int8_t	      , int8  , fail);break;	\
case type_pair(ARR_SINT,   ARR_SINT):  expr(oper, real, int16_t,	     int16,  real, int16_t	      , int16 , fail);break;	\
case type_pair(ARR_SINT,   ARR_INT):   expr(oper, real, int16_t,	     int16,  real, int32_t	      , int32 , fail);break;	\
case type_pair(ARR_SINT,   ARR_DBL):   expr(oper, real, int16_t,	     int16,  real, double	      , dbl   , fail);break;	\
case type_pair(ARR_SINT,   ARR_CMPX):  expr(oper, real, int16_t,	     int16,  cmpx, struct apl_cmpx    , cmpx  , fail);break;	\
case type_pair(ARR_SINT,   ARR_CHAR8): expr(oper, real, int16_t,	     int16,  char, uint8_t	      , char8 , fail);break;	\
case type_pair(ARR_SINT,   ARR_CHAR16):expr(oper, real, int16_t,	     int16,  char, uint16_t	      , char16, fail);break;	\
case type_pair(ARR_SINT,   ARR_CHAR32):expr(oper, real, int16_t,	     int16,  char, uint32_t	      , char32, fail);break;	\
case type_pair(ARR_SINT,   ARR_NESTED):expr(oper, real, int16_t,	     int16,  cell, struct cell_array *, nested, fail);break;	\
case type_pair(ARR_INT,	   ARR_BOOL):  expr(oper, real, int32_t,	     int32,  real, int8_t	      , int8  , fail);break;	\
case type_pair(ARR_INT,	   ARR_SINT):  expr(oper, real, int32_t,	     int32,  real, int16_t	      , int16 , fail);break;	\
case type_pair(ARR_INT,	   ARR_INT):   expr(oper, real, int32_t,	     int32,  real, int32_t	      , int32 , fail);break;	\
case type_pair(ARR_INT,	   ARR_DBL):   expr(oper, real, int32_t,	     int32,  real, double	      , dbl   , fail);break;	\
case type_pair(ARR_INT,	   ARR_CMPX):  expr(oper, real, int32_t,	     int32,  cmpx, struct apl_cmpx    , cmpx  , fail);break;	\
case type_pair(ARR_INT,	   ARR_CHAR8): expr(oper, real, int32_t,	     int32,  char, uint8_t	      , char8 , fail);break;	\
case type_pair(ARR_INT,	   ARR_CHAR16):expr(oper, real, int32_t,	     int32,  char, uint16_t	      , char16, fail);break;	\
case type_pair(ARR_INT,	   ARR_CHAR32):expr(oper, real, int32_t,	     int32,  char, uint32_t	      , char32, fail);break;	\
case type_pair(ARR_INT,	   ARR_NESTED):expr(oper, real, int32_t,	     int32,  cell, struct cell_array *, nested, fail);break;	\
case type_pair(ARR_DBL,	   ARR_BOOL):  expr(oper, real, double,		     dbl,    real, int8_t	      , int8  , fail);break;	\
case type_pair(ARR_DBL,	   ARR_SINT):  expr(oper, real, double,		     dbl,    real, int16_t	      , int16 , fail);break;	\
case type_pair(ARR_DBL,	   ARR_INT):   expr(oper, real, double,		     dbl,    real, int32_t	      , int32 , fail);break;	\
case type_pair(ARR_DBL,	   ARR_DBL):   expr(oper, real, double,		     dbl,    real, double	      , dbl   , fail);break;	\
case type_pair(ARR_DBL,	   ARR_CMPX):  expr(oper, real, double,		     dbl,    cmpx, struct apl_cmpx    , cmpx  , fail);break;	\
case type_pair(ARR_DBL,	   ARR_CHAR8): expr(oper, real, double,		     dbl,    char, uint8_t	      , char8 , fail);break;	\
case type_pair(ARR_DBL,	   ARR_CHAR16):expr(oper, real, double,		     dbl,    char, uint16_t	      , char16, fail);break;	\
case type_pair(ARR_DBL,	   ARR_CHAR32):expr(oper, real, double,		     dbl,    char, uint32_t	      , char32, fail);break;	\
case type_pair(ARR_DBL,	   ARR_NESTED):expr(oper, real, double,		     dbl,    cell, struct cell_array *, nested, fail);break;	\
case type_pair(ARR_CMPX,   ARR_BOOL):  expr(oper, cmpx, struct apl_cmpx,     cmpx,   real, int8_t	      , int8  , fail);break;	\
case type_pair(ARR_CMPX,   ARR_SINT):  expr(oper, cmpx, struct apl_cmpx,     cmpx,   real, int16_t	      , int16 , fail);break;	\
case type_pair(ARR_CMPX,   ARR_INT):   expr(oper, cmpx, struct apl_cmpx,     cmpx,   real, int32_t	      , int32 , fail);break;	\
case type_pair(ARR_CMPX,   ARR_DBL):   expr(oper, cmpx, struct apl_cmpx,     cmpx,   real, double	      , dbl   , fail);break;	\
case type_pair(ARR_CMPX,   ARR_CMPX):  expr(oper, cmpx, struct apl_cmpx,     cmpx,   cmpx, struct apl_cmpx    , cmpx  , fail);break;	\
case type_pair(ARR_CMPX,   ARR_CHAR8): expr(oper, cmpx, struct apl_cmpx,     cmpx,   char, uint8_t	      , char8 , fail);break;	\
case type_pair(ARR_CMPX,   ARR_CHAR16):expr(oper, cmpx, struct apl_cmpx,     cmpx,   char, uint16_t	      , char16, fail);break;	\
case type_pair(ARR_CMPX,   ARR_CHAR32):expr(oper, cmpx, struct apl_cmpx,     cmpx,   char, uint32_t	      , char32, fail);break;	\
case type_pair(ARR_CMPX,   ARR_NESTED):expr(oper, cmpx, struct apl_cmpx,     cmpx,   cell, struct cell_array *, nested, fail);break;	\
case type_pair(ARR_CHAR8,  ARR_BOOL):  expr(oper, char, uint8_t,	     char8,  real, int8_t	      , int8  , fail);break;	\
case type_pair(ARR_CHAR8,  ARR_SINT):  expr(oper, char, uint8_t,	     char8,  real, int16_t	      , int16 , fail);break;	\
case type_pair(ARR_CHAR8,  ARR_INT):   expr(oper, char, uint8_t,	     char8,  real, int32_t	      , int32 , fail);break;	\
case type_pair(ARR_CHAR8,  ARR_DBL):   expr(oper, char, uint8_t,	     char8,  real, double	      , dbl   , fail);break;	\
case type_pair(ARR_CHAR8,  ARR_CMPX):  expr(oper, char, uint8_t,	     char8,  cmpx, struct apl_cmpx    , cmpx  , fail);break;	\
case type_pair(ARR_CHAR8,  ARR_CHAR8): expr(oper, char, uint8_t,	     char8,  char, uint8_t	      , char8 , fail);break;	\
case type_pair(ARR_CHAR8,  ARR_CHAR16):expr(oper, char, uint8_t,	     char8,  char, uint16_t	      , char16, fail);break;	\
case type_pair(ARR_CHAR8,  ARR_CHAR32):expr(oper, char, uint8_t,	     char8,  char, uint32_t	      , char32, fail);break;	\
case type_pair(ARR_CHAR8,  ARR_NESTED):expr(oper, char, uint8_t,	     char8,  cell, struct cell_array *, nested, fail);break;	\
case type_pair(ARR_CHAR16, ARR_BOOL):  expr(oper, char, uint16_t,	     char16, real, int8_t	      , int8  , fail);break;	\
case type_pair(ARR_CHAR16, ARR_SINT):  expr(oper, char, uint16_t,	     char16, real, int16_t	      , int16 , fail);break;	\
case type_pair(ARR_CHAR16, ARR_INT):   expr(oper, char, uint16_t,	     char16, real, int32_t	      , int32 , fail);break;	\
case type_pair(ARR_CHAR16, ARR_DBL):   expr(oper, char, uint16_t,	     char16, real, double	      , dbl   , fail);break;	\
case type_pair(ARR_CHAR16, ARR_CMPX):  expr(oper, char, uint16_t,	     char16, cmpx, struct apl_cmpx    , cmpx  , fail);break;	\
case type_pair(ARR_CHAR16, ARR_CHAR8): expr(oper, char, uint16_t,	     char16, char, uint8_t	      , char8 , fail);break;	\
case type_pair(ARR_CHAR16, ARR_CHAR16):expr(oper, char, uint16_t,	     char16, char, uint16_t	      , char16, fail);break;	\
case type_pair(ARR_CHAR16, ARR_CHAR32):expr(oper, char, uint16_t,	     char16, char, uint32_t	      , char32, fail);break;	\
case type_pair(ARR_CHAR16, ARR_NESTED):expr(oper, char, uint16_t,	     char16, cell, struct cell_array *, nested, fail);break;	\
case type_pair(ARR_CHAR32, ARR_BOOL):  expr(oper, char, uint32_t,	     char32, real, int8_t	      , int8  , fail);break;	\
case type_pair(ARR_CHAR32, ARR_SINT):  expr(oper, char, uint32_t,	     char32, real, int16_t	      , int16 , fail);break;	\
case type_pair(ARR_CHAR32, ARR_INT):   expr(oper, char, uint32_t,	     char32, real, int32_t	      , int32 , fail);break;	\
case type_pair(ARR_CHAR32, ARR_DBL):   expr(oper, char, uint32_t,	     char32, real, double	      , dbl   , fail);break;	\
case type_pair(ARR_CHAR32, ARR_CMPX):  expr(oper, char, uint32_t,	     char32, cmpx, struct apl_cmpx    , cmpx  , fail);break;	\
case type_pair(ARR_CHAR32, ARR_CHAR8): expr(oper, char, uint32_t,	     char32, char, uint8_t	      , char8 , fail);break;	\
case type_pair(ARR_CHAR32, ARR_CHAR16):expr(oper, char, uint32_t,	     char32, char, uint16_t	      , char16, fail);break;	\
case type_pair(ARR_CHAR32, ARR_CHAR32):expr(oper, char, uint32_t,	     char32, char, uint32_t	      , char32, fail);break;	\
case type_pair(ARR_CHAR32, ARR_NESTED):expr(oper, char, uint32_t,	     char32, cell, struct cell_array *, nested, fail);break;	\
case type_pair(ARR_NESTED, ARR_BOOL):  expr(oper, cell, struct cell_array *, nested, real, int8_t	      , int8  , fail);break;	\
case type_pair(ARR_NESTED, ARR_SINT):  expr(oper, cell, struct cell_array *, nested, real, int16_t	      , int16 , fail);break;	\
case type_pair(ARR_NESTED, ARR_INT):   expr(oper, cell, struct cell_array *, nested, real, int32_t	      , int32 , fail);break;	\
case type_pair(ARR_NESTED, ARR_DBL):   expr(oper, cell, struct cell_array *, nested, real, double	      , dbl   , fail);break;	\
case type_pair(ARR_NESTED, ARR_CMPX):  expr(oper, cell, struct cell_array *, nested, cmpx, struct apl_cmpx    , cmpx  , fail);break;	\
case type_pair(ARR_NESTED, ARR_CHAR8): expr(oper, cell, struct cell_array *, nested, char, uint8_t	      , char8 , fail);break;	\
case type_pair(ARR_NESTED, ARR_CHAR16):expr(oper, cell, struct cell_array *, nested, char, uint16_t	      , char16, fail);break;	\
case type_pair(ARR_NESTED, ARR_CHAR32):expr(oper, cell, struct cell_array *, nested, char, uint32_t	      , char32, fail);break;	\
case type_pair(ARR_NESTED, ARR_NESTED):expr(oper, cell, struct cell_array *, nested, cell, struct cell_array *, nested, fail);break;	\
default:																\
	CHK(99, fail, L"Unknown type pair.");												\
}																	\

#define BAD_ELEM(sfx, fail) CHK(99, fail, L"Unexpected element type " #sfx)

#define MONADIC_SCALAR_LOOP(rt, expr) {		\
	rt *rv = r->values;			\
						\
	for (size_t i = 0; i < count; i++) {	\
		rt x = rv[i];			\
						\
		tv[i] = (expr);			\
	}					\
}						\

#define DYADIC_SCALAR_LOOP(lt, rt, expr) {	\
	lt *lv = l->values;			\
	rt *rv = r->values;			\
						\
	for (size_t i = 0; i < count; i++) {	\
		lt x = lv[i % lc];		\
		rt y = rv[i % rc];		\
						\
		tv[i] = (expr);			\
	}					\
}						\

#define MONADIC_SWITCH(oper, zt, rt) {		\
	zt *tv = t->values;			\
						\
	MONADIC_SCALAR_LOOP(rt, oper(x));	\
}						\

#define HOST_SWITCH(oper, zk, zt, zs, fail) oper##_##SWITCH##_##zk(zt, zs, fail)

#define SCALAR_SWITCH(sfx, typ, oper, fail) {					\
	typ *tv = t->values;							\
										\
	DYADIC_TYPE_SWITCH(l->type, r->type, SCALAR_LOOP_##sfx, oper, fail);	\
}										\

#define SCALAR_LOOP_int8(oper, lk, lt, ls, rk, rt, rs, fail) \
	DYADIC_SCALAR_LOOP(lt, rt, (int8_t)oper((int8_t)cast_real_##lk(x), (int8_t)cast_real_##rk(y)))
#define SCALAR_LOOP_int16(oper, lk, lt, ls, rk, rt, rs, fail) \
	DYADIC_SCALAR_LOOP(lt, rt, (int16_t)oper((int16_t)cast_real_##lk(x), (int16_t)cast_real_##rk(y)))
#define SCALAR_LOOP_int32(oper, lk, lt, ls, rk, rt, rs, fail) \
	DYADIC_SCALAR_LOOP(lt, rt, (int32_t)oper((int32_t)cast_real_##lk(x), (int32_t)cast_real_##rk(y)))
#define SCALAR_LOOP_dbl(oper, lk, lt, ls, rk, rt, rs, fail) \
	DYADIC_SCALAR_LOOP(lt, rt, (double)oper((double)cast_real_##lk(x), (double)cast_real_##rk(y)))
#define SCALAR_LOOP_cmpx(oper, lk, lt, ls, rk, rt, rs, fail) \
	DYADIC_SCALAR_LOOP(lt, rt, oper(cast_cmpx_##lk(x), cast_cmpx_##rk(y)))

#define DEFN_DYADIC_SCALAR(fn, FN, type_fn)					\
int										\
fn##_device(af_array *z, af_array l, af_array r)				\
{										\
	int err;								\
										\
	TRCAF(fn##_af(z, l, r));						\
										\
	return err;								\
}										\
										\
int										\
fn##_host(struct cell_array *t, size_t count,					\
    struct cell_array *l, size_t lc, struct cell_array *r, size_t rc)		\
{										\
	int err = 0;								\
										\
	MONADIC_TYPE_SWITCH(t->type, HOST_SWITCH, FN, fail);			\
										\
fail:										\
	return err;								\
}										\
										\
int										\
fn##_func(struct cell_array **z,						\
    struct cell_array *l, struct cell_array *r, struct cell_func *self)		\
{										\
	return dyadic_scalar_apply(z, l, r, type_fn, fn##_device, fn##_host);	\
}										\
										\
DECL_FUNC(fn##_vec_ibeam, error_mon_syntax, fn##_func)				\

#define CMP_TYPE_FAIL(op, zk, zt, zs, fail) CHK(99, fail, L"Unexpected type " #zs)

#define DEF_CMP_IBEAM(name, cmp_dev, oper)						\
int											\
name##_device(af_array *z, af_array l, af_array r)					\
{											\
	return cmp_dev(z, l, r, 0);							\
}											\
											\
int											\
name##_host(struct cell_array *t, size_t count,						\
    struct cell_array *l, size_t lc, struct cell_array *r, size_t rc)			\
{											\
	int err;									\
	int8_t *tv;									\
											\
	if (t->type != ARR_BOOL)							\
		MONADIC_TYPE_SWITCH(t->type, CMP_TYPE_FAIL,, fail);			\
											\
	tv = t->values;									\
											\
	DYADIC_TYPE_SWITCH(l->type, r->type, CMP_LOOP, oper, fail);			\
											\
	err = 0;									\
											\
fail:											\
	return err;									\
}											\
											\
int											\
name##_func(struct cell_array **z,							\
    struct cell_array *l, struct cell_array *r, struct cell_func *self)			\
{											\
	return dyadic_scalar_apply(z, l, r, bool_type, name##_device, name##_host);	\
}											\
											\
DECL_FUNC(name##_vec_ibeam, error_mon_syntax, name##_func)				\

#define DEFN_MONADIC_SCALAR(name)				\
int								\
name##_func(struct cell_array **z,				\
    struct cell_array *r, struct cell_func *self)		\
{								\
	return monadic_scalar_apply(z, r, name##_values);	\
}								\
								\
DECL_FUNC(name##_vec_ibeam, name##_func, error_dya_syntax)	\

