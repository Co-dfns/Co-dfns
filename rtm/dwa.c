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

int
dwa2array(struct cell_array **tgt, struct pocket *pkt)
{
	struct	cell_array *arr;
	void 	*data;
	struct	cell_array **cells;
	struct	pocket **pkts;
	size_t	count;
	int	err, proto;
	enum	array_type type;
	enum	array_storage storage;
	
	arr		= NULL;
	count		= 1;
		
	if (pkt == NULL) {
		*tgt = NULL;
		
		return 0;
	}

	if (pkt->type !=15 && pkt->type != 7)
		CHK(16, fail, "Unsupported DWA type");

	switch (pkt->eltype) {
	case APLU8:type = ARR_BOOL;break;
	case APLTI:type = ARR_SINT;break;
	case APLSI:type = ARR_SINT;break;
	case APLI:type = ARR_INT;break;
	case APLD:type = ARR_DBL;break;
	case APLZ:type = ARR_CMPX;break;
	case APLU:type = ARR_CHAR8;break;
	case APLV:type = ARR_CHAR16;break;
	case APLW:type = ARR_CHAR32;break;
	case APLP:type = ARR_NESTED;break;
	default:
		CHK(16, fail, "Unsupported DWA element type");
	}

	count = 1;

	for (unsigned int i = 0; i < pkt->rank; i++)
		count *= pkt->shape[i];

	storage = STG_HOST;

	if (count > STORAGE_DEVICE_THRESHOLD)
		storage = STG_DEVICE;

	if (pkt->type == 7)
		storage = STG_HOST;

	CHKFN(mk_array(&arr, type, storage, pkt->rank, count ? count : 1), fail);
	
	for (unsigned int i = 0; i < arr->rank; i++)
		arr->shape[i] = pkt->shape[i];
	
	if (arr->storage == STG_DEVICE && arr->type == ARR_NESTED)
		CHK(10, fail, "Cannot store nested data on device");
	
	if (!count) {
		proto	= is_char_array(arr) ? 32 : 0;
		data	= arr->type == ARR_NESTED ? DATA(pkt) : &proto;
		count	= 1;
	} else {
		switch (pkt->eltype) {
		case APLU8:{
			char	*res;
			uint8_t	*buf;
			
			buf	= DATA(pkt);
			res	= &arr->shape[arr->rank];
			data	= res;
			
			for (size_t i = 0; i < count; i++)
				res[i] = 1 & (buf[i/8] >> (7 - (i % 8)));
		}break;
		case APLTI:{
			int16_t	*res;
			int8_t	*buf;
			
			buf	= DATA(pkt);
			res	= &arr->shape[arr->rank];
			data	= res;
			
			for (size_t i = 0; i < count; i++)
				res[i] = buf[i];
		}break;
		default:
			data		= DATA(pkt);
		}
	}

	if (arr->storage == STG_DEVICE) {
		af_array *t = &arr->values;
		af_dtype dtp = array_af_dtype(arr);

		CHKAF(af_create_array(t, data, 1 &count, dtp), fail);

		*tgt = arr;

		return 0;
	}
	
	if (pkt->eltype == APLU8 || pkt->eltype == APLTI) {
		*tgt = arr;

		return 0;
	}

	if (arr->type != ARR_NESTED) {
		memcpy(arr->values, data, array_values_bytes(arr));

		*tgt = arr;

		return 0;
	}

	cells	= arr->values;
	pkts	= data;
	
	for (size_t i = 0; i < count; i++)
		CHKFN(dwa2array(&cells[i], pkts[i]), fail);
	
	*tgt = arr;

	return 0;

fail:
	release_array(arr);
	
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
		CHK(16, done, "Dyalog does not support rank or type");
	
	pkt = getarray(array_dwa_type(arr->type), arr->rank, arr->shape, lp);
	
	if (!array_count(arr) && arr->type != ARR_NESTED) {
		/* We don't do anything on the empty array case */
	} else if (arr->storage == STG_DEVICE) {
		af_dtype typ;
		
		CHKAF(af_get_type(&typ, arr->values), done);
		
		if (array_af_dtype(arr) != typ)
			CHK(99, done, "Inconsistent AF array type");
		
		CHKAF(af_get_data_ptr(DATA(pkt), arr->values), done);
	} else if (arr->type != ARR_NESTED) {
		memcpy(DATA(pkt), arr->values, array_values_bytes(arr));
	} else if (arr->type == ARR_NESTED) {
		struct pocket **pkts = DATA(pkt);
		struct cell_array **ptrs = arr->values;
		size_t count = array_values_count(arr);

		for (size_t i = 0; i < count; i++)
			CHKFN(array2dwa(&pkts[i], ptrs[i], NULL), done);
	} else {
		CHK(99, done, "Unexpected array type");
	}

	if (dst)
		*dst = pkt;

done:
	return err;
}

DECLSPEC int
call_dwa(topfn_ptr fn, void *zptr, void *lptr, void *rptr, char *name)
{
	struct localp *zp, *lp, *rp;
	struct cell_array *z, *l, *r, *dbg;
	int err, err2;
	
	zp = zptr;
	lp = lptr;
	rp = rptr;
	
	z = l = r = NULL;
	
	if (lp)
		CHK(dwa2array(&l, lp->pocket), cleanup, "Convert ⍺");
	
	if (rp)
		CHK(dwa2array(&r, rp->pocket), cleanup, "Convert ⍵");

	CHK(fn(&z, l, r), cleanup, name);
	
	if (err < 0) {
		zp->pocket = scalnum(0);
		goto cleanup;
	}
	
	CHK(array2dwa(NULL, z, zp), cleanup, "Convert result");
	
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
