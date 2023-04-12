#include <arrayfire.h>

#include "codfns.h"

wchar_t *get_aferr_msg(int);

#define type_pair(src, dst) ((src * ARR_MAX) + dst)

enum array_type array_max_type(enum array_type, enum array_type);
af_dtype array_type_af_dtype(enum array_type);
af_dtype array_af_dtype(struct cell_array *);
enum array_type closest_numeric_array_type(double);

int cast_values(struct cell_array *, enum array_type);
int squeeze_array(struct cell_array *);

int is_integer_dbl(double);
int is_integer_device(unsigned char *, af_array);
int is_integer_array(struct cell_array *);
int is_real_array(struct cell_array *);
int is_numeric_array(struct cell_array *);
int is_char_array(struct cell_array *);

int array_get_host_buffer(void **, int *, struct cell_array *);

int get_scalar_bool(int8_t *, struct cell_array *);
int get_scalar_sint(int16_t *, struct cell_array *);
int get_scalar_int(int32_t *, struct cell_array *);
int get_scalar_dbl(double *, struct cell_array *);
int get_scalar_cmpx(struct apl_cmpx *, struct cell_array *);
int get_scalar_u64(size_t *, struct cell_array *);
int get_scalar_char8(uint8_t *, struct cell_array *);
int get_scalar_char16(uint16_t *, struct cell_array *);
int get_scalar_char32(uint32_t *, struct cell_array *);

int mk_array_bool(struct cell_array **, int8_t);
int mk_array_sint(struct cell_array **, int16_t);
int mk_array_int(struct cell_array **, int32_t);
int mk_array_dbl(struct cell_array **, double);
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

int retain_array_data(struct cell_array *);
int release_array_data(struct cell_array *);
int array_is_same(int8_t *, struct cell_array *, struct cell_array *);
int array_promote_storage(struct cell_array *, struct cell_array *);
int array_migrate_storage(struct cell_array *, enum array_storage);

#define DECL_FUNC(name, mon, dya)						\
struct cell_func name##_closure = {CELL_FUNC, 1, mon, dya, NULL, NULL, 0};	\
struct cell_func *name = &name##_closure;					\

#define DECL_MOPER(name, am, ad, fm, fd)				\
struct cell_moper name##_closure = {CELL_MOPER, 1, am, ad, fm, fd, 0};	\
struct cell_moper *name = &name##_closure;				\

#define DECL_DOPER(name, aam, aad, afm, afd, fam, fad, ffm, ffd)	\
struct cell_doper name##_closure = {CELL_DOPER, 1,			\
	aam, aad, afm, afd, fam, fad, ffm, ffd, 0			\
};									\
struct cell_doper *name = &name##_closure;				\

#define MONADIC_TYPE_SWITCH(tp, expr, fail)			\
switch ((tp)) {							\
case ARR_BOOL:  expr(int8_t,              bool,   fail);break;	\
case ARR_SINT:  expr(int16_t,             sint,   fail);break;	\
case ARR_INT:   expr(int32_t,             int,    fail);break;	\
case ARR_DBL:   expr(double,              dbl,    fail);break;	\
case ARR_CMPX:  expr(struct apl_cmpx,     cmpx,   fail);break;	\
case ARR_CHAR8: expr(uint8_t,             char8,  fail);break;	\
case ARR_CHAR16:expr(uint16_t,            char16, fail);break;	\
case ARR_CHAR32:expr(uint32_t,            char32, fail);break;	\
case ARR_NESTED:expr(struct cell_array *, nested, fail);break;	\
default:							\
	CHK(99, fail, L"Unknown array type.");			\
}								\

