#include <complex.h>
#include <float.h>
#include <limits.h>
#include <math.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <wchar.h>
#include <windows.h>

#define UNICODE
#define _UNICODE

#pragma warning (push, 3)
#include <arrayfire.h>
#pragma warning (pop)

#if AF_API_VERSION < 38
#error "Your ArrayFire version is too old."
#endif

#ifdef _WIN32
 #define EXPORT __declspec(dllexport)
#elif defined(__GNUC__)
 #define EXPORT __attribute__ ((visibility ("default")))
#else
 #define EXPORT
 #define DECLSPEC
#endif

/******************
 * CORE DATATYPES *
 ******************/
 
enum elem_type { 
	ELEM_INT, ELEM_FLOAT, ELEM_CMPX, ELEM_CHAR, ELEM_CELL, ELEM_MAX
};

enum cell_type { CELL_VOID, CELL_ARRAY, CELL_FUNC };

enum storage_type { STG_HOST, STG_DEVICE };

struct apl_cmpx {
	double real, imag;
};

struct host_buffer {
	int refc;
	int64_t size;
	struct host_buffer *next;
	union {
		int64_t *i;
		double *f;
		struct apl_cmpx *j;
		uint64_t *c;
		struct cell **p;
	};
};

struct cell_array {
	enum elem_type etyp;
	enum storage_type stg;
	int rnk;
	struct host_buffer *shp;
	union {
		struct host_buffer *host;
		af_array dev;
		int64_t i;
		double f;
		struct apl_cmpx j;
		uint64_t c;
		struct cell *p;
	};
};

struct cell_func {
	int (**fn)(struct cell *, struct cell **, struct cell *, struct cell *, struct cell ***);
	struct cell *aa, *ww, *axis;
};

struct cell {
	int refc;
	enum cell_type ctyp;
	struct cell *next;
	union {
		struct cell_array a;
		struct cell_func f;
	};
};

struct cell *next_cell;
struct host_buffer *next_buffer[7]; /* 32 128 512 2048 8192 16384 */

int64_t
array_count(struct cell *a, int min)
{
	int64_t cnt;
	
	cnt = 1;
	
	for (int i = 0; i < a->a.rnk; i++)
		cnt *= a->a.shp->i[i];
	
	cnt = cnt < min ? min : cnt;
	
	return cnt;
}

EXPORT struct host_buffer *
get_host_buffer(int64_t size)
{
	struct host_buffer *res;
	int i;
	
	if (size <= 32) {
		i = 0;
		size = 32;
	} else if (size <= 128) {
		i = 1;
		size = 128;
	} else if (size <= 512) {
		i = 2;
		size = 512;
	} else if (size <= 2048) {
		i = 3;
		size = 2048;
	} else if (size <= 8192) {
		i = 4;
		size = 8192;
	} else if (size <= 16384) {
		i = 5;
		size = 16384;
	} else {
		i = 6;
	}
	
	if (next_buffer[i]) {
		res = next_buffer[i];
		next_buffer[i] = res->next;
	} else {
		res = malloc(sizeof(*res) + size);
		
		if (res == NULL)
			return NULL;
	}
	
	res->refc = 1;
	res->size = size;
	res->i = (int64_t *)((char *)res + sizeof(*res));
	
	return res;
}
	

void
free_host_buffer(struct host_buffer *b)
{
	int64_t i;
	
	if (!b || !b->refc)
		return;
		
	b->refc--;
		
	if (b->refc)
		return;
	
	switch(b->size) {
	case 32: i = 0; break;
	case 128: i = 1; break;
	case 512: i = 2; break;
	case 2048: i = 3; break;
	case 8192: i = 4; break;
	case 16384: i = 5; break;
	default: free(b); return;
	}
	
	b->next = next_buffer[i];
	next_buffer[i] = b;
}

EXPORT struct cell *
get_cell(void)
{
	struct cell *res;
	
	if (next_cell) {
		res = next_cell;
		next_cell = res->next;
	} else {
		res = malloc(sizeof(*res));
		
		if (res == NULL)
			return NULL;
	}
	
	res->refc = 1;
	
	return res;
}

EXPORT void
free_cell(struct cell *c)
{
	if (!c || !c->refc)
		return;
		
	c->refc--;
	
	if (c->refc) {
		return;
	}
	
	c->ctyp = CELL_VOID;
	c->next = next_cell;
	next_cell = c;
	
	free_host_buffer(c->a.shp);
	
	switch (c->ctyp) {
	case CELL_ARRAY:
		switch (c->a.stg) {
		case STG_HOST:
			if (!c->a.rnk)
				break;
				
			if (c->a.etyp == ELEM_CELL) {
				int64_t cnt = array_count(c, 1);
				
				for (int64_t i = 0; i < cnt; i++) 
					free_cell(c->a.host->p[i]);
			}
			
			free_host_buffer(c->a.host);
			break;
			
		case STG_DEVICE:
			af_release_array(c->a.dev);
			break;
		}break;
		
	case CELL_FUNC:
		free_cell(c->f.aa);
		free_cell(c->f.ww);
		free_cell(c->f.axis);
		break;
		
	default:
		break;
	}
}

