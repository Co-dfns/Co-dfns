/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * Core runtime
 * 
 * Copyright (c) 2012 Aaron Hsu <arcfide@sacrideo.us>
 * 
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#include <stdbool.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "runtime.h"
 
/* Allocation Slots */

#define DEFAULT_ELEM_HEAP 16*1024*1024
#define DEFUALT_SAF_HEAP  16*1024*1024  

void *apl_elems = NULL;
void *apl_elems_max = NULL;
void *apl_elems_cur = NULL;

void *apl_saflg = NULL;
void *apl_saflg_cur = NULL;
void *apl_saflg_max = NULL;

/* Error reporting */

#define APLERRALLOCTYP 2
#define APLERRALLOCTYP_MSG "Unknown element type for allocation"

#define APLERRALLOCFAIL 3
#define APLERRALLOCFAIL_MSG "Failed to allocate heap space"

#define APLERRFREEOVER 4
#define APLERRFREEOVER_MSG "Freed too much memory"

#define APLERRTYPE 5
#define APLERRTYPE_MSG "Unknown array element type"

#define APLERRBADSHAPE 6
#define APLERRBADSHAPE_MSG "Incompatible shapes"

#define APLERRDOMAIN 7
#define APLERRDOMAIN_MSG "Bad domain"

void
runtime_error(int type)
{
	char *msg;
	
	switch(type) {
	case APLERRALLOCTYP: msg = APLERRALLOCTYP_MSG;  break;
	case APLERRALLOCFAIL: msg = APLERRALLOCFAIL_MSG; break;
	case APLERRFREEOVER: msg = APLERRFREEOVER_MSG; break;
	case APLERRTYPE: msg = APLERRTYPE_MSG; break;
	case APLERRBADSHAPE: msg = APLERRBADSHAPE_MSG; break;
	case APLERRDOMAIN: msg = APLERRDOMAIN_MSG; break;
	default: msg = "Unknown error";
	}
	
	fprintf(stderr, "Runtime error: %s.\n", msg);
	exit(type);
}

/* Allocation functions */

void *
alloc_elems(size_t count, enum etype type)
{
	size_t alloc_size, new_size, offset;
	void *ptr, *new;
	
	ptr = apl_elems_cur;
	
	switch (type) {
	case ELCHR: ptr += count * sizeof(AplChr); break;
	case ELINT: ptr += count * sizeof(AplInt); break;
	case ELFLT: ptr += count * sizeof(AplFlt); break;
	case ELMIX: ptr += count * sizeof(AplMix); break;
	default: runtime_error(APLERRALLOCTYP);
	}
	
	if (ptr >= apl_elems_max) {
		alloc_size = apl_elems_max - apl_elems;
		offset = ptr - apl_elems;
		
		new_size = 0 == alloc_size ? DEFAULT_ELEM_HEAP : alloc_size;
		
		while (new_size <= offset) new_size *= 1.5;
		
		new = realloc(apl_elems, new_size);
		
		if (NULL == new) {
			perror("alloc_elems");
			runtime_error(APLERRALLOCFAIL);
		}
		
		apl_elems = new;
		apl_elems_max = apl_elems + new_size;
		ptr = apl_elems + offset;
	}
	
	apl_elems_cur = ptr;
	
	return ptr;
}

void
free_elems(size_t count, enum etype type)
{
	void *ptr;
	
	ptr = apl_elems_cur;
	
	switch (type) {
	case ELCHR: ptr -= count * sizeof(AplChr); break;
	case ELINT: ptr -= count * sizeof(AplInt); break;
	case ELFLT: ptr -= count * sizeof(AplFlt); break;
	case ELMIX: ptr -= count * sizeof(AplMix); break;
	default: runtime_error(APLERRALLOCTYP);
	}
	
	if (ptr < apl_elems) runtime_error(APLERRFREEOVER);
	
	apl_elems_cur = ptr;
}

/* Array creation */

void
init_array(struct array *arr, enum etype type) 
{
	int i;
	dimension_t *shape;
	
	shape = arr->shape;
	
	for (i = 0; i < MAXRANK; i++) *shape++ = SHAPEEND;
	
	arr->type = type;
	arr->size = 0;
	arr->data = NULL;
	arr->sasize = 0;
	arr->saflg = NULL;
}

void
init_data(struct array *arr, size_t size)
{
	arr->size = size;
	arr->data = alloc_elems(size, arr->type);
}

/* Function/Operator creation */

void 
init_function(struct function *fn, AplFunction code, 
    struct operand *lop, struct operand *rop, struct operand *env)
{
	fn->code = code;
	fn->lop = lop;
	fn->rop = rop;
	fn->env = env;
}