#define DYADIC_TYPE_SWITCH(lt, rt, expr, fail)										\
switch (type_pair((lt), (rt))) {											\
case type_pair(ARR_BOOL,   ARR_BOOL):  expr(int8_t,              bool,   int8_t             , bool  , fail);break;	\
case type_pair(ARR_BOOL,   ARR_SINT):  expr(int8_t,              bool,   int16_t            , sint  , fail);break;	\
case type_pair(ARR_BOOL,   ARR_INT):   expr(int8_t,              bool,   int32_t            , int   , fail);break;	\
case type_pair(ARR_BOOL,   ARR_DBL):   expr(int8_t,              bool,   double             , dbl   , fail);break;	\
case type_pair(ARR_BOOL,   ARR_CMPX):  expr(int8_t,              bool,   struct apl_cmpx    , cmpx  , fail);break;	\
case type_pair(ARR_BOOL,   ARR_CHAR8): expr(int8_t,              bool,   uint8_t            , char8 , fail);break;	\
case type_pair(ARR_BOOL,   ARR_CHAR16):expr(int8_t,              bool,   uint16_t           , char16, fail);break;	\
case type_pair(ARR_BOOL,   ARR_CHAR32):expr(int8_t,              bool,   uint32_t           , char32, fail);break;	\
case type_pair(ARR_BOOL,   ARR_NESTED):expr(int8_t,              bool,   struct cell_array *, nested, fail);break;	\
case type_pair(ARR_SINT,   ARR_BOOL):  expr(int16_t,             sint,   int8_t             , bool  , fail);break;	\
case type_pair(ARR_SINT,   ARR_SINT):  expr(int16_t,             sint,   int16_t            , sint  , fail);break;	\
case type_pair(ARR_SINT,   ARR_INT):   expr(int16_t,             sint,   int32_t            , int   , fail);break;	\
case type_pair(ARR_SINT,   ARR_DBL):   expr(int16_t,             sint,   double             , dbl   , fail);break;	\
case type_pair(ARR_SINT,   ARR_CMPX):  expr(int16_t,             sint,   struct apl_cmpx    , cmpx  , fail);break;	\
case type_pair(ARR_SINT,   ARR_CHAR8): expr(int16_t,             sint,   uint8_t            , char8 , fail);break;	\
case type_pair(ARR_SINT,   ARR_CHAR16):expr(int16_t,             sint,   uint16_t           , char16, fail);break;	\
case type_pair(ARR_SINT,   ARR_CHAR32):expr(int16_t,             sint,   uint32_t           , char32, fail);break;	\
case type_pair(ARR_SINT,   ARR_NESTED):expr(int16_t,             sint,   struct cell_array *, nested, fail);break;	\
case type_pair(ARR_INT,    ARR_BOOL):  expr(int32_t,             int,    int8_t             , bool  , fail);break;	\
case type_pair(ARR_INT,    ARR_SINT):  expr(int32_t,             int,    int16_t            , sint  , fail);break;	\
case type_pair(ARR_INT,    ARR_INT):   expr(int32_t,             int,    int32_t            , int   , fail);break;	\
case type_pair(ARR_INT,    ARR_DBL):   expr(int32_t,             int,    double             , dbl   , fail);break;	\
case type_pair(ARR_INT,    ARR_CMPX):  expr(int32_t,             int,    struct apl_cmpx    , cmpx  , fail);break;	\
case type_pair(ARR_INT,    ARR_CHAR8): expr(int32_t,             int,    uint8_t            , char8 , fail);break;	\
case type_pair(ARR_INT,    ARR_CHAR16):expr(int32_t,             int,    uint16_t           , char16, fail);break;	\
case type_pair(ARR_INT,    ARR_CHAR32):expr(int32_t,             int,    uint32_t           , char32, fail);break;	\
case type_pair(ARR_INT,    ARR_NESTED):expr(int32_t,             int,    struct cell_array *, nested, fail);break;	\
case type_pair(ARR_DBL,    ARR_BOOL):  expr(double,              dbl,    int8_t             , bool  , fail);break;	\
case type_pair(ARR_DBL,    ARR_SINT):  expr(double,              dbl,    int16_t            , sint  , fail);break;	\
case type_pair(ARR_DBL,    ARR_INT):   expr(double,              dbl,    int32_t            , int   , fail);break;	\
case type_pair(ARR_DBL,    ARR_DBL):   expr(double,              dbl,    double             , dbl   , fail);break;	\
case type_pair(ARR_DBL,    ARR_CMPX):  expr(double,              dbl,    struct apl_cmpx    , cmpx  , fail);break;	\
case type_pair(ARR_DBL,    ARR_CHAR8): expr(double,              dbl,    uint8_t            , char8 , fail);break;	\
case type_pair(ARR_DBL,    ARR_CHAR16):expr(double,              dbl,    uint16_t           , char16, fail);break;	\
case type_pair(ARR_DBL,    ARR_CHAR32):expr(double,              dbl,    uint32_t           , char32, fail);break;	\
case type_pair(ARR_DBL,    ARR_NESTED):expr(double,              dbl,    struct cell_array *, nested, fail);break;	\
case type_pair(ARR_CMPX,   ARR_BOOL):  expr(struct apl_cmpx,     cmpx,   int8_t             , bool  , fail);break;	\
case type_pair(ARR_CMPX,   ARR_SINT):  expr(struct apl_cmpx,     cmpx,   int16_t            , sint  , fail);break;	\
case type_pair(ARR_CMPX,   ARR_INT):   expr(struct apl_cmpx,     cmpx,   int32_t            , int   , fail);break;	\
case type_pair(ARR_CMPX,   ARR_DBL):   expr(struct apl_cmpx,     cmpx,   double             , dbl   , fail);break;	\
case type_pair(ARR_CMPX,   ARR_CMPX):  expr(struct apl_cmpx,     cmpx,   struct apl_cmpx    , cmpx  , fail);break;	\
case type_pair(ARR_CMPX,   ARR_CHAR8): expr(struct apl_cmpx,     cmpx,   uint8_t            , char8 , fail);break;	\
case type_pair(ARR_CMPX,   ARR_CHAR16):expr(struct apl_cmpx,     cmpx,   uint16_t           , char16, fail);break;	\
case type_pair(ARR_CMPX,   ARR_CHAR32):expr(struct apl_cmpx,     cmpx,   uint32_t           , char32, fail);break;	\
case type_pair(ARR_CMPX,   ARR_NESTED):expr(struct apl_cmpx,     cmpx,   struct cell_array *, nested, fail);break;	\
case type_pair(ARR_CHAR8,  ARR_BOOL):  expr(uint8_t,             char8,  int8_t             , bool  , fail);break;	\
case type_pair(ARR_CHAR8,  ARR_SINT):  expr(uint8_t,             char8,  int16_t            , sint  , fail);break;	\
case type_pair(ARR_CHAR8,  ARR_INT):   expr(uint8_t,             char8,  int32_t            , int   , fail);break;	\
case type_pair(ARR_CHAR8,  ARR_DBL):   expr(uint8_t,             char8,  double             , dbl   , fail);break;	\
case type_pair(ARR_CHAR8,  ARR_CMPX):  expr(uint8_t,             char8,  struct apl_cmpx    , cmpx  , fail);break;	\
case type_pair(ARR_CHAR8,  ARR_CHAR8): expr(uint8_t,             char8,  uint8_t            , char8 , fail);break;	\
case type_pair(ARR_CHAR8,  ARR_CHAR16):expr(uint8_t,             char8,  uint16_t           , char16, fail);break;	\
case type_pair(ARR_CHAR8,  ARR_CHAR32):expr(uint8_t,             char8,  uint32_t           , char32, fail);break;	\
case type_pair(ARR_CHAR8,  ARR_NESTED):expr(uint8_t,             char8,  struct cell_array *, nested, fail);break;	\
case type_pair(ARR_CHAR16, ARR_BOOL):  expr(uint16_t,            char16, int8_t             , bool  , fail);break;	\
case type_pair(ARR_CHAR16, ARR_SINT):  expr(uint16_t,            char16, int16_t            , sint  , fail);break;	\
case type_pair(ARR_CHAR16, ARR_INT):   expr(uint16_t,            char16, int32_t            , int   , fail);break;	\
case type_pair(ARR_CHAR16, ARR_DBL):   expr(uint16_t,            char16, double             , dbl   , fail);break;	\
case type_pair(ARR_CHAR16, ARR_CMPX):  expr(uint16_t,            char16, struct apl_cmpx    , cmpx  , fail);break;	\
case type_pair(ARR_CHAR16, ARR_CHAR8): expr(uint16_t,            char16, uint8_t            , char8 , fail);break;	\
case type_pair(ARR_CHAR16, ARR_CHAR16):expr(uint16_t,            char16, uint16_t           , char16, fail);break;	\
case type_pair(ARR_CHAR16, ARR_CHAR32):expr(uint16_t,            char16, uint32_t           , char32, fail);break;	\
case type_pair(ARR_CHAR16, ARR_NESTED):expr(uint16_t,            char16, struct cell_array *, nested, fail);break;	\
case type_pair(ARR_CHAR32, ARR_BOOL):  expr(uint32_t,            char32, int8_t             , bool  , fail);break;	\
case type_pair(ARR_CHAR32, ARR_SINT):  expr(uint32_t,            char32, int16_t            , sint  , fail);break;	\
case type_pair(ARR_CHAR32, ARR_INT):   expr(uint32_t,            char32, int32_t            , int   , fail);break;	\
case type_pair(ARR_CHAR32, ARR_DBL):   expr(uint32_t,            char32, double             , dbl   , fail);break;	\
case type_pair(ARR_CHAR32, ARR_CMPX):  expr(uint32_t,            char32, struct apl_cmpx    , cmpx  , fail);break;	\
case type_pair(ARR_CHAR32, ARR_CHAR8): expr(uint32_t,            char32, uint8_t            , char8 , fail);break;	\
case type_pair(ARR_CHAR32, ARR_CHAR16):expr(uint32_t,            char32, uint16_t           , char16, fail);break;	\
case type_pair(ARR_CHAR32, ARR_CHAR32):expr(uint32_t,            char32, uint32_t           , char32, fail);break;	\
case type_pair(ARR_CHAR32, ARR_NESTED):expr(uint32_t,            char32, struct cell_array *, nested, fail);break;	\
case type_pair(ARR_NESTED, ARR_BOOL):  expr(struct cell_array *, nested, int8_t             , bool  , fail);break;	\
case type_pair(ARR_NESTED, ARR_SINT):  expr(struct cell_array *, nested, int16_t            , sint  , fail);break;	\
case type_pair(ARR_NESTED, ARR_INT):   expr(struct cell_array *, nested, int32_t            , int   , fail);break;	\
case type_pair(ARR_NESTED, ARR_DBL):   expr(struct cell_array *, nested, double             , dbl   , fail);break;	\
case type_pair(ARR_NESTED, ARR_CMPX):  expr(struct cell_array *, nested, struct apl_cmpx    , cmpx  , fail);break;	\
case type_pair(ARR_NESTED, ARR_CHAR8): expr(struct cell_array *, nested, uint8_t            , char8 , fail);break;	\
case type_pair(ARR_NESTED, ARR_CHAR16):expr(struct cell_array *, nested, uint16_t           , char16, fail);break;	\
case type_pair(ARR_NESTED, ARR_CHAR32):expr(struct cell_array *, nested, uint32_t           , char32, fail);break;	\
case type_pair(ARR_NESTED, ARR_NESTED):expr(struct cell_array *, nested, struct cell_array *, nested, fail);break;	\
default:														\
	CHK(99, fail, L"Unknown type pair.");										\
}