EXPORT struct cell *
ref_cell(struct cell *c)
{
	if (c)
		c->refc++;
	
	return c;
}

EXPORT int64_t
buffer_size(enum elem_type t, int64_t c)
{
	if (t == ELEM_CMPX)
		return sizeof(struct apl_cmpx) * c;
	
	return sizeof(int64_t) * c;
}

enum elem_type elem_type_merge_map[ELEM_MAX][ELEM_MAX] = {
	ELEM_INT, ELEM_FLOAT, ELEM_CMPX, ELEM_CELL, ELEM_CELL,
	ELEM_FLOAT, ELEM_FLOAT, ELEM_CMPX, ELEM_CELL, ELEM_CELL,
	ELEM_CMPX, ELEM_CMPX, ELEM_CMPX, ELEM_CELL, ELEM_CELL,
	ELEM_CELL, ELEM_CELL, ELEM_CELL, ELEM_CHAR, ELEM_CELL,
	ELEM_CELL, ELEM_CELL, ELEM_CELL, ELEM_CELL, ELEM_CELL
};

EXPORT int
squeeze(struct cell *c)
{
	enum elem_type sqzt;
	struct cell **p;
	struct host_buffer *v;
	int64_t cnt;

	if (!c->a.rnk) {
		struct cell *x;
		
		if (c->a.etyp != ELEM_CELL)
			return 0;
			
		x = c->a.p;
		
		if (x->a.rnk)
			return 0;
		
		squeeze(x);
		
		switch (x->a.etyp) {
		case ELEM_INT:
			c->a.etyp = ELEM_INT;
			c->a.i = x->a.i;
			break;
			
		case ELEM_FLOAT:
			c->a.etyp = ELEM_FLOAT;
			c->a.f = x->a.f;
			break;
			
		case ELEM_CMPX:
			c->a.etyp = ELEM_CMPX;
			c->a.j = x->a.j;
			break;
		
		case ELEM_CHAR:
			c->a.etyp = ELEM_CHAR;
			c->a.c = x->a.c;
			break;
			
		default:
			return 0;
		}
		
		free_cell(x);
		
		return 0;
	}
	
	if (c->a.etyp != ELEM_CELL)
		return 0;
	
	p = c->a.host->p;
		
	if (p[0]->a.rnk)
		return 0;
			
	squeeze(p[0]);
		
	sqzt = p[0]->a.etyp;
	
	if (sqzt == ELEM_CELL)
		return 0;
		
	cnt = array_count(c, 1);
		
	for (int64_t i = 1; i < cnt; i++) {
		if (p[i]->a.rnk)
			return 0;
		
		squeeze(p[i]);
		
		sqzt = elem_type_merge_map[sqzt][p[i]->a.etyp];
		
		if (sqzt == ELEM_CELL)
			return 0;
	}
	
	v = c->a.host;
	
	if (buffer_size(sqzt, cnt) > c->a.host->size) {
		if (!(v = get_host_buffer(buffer_size(sqzt, cnt))))
			return 1;
	}
	
	switch (sqzt) {
	case ELEM_INT:
		for (int64_t i = 0; i < cnt; i++) {
			struct cell *t = p[i];
			
			v->i[i] = t->a.i;
			free_cell(t);
		}
		break;
	case ELEM_FLOAT:
		for (int64_t i = 0; i < cnt; i++) {
			struct cell *t = p[i];
			
			switch (t->a.etyp) {
			case ELEM_INT:
				v->f[i] = (double)t->a.i;
				break;
			case ELEM_FLOAT:
				v->f[i] = t->a.f;
				break;
			}
			
			free_cell(t);
		}
		break;
	case ELEM_CMPX:
		for (int64_t i = 0; i < cnt; i++) {
			struct cell *t = p[i];
			
			switch (t->a.etyp) {
			case ELEM_INT:
				v->j[i].real = (double)t->a.i;
				v->j[i].imag = 0;
				break;
			case ELEM_FLOAT:
				v->j[i].real = t->a.f;
				v->j[i].imag = 0;
				break;
			case ELEM_CMPX:
				v->j[i] = t->a.j;
			}
			
			free_cell(t);
		}
		break;
	case ELEM_CHAR:
		for (int64_t i = 0; i < cnt; i++) {
			struct cell *t = p[i];
			
			v->c[i] = t->a.c;
			
			free_cell(t);
		}
		break;
	}
	
	c->a.etyp = sqzt;

	if (v != c->a.host) {
		free_host_buffer(c->a.host);
		c->a.host = v;
	}
	
	return 0;
}

/***************
 * DWA HELPERS *
 ***************/
 
