#include <stdlib.h>
#include <error.h>
#include <inttypes.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

#include "codfns.h"
#include "s.h"

/* The following are not complete implementations of anything and 
 * exist only for the benefit of getting the runtime working quickly.
 */
 
int static inline
scale_shape(struct codfns_array *arr, uint16_t rank)
{
	uint32_t *buf;

	buf = arr->shape;

	if (rank > arr->rank) {
		buf = realloc(buf, sizeof(uint32_t) * rank);
		if (buf == NULL) {
			perror("scale_shape");
			return 1;
		}
	}

	arr->rank = rank;
	arr->shape = buf;

	return 0;
}

int
codfns_indexgenm(struct codfns_array *res,
    struct codfns_array *lft, struct codfns_array *rgt)
{
	uint32_t i;
	int64_t cnt, *dat;
	
	cnt = *((int64_t *)rgt->elements);
	
	if (scale_shape(res, 1)) {
		perror("codfns_indexgen");
		return 1;
	}
	
	if (scale_elements(res, cnt)) {
		perror("codfns_indexgen");
		return 2;
	}
	
	res->type = 2;
	dat = res->elements;
	
	for (i = 0; i < cnt; i++)
		*dat++ = i;
		
	return 0;
}


int
codfns_squadd(struct codfns_array *res,
    struct codfns_array *lft, struct codfns_array *rgt)
{
	int row;
	
	if (scale_shape(res, 1)) {
		perror("codfns_squad");
		return 1;
	}
	
	if (scale_elements(res, rgt->shape[1])) {
		perror("codfns_squad");
		return 2;
	}
	
	res->type = rgt->type;
	*res->shape = rgt->shape[1];
	row = *((int64_t *)lft->elements);
	
	if (res->type == 3) {
		double *elems = rgt->elements;
		elems += row * res->size;
		memcpy(res->elements, elems, sizeof(double) * res->size);
	} else {
		int64_t *elems = rgt->elements;
		elems += row * res->size;
		memcpy(res->elements, elems, sizeof(int64_t) * res->size);
	}
	
	return 0;
}

int
codfns_indexd(struct codfns_array *res,
    struct codfns_array *lft, struct codfns_array *rgt)
{
	uint64_t i;
	int64_t *lfte;
	
	/*printf("Index ");*/
	
	if (copy_shape(res, lft)) {
		perror("codfns_index");
		return 1;
	}
	
	if (scale_elements(res, lft->size)) {
		perror("codfns_index");
		return 2;
	}
	
	res->type = rgt->type;
	lfte = lft->elements;
	
	if (res->type == 3) {
		double *rgte = rgt->elements;
		double *rese = res->elements;
		for (i = 0; i < res->size; i++)
			*rese++ = rgte[*lfte++];
	} else {
		int64_t *rgte = rgt->elements;
		int64_t *rese = res->elements;
		for (i = 0; i < res->size; i++)
			*rese++ = rgte[*lfte++];
	}

	/*print_shape(lft);
	print_shape(rgt);
	printf(" lft: %ld rgt: %ld res: %ld\n", lft->size, rgt->size, res->size);*/
	
	return 0;
}

int
codfns_reshapem(struct codfns_array *res,
    struct codfns_array *lft, struct codfns_array *rgt)
{
	uint64_t i;
	uint32_t *rgts;
	int64_t *rese;

	if (scale_shape(res, 1)) {
		perror("codfns_reshape");
		return 1;
	}

	if (scale_elements(res, rgt->rank)) {
		perror("codfns_reshape");
		return 2;
	}

	res->type = 2;
	*res->shape = rgt->rank;
	rese = res->elements;
	rgts = rgt->shape;

	for (i = 0; i < rgt->rank; i++)
		*rese++ = *rgts++;

	return 0;
}

int
codfns_reshaped(struct codfns_array *res,
    struct codfns_array *lft, struct codfns_array *rgt)
{
	uint64_t i, size;
	int64_t *lfte;
	uint32_t *ress;
	size_t esize;
	
	if (scale_shape(res, lft->size)) {
		perror("codfns_reshape");
		return 3;
	}

	lfte = lft->elements;

	for (i = 0, size = 1; i < lft->size; i++)
		size *= *lfte++;

	if (scale_elements(res, size)) {
		perror("codfns_reshape");
		return 4;
	}

	res->type = rgt->type;
	esize = res->type == 3 ? sizeof(double) : sizeof(int64_t);
	ress = res->shape;
	lfte = lft->elements;

	for (i = 0; i < lft->size; i++)
		*ress++ = *lfte++;

	memcpy(res->elements, rgt->elements, esize * size);
	
