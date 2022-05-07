#include <stdlib.h>
#include <string.h>

#include "codfns.h"

struct closure {
	enum	cell_type ctyp;
	unsigned	int refc;
	unsigned	int fs;
	int	(*fn)(void **, void *, void *, void **);
	void	*fv[];
};

DECLSPEC int
mk_closure(struct closure **clr,
    int (*fn)(void **, void *, void *, void **), 
    unsigned int fs)
{
	*clr = malloc(sizeof(struct closure) + fs * sizeof(void *));

	if (*clr == NULL)
		return 1;

	(*clr)->ctyp	= CELL_CLOSURE;
	(*clr)->refc	= 1;
	(*clr)->fs	= fs;
	(*clr)->fn	= fn;

	return 0;
}

DECLSPEC void
release_closure(struct closure *clr)
{
	if (clr == NULL)
		return;

	clr->refc--;

	if (clr->refc)
		return;

	for (unsigned int i = 0; i < clr->fs; i++)
		release_cell(clr->fv[i]);
	
	free(clr);
}

DECLSPEC int
apply_oper(struct closure **z, struct closure *op, void *l, void *r)
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
