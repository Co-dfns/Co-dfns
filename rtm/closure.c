#include <stdlib.h>
#include <string.h>

#include "codfns.h"

DECLSPEC int
mk_closure(struct cell_closure **k,
    int (*fn)(struct cell_array **,
        struct cell_array *, struct cell_array *, void **),
    unsigned int fs)
{
        size_t sz;
        struct cell_closure *ptr;

        sz = sizeof(struct cell_closure) + fs * sizeof(void *);
        ptr = malloc(sz);

        if (ptr == NULL)
                return 1;

        ptr->ctyp = CELL_CLOSURE;
        ptr->refc = 1;
        ptr->fn = fn;
        ptr->fs = fs;

        *k = ptr;

        return 0;
}

DECLSPEC void
release_closure(struct cell_closure *k)
{
        if (k == NULL)
                return;

        k->refc--;

        if (k->refc)
                return;

        for (unsigned int i = 0; i < k->fs; i++)
                release_cell(k->fv[i]);
        
        free(k);
}
DECLSPEC int
apply_dop(struct cell_closure **z,
    struct cell_closure *op, void *l, void *r)
{
        int err;

        err = mk_closure(z, op->fn, op->fs+2);

        if (err)
                return err;

        (*z)->fv[0] = l;
        (*z)->fv[1] = r;

        memcpy(&(*z)->fv[2], op->fv, op->fs * sizeof(op->fv[0]));

        for (unsigned int i = 0; i < (*z)->fs; i++)
                retain_cell((*z)->fv[i]);

        return 0;
}