#define NOOP(zt, lt, rt)

#define SIMPLE_SWITCH(LOOP, CMPX_LOOP, LCMPX_LOOP, RCMPX_LOOP, zt, lt, rt, def_expr)			\
	switch (type_pair((lt), (rt))) {								\
	case type_pair(ARR_SPAN, ARR_BOOL):LOOP(zt,	    int, int8_t);break;				\
	case type_pair(ARR_SPAN, ARR_SINT):LOOP(zt,	    int, int16_t);break;			\
	case type_pair(ARR_SPAN, ARR_INT):LOOP(zt,	    int, int32_t);break;			\
	case type_pair(ARR_SPAN, ARR_DBL):LOOP(zt,	    int, double);break;				\
	case type_pair(ARR_SPAN, ARR_CMPX):RCMPX_LOOP(zt,   int, struct apl_cmpx);break;		\
	case type_pair(ARR_SPAN, ARR_CHAR8):LOOP(zt,	    int, uint8_t);break;			\
	case type_pair(ARR_SPAN, ARR_CHAR16):LOOP(zt,	    int, uint16_t);break;			\
	case type_pair(ARR_SPAN, ARR_CHAR32):LOOP(zt,	    int, uint32_t);break;			\
	case type_pair(ARR_BOOL, ARR_BOOL):LOOP(zt,	    int8_t, int8_t);break;			\
	case type_pair(ARR_BOOL, ARR_SINT):LOOP(zt,	    int8_t, int16_t);break;			\
	case type_pair(ARR_BOOL, ARR_INT):LOOP(zt,	    int8_t, int32_t);break;			\
	case type_pair(ARR_BOOL, ARR_DBL):LOOP(zt,	    int8_t, double);break;			\
	case type_pair(ARR_BOOL, ARR_CMPX):RCMPX_LOOP(zt,   int8_t, struct apl_cmpx);break;		\
	case type_pair(ARR_BOOL, ARR_CHAR8):LOOP(zt,	    int8_t, uint8_t);break;			\
	case type_pair(ARR_BOOL, ARR_CHAR16):LOOP(zt,	    int8_t, uint16_t);break;			\
	case type_pair(ARR_BOOL, ARR_CHAR32):LOOP(zt,	    int8_t, uint32_t);break;			\
	case type_pair(ARR_SINT, ARR_BOOL):LOOP(zt,	    int16_t, int8_t);break;			\
	case type_pair(ARR_SINT, ARR_SINT):LOOP(zt,	    int16_t, int16_t);break;			\
	case type_pair(ARR_SINT, ARR_INT):LOOP(zt,	    int16_t, int32_t);break;			\
	case type_pair(ARR_SINT, ARR_DBL):LOOP(zt,	    int16_t, double);break;			\
	case type_pair(ARR_SINT, ARR_CMPX):RCMPX_LOOP(zt,   int16_t, struct apl_cmpx);break;		\
	case type_pair(ARR_SINT, ARR_CHAR8):LOOP(zt,	    int16_t, uint8_t);break;			\
	case type_pair(ARR_SINT, ARR_CHAR16):LOOP(zt,	    int16_t, uint16_t);break;			\
	case type_pair(ARR_SINT, ARR_CHAR32):LOOP(zt,	    int16_t, uint32_t);break;			\
	case type_pair(ARR_INT, ARR_BOOL):LOOP(zt,	    int32_t, int8_t);break;			\
	case type_pair(ARR_INT, ARR_SINT):LOOP(zt,	    int32_t, int16_t);break;			\
	case type_pair(ARR_INT, ARR_INT):LOOP(zt,	    int32_t, int32_t);break;			\
	case type_pair(ARR_INT, ARR_DBL):LOOP(zt,	    int32_t, double);break;			\
	case type_pair(ARR_INT, ARR_CMPX):RCMPX_LOOP(zt,    int32_t, struct apl_cmpx);break;		\
	case type_pair(ARR_INT, ARR_CHAR8):LOOP(zt,	    int32_t, uint8_t);break;			\
	case type_pair(ARR_INT, ARR_CHAR16):LOOP(zt,	    int32_t, uint16_t);break;			\
	case type_pair(ARR_INT, ARR_CHAR32):LOOP(zt,	    int32_t, uint32_t);break;			\
	case type_pair(ARR_DBL, ARR_BOOL):LOOP(zt,	    double, int8_t);break;			\
	case type_pair(ARR_DBL, ARR_SINT):LOOP(zt,	    double, int16_t);break;			\
	case type_pair(ARR_DBL, ARR_INT):LOOP(zt,	    double, int32_t);break;			\
	case type_pair(ARR_DBL, ARR_DBL):LOOP(zt,	    double, double);break;			\
	case type_pair(ARR_DBL, ARR_CMPX):RCMPX_LOOP(zt,    double, struct apl_cmpx);break;		\
	case type_pair(ARR_DBL, ARR_CHAR8):LOOP(zt,	    double, uint8_t);break;			\
	case type_pair(ARR_DBL, ARR_CHAR16):LOOP(zt,	    double, uint16_t);break;			\
	case type_pair(ARR_DBL, ARR_CHAR32):LOOP(zt,	    double, uint32_t);break;			\
	case type_pair(ARR_CMPX, ARR_BOOL):LCMPX_LOOP(zt,   struct apl_cmpx, int8_t);break;		\
	case type_pair(ARR_CMPX, ARR_SINT):LCMPX_LOOP(zt,   struct apl_cmpx, int16_t);break;		\
	case type_pair(ARR_CMPX, ARR_INT):LCMPX_LOOP(zt,    struct apl_cmpx, int32_t);break;		\
	case type_pair(ARR_CMPX, ARR_DBL):LCMPX_LOOP(zt,    struct apl_cmpx, double);break;		\
	case type_pair(ARR_CMPX, ARR_CMPX):CMPX_LOOP(zt,    struct apl_cmpx, struct apl_cmpx);break;	\
	case type_pair(ARR_CMPX, ARR_CHAR8):LCMPX_LOOP(zt,  struct apl_cmpx, uint8_t);break;		\
	case type_pair(ARR_CMPX, ARR_CHAR16):LCMPX_LOOP(zt, struct apl_cmpx, uint16_t);break;		\
	case type_pair(ARR_CMPX, ARR_CHAR32):LCMPX_LOOP(zt, struct apl_cmpx, uint32_t);break;		\
	case type_pair(ARR_CHAR8, ARR_BOOL):LOOP(zt,	    uint8_t, int8_t);break;			\
	case type_pair(ARR_CHAR8, ARR_SINT):LOOP(zt,	    uint8_t, int16_t);break;			\
	case type_pair(ARR_CHAR8, ARR_INT):LOOP(zt,	    uint8_t, int32_t);break;			\
	case type_pair(ARR_CHAR8, ARR_DBL):LOOP(zt,	    uint8_t, double);break;			\
	case type_pair(ARR_CHAR8, ARR_CMPX):RCMPX_LOOP(zt,  uint8_t, struct apl_cmpx);break;		\
	case type_pair(ARR_CHAR8, ARR_CHAR8):LOOP(zt,	    uint8_t, uint8_t);break;			\
	case type_pair(ARR_CHAR8, ARR_CHAR16):LOOP(zt,	    uint8_t, uint16_t);break;			\
	case type_pair(ARR_CHAR8, ARR_CHAR32):LOOP(zt,	    uint8_t, uint32_t);break;			\
	case type_pair(ARR_CHAR16, ARR_BOOL):LOOP(zt,	    uint16_t, int8_t);break;			\
	case type_pair(ARR_CHAR16, ARR_SINT):LOOP(zt,	    uint16_t, int16_t);break;			\
	case type_pair(ARR_CHAR16, ARR_INT):LOOP(zt,	    uint16_t, int32_t);break;			\
	case type_pair(ARR_CHAR16, ARR_DBL):LOOP(zt,	    uint16_t, double);break;			\
	case type_pair(ARR_CHAR16, ARR_CMPX):RCMPX_LOOP(zt, uint16_t, struct apl_cmpx);break;		\
	case type_pair(ARR_CHAR16, ARR_CHAR8):LOOP(zt,	    uint16_t, uint8_t);break;			\
	case type_pair(ARR_CHAR16, ARR_CHAR16):LOOP(zt,	    uint16_t, uint16_t);break;			\
	case type_pair(ARR_CHAR16, ARR_CHAR32):LOOP(zt,	    uint16_t, uint32_t);break;			\
	case type_pair(ARR_CHAR32, ARR_BOOL):LOOP(zt,	    uint32_t, int8_t);break;			\
	case type_pair(ARR_CHAR32, ARR_SINT):LOOP(zt,	    uint32_t, int16_t);break;			\
	case type_pair(ARR_CHAR32, ARR_INT):LOOP(zt,	    uint32_t, int32_t);break;			\
	case type_pair(ARR_CHAR32, ARR_DBL):LOOP(zt,	    uint32_t, double);break;			\
	case type_pair(ARR_CHAR32, ARR_CMPX):RCMPX_LOOP(zt, uint32_t, struct apl_cmpx);break;		\
	case type_pair(ARR_CHAR32, ARR_CHAR8):LOOP(zt,	    uint32_t, uint8_t);break;			\
	case type_pair(ARR_CHAR32, ARR_CHAR16):LOOP(zt,	    uint32_t, uint16_t);break;			\
	case type_pair(ARR_CHAR32, ARR_CHAR32):LOOP(zt,	    uint32_t, uint32_t);break;			\
	default:											\
		def_expr;										\
	}
	
