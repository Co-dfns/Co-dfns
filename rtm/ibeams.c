#include "internal.h"

int
q_signal_func(struct cell_array **z, 
    struct cell_array *l, struct cell_array *r, struct cell_func *self)
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

int
q_dr_func(struct cell_array **z,
    struct cell_array *l, struct cell_array *r, struct cell_func *self)
{
	struct cell_array *t;
	int16_t *val;
	int err;
	
	if (l)
		return 16;
	
	if (err = mk_array(&t, ARR_SINT, STG_HOST, 0, NULL))
		return err;
	
	val = t->values;
	
	switch (r->type) {
	case ARR_SPAN:
		*val = 323;
		break;
	case ARR_BOOL:
		*val = 83;
		break;
	case ARR_SINT:
		*val = 163;
	case ARR_INT:
		*val = 323;
		break;
	case ARR_DBL:
		*val = 645;
		break;
	case ARR_CMPX:
		*val = 1289;
		break;
	case ARR_CHAR8:
		*val = 80;
		break;
	case ARR_CHAR16:
		*val = 160;
		break;
	case ARR_CHAR32:
		*val = 320;
		break;
	case ARR_MIXED:
	case ARR_NESTED:
		*val = 326;
		break;
	default:
		release_cell(t);
		return 99;
	}
	
	*z = t;
	
	return 0;
}

struct cell_func q_dr_closure = {CELL_FUNC, 1, q_dr_func, 0};
struct cell_func *q_dr_ibeam = &q_dr_closure;