	return 0;
}

int
codfns_catenated(struct codfns_array *res,
    struct codfns_array *lft, struct codfns_array *rgt)
{
	uint64_t i, lsz, rsz;
	uint32_t sz;
	
	if (scale_shape(res, 1)) {
		perror("codfns_catenate");
		return 1;
	}
	
	lsz = lft->size;
	rsz = rgt->size;
	sz = lsz + rsz;
	
	if (scale_elements(res, sz)) {
		perror("codfns_catenate");
		return 2;
	}
	
	*res->shape = sz;
	res->type = lft->type;
	
	if (res->type == 3) {
		double *rese = res->elements;
		double *lfte = lft->elements;
		double *rgte = rgt->elements;
		
		if (rgt == res) {
			rese += lsz;
			for (i = 0; i < rsz; i++)
				*rese++ = *rgte++;
			rese = res->elements;
			for (i = 0; i < lsz; i++)
				*rese++ = *lfte++;
		} else if (lft == res) {
			rese += lsz;
			for (i = 0; i < rsz; i++)
				*rese++ = *rgte++;
		} else {
			for (i = 0; i < lsz; i++)
				*rese++ = *lfte++;
			for (i = 0; i < rsz; i++)
				*rese++ = *rgte++;
		}
	} else {
		int64_t *rese = res->elements;
		int64_t *lfte = lft->elements;
		int64_t *rgte = rgt->elements;
	
		if (rgt == res) {
			rese += lsz;
			for (i = 0; i < rsz; i++)
				*rese++ = *rgte++;
			rese = res->elements;
			for (i = 0; i < lsz; i++)
				*rese++ = *lfte++;
		} else if (lft == res) {
			rese += lsz;
			for (i = 0; i < rsz; i++)
				*rese++ = *rgte++;
		} else {
			for (i = 0; i < lsz; i++)
				*rese++ = *lfte++;
			for (i = 0; i < rsz; i++)
				*rese++ = *rgte++;
		}
	}
		
	return 0;
}

int
codfns_ptredd(struct codfns_array *res,
    struct codfns_array *lft, struct codfns_array *rgt)
{
	uint64_t i;
	double val, *lfte, *rgte;
	
	if (scale_shape(res, 0)) {
		perror("codfns_ptred");
		return 1;
	}
	
	if (scale_elements(res, 1)) {
		perror("codfns_ptred");
		return 2;
	}
	
	lfte = lft->elements;
	rgte = rgt->elements;
	val = 0;
	
	for (i = 0; i < rgt->size; i++) 
		val += *lfte++ * *rgte++;
		
	*((double *)res->elements) = val;

	return 0;
}

int
codfns_eachm(struct codfns_array *res,
    struct codfns_array *lft, struct codfns_array *rgt,
    int (*fn)(struct codfns_array *, struct codfns_array *,
        struct codfns_array *, struct codfns_array **),
    struct codfns_array **env)
{
	int code;
	uint64_t i;
	double *rese, *srgte;
	struct codfns_array sres, srgt;

	if (copy_shape(res, rgt)) {
		perror("codfns_each");
		return 1;
	}
	
	if (scale_elements(res, rgt->size)) {
		perror("codfns_each");
		return 2;
	}
	
	sres.rank = 0;
	sres.size = 0;
	sres.type = 2;
	sres.shape = NULL;
	sres.elements = NULL;
	
	srgt.rank = 0;
	srgt.size = 1;
	srgt.type = rgt->type;
	srgt.shape = NULL;
	srgte = srgt.elements = rgt->elements;
	
	rese = res->elements;
	
	for (i = 0; i < res->size; i++) {
		if ((code = fn(&sres, NULL, &srgt, env)))
			return code;
		
		srgt.elements = ++srgte;
		*rese++ = *((double *)sres.elements);
	}
	
	res->type = sres.type;
	
	array_free(&sres);

	return 0;
}

int
print_array(struct codfns_array *arr)
{
	int i;
	
	printf("\nRank: %d\n", arr->rank);
	printf("Size: %lu\n", arr->size);
	printf("Type: %d\n", arr->type);
	printf("Shape: ");
	
	for (i = 0; i < arr->rank; i++)
		printf("%d ", arr->shape[i]);
	
	printf("\nElements: ");
	
	if (arr->type == apl_type_d)
		for (i = 0; i < arr->size; i++)
			printf("%lf ", ((double *)arr->elements)[i]);
	else if (arr->type == apl_type_i)
		for (i = 0; i < arr->size; i++)
			printf("%ld ", ((int64_t *)arr->elements)[i]);
	else
		printf("N/A");
	
	printf("\n");
	
	return 0;
}
