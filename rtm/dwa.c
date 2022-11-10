#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <arrayfire.h>

#include "internal.h"

#define DATA(pp) ((void *)&(pp)->shape[(pp)->rank])

struct dwa_fns {
	long long size;
	struct {
		long long size;
		void *fns[18];
	} *ws;
};

enum dwa_type { 
	APLNC=0, APLU8, APLTI, APLSI, APLI, APLD, 
	APLP,    APLU,  APLV,  APLW,  APLZ, APLR, APLF, APLQ
};

struct pocket {
	long    long length;
	long    long refcount;
	unsigned        int type        : 4;
	unsigned        int rank        : 4;
	unsigned        int eltype      : 4;
	unsigned        int _0          : 13;
	unsigned        int _1          : 16;
	unsigned        int _2          : 16;
	long    long shape[1];
};

struct localp {
	struct pocket *pocket;
	void *i;
};

struct pocket *(*getarray)(enum dwa_type, unsigned int, long long *, struct localp *);
struct pocket *(*scalnum)(int);

DECLSPEC int
set_dwafns(void *p)
{
	struct dwa_fns *dwa;

	if (p == NULL)
		return 0;

	dwa = p;

	if (dwa->size < (long long)sizeof(struct dwa_fns))
		return 16;

	getarray = dwa->ws->fns[0];
	scalnum = dwa->ws->fns[12];

	return 0;
}

size_t
dwa_count(struct pocket *pkt)
{
	size_t	count;
	
	count	= 1;
	
	for (unsigned int i = 0; i < pkt->rank; i++)
		count *= pkt->shape[i];
	
	return count;
}

size_t
dwa_values_count(struct pocket *pkt)
{
	size_t	count;
	
	count	= dwa_count(pkt);
	
	if (!count)
		count = 1;
	
	return count;
}

char *
cnvu8_ch(struct pocket *pkt)
{
	char	*res;
	uint8_t	*buf;
	size_t	count;

	buf	= DATA(pkt);
	count	= dwa_values_count(pkt);

	res	= calloc(count, sizeof(char));

	if (res == NULL)
		return res;

	for (size_t i = 0; i < count; i++)
		res[i] = 1 & (buf[i/8] >> (7 - (i % 8)));

	return res;
}

int16_t *
cnvi8_i16(struct pocket *pkt)
{
	int16_t *res;
	int8_t	*buf;
	size_t	count;

	buf	= DATA(pkt);
	count	= dwa_values_count(pkt);
	
	res	= calloc(count, sizeof(int16_t));

	if (res == NULL) 
		return res;

	for (size_t i = 0; i < count; i++)
		res[i] = buf[i];

	return res;
}

enum array_type
dwa_array_type(enum dwa_type dtype)
{
	switch (dtype) {
	case APLU8:
		return ARR_BOOL;
	case APLTI:
		return ARR_SINT;
	case APLSI:
		return ARR_SINT;
	case APLI:
		return ARR_INT;
	case APLD:
		return ARR_DBL;
	case APLZ:
		return ARR_CMPX;
	case APLP:
		return ARR_NESTED;
	default:
		return -1;
	}
}

enum dwa_type
array_dwa_type(enum array_type type)
{
	switch (type) {
	case ARR_SPAN:
		return APLNC;
        case ARR_BOOL:
		return APLU8;
	case ARR_SINT:
		return APLSI;
	case ARR_INT:
		return APLI;
	case ARR_DBL:
		return APLD;
	case ARR_CMPX:
		return APLZ;
        case ARR_CHAR8:
		return APLU;
	case ARR_CHAR16:
		return APLV;
	case ARR_CHAR32:
		return APLW;
        case ARR_MIXED:
		return APLNC;
	case ARR_NESTED:
		return APLP;
	default:
		return APLNC;
	}
}

enum array_storage
dwa_array_storage(unsigned int type)
{
	switch (type) {
	case 15:
		return STG_DEVICE;
	case 7:
		return STG_HOST;
	default:
		return -1;
	}
}

int dwa2array(struct cell_array **tgt, struct pocket *pkt);

