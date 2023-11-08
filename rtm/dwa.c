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
	case APLU:
		return ARR_CHAR8;
	case APLV:
		return ARR_CHAR16;
	case APLW:
		return ARR_CHAR32;
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
		return APLTI;
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
dwa_array_storage(struct pocket *pkt)
{
	size_t count;
	unsigned int type;
	
	type = pkt->type;
	
	if (type != 15 && type != 7)
		return -1;
	
	if (type == 7)
		return STG_HOST;
	
	count = 1;
	
	for (unsigned int i = 0; i < pkt->rank; i++) 
		count *= pkt->shape[i];
	
	if (count > STORAGE_DEVICE_THRESHOLD)
		return STG_DEVICE;
	
	return STG_HOST;
}

int dwa2array(struct cell_array **tgt, struct pocket *pkt);

int
dwa2array(struct cell_array **tgt, struct pocket *pkt)
{
	struct	cell_array *arr;
	void 	*data;
	struct	cell_array **cells;
	struct	pocket **pkts;
	size_t	count;
	int	err, free_data, proto;
	enum	array_type type;
	enum	array_storage storage;
	
	arr		= NULL;
	free_data	= 0;
		
	if (pkt == NULL) {
		*tgt = NULL;
		
		return 0;
	}
	
	storage	= dwa_array_storage(pkt);
	type	= dwa_array_type(pkt->eltype);
	
	CHK(storage == -1, done, L"Unsupported DWA type");
	CHK(type == -1, done, L"Unsupported DWA element type");

	CHKFN(mk_array(&arr, type, storage, pkt->rank), done);
	
	for (unsigned int i = 0; i < arr->rank; i++)
		arr->shape[i] = pkt->shape[i];
	
	if (arr->storage == STG_DEVICE && arr->type == ARR_NESTED)
		CHK(10, done, L"Cannot store nested data on device");
	
	if (!(count = array_count(arr))) {
		proto	= is_char_array(arr) ? 32 : 0;
		data	= arr->type == ARR_NESTED ? DATA(pkt) : &proto;
		count	= 1;
	} else {
		switch (pkt->eltype) {
		case APLU8:{
			char	*res;
			uint8_t	*buf;
			
			buf	= DATA(pkt);
			res	= calloc(count, sizeof(char));
			
			CHK(res == NULL, done, 
			    L"Failed to allocate APLU8 buffer");

			for (size_t i = 0; i < count; i++)
				res[i] = 1 & (buf[i/8] >> (7 - (i % 8)));
			
			data 		= res;
			free_data	= 1;
			
			break;
		}
		case APLTI:{
			int16_t	*res;
			int8_t	*buf;
			
			buf	= DATA(pkt);
			res	= calloc(count, sizeof(int16_t));
			
			CHK(res == NULL, done, 
			    L"Failed to allocate APLTI buffer");
			
			for (size_t i = 0; i < count; i++)
				res[i] = buf[i];
			
			data		= res;
			free_data	= 1;
			
			break;
		}
		default:
			data		= DATA(pkt);
		}
	}
	
	if (arr->type != ARR_NESTED) {
		CHKFN(fill_array(arr, data), done);
		goto done;
	}
	
	CHKFN(alloc_array(arr), done);
	
	cells	= arr->values;
	pkts	= data;
	
	for (size_t i = 0; i < count; i++)
		CHKFN(dwa2array(&cells[i], pkts[i]), done);
	
done:
	if (free_data)
		free(data);
	
	if (err)
		release_array(arr);
	else
		*tgt = arr;
	
	return err;
}

int
array2dwa(struct pocket **dst, struct cell_array *arr, struct localp *lp)
{
	struct	pocket *pkt;
	int	err;
	
	err = 0;
	
	if (arr == NULL) {
		if (lp)
			lp->pocket = NULL;
		
		if (dst)
			*dst = NULL;

		return 0;
	}

	if (arr->rank > 15 || arr->type == ARR_SPAN)
		CHK(16, done, L"Dyalog does not support rank or type");
	
	pkt = getarray(array_dwa_type(arr->type), arr->rank, arr->shape, lp);
	
	if (!array_count(arr) && arr->type != ARR_NESTED) {
		/* We don't do anything on the empty array case */
	} else if (arr->storage == STG_DEVICE) {
		af_dtype typ;
		
		CHKAF(af_get_type(&typ, arr->values), done);
		
		if (array_af_dtype(arr) != typ)
			CHK(99, done, L"Inconsistent AF array type");
		
		CHKAF(af_get_data_ptr(DATA(pkt), arr->values), done);
	} else if (arr->type != ARR_NESTED) {
		memcpy(DATA(pkt), arr->values,
		    array_values_count(arr) * array_element_size(arr));
	} else if (arr->type == ARR_NESTED) {
		struct pocket **pkts = DATA(pkt);
		struct cell_array **ptrs = arr->values;
		size_t count = array_values_count(arr);

		for (size_t i = 0; i < count; i++)
			CHKFN(array2dwa(&pkts[i], ptrs[i], NULL), done);
	} else {
		CHK(99, done, L"Unexpected array type");
	}

	if (dst)
		*dst = pkt;

done:
	return err;
}

DECLSPEC int
call_dwa(topfn_ptr fn, void *zptr, void *lptr, void *rptr, const wchar_t *name)
{
	struct localp *zp, *lp, *rp;
	struct cell_array *z, *l, *r, *dbg;
	int err, err2;
	
	zp = zptr;
	lp = lptr;
	rp = rptr;
	
	z = l = r = NULL;
	
	if (lp)
		CHK(dwa2array(&l, lp->pocket), cleanup, L"Convert ⍺");
	
	if (rp)
		CHK(dwa2array(&r, rp->pocket), cleanup, L"Convert ⍵");

	CHK(fn(&z, l, r), cleanup, name);
	
	if (err < 0) {
		zp->pocket = scalnum(0);
		goto cleanup;
	}
	
	CHK(array2dwa(NULL, z, zp), cleanup, L"Convert result");
	
cleanup:
	release_array(l);
	release_array(r);
	release_array(z);
	
	if (err <= 0)
		return err;
	
	err2 = 0;
	
	dbg = get_debug_info();
	
	if (dbg)
		err2 = array2dwa(NULL, dbg, zp);
	
	if (dbg == NULL || err2)
		zp->pocket = scalnum(0);
	
	release_debug_info();
	
	return err;
}
