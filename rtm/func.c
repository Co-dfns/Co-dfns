#include <stdlib.h>
#include <string.h>

#include "codfns.h"

DECLSPEC int
mk_func(struct cell_func **k, func_ptr fn, unsigned int fs)
{
        size_t sz;
        struct cell_func *ptr;

        sz = sizeof(struct cell_func) + fs * sizeof(void *);
        ptr = malloc(sz);

        if (ptr == NULL)
                return 1;

        ptr->ctyp = CELL_FUNC;
        ptr->refc = 1;
        ptr->fptr = fn;
        ptr->fs = fs;

        *k = ptr;

        return 0;
}

DECLSPEC void
release_func(struct cell_func *k)
{
        if (k == NULL)
                return;
	
	if (!k->refc)
		return;

        k->refc--;

        if (k->refc)
                return;

        for (unsigned int i = 0; i < k->fs; i++)
                release_cell(k->fv[i]);
        
        free(k);
}

DECLSPEC int
apply_dop(struct cell_func **z, struct cell_func *op, void *l, void *r)
{
        int err;

        err = mk_func(z, op->fptr, op->fs+2);

        if (err)
                return err;

        (*z)->fv[0] = l;
        (*z)->fv[1] = r;

        memcpy(&(*z)->fv[2], op->fv, op->fs * sizeof(op->fv[0]));

        for (unsigned int i = 0; i < (*z)->fs; i++)
                retain_cell((*z)->fv[i]);

        return 0;
}
