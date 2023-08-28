#include <stdlib.h>
#include <string.h>

#include "internal.h"

DECLSPEC int
mk_func(struct cell_func **k, func_mon fm, func_dya fd, unsigned int fs)
{
	size_t sz;
	struct cell_func *ptr;

	sz = sizeof(struct cell_func) + fs * sizeof(void *);
	ptr = malloc(sz);

	if (ptr == NULL)
		return 1;

	ptr->ctyp = CELL_FUNC;
	ptr->refc = 1;
	ptr->fptr_mon = fm;
	ptr->fptr_dya = fd;
	ptr->fs = fs;
	ptr->opts = NULL;
	ptr->fv = ptr->fv_;
	
	for (unsigned int i = 0; i < fs; i++)
		ptr->fv[i] = NULL;

	*k = ptr;

	return 0;
}

DECLSPEC int
mk_moper(struct cell_moper **k, 
    func_mon fam, func_dya fad, func_mon ffm, func_dya ffd,
    unsigned int fs)
{
	size_t sz;
	struct cell_moper *ptr;

	sz = sizeof(struct cell_moper) + fs * sizeof(void *);
	ptr = malloc(sz);

	if (ptr == NULL)
		return 1;

	ptr->ctyp = CELL_MOPER;
	ptr->refc = 1;
	ptr->fptr_am = fam;
	ptr->fptr_ad = fad;
	ptr->fptr_fm = ffm;
	ptr->fptr_fd = ffd;
	ptr->fs = fs;

	for (unsigned int i = 0; i < fs; i++)
		ptr->fv[i] = NULL;

	*k = ptr;

	return 0;
}

DECLSPEC int
mk_doper(struct cell_doper **k, 
    func_mon faam, func_dya faad, func_mon fafm, func_dya fafd,
    func_mon ffam, func_dya ffad, func_mon fffm, func_dya fffd,
    unsigned int fs)
{
	size_t sz;
	struct cell_doper *ptr;

	sz = sizeof(struct cell_doper) + fs * sizeof(void *);
	ptr = malloc(sz);

	if (ptr == NULL)
		return 1;

	ptr->ctyp = CELL_DOPER;
	ptr->refc = 1;
	ptr->fptr_aam = faam;
	ptr->fptr_aad = faad;
	ptr->fptr_afm = fafm;
	ptr->fptr_afd = fafd;
	ptr->fptr_fam = ffam;
	ptr->fptr_fad = ffad;
	ptr->fptr_ffm = fffm;
	ptr->fptr_ffd = fffd;
	ptr->fs = fs;

	for (unsigned int i = 0; i < fs; i++)
		ptr->fv[i] = NULL;

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
		release_cell(k->fv_[i]);
	
	free(k);
}

DECLSPEC void
release_moper(struct cell_moper *k)
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
}

DECLSPEC void
release_doper(struct cell_doper *k)
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
}