/* Calling functions */

void
call(struct function *fn, struct array *res, 
    struct array *lft, struct array *rgt)
{
	(fn->code)(res, lft, rgt, fn);
}

/* Print an Array */

void
print_chr(dimension_t *shape, AplChr *data)
{
	int i, j;
	
	for (i = 0; *shape != SHAPEEND && i < MAXRANK; i++, shape++)
		for(j = 0; j < *shape; j++)
			printf("%lc ", *data++);
}

void
print_int(dimension_t *shape, AplInt *data)
{
	int i, j;
	
	for (i = 0; *shape != SHAPEEND && i < MAXRANK; i++, shape++)
		for(j = 0; j < *shape; j++)
			printf("%lld ", *data++);
}

void
print_flt(dimension_t *shape, AplFlt *data)
{
	int i, j;
	
	for (i = 0; *shape != SHAPEEND && i < MAXRANK; i++, shape++)
		for(j = 0; j < *shape; j++)
			printf("%lf ", *data++);
}

void
print_mix(dimension_t *shape, AplMix *data)
{
	int i, j;
	
	for (i = 0; *shape != SHAPEEND && i < MAXRANK; i++, shape++) {
		for(j = 0; j < *shape; j++) {
			switch (data->type) {
			case ELCHR: 
				printf("%lc ", data->value.character);
				break;
			case ELINT:
				printf("%lld ", data->value.integer);
				break;
			case ELFLT:
				printf("%lf ", data->value.floating);
				break;
			default: runtime_error(APLERRTYPE);
			}
		}
	}
}

void
print_scalar(enum etype type, union value *val)
{
	switch (type) {
	case ELCHR: printf("%lc ", val->character); break;
	case ELINT: printf("%lld ", val->integer); break;
	case ELFLT: printf("%lf ", val->floating); break;
	case ELMIX: 
		print_scalar(val->mixed.type, 
		    (union value *)&val->mixed.value); break;
	default: runtime_error(APLERRTYPE);
	}
}

void
apl_print(struct array *arr)
{
	dimension_t *shape;
	void *data;
	
	if (0 == rank(arr)) {
		print_scalar(arr->type, (union value *)arr->data);
	} else {
		shape = arr->shape;
		data = arr->data;
	
		switch (arr->type) {
		case ELCHR: print_chr(shape, data); break;
		case ELINT: print_int(shape, data); break;
		case ELFLT: print_flt(shape, data); break;
		case ELMIX: print_mix(shape, data); break;
		default: runtime_error(APLERRTYPE);
		}
	}
	
	printf("\n");
}

/* Primitive Functions and Operators */

void
apl_assign(struct array *res, size_t idx, union value val)
{
	switch(res->type) {
	case ELCHR: ((AplChr *) (res->data))[idx] = val.character; break;
	case ELINT: ((AplInt *) (res->data))[idx] = val.integer; break;
	case ELFLT: ((AplFlt *) (res->data))[idx] = val.floating; break;
	case ELMIX: ((AplMix *) (res->data))[idx] = val.mixed; break;
	default: runtime_error(APLERRTYPE);
	}
}

void
apl_copy(struct array *tgt, struct array *src)
{
	tgt->type = src->type;
	tgt->size = src->size;
	tgt->sasize = src->sasize;
	
	memcpy(tgt->shape, src->shape, MAXRANK);
	memcpy(tgt->data, src->data, src->size);
	memcpy(tgt->saflg, src->saflg, src->sasize);
}

bool
same_shape(struct array *a, struct array *b)
{
	int i;
	dimension_t *as, *bs;
	
	as = a->shape;
	bs = b->shape;
	
	for (i = 0; i < MAXRANK; i++)
		if (*as++ != *bs++) return false;
	
	return true;
}

unsigned short 
rank(struct array *arr)
{
	int i;
	unsigned short rnk;
	dimension_t *shp;
	
	shp = arr->shape;	
	rnk = 0;
	
	for (i = 0; SHAPEEND != *shp++ && i < MAXRANK; i++)
		rnk++;
	
	return rnk;
}

size_t
product(struct array *arr)
{
	size_t res, size, i;
	
	size = arr->size;
	res = 1;
	
	for (i = 0; i < size; i++) {
		res *= ((AplInt *) arr->data)[i];
	}
	
	return res;
}

size_t
typesize(enum etype type) 
{
	switch(type) {
	case ELCHR: return sizeof(AplChr);
	case ELINT: return sizeof(AplInt);
	case ELFLT: return sizeof(AplFlt);
	case ELMIX: return sizeof(AplMix);
	default: runtime_error(APLERRTYPE);
	}
}