#define DATA(pp) ((void *)&(pp)->shape[(pp)->rank])

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

struct dwa_fns {
	long long size;
	struct {
		long long size;
		struct pocket *(*getarray)(enum dwa_type, unsigned int, long long *, struct localp *);
		void *fns1[11];
		struct pocket *(*scalnum)(int);
		void *fns2[5];
	} *ws;
};

struct pocket *(*getarray)(enum dwa_type, unsigned int, long long *, struct localp *);
struct pocket *(*scalnum)(int);

EXPORT int
set_dwafns(void *p)
{
	struct dwa_fns *dwa;

	if (p == NULL)
		return 0;

	dwa = p;

	if (dwa->size < (long long)sizeof(struct dwa_fns))
		return 16;

	getarray = dwa->ws->getarray;
	scalnum = dwa->ws->scalnum;

	return 0;
}

/******************
 * ERROR HANDLING *
 ******************/
 
char *debug_msg;
char *fmt = "%hs:%d(%hs) %s\n";

EXPORT struct cell *
get_debug_info(void)
{
	return NULL;
}

EXPORT void
release_debug_info(void)
{
	free(debug_msg);
	debug_msg = NULL;
}

EXPORT void
debug_trace(const char *file, int line, const char *func, 
    const char *expr)
{
	size_t msgcnt, oldcnt;
	char *dbg;
	
	oldcnt = debug_msg ? strlen(debug_msg) : 0;
	msgcnt = snprintf(NULL, 0, fmt, file, line, func, expr);
	
	if (!(dbg = realloc(debug_msg, oldcnt + msgcnt + 1)))
		return;
	
	snprintf(dbg + oldcnt, msgcnt + 1, fmt, file, line, func, expr);
	
	debug_msg = dbg;
}

EXPORT void
print_debug_info(int err)
{
	printf("\n%s\n", debug_msg);
	printf("ERROR %d\n", err);
}

/**********************
 * Character Handling *
 **********************/
 
static void 
print_char(uint64_t point)
{
	int count;
	unsigned char buf[4];
	
	count = 0;
	
	/* https://stackoverflow.com/a/42013433 */
	
	if (point <= 0x7F) {
		buf[0] = (unsigned char)point;
		count = 1;
	} else if (point <= 0x7FF) {
		buf[0] = (unsigned char)(0xC0 | (point >> 6));	/* 110xxxxx */
		buf[1] = 0x80 | (point & 0x3F);			/* 10xxxxxx */
		count = 2;
	} else if (point <= 0xFFFF) {
		buf[0] = (unsigned char)(0xE0 | (point >> 12));	/* 1110xxxx */
		buf[1] = 0x80 | ((point >> 6) & 0x3F);		/* 10xxxxxx */
		buf[2] = 0x80 | (point & 0x3F);			/* 10xxxxxx */
		count = 3;
	} else if (point <= 0x10FFFF) {
		buf[0] = (unsigned char)(0xF0 | (point >> 18));	/* 11110xxx */
		buf[1] = 0x80 | ((point >> 12) & 0x3F);		/* 10xxxxxx */
		buf[2] = 0x80 | ((point >> 6) & 0x3F);		/* 10xxxxxx */
		buf[3] = 0x80 | (point & 0x3F);			/* 10xxxxxx */
		count = 4;
	}

	for (int i = 0; i < count; i++)
		putchar(buf[i]);
}

/*********************
 * ARRAYFIRE HELPERS *
 *********************/
 
#define CHKAF(expr, fail)							\
if (0 < (err = (expr))) {							\
	debug_trace(__FILE__, __LINE__, __func__, af_err_to_string(err));	\
	goto fail;								\
}										\

#define TRCAF(expr)								\
if (0 < (err = (expr))) {							\
	debug_trace(__FILE__, __LINE__, __func__, af_err_to_string(err));	\
}										\
 
enum elem_type
convert_af_dtype(af_array *a)
{
	af_dtype typ;
	
	af_get_type(&typ, a);
	
	switch (typ) {
	case s64: return ELEM_INT;
	case f64: return ELEM_FLOAT;
	case c64: return ELEM_CMPX;
	case u64: return ELEM_CHAR;
	default:
		return -1;
	}
}

/*******************
 * RUNTIME HELPERS *
 *******************/
 
EXPORT int
is_bound(struct cell *c)
{
	if (!c || c->ctyp == CELL_VOID || !c->refc)
		return 6;
		
	return 0;
}

