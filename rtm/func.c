#include <stdlib.h>
#include <string.h>

#include "internal.h"

size_t mk_func_count = 0;
size_t mk_derf_count = 0;
size_t mk_moper_count = 0;
size_t mk_doper_count = 0;
size_t free_func_count = 0;
size_t free_derf_count = 0;
size_t free_moper_count = 0;
size_t free_doper_count = 0;

DECLSPEC int
mk_func(struct cell_func **k, func_mon fm, func_dya fd, unsigned int fs)
{
	size_t sz;
	struct cell_func *ptr;
	
	mk_func_count++;

	sz = sizeof(struct cell_func) + fs * sizeof(void *);
	ptr = malloc(sz);

	if (ptr == NULL)
		return 1;

	ptr->ctyp = CELL_FUNC;
	ptr->refc = 1;
	ptr->fptr_mon = fm;
	ptr->fptr_dya = fd;
	ptr->fs = fs;
	ptr->fv = ptr->fv_;
	
	for (unsigned int i = 0; i < fs; i++)
		ptr->fv[i] = NULL;

	*k = ptr;

	return 0;
}

DECLSPEC int
mk_derf(struct cell_derf **k, func_mon fm, func_dya fd, unsigned int fs)
{
	size_t sz;
	struct cell_derf *ptr;
	
	mk_derf_count++;

	sz = sizeof(struct cell_func) + fs * sizeof(void *);
	ptr = malloc(sz);

	if (ptr == NULL)
		return 1;

	ptr->ctyp = CELL_DERF;
	ptr->refc = 1;
	ptr->fptr_mon = fm;
	ptr->fptr_dya = fd;
	ptr->fs = fs;
	ptr->fv = ptr->fv_;
	ptr->opts = NULL;
	
	for (unsigned int i = 0; i < fs; i++)
		ptr->fv_[i] = NULL;

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
	
	mk_moper_count++;

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
	
	mk_doper_count++;

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
	
	if (k->ctyp == CELL_DERF) {
		release_derf((struct cell_derf *)k);
		return;
	}
	
	if (!k->refc)
		return;

	k->refc--;

	if (k->refc)
		return;

	free_func_count++;
	
	free(k);
}

DECLSPEC void
release_derf(struct cell_derf *k)
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
	
	free_derf_count++;
	
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
	
	free_moper_count++;
	
	free(k);
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
	
	free_doper_count++;
	
	free(k);
}

void
print_func_stats(void)
{
	printf("\tfunc alloc: %zd freed: %zd\n",
	    mk_func_count, free_func_count);
	printf("\tderf alloc: %zd freed: %zd\n",
	    mk_derf_count, free_derf_count);
	printf("\tmoper alloc: %zd freed: %zd\n",
	    mk_moper_count, free_moper_count);
	printf("\tdoper alloc: %zd freed: %zd\n",
	    mk_doper_count, free_doper_count);
}