#define MON_LOOP(zt, rt, expr) {		\
	zt *tvals = t->values;			\
	rt *rvals = r->values;			\
						\
	for (size_t i = 0; i < count; i++) {	\
		rt x = rvals[i];		\
						\
		tvals[i] = (expr);		\
	}					\
}						\

#define LOOP_LOCALS(ztype, ltype, rtype)	\
	ztype *tvals = t->values;		\
	ltype *lvals = l->values;		\
	rtype *rvals = r->values;		\
	
#define EXPR_LOOP(ztype, ltype, rtype, expr) {	\
	LOOP_LOCALS(ztype, ltype, rtype)	\
						\
	for (size_t i = 0; i < count; i++) {	\
		ltype x = lvals[i % lc];	\
		rtype y = rvals[i % rc];	\
						\
		tvals[i] = (expr);		\
	}					\
}						\

#define RCMPX_LOOP(ztype, ltype, expr) {		\
	LOOP_LOCALS(ztype, ltype, struct apl_cmpx)	\
							\
	for (size_t i = 0; i < count; i++) {		\
		struct apl_cmpx x = {lvals[i % lc], 0};	\
		struct apl_cmpx y = rvals[i % rc];	\
							\
		tvals[i] = (expr);			\
	}						\
}							\

#define LCMPX_LOOP(ztype, rtype, expr) {		\
	LOOP_LOCALS(ztype, struct apl_cmpx, rtype)	\
							\
	for (size_t i = 0; i < count; i++) {		\
		struct apl_cmpx x = lvals[i % lc];	\
		struct apl_cmpx y = {rvals[i % rc], 0};	\
							\
		tvals[i] = (expr);			\
	}						\
}							\

#define STMT_LOOP(zt, lt, rt, stmts) {		\
	zt *tv = t->values;			\
	lt *lv = l->values;			\
	rt *rv = r->values;			\
						\
	for (size_t i = 0; i < count; i++)	\
		stmts;				\
}						\

