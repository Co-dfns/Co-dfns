#include <complex.h>
#include <stddef.h>
#include <stdint.h>
#include <string.h>
#include <arrayfire.h>

#include "codfns.h"

#if defined(_WIN32)
#define dcomplex _Dcomplex
#else
#define dcomplex double complex
#endif

#define DATA(pp) ((void *)&(pp)->shape[(pp)->rank])

enum dwa_type { 
	APLNC=0, APLU8, APLTI, APLSI, APLI, APLD, 
	APLP,    APLU,  APLV,  APLW,  APLZ, APLR, APLF, APLQ
};

struct pocket {
	long	long length;
	long	long refcount;
	unsigned	int type	: 4;
	unsigned	int rank	: 4;
	unsigned	int eltype	: 4;
	unsigned	int _0		: 13;
	unsigned	int _1		: 16;
	unsigned	int _2		: 16;
	long	long shape[1];
};

struct dwa_dmx {
	unsigned	int flags;
	unsigned	int en;
	unsigned	int enx;
	const	wchar_t *vendor;
	const	wchar_t *message;
	const	wchar_t *category;
};

struct dwa_wsfns {
	long	long size;
	struct	pocket *
	    (*getarr)(enum dwa_type, unsigned, long long *, struct localp *);
	void	(*_0[16])(void);
	void	(*error)(struct dwa_dmx *);
};

struct dwa_fns {
	long	long size;
	struct	dwa_wsfns *ws;
};

struct dwa_dmx dmx;	
struct dwa_fns *dwa = NULL;

DECLSPEC int 
set_dwafns(void *fns)
{
	if (fns)
		dwa = fns;
	else 
		return 0;

	if (dwa->size < (long long)sizeof(struct dwa_fns))
		return 16;
	
	return 0;
}

DECLSPEC void
set_dmx_message(wchar_t *msg)
{
	dmx.message = msg;
}

DECLSPEC void
dwa_error(unsigned int n)
{
	dmx.flags	= 3;
	dmx.en		= n;
	dmx.enx		= n;
	dmx.vendor	= L"Co-dfns";
	dmx.category	= NULL;

	dwa->ws->error(&dmx);
}

struct pocket *
getarray(enum dwa_type type, unsigned rank, long long *shape, struct localp *lp)
{
	return (dwa->ws->getarr)(type, rank, shape, lp);
}

char *
cnvu8_ch(uint8_t *buf, size_t count)
{
	char *res;

	res = calloc(count, sizeof(char));

	if (res == NULL)
		return res;

	for (size_t i = 0; i < count; i++)
		res[i] = 1 & (buf[i/8] >> (7 - (i % 8)));

	return res;
}

int16_t *
cnvi8_i16(int8_t *buf, size_t count)
{
	int16_t *res;

	res = calloc(count, sizeof(int16_t));

	if (res == NULL) 
		return res;

	for (size_t i = 0; i < count; i++)
		res[i] = buf[i];

	return res;
}

DECLSPEC int
dwa2array(struct array **tgt, struct pocket *pkt)
{
	struct	array *arr;
	long	long *shape;
	void	*data;
	size_t	count;
	int	err;
	unsigned	int rank;

	rank	= pkt->rank;
	shape	= pkt->shape;
	data	= DATA(pkt);

	switch (pkt->type) {
	case 15: /* Simple */
		switch (pkt->eltype) {
		case APLU8:
			count = 1;

			for (unsigned int i = 0; i < rank; i++)
				count *= shape[i];

			data = cnvu8_ch(data, count);

			if (data == NULL) {
				err = 1;
				goto done;
			}

			err = mk_array(&arr, ARR_BOOL, STG_DEVICE, rank, shape, data);

			free(data);
			break;

		case APLTI:
			count = 1;

			for (unsigned int i = 0; i < rank; i++)
				count *= shape[i];

			data = cnvi8_i16(data, count);

			if (data == NULL) {
				err = 1;
				goto done;
			}

			err = mk_array(&arr, ARR_SINT, STG_DEVICE, rank, shape, data);

			free(data);
			break;

		case APLSI:
			err = mk_array(&arr, ARR_SINT, STG_DEVICE, rank, shape, data);
			break;

		case APLI:
			err = mk_array(&arr, ARR_INT, STG_DEVICE, rank, shape, data);
			break;

		case APLD:
			err = mk_array(&arr, ARR_DBL, STG_DEVICE, rank, shape, data);
			break;

		case APLZ:
			err = mk_array(&arr, ARR_CMP, STG_DEVICE, rank, shape, data);
			break;

		default:
			err = 16;
		}
		break;
	case 7: /* Nested */
		switch (pkt->eltype) {
		case APLP:
			err = mk_array(&arr, ARR_NESTED, STG_HOST, rank, shape, data);
			break;

		default:
			err = 16;
		}
		break;

	default:
		err = 16;
	}

done:
	if (err)
		return err;

	*tgt = arr;

	return 0;
}

DECLSPEC int
array2dwa(struct pocket **dst, struct array *arr, struct localp *lp)
{
	struct	pocket *pkt;
	unsigned	int rank;
	long	long *shape;
	enum	dwa_type dtyp;
	size_t	count, esiz;
	int	err;

	if (arr == NULL) {
		if (lp)
			lp->pocket = NULL;

		goto done;
	}

	rank = arr->rank;
	shape = arr->shape;

	if (rank > 15)
		return 16;

	switch (arr->type) {
	case ARR_BOOL:
		dtyp = APLTI;
		esiz = sizeof(int8_t);
		break;

	case ARR_SINT:
		dtyp = APLSI;
		esiz = sizeof(int16_t);
		break;

	case ARR_INT:
		dtyp = APLI;
		esiz = sizeof(int32_t);
		break;

	case ARR_DBL:
		dtyp = APLD;
		esiz = sizeof(double);
		break;

	case ARR_CMP:
		dtyp = APLZ;
		esiz = sizeof(dcomplex);
		break;

	case ARR_NESTED:
		dtyp = APLP;
		esiz = sizeof(void *);
		break;

	case ARR_MIXED:
	case ARR_CHAR:
	default:
		return 16;
	}

	pkt = getarray(dtyp, rank, shape, lp);

	count = 1;
	for (size_t i = 0; i < rank; i++)
		count *= shape[i];

	switch (arr->storage) {
	case STG_DEVICE:
		err = af_get_data_ptr(DATA(pkt), arr->values);

		if (err)
			return err;

		break;

	case STG_HOST:
		memcpy(DATA(pkt), arr->values, esiz * count);
		break;

	default:
		return 999;
	}

	if (arr->type == ARR_NESTED) {
		void **values = DATA(pkt);

		for (size_t i = 0; i < count; i++) {
			err = array2dwa(&(struct pocket *)values[i], values[i], NULL);

			if (err)
				return err;
		}
	}

done:
	if (dst)
		*dst = pkt;

	return 0;
}