/*************
 * Utilities *
 *************/
 
 int
 println_pad(struct cell *r)
 {
	int64_t cnt;
	
	if (!r->a.rnk) {
		switch (r->a.etyp) {
		case ELEM_INT:
			printf("%lld", r->a.i);
			return 0;
		case ELEM_FLOAT:
			printf("%f", r->a.f);
			return 0;
		case ELEM_CMPX:
			printf("%fJ%f", r->a.j.real, r->a.j.imag);
			return 0;
		case ELEM_CHAR:
			print_char(r->a.c);
			return 0;
		case ELEM_CELL:
			printf(" ");
			println_pad(r->a.p);
			printf(" ");
			return 0;
		default:
			return 99;
		}
	}
	
	if (r->a.stg == STG_DEVICE)
		return 16;
	
	cnt = array_count(r, 0);
		
	switch (r->a.etyp) {
	case ELEM_INT:
		for (int64_t i = 0; i < cnt; i++) {
			if (i > 0) printf(" ");
			printf("%lld", r->a.host->i[i]);
		}
		break;
	case ELEM_FLOAT:
		for (int64_t i = 0; i < cnt; i++) {
			if (i > 0) printf(" ");
			printf("%f", r->a.host->f[i]);
		}
		break;
	case ELEM_CHAR:
		for (int64_t i = 0; i < cnt; i++) {
			print_char(r->a.host->c[i]);
		}
		break;
	case ELEM_CMPX:
		for (int64_t i = 0; i < cnt; i++) {
			struct apl_cmpx x;
		
			x = r->a.host->j[i];
			
			if (i > 0) printf(" ");
			printf("%fJ%f", x.real, x.imag);
		}
		break;
	case ELEM_CELL:
		struct cell **p;
		int nst;
		
		p = r->a.host->p;
		nst = 1;
		
		for (int64_t i = 0; i < cnt; i++) {
			int err, prv;
			
			prv = nst;
			nst = 1;
			
			if (!p[i]->a.rnk) {
				switch (p[i]->a.etyp) {
				case ELEM_INT:
				case ELEM_FLOAT:
				case ELEM_CMPX:
				case ELEM_CHAR:
					nst = 0;
				}
			}
			
			if (nst && !prv)
				printf(" ");
			
			if (nst || i > 0)
				printf(" ");
			
			if ((err = println_pad(p[i])))
				return err;
				
			if (nst)
				printf(" ");
		}
		break;
	default:
		return 99;
	}
	
	return 0;
 }
 
/**************
 * PRIMITIVES *
 **************/
 
 EXPORT int
 println_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***env)
 {
	int err;
	
	s; l; env;
	
	if ((err = println_pad(r)))
		return err;
		
	printf("\n");
	
	*z = ref_cell(r);
	
	return 0;
}

EXPORT int
ravel_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***env)
{
	int err;
	struct cell *t;
	
	s; l; env;
	
	if (!r->a.rnk) {
		if (!(t = get_cell())) {
			err = 1;
			goto fail;
		}
		
		t->ctyp = CELL_ARRAY;
		t->a.etyp = r->a.etyp;
		t->a.stg = STG_HOST;
		t->a.rnk = 1;
		
		if (!(t->a.shp = get_host_buffer(buffer_size(ELEM_INT, 1)))) {
			err = 1;
			goto fail;
		}
		
		t->a.shp->i[0] = 1;
		
		if (!(t->a.host = get_host_buffer(buffer_size(t->a.etyp, 1)))) {
			err = 1;
			goto fail;
		}
				
		switch (t->a.etyp) {
		case ELEM_INT: t->a.host->i[0] = r->a.i; break;
		case ELEM_FLOAT: t->a.host->f[0] = r->a.f; break;
		case ELEM_CMPX: t->a.host->j[0] = r->a.j; break;
		case ELEM_CHAR: t->a.host->c[0] = r->a.c; break;
		case ELEM_CELL: t->a.host->p[0] = ref_cell(r->a.p); break;
		default:
			err = 99;
			goto fail;
		}
		
		*z = t;
		
		return 0;
	}
	
	if (r->a.rnk == 1) {
		t = ref_cell(r);
	}
	
	if (!(t = get_cell())) {
		err = 1;
		goto fail;
	}
	
	t->ctyp = CELL_ARRAY;
	t->a.etyp = r->a.etyp;
	t->a.stg = r->a.stg;
	t->a.rnk = 1;
	
	if (!(t->a.shp = get_host_buffer(buffer_size(ELEM_INT, 1)))) {
		err = 1;
		goto fail;
	}
	
	t->a.shp->i[0] = array_count(r, 0);
	
	switch (t->a.stg) {
	case STG_HOST: 
		t->a.host = r->a.host;
		r->a.host->refc++;
		break;
	case STG_DEVICE:
		af_retain_array(&t->a.dev, r->a.dev);
		break;
	default:
		err = 99;
		goto fail;
	}
	
	*z = t;
	
	return 0;
	
fail:
	free_cell(t);
	
	return err;
}

