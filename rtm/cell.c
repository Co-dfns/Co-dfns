#include <stdlib.h>

#include "codfns.h"

DECLSPEC int
mk_void(struct cell_void **cell)
{
        struct cell_void *ptr;

        ptr = malloc(sizeof(struct cell_void));

        if (ptr == NULL)
                return 1;

        ptr->ctyp = CELL_VOID;
        ptr->refc = 1;
        *cell = ptr;

        return 0;
}
DECLSPEC void
release_void(struct cell_void *cell)
{
        if (cell == NULL)
                return;

        if (--cell->refc)
                return;

        free(cell);
}
DECLSPEC void
release_cell(void *cell)
{
        if (cell == NULL)
                return;

        switch (((struct cell_void *)cell)->ctyp) {
        case CELL_VOID:
                release_void(cell);
                break;
        case CELL_ARRAY:
                release_array(cell);
                break;
        case CELL_BOX:
                release_box(cell);
                break;
        case CELL_CLOSURE:
                release_closure(cell);
                break;
        default:
                dwa_error(99);
        }
}
DECLSPEC void *
retain_cell(void *cell)
{
        if (cell != NULL)
                ((struct cell_void *)cell)->refc++;

        return cell;
}
