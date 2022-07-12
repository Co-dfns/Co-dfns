#include <stddef.h>
#include <stdlib.h>
#include <arrayfire.h>

#include "codfns.h"

#if AF_API_VERSION < 38
#error "Your ArrayFire version is too old."
#endif

int
fill_device_array(struct array *arr, void *vals, size_t size, enum array_type typ)
{
        af_dtype        aftyp;

        arr->values = NULL;

        switch (typ) {
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

        case ARR_NESTED:
        case ARR_CHAR:
        case ARR_MIXED:
        default:
                return 16;
        }

        if (!size) {
                size = 1;

                return af_constant(&arr->values, 0, 1, &size, aftyp);
        }

        return af_create_array(&arr->values, vals, 1, &size, aftyp);
}

int
fill_host_array(struct array *arr, void *vals, size_t size, enum array_type typ)
{
        struct array **data;
        struct pocket **pkts;
        int     err;

        if (typ != ARR_NESTED)
                return 16;

        arr->values = NULL;

        if (!size)
                size++;

        pkts = vals;
        data = calloc(size, sizeof(struct array *));

        if (data == NULL)
                return 1;

        for (size_t i = 0; i < size; i++) {
                err = dwa2array(&data[i], pkts[i]);

                if (err) {
                        free(data);
                        return err;
                }
        }

        arr->values = data;

        return 0;
}

DECLSPEC int
mk_array(struct cell_array **dest,
    enum array_type type, enum array_storage storage,
    unsigned int rank, unsigned long long *shape, void *values)
{
        struct cell_array *arr;
        size_t  size;
        int     err;

        size = sizeof(struct cell_array) + rank * sizeof(unsigned long long);
        arr = malloc(size);

        if (arr == NULL)
                return 1;

        arr->ctyp       = CELL_ARRAY;
        arr->refc       = 1;
        arr->type       = type;
        arr->storage    = storage;
        arr->rank       = rank;
        arr->values     = NULL;

        size = 1;

        for (unsigned i = 0; i < rank; ++i) {
                arr->shape[i] = shape[i];
                size *= shape[i];
        }

        err = 0;

        switch (storage) {
        case STG_DEVICE:
                err = fill_device_array(arr, values, size, type);
                break;

        case STG_HOST:
                err = fill_host_array(arr, values, size, type);
                break;

        default:
                err = 16;
        }

        if (err) {
                free(arr);
                return err;
        }

        *dest = arr;

        return 0;
}
        


DECLSPEC void
release_array(struct cell_array *arr)
{
        if (arr == NULL)
                return;

        arr->refc--;

        if (arr->refc)
                return;

        if (arr->type == ARR_NESTED) {
                struct cell_array **values = arr->values;

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
                        dwa_error(999);
                }

        free(arr);
}