EXPORT int
first_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***env)
{
	struct cell *t;
	int err;
	
	s; l; env;
	
	if (!r->a.rnk) {
		if (r->a.etyp == ELEM_CELL) {
			*z = ref_cell(r->a.p);
		} else {
			*z = ref_cell(r);
		}
		return 0;
	}
	
	if (r->a.etyp == ELEM_CELL) {
		*z = ref_cell(r->a.host->p[0]);
		return 0;
	}
	
	if (!(t = get_cell())) {
		err = 1;
		goto fail;
	}
	
	t->ctyp = CELL_ARRAY;
	t->a.etyp = r->a.etyp;
	t->a.stg = STG_HOST;
	t->a.rnk = 0;
	t->a.shp = NULL;
	
	switch (r->a.stg) {
	case STG_HOST:
		switch (r->a.etyp) {
		case ELEM_INT: t->a.i = r->a.host->i[0]; break;
		case ELEM_FLOAT: t->a.f = r->a.host->f[0]; break;
		case ELEM_CMPX: t->a.j = r->a.host->j[0]; break;
		case ELEM_CHAR: t->a.c = r->a.host->c[0]; break;
		default:
			err = 99;
			goto fail;
		}
		break;
	
	case STG_DEVICE:
		CHKAF(af_get_scalar(&t->a.i, r->a.dev), fail);
		break;
		
	default:
		err = 99;
		goto fail;
	}
	
	*z = t;
	
	return 0;
	
fail:
	free_cell(t);
	
	return err;
}

EXPORT int
pick_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***env)
{
	struct cell *t;
	
	s; env;
	
	if (!l->a.rnk) {
		switch (l->a.etyp) {
		case ELEM_INT:
			if (r->a.rnk != 1)
				return 4;
				
			if (r->a.stg == STG_DEVICE)
				return 16;
			
			if (l->a.i >= r->a.shp->i[0])
				return 3;
			
			if (r->a.etyp == ELEM_CELL) {
				*z = ref_cell(r->a.host->p[l->a.i]);
				return 0;
			}
			
			if (!(t = get_cell()))
				return 1;
			
			t->ctyp = CELL_ARRAY;
			t->a.etyp = r->a.etyp;
			t->a.stg = STG_HOST;
			t->a.rnk = 0;
			t->a.shp = NULL;
			
			switch (r->a.etyp) {
			case ELEM_INT: t->a.i = r->a.host->i[l->a.i]; break;
			case ELEM_FLOAT: t->a.f = r->a.host->f[l->a.i]; break;
			case ELEM_CMPX: t->a.j = r->a.host->j[l->a.i]; break;
			case ELEM_CHAR: t->a.c = r->a.host->c[l->a.i]; break;
			default:
				return 99;
			}
			
			*z = t;
			
			return 0;

		case ELEM_FLOAT:
		case ELEM_CMPX:
		case ELEM_CHAR:
			return 11;
			
		case ELEM_CELL:
			return 16;
			
		default:
			return 99;
		}
	}
	
	if (l->a.rnk != 1)
		return 4;
	
	return 16;
}

EXPORT int
rgt_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
{
	s; l; fv;
	
	*z = ref_cell(r);
	return 0;
}

int (*rgt_fn[])(struct cell *, struct cell **, struct cell *, struct cell *, struct cell ***) = {
	rgt_f, rgt_f
};
struct cell rgt_c = {
	1, CELL_FUNC, NULL, .f = {
		rgt_fn, NULL, NULL, NULL
	}
};
EXPORT struct cell *rgt = &rgt_c;

EXPORT int
lftid_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
{
	s; l; fv;
	
	*z = ref_cell(r);
	return 0;
}

EXPORT int
left_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
{
	s; r; fv;
	
	*z = ref_cell(l);
	return 0;
}

int (*lft_fn[])(struct cell *, struct cell **, struct cell *, struct cell *, struct cell ***) = {
	lftid_f, left_f
};
struct cell lft_c = {
	1, CELL_FUNC, NULL, .f = {
		lft_fn, NULL, NULL, NULL
	}
};
EXPORT struct cell *lft = &lft_c;

EXPORT int
brkidx_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
{
	s, l, fv;
	
	*z = ref_cell(r);
	
	return 0;
}

