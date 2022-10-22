#include <arrayfire.h>

#include "codfns.h"

enum array_type array_max_type(enum array_type, enum array_type);

int squeeze_array(struct cell_array *);

int get_scalar_int(struct cell_array *);
double get_scalar_dbl(struct cell_array *);
struct apl_cmpx get_scalar_cmpx(struct cell_array *);

int is_simple(struct cell_array *);
int is_integer(double);
int is_real(struct cell_array *);
int is_numeric(struct cell_array *);

size_t array_count(struct cell_array *);
size_t array_values_count(struct cell_array *);
size_t array_values_bytes(struct cell_array *);
size_t array_element_size(struct cell_array *);
af_dtype array_af_dtype(struct cell_array *);

