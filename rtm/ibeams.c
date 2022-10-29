#include "internal.h"

int
q_signal_func(struct cell_array **z, 
    struct cell_array *l, struct cell_array *r,
    struct cell_func *self)
{
	int err;
	int32_t val;
	
	if (r->rank > 1)
		return 4;
	
	if (!array_count(r)) {
		*z = retain_cell(r);
		return 0;
	}
	
	if (err = squeeze_array(r))
		return err;
	
	if (!is_integer_array(r))
		return 11;
	
	if (l) {
		if (!is_char_array(l))
			return 11;
		
		if (l->rank > 1)
			return 4;
	}
	
	if (err = get_scalar_int(&val, r))
		return err;
	
	return val;
}

struct cell_func q_signal_closure = {CELL_FUNC, 1, q_signal_func, 0};
struct cell_func *q_signal_ibeam = &q_signal_closure;