int
set_host(struct cell **z, struct cell *l, struct cell *r, int64_t k, int64_t *zi, int64_t *ri)
{
	struct cell *idx;
	
	idx = l->a.host->p[k];
	
	if (k == l->a.shp->i[0] - 1) {
		int64_t * restrict iv, cnt;
		
		iv = idx->a.rnk ? idx->a.host->i : &idx->a.i;
		cnt = array_count(idx, 0);
		*zi *= (*z)->a.shp->i[k];
		
		switch ((*z)->a.etyp) {
		case ELEM_INT:{
			int64_t * restrict zv = (*z)->a.host->i;
			
			switch (r->a.etyp) {
			case ELEM_INT:
				if (r->a.rnk) {
					int64_t * restrict rv = r->a.host->i;
				
					for (int64_t i = 0; i < cnt; i++)
						zv[*zi + iv[i]] = rv[(*ri)++];
				} else {
					for (int64_t i = 0; i < cnt; i++)
						zv[*zi + iv[i]] = r->a.i;
				}
			break;
			default:
				return 99;
			}
		}break;
		
		case ELEM_FLOAT:{
			double * restrict zv = (*z)->a.host->f;
			
			switch (r->a.etyp) {
			case ELEM_INT:
				if (r->a.rnk) {
					int64_t * restrict rv = r->a.host->i;
					
					for (int64_t i = 0; i < cnt; i++)
						zv[*zi + iv[i]] = (double)rv[(*ri)++];
				} else {
					for (int64_t i = 0; i < cnt; i++)
						zv[*zi + iv[i]] = (double)r->a.i;
				}
			break;
			
			case ELEM_FLOAT:
				if (r->a.rnk) {
					double * restrict rv = r->a.host->f;
					
					for (int64_t i = 0; i < cnt; i++)
						zv[*zi + iv[i]] = rv[(*ri)++];
				} else {
					for (int64_t i = 0; i < cnt; i++)
						zv[*zi + iv[i]] = r->a.f;
				}
			break;
			
			default:
				return 99;
			}
		}break;
		
		case ELEM_CMPX:{
			struct apl_cmpx * restrict zv = (*z)->a.host->j;
			
			switch (r->a.etyp) {
			case ELEM_INT:
				if (r->a.rnk) {
					int64_t * restrict rv = r->a.host->i;
					
					for (int64_t i = 0; i < cnt; i++) {
						int64_t j = *zi + iv[i];
						
						zv[j].real = (double)rv[(*ri)++];
						zv[j].imag = 0;
					}
				} else {
					for (int64_t i = 0; i < cnt; i++) {
						int64_t j = *zi + iv[i];

						zv[j].real = (double)r->a.i;
						zv[j].imag = 0;
					}
				}
			break;
			
			case ELEM_FLOAT:
				if (r->a.rnk) {
					double * restrict rv = r->a.host->f;
					
					for (int64_t i = 0; i < cnt; i++) {
						int64_t j = *zi + iv[i];
						
						zv[j].real = rv[(*ri)++];
						zv[j].imag = 0;
					}
				} else {
					for (int64_t i = 0; i < cnt; i++) {
						int64_t j = *zi + iv[i];
						
						zv[j].real = r->a.f;
						zv[j].imag = 0;
					}
				}
			break;
			
			case ELEM_CMPX:
				if (r->a.rnk) {
					struct apl_cmpx * restrict rv = r->a.host->j;
					
					for (int64_t i = 0; i < cnt; i++)
						zv[*zi + iv[i]] = rv[(*ri)++];
				} else {
					for (int64_t i = 0; i < cnt; i++)
						zv[*zi + iv[i]] = r->a.j;
				}
			break;
			
			default:
				return 99;
			}
		}break;
		
		case ELEM_CHAR:{
			uint64_t * restrict zv = (*z)->a.host->c;
			
			switch (r->a.etyp) {
			case ELEM_CHAR:
				if (r->a.rnk) {
					uint64_t * restrict rv = r->a.host->c;
					
					for (int64_t i = 0; i < cnt; i++)
						zv[*zi + iv[i]] = rv[(*ri)++];
				} else {
					for (int64_t i = 0; i < cnt; i++)
						zv[*zi + iv[i]] = r->a.c;
				}
			break;
			default:
				return 99;
			}
		}break;
		
		case ELEM_CELL:{
			struct cell ** restrict zv = (*z)->a.host->p;
			
			switch (r->a.etyp) {
			case ELEM_INT:
				if (r->a.rnk) {
					int64_t * restrict rv = r->a.host->i;
					
					for (int64_t i = 0; i < cnt; i++) {
						struct cell *c = get_cell();
						int64_t j = *zi + iv[i];
						
						if (!c) return 1;
						
						c->ctyp = CELL_ARRAY;
						c->a.etyp = ELEM_INT;
						c->a.stg = STG_HOST;
						c->a.rnk = 0;
						c->a.shp = NULL;
						c->a.i = rv[(*ri)++];
						
						free_cell(zv[j]);
						zv[j] = c;
					}
				} else {
					for (int64_t i = 0; i < cnt; i++) {
						struct cell *c = get_cell();
						int64_t j = *zi + iv[i];

						if (!c) return 1;
						
						c->ctyp = CELL_ARRAY;
						c->a.etyp = ELEM_INT;
						c->a.stg = STG_HOST;
						c->a.rnk = 0;
						c->a.shp = NULL;
						c->a.i = r->a.i;
						
						free_cell(zv[j]);
						zv[j] = c;
					}
				}
				break;
			
			case ELEM_FLOAT:
				if (r->a.rnk) {
					double * restrict rv = r->a.host->f;
					
					for (int64_t i = 0; i < cnt; i++) {
						struct cell *c = get_cell();
						int64_t j = *zi + iv[i];

						if (!c) return 1;
						
						c->ctyp = CELL_ARRAY;
						c->a.etyp = ELEM_FLOAT;
						c->a.stg = STG_HOST;
						c->a.rnk = 0;
						c->a.shp = NULL;
						c->a.f = rv[(*ri)++];
						
						free_cell(zv[j]);
						zv[j] = c;
					}
				} else {
					for (int64_t i = 0; i < cnt; i++) {
						struct cell *c = get_cell();
						int64_t j = *zi + iv[i];

						if (!c) return 1;
						
						c->ctyp = CELL_ARRAY;
						c->a.etyp = ELEM_FLOAT;
						c->a.stg = STG_HOST;
						c->a.rnk = 0;
						c->a.shp = NULL;
						c->a.f = r->a.f;
						
						free_cell(zv[j]);
						zv[j] = c;
					}
				}
				break;
			
			case ELEM_CMPX:
				if (r->a.rnk) {
					struct apl_cmpx * restrict rv = r->a.host->j;
					
					for (int64_t i = 0; i < cnt; i++) {
						struct cell *c = get_cell();
						int64_t j = *zi + iv[i];

						if (!c) return 1;
						
						c->ctyp = CELL_ARRAY;
						c->a.etyp = ELEM_CMPX;
						c->a.stg = STG_HOST;
						c->a.rnk = 0;
						c->a.shp = NULL;
						c->a.j = rv[(*ri)++];
						
						free_cell(zv[j]);
						zv[j] = c;
					}
				} else {
					for (int64_t i = 0; i < cnt; i++) {
						struct cell *c = get_cell();
						int64_t j = *zi + iv[i];

						if (!c) return 1;
						
						c->ctyp = CELL_ARRAY;
						c->a.etyp = ELEM_CMPX;
						c->a.stg = STG_HOST;
						c->a.rnk = 0;
						c->a.shp = NULL;
						c->a.j = r->a.j;
						
						free_cell(zv[j]);
						zv[j] = c;
					}
				}
			break;
			
			case ELEM_CHAR:
				if (r->a.rnk) {
					uint64_t * restrict rv = r->a.host->c;
					
					for (int64_t i = 0; i < cnt; i++) {
						struct cell *c = get_cell();
						int64_t j = *zi + iv[i];

						if (!c) return 1;
						
						c->ctyp = CELL_ARRAY;
						c->a.etyp = ELEM_CHAR;
						c->a.stg = STG_HOST;
						c->a.rnk = 0;
						c->a.shp = NULL;
						c->a.c = rv[(*ri)++];
						
						free_cell(zv[j]);
						zv[j] = c;
					}
				} else {
					for (int64_t i = 0; i < cnt; i++) {
						struct cell *c = get_cell();
						int64_t j = *zi + iv[i];

						if (!c) return 1;
						
						c->ctyp = CELL_ARRAY;
						c->a.etyp = ELEM_CHAR;
						c->a.stg = STG_HOST;
						c->a.rnk = 0;
						c->a.shp = NULL;
						c->a.c = r->a.i;
						
						free_cell(zv[j]);
						zv[j] = c;
					}
				}
			break;
			
			case ELEM_CELL:
				if (r->a.rnk) {
					struct cell ** restrict rv = r->a.host->p;

					for (int64_t i = 0; i < cnt; i++) {
						int64_t j = *zi + iv[i];
						
						free_cell(zv[j]);
						zv[j] = ref_cell(rv[(*ri)++]);
					}
				} else {
					for (int64_t i = 0; i < cnt; i++) {
						int64_t j = *zi + iv[i];
						
						free_cell(zv[j]);
						zv[j] = ref_cell(r->a.p);
					}
				}
			break;
			
			default:
				return 99;
			}
		}break;
		
		default:
			return 99;
		}
			
		return 0;
	}
	
	return 16;
}

