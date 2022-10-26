#include <arrayfire.h>

#include "codfns.h"

enum array_type array_max_type(enum array_type, enum array_type);

int squeeze_array(struct cell_array *);

int is_integer(double);
int is_real_array(struct cell_array *);
int is_numeric_array(struct cell_array *);
int is_char_array(struct cell_array *);

int get_scalar_bool(int8_t *, struct cell_array *);
int get_scalar_sint(int16_t *, struct cell_array *);
int get_scalar_int(int32_t *, struct cell_array *);
int get_scalar_dbl(double *, struct cell_array *);
int get_scalar_cmpx(struct apl_cmpx *, struct cell_array *);
int get_scalar_char8(uint8_t *, struct cell_array *);
int get_scalar_char16(uint16_t *, struct cell_array *);
int get_scalar_char32(uint32_t *, struct cell_array *);

size_t array_count(struct cell_array *);
size_t array_values_count(struct cell_array *);
size_t array_values_bytes(struct cell_array *);
size_t array_element_size(struct cell_array *);
af_dtype array_af_dtype(struct cell_array *);

