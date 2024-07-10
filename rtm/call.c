#include "internal.h"

DECLSPEC int
mk_nested_array(struct cell_array **arr, size_t count)
{
	int err;
	
	*arr = NULL;
	
	CHKFN(mk_array(arr, ARR_NESTED, STG_HOST, 1), fail);
	
	(*arr)->shape[0] = count;
	
	CHKFN(alloc_array(*arr), fail);
	
fail:
	if (err)
		release_array(*arr);
	
	return err;
}

DECLSPEC int
var_ref(void *ref)
{
	if (!ref)
		return 6;
	
	return 0;
}

DECLSPEC int
guard_check(struct cell_array *x)
{
	int err, val;
	
	if (NUM_1 == x) {
		err = 0;
		goto done;
	}
	
	if (NUM_0 == x) {
		err = -1;
		goto done;
	}
	
	if (array_count(x) != 1)
		CHK(5, done, "Non-singleton test expression.");
	
	CHKFN(squeeze_array(x), done);
	
	if (x->type != ARR_BOOL)
		CHK(11, done, "Test expression is not Boolean.");

	CHKFN(get_scalar_int32(&val, x, 0), done);

	err = val - 1;

done:	
	return err;
}
