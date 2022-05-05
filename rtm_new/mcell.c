#include <stdlib.h>

#include "codfns.h"

struct mcell {
	enum	cell_type ctyp;
	unsigned	int refc;
	void	*value;
};

DECLSPEC int
mk_mcell(struct mcell **box, void *value)
{
	*box = malloc(sizeof(struct mcell));

	if (*box == NULL)
		return 1;

	(*box)->ctyp	= CELL_MCELL;
	(*box)->refc	= 1;
	(*box)->value	= value;

	return 0;
}

DECLSPEC void
release_mcell(struct mcell *box)
{
	if (box == NULL)
		return;

	box->refc--;

	if (box->refc)
		return;

	release_cell(box->value);
	free(box);
}