EXPORT int
set_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
{
	int64_t cnt, zi, ri;
	enum elem_type ztyp;
	
	s, fv;
	
	if (l->a.rnk != 1 || l->a.etyp != ELEM_CELL)
		return 99;
		
	if (r->a.rnk) {
		int64_t j;
		
		j = 0;
		
		for (int64_t k = 0; k < l->a.shp->i[0]; k++) {
			struct cell *idx = l->a.host->p[k];
		
			for (int64_t i = 0; i < idx->a.rnk; i++) {
				if (j == r->a.rnk)
					return 4;
					
				if (idx->a.shp->i[i] != r->a.shp->i[j++])
					return 5;
			}
		}
		
		if (j != r->a.rnk)
			return 4;
	}
	
	cnt = 1;
	
	for (int64_t i = 0; i < l->a.shp->i[0]; i++) {
		struct cell *idx = l->a.host->p[i];
		
		for (int64_t j = 0; j < idx->a.rnk; j++)
			cnt *= idx->a.shp->i[j];
	}
	
	if (!cnt)
		return 0;
	
	if ((*z)->a.stg != STG_HOST)
		return 16;
		
	if ((*z)->refc != 1) {
		struct cell *t = get_cell();
		
		if (!t) return 1;
		
		t->ctyp = CELL_ARRAY;
		t->a = (*z)->a;
		t->a.shp->refc++;
		t->a.host->refc++;
		
		free_cell(*z);
		
		*z = t;
	}
	
	ztyp = elem_type_merge_map[(*z)->a.etyp][r->a.etyp];
	
	if ((*z)->a.host->refc != 1 || (*z)->a.etyp != ztyp){
		int64_t zc;
		struct host_buffer *h;
		
		zc = array_count(*z, 1);
		h = get_host_buffer(buffer_size(ztyp, zc));
		
		if (!h)
			return 1;
		
		switch (ztyp) {
		case ELEM_INT:
			for (int64_t i = 0; i < zc; i++)
				h->i[i] = (*z)->a.host->i[i];
			break;
			
		case ELEM_FLOAT:
			switch ((*z)->a.etyp) {
			case ELEM_INT:
				for (int64_t i = 0; i < zc; i++) 
					h->f[i] = (double)(*z)->a.host->i[i];
			break;
			case ELEM_FLOAT:
				for (int64_t i = 0; i < zc; i++)
					h->f[i] = (*z)->a.host->f[i];
			break;
			}
			break;
			
		case ELEM_CMPX:
			switch ((*z)->a.etyp) {
			case ELEM_INT:
				for (int64_t i = 0; i < zc; i++) {
					h->j[i].real = (double)(*z)->a.host->i[i];
					h->j[i].imag = 0;
				}
			break;
				
			case ELEM_FLOAT:
				for (int64_t i = 0; i < zc; i++) {
					h->j[i].real = (*z)->a.host->f[i];
					h->j[i].imag = 0;
				}
			break;
			
			case ELEM_CMPX:
				for (int64_t i = 0; i < zc; i++) 
					h->j[i] = (*z)->a.host->j[i];
			break;
			}
			break;
			
		case ELEM_CHAR:
			for (int64_t i = 0; i < zc; i++)
				h->c[i] = (*z)->a.host->c[i];
			break;
			
		case ELEM_CELL:
			switch ((*z)->a.etyp) {
			case ELEM_INT:
				for (int64_t i = 0; i < zc; i++) {
					struct cell *c = get_cell();
					
					if (!c) {
						free_host_buffer(h);
						return 1;
					}
					
					c->ctyp = CELL_ARRAY;
					c->a.etyp = (*z)->a.etyp;
					c->a.stg = STG_HOST;
					c->a.rnk = 0;
					c->a.shp = NULL;
					c->a.i = (*z)->a.host->i[i];
					
					h->p[i] = c;
				}
				break;
				
			case ELEM_FLOAT:
				for (int64_t i = 0; i < zc; i++) {
					struct cell *c = get_cell();
					
					if (!c) {
						free_host_buffer(h);
						return 1;
					}
					
					c->ctyp = CELL_ARRAY;
					c->a.etyp = (*z)->a.etyp;
					c->a.stg = STG_HOST;
					c->a.rnk = 0;
					c->a.shp = NULL;
					c->a.f = (*z)->a.host->f[i];
					
					h->p[i] = c;
				}
				break;
			
			case ELEM_CMPX:
				for (int64_t i = 0; i < zc; i++) {
					struct cell *c = get_cell();
					
					if (!c) {
						free_host_buffer(h);
						return 1;
					}
					
					c->ctyp = CELL_ARRAY;
					c->a.etyp = (*z)->a.etyp;
					c->a.stg = STG_HOST;
					c->a.rnk = 0;
					c->a.shp = NULL;
					c->a.j = (*z)->a.host->j[i];
					
					h->p[i] = c;
				}
				break;
			
			case ELEM_CHAR:
				for (int64_t i = 0; i < zc; i++) {
					struct cell *c = get_cell();
					
					if (!c) {
						free_host_buffer(h);
						return 1;
					}
					
					c->ctyp = CELL_ARRAY;
					c->a.etyp = (*z)->a.etyp;
					c->a.stg = STG_HOST;
					c->a.rnk = 0;
					c->a.shp = NULL;
					c->a.c = (*z)->a.host->c[i];
					
					h->p[i] = c;
				}
				break;
			
			case ELEM_CELL:
				for (int64_t i = 0; i < zc; i++)
					h->p[i] = ref_cell((*z)->a.host->p[i]);
				break;
			}
			break;
		default:
			free_host_buffer(h);
			return 99;
		}
		
		free_host_buffer((*z)->a.host);
		(*z)->a.host = h;
		(*z)->a.etyp = ztyp;
	}
	
	
	if (r->a.stg != STG_HOST)
		return 16;
	
	zi = 0;
	ri = 0;
	
	return set_host(z, l, r, 0, &zi, &ri);
}