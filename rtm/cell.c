#include <stdlib.h>

#include "internal.h"

DECLSPEC void *
retain_cell(void *cell)
{
        if (cell != NULL)
                ((struct cell_void *)cell)->refc++;

        return cell;
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
        case CELL_FUNC:
                release_func(cell);
                break;
        case CELL_MOPER:
                release_moper(cell);
                break;
        case CELL_DOPER:
                release_doper(cell);
                break;
	case CELL_DERF:
		release_derf(cell);
		break;
        default:
                exit(99);
        }
}

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
	
	if (!cell->refc)
		return;

        if (--cell->refc)
                return;

        free(cell);
}

DECLSPEC void
print_cell_stats(void)
{
	printf("Cell Statistics:\n");
	print_array_stats();
	print_func_stats();
}