void
apl_iota(struct array *res, struct array *lft, struct array *rgt,
    struct function *fn)
{
	int64_t i, cnt;
	
	cnt = ((AplInt *) rgt->data)[0];
	
	for (i = 0; i < cnt; i++)
		((AplInt *) res->data)[i] = i;
	
	for (i = 1; i < MAXRANK; i++)
		res->shape[i] = SHAPEEND;
	
	res->shape[0] = cnt;
}

void
apl_plus_same(struct array *res, struct array *lft, struct array *rgt)
{
	size_t i, size;
	dimension_t *rs, *os;
	
	os = lft->shape;
	rs = res->shape;
	
	for (i = 0; i < MAXRANK; i++) *rs++ = *os++;
	
	size = lft->size;
	
	if (ELINT == lft->type && ELINT == rgt->type) {
		res->type = ELINT;
		for (i = 0; i < size; i++) {
			((AplInt *) res->data)[i] =
			    ((AplInt *) lft->data)[i] 
			    + ((AplInt *) rgt->data)[i];
		}
	} else if (ELINT == lft->type && ELFLT == rgt->type) {
		res->type = ELFLT;
		for (i = 0; i < size; i++) {
			((AplFlt *) res->data)[i] =
			    ((AplInt *) lft->data)[i] 
			    + ((AplFlt *) rgt->data)[i];
		}
	} else if (ELFLT == lft->type && ELINT == rgt->type) {
		res->type = ELFLT;
		for (i = 0; i < size; i++) {
			((AplFlt *) res->data)[i] =
			    ((AplFlt *) lft->data)[i] 
			    + ((AplInt *) rgt->data)[i];
		}
	} else if (ELFLT == lft->type && ELFLT == rgt->type) {
		res->type = ELFLT;
		for (i = 0; i < size; i++) {
			((AplFlt *) res->data)[i] =
			    ((AplFlt *) lft->data)[i] 
			    + ((AplFlt *) rgt->data)[i];
		}
	} else {
		runtime_error(APLERRDOMAIN);
	}
}

void
apl_plus_scalar(struct array *res, struct array *scl, struct array *arr)
{
	size_t i, size;
	
	size = arr->size;
	
	if (ELINT == scl->type && ELINT == arr->type) {
		AplInt val = ((AplInt *) scl->data)[0];
		res->type = ELINT;
		for (i = 0; i < size; i++) {
			((AplInt *) res->data)[i] = 
			    val + ((AplInt *) res->data)[i];
		}
	} else if (ELINT == scl->type && ELFLT == arr->type) {
		AplInt val = ((AplInt *) scl->data)[0];
		res->type = ELFLT;
		for (i = 0; i < size; i++) {
			((AplFlt *) res->data)[i] = 
			    val + ((AplFlt *) res->data)[i];
		}
	} else if (ELFLT == scl->type && ELINT == arr->type) {
		AplFlt val = ((AplFlt *) scl->data)[0];
		res->type = ELFLT;
		for (i = 0; i < size; i++) {
			((AplFlt *) res->data)[i] = 
			    val + ((AplInt *) res->data)[i];
		}
	} else if (ELFLT == scl->type && ELFLT == arr->type) {
		AplFlt val = ((AplInt *) scl->data)[0];
		res->type = ELFLT;
		for (i = 0; i < size; i++) {
			((AplFlt *) res->data)[i] = 
			    val + ((AplFlt *) res->data)[i];
		}
	} else {
		runtime_error(APLERRDOMAIN);
	}
}

void 
apl_plus(struct array *res, struct array *lft, struct array *rgt,
    struct function *fn)
{
	if (same_shape(lft, rgt))
		apl_plus_same(res, lft, rgt);
	else if (0 == rank(lft))
		apl_plus_scalar(res, lft, rgt);
	else if (0 == rank(rgt))
		apl_plus_scalar(res, rgt, lft);
	else
		runtime_error(APLERRBADSHAPE);
}

void
apl_each_same(struct array *res, struct array *lft, struct array *rgt,
    struct function *fn)
{
	size_t i, len, offa, offb, offr;
	dimension_t *rs, *os;
	struct array sa, sb, sr;
	struct function *lop;
	
	rs = res->shape;
	os = lft->shape;
	
	for (i = 0; i < MAXRANK; i++) *rs++ = *os++;

	len = lft->size;
	
	if (0 == len) return;
	
	lop = fn->lop->value.fun;
	
