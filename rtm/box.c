#include <stdlib.h>

#include "codfns.h"

DECLSPEC int
mk_box(struct cell_box **box, void *value)
{
        *box = malloc(sizeof(struct cell_box));

        if (*box == NULL)
                return 1;

        (*box)->ctyp    = CELL_BOX;
        (*box)->refc    = 1;
        (*box)->value   = value;

        return 0;
}

DECLSPEC void
release_box(struct cell_box *box)
{
        if (box == NULL)
                return;

        box->refc--;

        if (box->refc)
                return;

        release_cell(box->value);
        free(box);
}
