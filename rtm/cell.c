#include <stdlib.h>

#include "codfns.h"

struct cell {
	enum	cell_type ctyp;
	unsigned	int refc;
};

DECLSPEC void
release_cell(void *val)
{
	if (val == NULL)
		return;

	switch (((struct cell *)val)->ctyp) {
	case CELL_ARRAY:
		release_array(val);
		break;
	case CELL_MCELL:
		release_mcell(val);
		break;
	case CELL_CLOSURE:
		release_closure(val);
		break;
	default:
		dwa_error(999, L"Unknown cell type.");
	}
}

DECLSPEC void
retain_cell(void *val)
{
	if (val != NULL)
		((struct cell *)val)->refc++;
}
