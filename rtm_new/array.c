#include <stddef.h>
#include <stdlib.h>
#include <arrayfire.h>

#include "codfns.h"

#if AF_API_VERSION < 38
#error "Your ArrayFire version is too old."
#endif

struct array {
	enum	cell_type ctyp;
	unsigned	int refc;
	void	*values;
	enum	cdf_storage storage;
	enum	cdf_type type;
	unsigned	int rank;
	unsigned	long long shape[];
};

DECLSPEC int
mk_array(struct array **arr, enum array_type type, enum array_storage storage,
    unsigned int rank, unsigned long long *shape)
{
	af_err		aferr;
	af_dtype	aftyp;
	size_t		size;

	if (storage != STG_DEVICE)
		return 16;

	size = sizeof(struct array) + rank * sizeof(unsigned long long);
	*arr = malloc(size);

	if (*arr == NULL)
		return 1;

	(*arr)->ctyp	= CELL_ARRAY;
	(*arr)->refc	= 1;
	(*arr)->type	= type;
	(*arr)->storage	= storage;
	(*arr)->rank	= rank;

	size = 1;

	for (unsigned i = 0; i < rank; ++i) {
		(*arr)->shape[i] = shape[i];
		size *= shape[i];
	}

	if (type == ARR_NESTED) {
		(*arr)->values = calloc(size, sizeof(struct array *));

		if ((*arr)->values == NULL) {
			free(*arr);
			return 1;
		}

		return 0;
	}

	switch (type) {
	case ARR_BOOL:
		aftyp = b8;
		break;
	case ARR_SINT:
		aftyp = s16;
		break;
	case ARR_INT:
		aftyp = s32;
		break;
	case ARR_DBL:
		aftyp = f64;
		break;
	case ARR_CMP:
		aftyp = c64;
		break;
	case ARR_CHAR:
	case ARR_MIXED:
	default:
		free(*arr);
		return 16;
	}

	aferr = af_create_handle(&(*arr)->values, rank, shape, aftyp);

	if (aferr != AF_SUCCESS) {
		free(*arr);
		return 99;
	}

	return 0;
}

DECLSPEC void
release_array(struct array *arr)
{
	if (arr == NULL)
		return;

	arr->refc--;

	if (arr->refc)
		return;

	if (arr->type == ARR_NESTED) {
		struct array **values = arr->values;

		for (unsigned int i = 0; i < arr->rank; i++)
			release_array(values[i]);
	}

	if (arr->values)
		switch (arr->storage) {
		case STG_HOST:
			free(arr->values);
			break;
		case STG_DEVICE:
			af_release_array(arr->values);
			break;
		default:
			dwa_error(999, L"Unknown storage type.");
		}

	free(arr);
}
