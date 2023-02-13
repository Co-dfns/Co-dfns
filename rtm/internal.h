#include <arrayfire.h>

#include "codfns.h"

wchar_t *get_aferr_msg(int);

#define type_pair(src, dst) ((src * ARR_MAX) + dst)

enum array_type array_max_type(enum array_type, enum array_type);
af_dtype array_type_af_dtype(enum array_type);
af_dtype array_af_dtype(struct cell_array *);
enum array_type closest_numeric_array_type(double);

int squeeze_array(struct cell_array *);

int is_integer_dbl(double);
int is_integer_device(unsigned char *, af_array);
int is_integer_array(struct cell_array *);
int is_real_array(struct cell_array *);
int is_numeric_array(struct cell_array *);
int is_char_array(struct cell_array *);

int get_scalar_bool(int8_t *, struct cell_array *);
int get_scalar_sint(int16_t *, struct cell_array *);
int get_scalar_int(int32_t *, struct cell_array *);
int get_scalar_dbl(double *, struct cell_array *);
int get_scalar_cmpx(struct apl_cmpx *, struct cell_array *);
int get_scalar_u64(size_t *, struct cell_array *);
int get_scalar_char8(uint8_t *, struct cell_array *);
int get_scalar_char16(uint16_t *, struct cell_array *);
int get_scalar_char32(uint32_t *, struct cell_array *);

int mk_scalar_bool(struct cell_array **, int8_t);
int mk_scalar_sint(struct cell_array **, int16_t);
int mk_scalar_int(struct cell_array **, int32_t);
int mk_scalar_dbl(struct cell_array **, double);
int mk_scalar_cmpx(struct cell_array **, struct apl_cmpx);
int mk_scalar_char8(struct cell_array **, uint8_t);
int mk_scalar_char16(struct cell_array **, uint16_t);
int mk_scalar_char32(struct cell_array **, uint32_t);

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