int
copydat_dwa2arr(struct cell_array *arr, struct pocket *pkt)
{
	void	*data;
	size_t	count;
	int 	err;
	struct	cell_array **cells;
	struct	pocket **pkts;
	
	if (arr->storage == STG_DEVICE && pkt->type == 7)
		return 16;
	
	switch (pkt->eltype) {
	case APLU8:
		data = cnvu8_ch(pkt);
		break;
	case APLTI:
		data = cnvi8_i16(pkt);
		break;
	default:
		data = DATA(pkt);
	}
	
	if (data == NULL)
		return 1;
	
	if (arr->type != ARR_NESTED) {
		err = fill_array(arr, data);

		if (pkt->eltype == APLU8 || pkt->eltype == APLTI)
			free(data);
		
		return err;	
	}
	
	count	= array_values_count(arr);
	cells	= arr->values;
	pkts	= data;
	
	for (size_t i = 0; i < count; i++) {
		err = dwa2array(&cells[i], pkts[i]);
		
		if (err)
			return err;
	}
	
	return 0;
}

int
dwa2array(struct cell_array **tgt, struct pocket *pkt)
{
	struct	cell_array *arr;
	int	err;
	enum	array_type type;
	enum	array_storage storage;
		
	if (pkt == NULL) {
		*tgt = NULL;

		return 0;
	}
	
	storage	= dwa_array_storage(pkt->type);
	type	= dwa_array_type(pkt->eltype);
	
	if (type == -1 || storage == -1)
		return 16;
	
	err = mk_array(&arr, type, storage, pkt->rank);
	
	if (err)
		return err;
	
	for (unsigned int i = 0; i < arr->rank; i++)
		arr->shape[i] = pkt->shape[i];
	
	err = copydat_dwa2arr(arr, pkt);
	
	if (err) {
		release_array(arr);
		return err;
	}
	
	*tgt = arr;

	return 0;
}

int
array2dwa(struct pocket **dst, struct cell_array *arr, struct localp *lp)
{
	struct	pocket *pkt;
	int	err;
	
	if (arr == NULL) {
		if (lp)
			lp->pocket = NULL;
		
		if (dst)
			*dst = NULL;

		return 0;
	}

	if (arr->rank > 15 || arr->type == ARR_SPAN)
		return 16;
	
	pkt = getarray(array_dwa_type(arr->type), arr->rank, arr->shape, lp);
	
	if (arr->storage == STG_DEVICE) {
		err = af_get_data_ptr(DATA(pkt), arr->values);
		
		if (err)
			return err;
	} else if (arr->type != ARR_NESTED) {
		memcpy(DATA(pkt), arr->values,
		    array_values_count(arr) * array_element_size(arr));
	} else if (arr->type == ARR_NESTED) {
		struct pocket **pkts = DATA(pkt);
		struct cell_array **ptrs = arr->values;
		size_t count = array_values_count(arr);

		for (size_t i = 0; i < count; i++) {
			err = array2dwa(&pkts[i], ptrs[i], NULL);

			if (err)
				return err;
		}
	} else {
		return 99;
	}

	if (dst)
		*dst = pkt;

	return 0;
}

DECLSPEC int
call_dwa(topfn_ptr fn, void *zptr, void *lptr, void *rptr)
{
	struct localp *zp, *lp, *rp;
	struct cell_array *z, *l, *r;
	int err;
	
	zp = zptr;
	lp = lptr;
	rp = rptr;
	
	if (lp)
		if (err = dwa2array(&l, lp->pocket))
			return err;
	
	if (rp)
		if (err = dwa2array(&r, rp->pocket)) {
			release_array(l);
			return err;
		}
	
	z = NULL;
	err = fn(&z, l, r);
	
	release_array(l);
	release_array(r);
	
	if (err == -1) {
		zp->pocket = scalnum(0);
		return err;
	}
		
	
	if (err)
		return err;
	
	err = array2dwa(NULL, z, zp);

	release_array(z);
	
	if (err)
		return err;
		
	return 0;
}