	init_array(&sa, lft->type);
	init_array(&sb, rgt->type);
	init_array(&sr, ELUNSET);
	
	sa.size = sb.size = sr.size = 1;	
	
	sa.data = lft->data;
	sb.data = rgt->data;
	sr.data = res->data;
	
	offa = typesize(lft->type);
	offb = typesize(rgt->type);
	
	call(lop, &sr, &sa, &sb);
	
	offr = typesize(sr.type);
	
	for (i = 1; i < len; i++) {
		sa.data += offa;
		sb.data += offb;
		sr.data += offr; 
		call(lop, &sr, &sa, &sb);
	}
}

void
apl_each_scalar_left(struct array *res, struct array *lft, struct array *rgt, 
    struct function *fn)
{
	size_t i, len, offb, offr;
	dimension_t *rs, *os;
	struct array sb, sr;
	struct function *lop;
	
	rs = res->shape;
	os = rgt->shape;
	
	for (i = 0; i < MAXRANK; i++) *rs++ = *os++;

	len = rgt->size;
	
	if (0 == len) return;
	
	lop = fn->lop->value.fun;
	
	init_array(&sb, rgt->type);
	init_array(&sr, ELUNSET);
	
	sb.size = sr.size = 1;	
	
	sb.data = rgt->data;
	sr.data = res->data;
	
	offb = typesize(rgt->type);
	
	call(lop, &sr, lft, &sb);
	
	offr = typesize(sr.type);
	
	printf("Each %d %d\n", offb, offr);
	apl_print(rgt);
	
	for (i = 1; i < len; i++) {
		sb.data += offb;
		sr.data += offr;
		apl_print(&sb);
		call(lop, &sr, lft, &sb);
	}
	
	printf("Each Ends\n");
}

void
apl_each_scalar_right(struct array *res, struct array *lft, struct array *rgt, 
    struct function *fn)
{
	size_t i, len, offa, offr;
	dimension_t *rs, *os;
	struct array sa, sr;
	struct function *lop;
	
	rs = res->shape;
	os = lft->shape;
	
	for (i = 0; i < MAXRANK; i++) *rs++ = *os++;

	len = lft->size;
	
	if (0 == len) return;
	
	lop = fn->lop->value.fun;
	
	init_array(&sa, lft->type);
	init_array(&sr, ELUNSET);
	
	sa.size = sr.size = 1;	
	
	sa.data = lft->data;
	sr.data = res->data;
	
	offa = typesize(lft->type);
	
	call(lop, &sr, &sa, rgt);
	
	offr = typesize(sr.type);
	
	for (i = 1; i < len; i++) {
		sa.data += offa;
		sr.data += offr; 
		call(lop, &sr, &sa, rgt);
	}
}

void
apl_each(struct array *res, struct array *lft, struct array *rgt,
    struct function *fn)
{
	if (NULL == lft)
		apl_each_scalar_left(res, lft, rgt, fn);
	else if (same_shape(lft, rgt))
		apl_each_same(res, lft, rgt, fn);
	else if (0 == rank(lft))
		apl_each_scalar_left(res, lft, rgt, fn);
	else if (0 == rank(rgt))
		apl_each_scalar_right(res, lft, rgt, fn);
	else
		runtime_error(APLERRBADSHAPE);
}

void
apl_reduce(struct array *res, struct array *lft, struct array *rgt,
    struct function *fn)
{
	size_t i, len, shift;
	struct array sl;
	struct function *lop;
	
	lop = fn->lop->value.fun;
	
	for (i = 0; i < MAXRANK; i++) res->shape[i] = SHAPEEND;
	
	res->type = rgt->type;
	len = rgt->size;
	
	if (0 == len) return;
	
	switch (rgt->type) {
	case ELCHR: 
		((AplChr *) res->data)[0] = ((AplChr *) rgt->data)[len - 1];
		break;
	case ELINT:
		((AplInt *) res->data)[0] = ((AplInt *) rgt->data)[len - 1];
		break;
	case ELFLT:
		((AplFlt *) res->data)[0] = ((AplFlt *) rgt->data)[len - 1];
		break;
	case ELMIX:
		((AplMix *) res->data)[0] = ((AplMix *) rgt->data)[len - 1];
		break;
	default: runtime_error(APLERRTYPE);
	}
	
	if (1 == len) return;
	
	init_array(&sl, rgt->type);
	
	sl.size = 1;
	shift = typesize(sl.type);
	sl.data = rgt->data + shift * (len - 1);
	
	for (i = 0; i < len - 1; i++) {
		sl.data -= shift;
		call(lop, res, &sl, res);
	}
}
