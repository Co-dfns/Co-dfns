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
	
	switch (c->ctyp) {
	case CELL_ARRAY:
		free_host_buffer(c->a.shp);
		switch (c->a.stg) {
		case STG_HOST:
			if (!c->a.rnk) {
				if (c->a.etyp == ELEM_CELL)
					free_cell(c->a.p);
					
				break;
			}
				
			if (c->a.etyp == ELEM_CELL && c->a.host) {
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
 
 int64_t zero_list[] = {0};
 struct host_buffer zero_buf = {2, 0, NULL, .i = zero_list};
 struct cell mt_num_vec = {
	1, CELL_ARRAY, NULL, .a = {
		ELEM_INT, STG_HOST, 1, &zero_buf, .host = &zero_buf
	}
 };
 
 struct cell scl_zero = {
	1, CELL_ARRAY, NULL, .a = {ELEM_INT, STG_HOST, 0, NULL, .i = 0}
};

struct cell scl_one = {
	1, CELL_ARRAY, NULL, .a = {ELEM_INT, STG_HOST, 0, NULL, .i = 1}
};

static int
syserr_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
{
	s; z; l; r; fv;

	return 99;
}
 
static int
syntaxerr_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
{
	s; z; l; r; fv;

	return 2;
}
 
/**************
 * PRIMITIVES *
 **************/
 
 
 EXPORT int
 println_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***env)
 {
	struct host_buffer *shp;
	char *vs;
	int64_t mc, cc, sz;
	int err;
	
	s; l; env;
	
	if (r->a.stg == STG_DEVICE)
		return 16;
	
	if (r->a.rnk <= 1) {
		if ((err = println_pad(r)))
			return err;

		printf("\n");
		goto done;
	}
	
	mc = r->a.shp->i[0];
	cc = array_count(r, 0) / mc;
	
	if (!(shp = get_host_buffer(buffer_size(ELEM_INT, r->a.rnk - 1))))
		return 1;
	
	for (int64_t i = 0; i < r->a.rnk - 1; i++)
		shp->i[i] = r->a.shp->i[i + 1];
		
	sz = buffer_size(r->a.etyp, cc);
	vs = (char *)r->a.host->i;
	
	for (int64_t i = 0; i < mc; i++) {
		struct host_buffer hb = {
			1, 0, NULL, .i = (int64_t *)(vs + i * sz)
		};
		struct cell x = {
			1, CELL_ARRAY, NULL, .a = {
				r->a.etyp, STG_HOST, r->a.rnk - 1, shp,
				.host = &hb
			}
		};
		struct cell *nil;
		
		if ((err = println_f(NULL, &nil, NULL, &x, NULL)))
			goto fail;
	}
	
	free_host_buffer(shp);
	
done:
	*z = ref_cell(r);
	
	return 0;

fail:
	free_host_buffer(shp);
	
	return err;
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

EXPORT int
conjugate_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
{
	struct cell *t;
	int err;
	
	s; l; fv;
	
	t = NULL;
	
	if (r->a.etyp != ELEM_CMPX) {
		*z = ref_cell(r);
		return 0;
	}
	
	if (!(t = get_cell()))
		return 1;
	
	t->ctyp = CELL_ARRAY;
	t->a = r->a;
	t->a.etyp = ELEM_FLOAT;
	
	if (!t->a.rnk)
		goto done;
	
	t->a.shp->refc++;
	t->a.host = NULL;
	
	switch (t->a.stg) {
	case STG_DEVICE:{
		CHKAF(af_conjg(&t->a.dev, r->a.dev), fail);
	}break;
	case STG_HOST:{
		int64_t cnt;
		struct apl_cmpx *restrict rv;
		double *restrict zv;
		
		cnt = array_count(t, 1);
		
		if (!(t->a.host = get_host_buffer(buffer_size(ELEM_FLOAT, cnt)))) {
			err = 1;
			goto fail;
		}
		
		rv = r->a.host->j;
		zv = t->a.host->f;
		
		for (int64_t i = 0; i < cnt; i++)
			zv[i] = rv[i].real;
		
	}break;	
	default:
		return 99;
	}
	
done:
	*z = t;
	
	return 0;

fail:
	free_cell(t);
	
	return err;
}

static int
get_scalar_cell(struct cell **z, struct cell *l, struct cell *r, enum elem_type type)
{
	struct cell *t;
	
	if (!(t = get_cell()))
		return 1;
	
	t->ctyp = CELL_ARRAY;
	
	if (!l->a.rnk) {
		t->a.rnk = r->a.rnk;
		t->a.shp = r->a.shp;
		
		if (t->a.shp)
			t->a.shp->refc++;
	} else if (!r->a.rnk) {
		t->a.rnk = l->a.rnk;
		t->a.shp = l->a.shp;
		
		t->a.shp->refc++;
	} else if (r->a.rnk != l->a.rnk) {
		return 4;
	} else {
		for (int64_t i = 0; i < r->a.rnk; i++)
			if (l->a.shp->i[i] != r->a.shp->i[i])
				return 5;
		
		t->a.rnk = r->a.rnk;
		t->a.shp = r->a.shp;
		t->a.shp->refc++;
	}
	
	t->a.stg = STG_HOST;
	t->a.etyp = type == ELEM_MAX ? elem_type_merge_map[l->a.etyp][r->a.etyp] : type;
	
	if (r->a.stg == STG_DEVICE || l->a.stg == STG_DEVICE)
		t->a.stg = STG_DEVICE;
		
	switch (t->a.stg) {
	case STG_DEVICE:
		t->a.dev = NULL;
		break;
	case STG_HOST:
		if (t->a.rnk) {
			int64_t cnt;
			
			cnt = array_count(t, 1);
			
			if (!(t->a.host = get_host_buffer(buffer_size(t->a.etyp, cnt))))
				goto fail;
				
			if (t->a.etyp == ELEM_CELL)
				memset(t->a.host->p, 0, sizeof(*t->a.host->p) * cnt);
		} else if (t->a.etyp == ELEM_CELL) {
			t->a.p = NULL;
		}break;
	default:
		goto fail;
	}
	
	*z = t;
	
	return 0;

fail:
	free_cell(t);
	
	return 1;
}

EXPORT int
plus_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
{
	struct cell *t;
	int64_t cnt;
	int err;
	
	s; fv;
	
	if (s != NULL && s->f.axis != NULL)
		return 16;
	
	t = NULL;
	
	if (l->a.etyp == ELEM_CHAR || r->a.etyp == ELEM_CHAR) {
		err = 11;
		goto fail;
	}
	
	if ((err = get_scalar_cell(&t, l, r, ELEM_MAX)))
		goto fail;
	
	if (t->a.stg == STG_DEVICE) {
		err = 16;
		goto fail;
	}
	
	cnt = array_count(t, 1);
	
	switch (l->a.etyp) {
	case ELEM_INT:{
		switch (r->a.etyp) {
		case ELEM_INT:{
			if (!t->a.rnk) {
				t->a.i = l->a.i + r->a.i;
			} else if (!l->a.rnk) {
				int64_t *restrict tv = t->a.host->i;
				int64_t lv = l->a.i;
				int64_t *restrict rv = r->a.host->i;
				
				for (int64_t i = 0; i < cnt; i++)
					tv[i] = lv + rv[i];
			} else if (!r->a.rnk) {
				int64_t *restrict tv = t->a.host->i;
				int64_t *restrict lv = l->a.host->i;
				int64_t rv = r->a.i;
				
				for (int64_t i = 0; i < cnt; i++)
					tv[i] = lv[i] + rv;
			} else {
				int64_t *restrict tv = t->a.host->i;
				int64_t *restrict lv = l->a.host->i;
				int64_t *restrict rv = r->a.host->i;
				
				for (int64_t i = 0; i < cnt; i++)
					tv[i] = lv[i] + rv[i];
			}
		}break;
		case ELEM_FLOAT:{
			if (!t->a.rnk) {
				t->a.f = l->a.i + r->a.f;
			} else if (!l->a.rnk) {
				double *restrict tv = t->a.host->f;
				int64_t lv = l->a.i;
				double *restrict rv = r->a.host->f;
				
				for (int64_t i = 0; i < cnt; i++)
					tv[i] = lv + rv[i];
			} else if (!r->a.rnk) {
				double *restrict tv = t->a.host->f;
				int64_t *restrict lv = l->a.host->i;
				double rv = r->a.f;
				
				for (int64_t i = 0; i < cnt; i++)
					tv[i] = lv[i] + rv;
			} else {
				double *restrict tv = t->a.host->f;
				int64_t *restrict lv = l->a.host->i;
				double *restrict rv = r->a.host->f;
				
				for (int64_t i = 0; i < cnt; i++)
					tv[i] = lv[i] + rv[i];
			}
		}break;
		case ELEM_CMPX:{
			if (!t->a.rnk) {
				t->a.j.real = l->a.i + r->a.j.real;
				t->a.j.imag = r->a.j.imag;
			} else if (!l->a.rnk) {
				struct apl_cmpx *restrict tv = t->a.host->j;
				int64_t lv = l->a.i;
				struct apl_cmpx *restrict rv = r->a.host->j;
				
				for (int64_t i = 0; i < cnt; i++) {
					tv[i].real = lv + rv[i].real;
					tv[i].imag = rv[i].imag;
				}
			} else if (!r->a.rnk) {
				struct apl_cmpx *restrict tv = t->a.host->j;
				int64_t *restrict lv = l->a.host->i;
				struct apl_cmpx rv = r->a.j;
				
				for (int64_t i = 0; i < cnt; i++) {
					tv[i].real = lv[i] + rv.real;
					tv[i].imag = rv.imag;
				}
			} else {
				struct apl_cmpx *restrict tv = t->a.host->j;
				int64_t *restrict lv = l->a.host->i;
				struct apl_cmpx *restrict rv = r->a.host->j;
				
				for (int64_t i = 0; i < cnt; i++) {
					tv[i].real = lv[i] + rv[i].real;
					tv[i].imag = rv[i].imag;
				}
			}
		}break;
		case ELEM_CHAR:err = 99; goto fail;
		case ELEM_CELL:{
			struct cell x = {
				1, CELL_ARRAY, NULL, .a = {
					ELEM_INT, STG_HOST, 0, NULL, .i = 0
				}
			};
			
			if (!t->a.rnk) {
				err = plus_f(NULL, &t->a.p, l, r->a.p, NULL);
				if (err) goto fail;
			} else if (!l->a.rnk) {
				struct cell **restrict tv = t->a.host->p;
				struct cell **restrict rv = r->a.host->p;

				for (int64_t i = 0; i < cnt; i++) {
					err = plus_f(NULL, &tv[i], l, rv[i], NULL);
					if (err) goto fail;
				}
			} else if (!r->a.rnk) {
				struct cell **restrict tv = t->a.host->p;
				int64_t *restrict lv = l->a.host->i;
				struct cell *rv = r->a.p;
				
				for (int64_t i = 0; i < cnt; i++) {
					x.a.i = lv[i];
					err = plus_f(NULL, &tv[i], &x, rv, NULL);
					if (err) goto fail;
				}
			} else {
				struct cell **restrict tv = t->a.host->p;
				int64_t *restrict lv = l->a.host->i;
				struct cell **restrict rv = r->a.host->p;
				
				for (int64_t i = 0; i < cnt; i++) {
					x.a.i = lv[i];
					err = plus_f(NULL, &tv[i], &x, rv[i], NULL);
					if (err) goto fail;
				}
			}
		}break;
		default:err = 99; goto fail;
		}
	}break;
	case ELEM_FLOAT:{
		switch (r->a.etyp) {
		case ELEM_INT:{
			if (!t->a.rnk) {
				t->a.f = l->a.f + r->a.i;
			} else if (!l->a.rnk) {
				double *restrict tv = t->a.host->f;
				double lv = l->a.f;
				int64_t *restrict rv = r->a.host->i;
				
				for (int64_t i = 0; i < cnt; i++)
					tv[i] = lv + rv[i];
			} else if (!r->a.rnk) {
				double *restrict tv = t->a.host->f;
				double *restrict lv = l->a.host->f;
				int64_t rv = r->a.i;
				
				for (int64_t i = 0; i < cnt; i++)
					tv[i] = lv[i] + rv;
			} else {
				double *restrict tv = t->a.host->f;
				double *restrict lv = l->a.host->f;
				int64_t *restrict rv = r->a.host->i;
				
				for (int64_t i = 0; i < cnt; i++)
					tv[i] = lv[i] + rv[i];
			}
		}break;
		case ELEM_FLOAT:{
			if (!t->a.rnk) {
				t->a.f = l->a.f + r->a.f;
			} else if (!l->a.rnk) {
				double *restrict tv = t->a.host->f;
				double lv = l->a.f;
				double *restrict rv = r->a.host->f;
				
				for (int64_t i = 0; i < cnt; i++)
					tv[i] = lv + rv[i];
			} else if (!r->a.rnk) {
				double *restrict tv = t->a.host->f;
				double *restrict lv = l->a.host->f;
				double rv = r->a.f;
				
				for (int64_t i = 0; i < cnt; i++)
					tv[i] = lv[i] + rv;
			} else {
				double *restrict tv = t->a.host->f;
				double *restrict lv = l->a.host->f;
				double *restrict rv = r->a.host->f;
				
				for (int64_t i = 0; i < cnt; i++)
					tv[i] = lv[i] + rv[i];
			}
		}break;
		case ELEM_CMPX:{
			if (!t->a.rnk) {
				t->a.j.real = l->a.f + r->a.j.real;
				t->a.j.imag = r->a.j.imag;
			} else if (!l->a.rnk) {
				struct apl_cmpx *restrict tv = t->a.host->j;
				double lv = l->a.f;
				struct apl_cmpx *restrict rv = r->a.host->j;
				
				for (int64_t i = 0; i < cnt; i++) {
					tv[i].real = lv + rv[i].real;
					tv[i].imag = rv[i].imag;
				}
			} else if (!r->a.rnk) {
				struct apl_cmpx *restrict tv = t->a.host->j;
				double *restrict lv = l->a.host->f;
				struct apl_cmpx rv = r->a.j;
				
				for (int64_t i = 0; i < cnt; i++) {
					tv[i].real = lv[i] + rv.real;
					tv[i].imag = rv.imag;
				}
			} else {
				struct apl_cmpx *restrict tv = t->a.host->j;
				double *restrict lv = l->a.host->f;
				struct apl_cmpx *restrict rv = r->a.host->j;
				
				for (int64_t i = 0; i < cnt; i++) {
					tv[i].real = lv[i] + rv[i].real;
					tv[i].imag = rv[i].imag;
				}
			}
		}break;
		case ELEM_CHAR:err = 99; goto fail;
		case ELEM_CELL:{
			struct cell x = {
				1, CELL_ARRAY, NULL, .a = {
					ELEM_FLOAT, STG_HOST, 0, NULL, .f = 0
				}
			};
			
			if (!t->a.rnk) {
				err = plus_f(NULL, &t->a.p, l, r->a.p, NULL);
				if (err) goto fail;
			} else if (!l->a.rnk) {
				struct cell **restrict tv = t->a.host->p;
				struct cell **restrict rv = r->a.host->p;

				for (int64_t i = 0; i < cnt; i++) {
					err = plus_f(NULL, &tv[i], l, rv[i], NULL);
					if (err) goto fail;
				}
			} else if (!r->a.rnk) {
				struct cell **restrict tv = t->a.host->p;
				double *restrict lv = l->a.host->f;
				struct cell *rv = r->a.p;
				
				for (int64_t i = 0; i < cnt; i++) {
					x.a.f = lv[i];
					err = plus_f(NULL, &tv[i], &x, rv, NULL);
					if (err) goto fail;
				}
			} else {
				struct cell **restrict tv = t->a.host->p;
				double *restrict lv = l->a.host->f;
				struct cell **restrict rv = r->a.host->p;
				
				for (int64_t i = 0; i < cnt; i++) {
					x.a.f = lv[i];
					err = plus_f(NULL, &tv[i], &x, rv[i], NULL);
					if (err) goto fail;
				}
			}
		}break;
		default:err = 99; goto fail;
		}
	}break;
	case ELEM_CMPX:{
		switch (r->a.etyp) {
		case ELEM_INT:{
			if (!t->a.rnk) {
				t->a.j.real = l->a.j.real + r->a.i;
				t->a.j.imag = l->a.j.imag;
			} else if (!l->a.rnk) {
				struct apl_cmpx *restrict tv = t->a.host->j;
				struct apl_cmpx lv = l->a.j;
				int64_t *restrict rv = r->a.host->i;
				
				for (int64_t i = 0; i < cnt; i++) {
					tv[i].real = lv.real + rv[i];
					tv[i].imag = lv.imag;
				}
			} else if (!r->a.rnk) {
				struct apl_cmpx *restrict tv = t->a.host->j;
				struct apl_cmpx *restrict lv = l->a.host->j;
				int64_t rv = r->a.i;
				
				for (int64_t i = 0; i < cnt; i++) {
					tv[i].real = lv[i].real + rv;
					tv[i].imag = lv[i].imag;
				}
			} else {
				struct apl_cmpx *restrict tv = t->a.host->j;
				struct apl_cmpx *restrict lv = l->a.host->j;
				int64_t *restrict rv = r->a.host->i;
				
				for (int64_t i = 0; i < cnt; i++) {
					tv[i].real = lv[i].real + rv[i];
					tv[i].imag = lv[i].imag;
				}
			}
		}break;
		case ELEM_FLOAT:{
			if (!t->a.rnk) {
				t->a.j.real = l->a.j.real + r->a.f;
				t->a.j.imag = l->a.j.imag;
			} else if (!l->a.rnk) {
				struct apl_cmpx *restrict tv = t->a.host->j;
				struct apl_cmpx lv = l->a.j;
				double *restrict rv = r->a.host->f;
				
				for (int64_t i = 0; i < cnt; i++) {
					tv[i].real = lv.real + rv[i];
					tv[i].imag = lv.imag;
				}
			} else if (!r->a.rnk) {
				struct apl_cmpx *restrict tv = t->a.host->j;
				struct apl_cmpx *restrict lv = l->a.host->j;
				double rv = r->a.f;
				
				for (int64_t i = 0; i < cnt; i++) {
					tv[i].real = lv[i].real + rv;
					tv[i].imag = lv[i].imag;
				}
			} else {
				struct apl_cmpx *restrict tv = t->a.host->j;
				struct apl_cmpx *restrict lv = l->a.host->j;
				double *restrict rv = r->a.host->f;
				
				for (int64_t i = 0; i < cnt; i++) {
					tv[i].real = lv[i].real + rv[i];
					tv[i].imag = lv[i].imag;
				}
			}
		}break;
		case ELEM_CMPX:{
			if (!t->a.rnk) {
				t->a.j.real = l->a.j.real + r->a.j.real;
				t->a.j.imag = l->a.j.imag + r->a.j.imag;
			} else if (!l->a.rnk) {
				struct apl_cmpx *restrict tv = t->a.host->j;
				struct apl_cmpx lv = l->a.j;
				struct apl_cmpx *restrict rv = r->a.host->j;
				
				for (int64_t i = 0; i < cnt; i++) {
					tv[i].real = lv.real + rv[i].real;
					tv[i].imag = lv.imag + rv[i].imag;
				}
			} else if (!r->a.rnk) {
				struct apl_cmpx *restrict tv = t->a.host->j;
				struct apl_cmpx *restrict lv = l->a.host->j;
				struct apl_cmpx rv = r->a.j;
				
				for (int64_t i = 0; i < cnt; i++) {
					tv[i].real = lv[i].real + rv.real;
					tv[i].imag = lv[i].imag + rv.imag;
				}
			} else {
				struct apl_cmpx *restrict tv = t->a.host->j;
				struct apl_cmpx *restrict lv = l->a.host->j;
				struct apl_cmpx *restrict rv = r->a.host->j;
				
				for (int64_t i = 0; i < cnt; i++) {
					tv[i].real = lv[i].real + rv[i].real;
					tv[i].imag = lv[i].imag + rv[i].imag;
				}
			}
		}break;
		case ELEM_CHAR:err = 99; goto fail;
		case ELEM_CELL:{
			struct cell x = {
				1, CELL_ARRAY, NULL, .a = {
					ELEM_CMPX, STG_HOST, 0, NULL, .j = {0, 0}
				}
			};
			
			if (!t->a.rnk) {
				err = plus_f(NULL, &t->a.p, l, r->a.p, NULL);
				if (err) goto fail;
			} else if (!l->a.rnk) {
				struct cell **restrict tv = t->a.host->p;
				struct cell **restrict rv = r->a.host->p;

				for (int64_t i = 0; i < cnt; i++) {
					err = plus_f(NULL, &tv[i], l, rv[i], NULL);
					if (err) goto fail;
				}
			} else if (!r->a.rnk) {
				struct cell **restrict tv = t->a.host->p;
				struct apl_cmpx *restrict lv = l->a.host->j;
				struct cell *rv = r->a.p;
				
				for (int64_t i = 0; i < cnt; i++) {
					x.a.j = lv[i];
					err = plus_f(NULL, &tv[i], &x, rv, NULL);
					if (err) goto fail;
				}
			} else {
				struct cell **restrict tv = t->a.host->p;
				struct apl_cmpx *restrict lv = l->a.host->j;
				struct cell **restrict rv = r->a.host->p;
				
				for (int64_t i = 0; i < cnt; i++) {
					x.a.j = lv[i];
					err = plus_f(NULL, &tv[i], &x, rv[i], NULL);
					if (err) goto fail;
				}
			}
		}break;
		default:err = 99; goto fail;
		}
	}break;
	case ELEM_CHAR:err = 99; goto fail;
	case ELEM_CELL:{
		switch (r->a.etyp) {
		case ELEM_INT:{
			struct cell x = {
				1, CELL_ARRAY, NULL, .a = {
					ELEM_INT, STG_HOST, 0, NULL, .i = 0
				}
			};
			
			if (!t->a.rnk) {
				err = plus_f(NULL, &t->a.p, l->a.p, r, NULL);
				if (err) goto fail;
			} else if (!l->a.rnk) {
				struct cell **restrict tv = t->a.host->p;
				int64_t *restrict rv = r->a.host->i;

				for (int64_t i = 0; i < cnt; i++) {
					x.a.i = rv[i];
					err = plus_f(NULL, &tv[i], l->a.p, &x, NULL);
					if (err) goto fail;
				}
			} else if (!r->a.rnk) {
				struct cell **restrict tv = t->a.host->p;
				struct cell **restrict lv = l->a.host->p;
				x.a.i = r->a.i;
				
				for (int64_t i = 0; i < cnt; i++) {
					err = plus_f(NULL, &tv[i], lv[i], &x, NULL);
					if (err) goto fail;
				}
			} else {
				struct cell **restrict tv = t->a.host->p;
				struct cell **restrict lv = l->a.host->p;
				int64_t *restrict rv = r->a.host->i;
				
				for (int64_t i = 0; i < cnt; i++) {
					x.a.i = rv[i];
					err = plus_f(NULL, &tv[i], lv[i], &x, NULL);
					if (err) goto fail;
				}
			}
		}break;
		case ELEM_FLOAT:{
			struct cell x = {
				1, CELL_ARRAY, NULL, .a = {
					ELEM_FLOAT, STG_HOST, 0, NULL, .f = 0
				}
			};
			
			if (!t->a.rnk) {
				err = plus_f(NULL, &t->a.p, l->a.p, r, NULL);
				if (err) goto fail;
			} else if (!l->a.rnk) {
				struct cell **restrict tv = t->a.host->p;
				double *restrict rv = r->a.host->f;

				for (int64_t i = 0; i < cnt; i++) {
					x.a.f = rv[i];
					err = plus_f(NULL, &tv[i], l->a.p, &x, NULL);
					if (err) goto fail;
				}
			} else if (!r->a.rnk) {
				struct cell **restrict tv = t->a.host->p;
				struct cell **restrict lv = l->a.host->p;
				x.a.f = r->a.f;
				
				for (int64_t i = 0; i < cnt; i++) {
					err = plus_f(NULL, &tv[i], lv[i], &x, NULL);
					if (err) goto fail;
				}
			} else {
				struct cell **restrict tv = t->a.host->p;
				struct cell **restrict lv = l->a.host->p;
				double *restrict rv = r->a.host->f;
				
				for (int64_t i = 0; i < cnt; i++) {
					x.a.f = rv[i];
					err = plus_f(NULL, &tv[i], lv[i], &x, NULL);
					if (err) goto fail;
				}
			}
		}break;
		case ELEM_CMPX:{
			struct cell x = {
				1, CELL_ARRAY, NULL, .a = {
					ELEM_CMPX, STG_HOST, 0, NULL, .j = {0, 0}
				}
			};
			
			if (!t->a.rnk) {
				err = plus_f(NULL, &t->a.p, l->a.p, r, NULL);
				if (err) goto fail;
			} else if (!l->a.rnk) {
				struct cell **restrict tv = t->a.host->p;
				struct apl_cmpx *restrict rv = r->a.host->j;

				for (int64_t i = 0; i < cnt; i++) {
					x.a.j = rv[i];
					err = plus_f(NULL, &tv[i], l->a.p, &x, NULL);
					if (err) goto fail;
				}
			} else if (!r->a.rnk) {
				struct cell **restrict tv = t->a.host->p;
				struct cell **restrict lv = l->a.host->p;
				x.a.j = r->a.j;
				
				for (int64_t i = 0; i < cnt; i++) {
					err = plus_f(NULL, &tv[i], lv[i], &x, NULL);
					if (err) goto fail;
				}
			} else {
				struct cell **restrict tv = t->a.host->p;
				struct cell **restrict lv = l->a.host->p;
				struct apl_cmpx *restrict rv = r->a.host->j;
				
				for (int64_t i = 0; i < cnt; i++) {
					x.a.j = rv[i];
					err = plus_f(NULL, &tv[i], lv[i], &x, NULL);
					if (err) goto fail;
				}
			}
		}break;
		case ELEM_CHAR:err = 99; goto fail;
		case ELEM_CELL:{
			if (!t->a.rnk) {
				err = plus_f(NULL, &t->a.p, l->a.p, r->a.p, NULL);
				if (err) goto fail;
			} else if (!l->a.rnk) {
				struct cell **restrict tv = t->a.host->p;
				struct cell **restrict rv = r->a.host->p;

				for (int64_t i = 0; i < cnt; i++) {
					err = plus_f(NULL, &tv[i], l->a.p, rv[i], NULL);
					if (err) goto fail;
				}
			} else if (!r->a.rnk) {
				struct cell **restrict tv = t->a.host->p;
				struct cell **restrict lv = l->a.host->p;
				
				for (int64_t i = 0; i < cnt; i++) {
					err = plus_f(NULL, &tv[i], lv[i], r->a.p, NULL);
					if (err) goto fail;
				}
			} else {
				struct cell **restrict tv = t->a.host->p;
				struct cell **restrict lv = l->a.host->p;
				struct cell **restrict rv = r->a.host->p;
				
				for (int64_t i = 0; i < cnt; i++) {
					err = plus_f(NULL, &tv[i], lv[i], rv[i], NULL);
					if (err) goto fail;
				}
			}
		}break;
		default:err = 99; goto fail;
		}
	}break;
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

int (*add_fn[])(struct cell *, struct cell **, struct cell *, struct cell *, struct cell ***) = {
	conjugate_f, plus_f
};
struct cell add_c = {
	1, CELL_FUNC, NULL, .f = {
		add_fn, NULL, NULL, NULL
	}
};
EXPORT struct cell *add = &add_c;

EXPORT int
sign_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
{
	s; z; l; r; fv;
	
	return 16;
}

EXPORT int
times_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
{
	struct cell *t;
	int64_t cnt;
	int err;
	
	fv;
	
	if (s != NULL && s->f.axis != NULL)
		return 16;
	
	t = NULL;
	
	if (l->a.etyp == ELEM_CHAR || r->a.etyp == ELEM_CHAR) {
		err = 11;
		goto fail;
	}
	
	if ((err = get_scalar_cell(&t, l, r, ELEM_MAX)))
		goto fail;
	
	if (t->a.stg == STG_DEVICE) {
		err = 16;
		goto fail;
	}
	
	cnt = array_count(t, 1);
	
	switch (l->a.etyp) {
	case ELEM_INT:{
		switch (r->a.etyp) {
		case ELEM_INT:{
			if (!t->a.rnk) {
				t->a.i = l->a.i * r->a.i;
			} else if (!l->a.rnk) {
				int64_t *restrict tv = t->a.host->i;
				int64_t lv = l->a.i;
				int64_t *restrict rv = r->a.host->i;
				
				for (int64_t i = 0; i < cnt; i++)
					tv[i] = lv * rv[i];
			} else if (!r->a.rnk) {
				int64_t *restrict tv = t->a.host->i;
				int64_t *restrict lv = l->a.host->i;
				int64_t rv = r->a.i;
				
				for (int64_t i = 0; i < cnt; i++)
					tv[i] = lv[i] * rv;
			} else {
				int64_t *restrict tv = t->a.host->i;
				int64_t *restrict lv = l->a.host->i;
				int64_t *restrict rv = r->a.host->i;
				
				for (int64_t i = 0; i < cnt; i++)
					tv[i] = lv[i] * rv[i];
			}
		}break;
		case ELEM_FLOAT:{
			if (!t->a.rnk) {
				t->a.f = l->a.i * r->a.f;
			} else if (!l->a.rnk) {
				double *restrict tv = t->a.host->f;
				int64_t lv = l->a.i;
				double *restrict rv = r->a.host->f;
				
				for (int64_t i = 0; i < cnt; i++)
					tv[i] = lv * rv[i];
			} else if (!r->a.rnk) {
				double *restrict tv = t->a.host->f;
				int64_t *restrict lv = l->a.host->i;
				double rv = r->a.f;
				
				for (int64_t i = 0; i < cnt; i++)
					tv[i] = lv[i] * rv;
			} else {
				double *restrict tv = t->a.host->f;
				int64_t *restrict lv = l->a.host->i;
				double *restrict rv = r->a.host->f;
				
				for (int64_t i = 0; i < cnt; i++)
					tv[i] = lv[i] * rv[i];
			}
		}break;
		case ELEM_CMPX:{
			if (!t->a.rnk) {
				t->a.j.real = l->a.i * r->a.j.real;
				t->a.j.imag = l->a.i * r->a.j.imag;
			} else if (!l->a.rnk) {
				struct apl_cmpx *restrict tv = t->a.host->j;
				int64_t lv = l->a.i;
				struct apl_cmpx *restrict rv = r->a.host->j;
				
				for (int64_t i = 0; i < cnt; i++) {
					tv[i].real = lv * rv[i].real;
					tv[i].imag = lv * rv[i].imag;
				}
			} else if (!r->a.rnk) {
				struct apl_cmpx *restrict tv = t->a.host->j;
				int64_t *restrict lv = l->a.host->i;
				struct apl_cmpx rv = r->a.j;
				
				for (int64_t i = 0; i < cnt; i++) {
					tv[i].real = lv[i] * rv.real;
					tv[i].imag = lv[i] * rv.imag;
				}
			} else {
				struct apl_cmpx *restrict tv = t->a.host->j;
				int64_t *restrict lv = l->a.host->i;
				struct apl_cmpx *restrict rv = r->a.host->j;
				
				for (int64_t i = 0; i < cnt; i++) {
					tv[i].real = lv[i] * rv[i].real;
					tv[i].imag = lv[i] * rv[i].imag;
				}
			}
		}break;
		case ELEM_CHAR:err = 99; goto fail;
		case ELEM_CELL:{
			struct cell x = {
				1, CELL_ARRAY, NULL, .a = {
					ELEM_INT, STG_HOST, 0, NULL, .i = 0
				}
			};
			
			if (!t->a.rnk) {
				err = times_f(NULL, &t->a.p, l, r->a.p, NULL);
				if (err) goto fail;
			} else if (!l->a.rnk) {
				struct cell **restrict tv = t->a.host->p;
				struct cell **restrict rv = r->a.host->p;

				for (int64_t i = 0; i < cnt; i++) {
					err = times_f(NULL, &tv[i], l, rv[i], NULL);
					if (err) goto fail;
				}
			} else if (!r->a.rnk) {
				struct cell **restrict tv = t->a.host->p;
				int64_t *restrict lv = l->a.host->i;
				struct cell *rv = r->a.p;
				
				for (int64_t i = 0; i < cnt; i++) {
					x.a.i = lv[i];
					err = times_f(NULL, &tv[i], &x, rv, NULL);
					if (err) goto fail;
				}
			} else {
				struct cell **restrict tv = t->a.host->p;
				int64_t *restrict lv = l->a.host->i;
				struct cell **restrict rv = r->a.host->p;
				
				for (int64_t i = 0; i < cnt; i++) {
					x.a.i = lv[i];
					err = times_f(NULL, &tv[i], &x, rv[i], NULL);
					if (err) goto fail;
				}
			}
		}break;
		default:err = 99; goto fail;
		}
	}break;
	case ELEM_FLOAT:{
		switch (r->a.etyp) {
		case ELEM_INT:{
			if (!t->a.rnk) {
				t->a.f = l->a.f * r->a.i;
			} else if (!l->a.rnk) {
				double *restrict tv = t->a.host->f;
				double lv = l->a.f;
				int64_t *restrict rv = r->a.host->i;
				
				for (int64_t i = 0; i < cnt; i++)
					tv[i] = lv * rv[i];
			} else if (!r->a.rnk) {
				double *restrict tv = t->a.host->f;
				double *restrict lv = l->a.host->f;
				int64_t rv = r->a.i;
				
				for (int64_t i = 0; i < cnt; i++)
					tv[i] = lv[i] * rv;
			} else {
				double *restrict tv = t->a.host->f;
				double *restrict lv = l->a.host->f;
				int64_t *restrict rv = r->a.host->i;
				
				for (int64_t i = 0; i < cnt; i++)
					tv[i] = lv[i] * rv[i];
			}
		}break;
		case ELEM_FLOAT:{
			if (!t->a.rnk) {
				t->a.f = l->a.f * r->a.f;
			} else if (!l->a.rnk) {
				double *restrict tv = t->a.host->f;
				double lv = l->a.f;
				double *restrict rv = r->a.host->f;
				
				for (int64_t i = 0; i < cnt; i++)
					tv[i] = lv * rv[i];
			} else if (!r->a.rnk) {
				double *restrict tv = t->a.host->f;
				double *restrict lv = l->a.host->f;
				double rv = r->a.f;
				
				for (int64_t i = 0; i < cnt; i++)
					tv[i] = lv[i] * rv;
			} else {
				double *restrict tv = t->a.host->f;
				double *restrict lv = l->a.host->f;
				double *restrict rv = r->a.host->f;
				
				for (int64_t i = 0; i < cnt; i++)
					tv[i] = lv[i] * rv[i];
			}
		}break;
		case ELEM_CMPX:{
			if (!t->a.rnk) {
				t->a.j.real = l->a.f * r->a.j.real;
				t->a.j.imag = l->a.f * r->a.j.imag;
			} else if (!l->a.rnk) {
				struct apl_cmpx *restrict tv = t->a.host->j;
				double lv = l->a.f;
				struct apl_cmpx *restrict rv = r->a.host->j;
				
				for (int64_t i = 0; i < cnt; i++) {
					tv[i].real = lv * rv[i].real;
					tv[i].imag = lv * rv[i].imag;
				}
			} else if (!r->a.rnk) {
				struct apl_cmpx *restrict tv = t->a.host->j;
				double *restrict lv = l->a.host->f;
				struct apl_cmpx rv = r->a.j;
				
				for (int64_t i = 0; i < cnt; i++) {
					tv[i].real = lv[i] * rv.real;
					tv[i].imag = lv[i] * rv.imag;
				}
			} else {
				struct apl_cmpx *restrict tv = t->a.host->j;
				double *restrict lv = l->a.host->f;
				struct apl_cmpx *restrict rv = r->a.host->j;
				
				for (int64_t i = 0; i < cnt; i++) {
					tv[i].real = lv[i] * rv[i].real;
					tv[i].imag = lv[i] * rv[i].imag;
				}
			}
		}break;
		case ELEM_CHAR:err = 99; goto fail;
		case ELEM_CELL:{
			struct cell x = {
				1, CELL_ARRAY, NULL, .a = {
					ELEM_FLOAT, STG_HOST, 0, NULL, .f = 0
				}
			};
			
			if (!t->a.rnk) {
				err = times_f(NULL, &t->a.p, l, r->a.p, NULL);
				if (err) goto fail;
			} else if (!l->a.rnk) {
				struct cell **restrict tv = t->a.host->p;
				struct cell **restrict rv = r->a.host->p;

				for (int64_t i = 0; i < cnt; i++) {
					err = times_f(NULL, &tv[i], l, rv[i], NULL);
					if (err) goto fail;
				}
			} else if (!r->a.rnk) {
				struct cell **restrict tv = t->a.host->p;
				double *restrict lv = l->a.host->f;
				struct cell *rv = r->a.p;
				
				for (int64_t i = 0; i < cnt; i++) {
					x.a.f = lv[i];
					err = times_f(NULL, &tv[i], &x, rv, NULL);
					if (err) goto fail;
				}
			} else {
				struct cell **restrict tv = t->a.host->p;
				double *restrict lv = l->a.host->f;
				struct cell **restrict rv = r->a.host->p;
				
				for (int64_t i = 0; i < cnt; i++) {
					x.a.f = lv[i];
					err = times_f(NULL, &tv[i], &x, rv[i], NULL);
					if (err) goto fail;
				}
			}
		}break;
		default:err = 99; goto fail;
		}
	}break;
	case ELEM_CMPX:{
		switch (r->a.etyp) {
		case ELEM_INT:{
			if (!t->a.rnk) {
				t->a.j.real = l->a.j.real * r->a.i;
				t->a.j.imag = l->a.j.imag * r->a.i;
			} else if (!l->a.rnk) {
				struct apl_cmpx *restrict tv = t->a.host->j;
				struct apl_cmpx lv = l->a.j;
				int64_t *restrict rv = r->a.host->i;
				
				for (int64_t i = 0; i < cnt; i++) {
					tv[i].real = lv.real * rv[i];
					tv[i].imag = lv.imag * rv[i];
				}
			} else if (!r->a.rnk) {
				struct apl_cmpx *restrict tv = t->a.host->j;
				struct apl_cmpx *restrict lv = l->a.host->j;
				int64_t rv = r->a.i;
				
				for (int64_t i = 0; i < cnt; i++) {
					tv[i].real = lv[i].real * rv;
					tv[i].imag = lv[i].imag * rv;
				}
			} else {
				struct apl_cmpx *restrict tv = t->a.host->j;
				struct apl_cmpx *restrict lv = l->a.host->j;
				int64_t *restrict rv = r->a.host->i;
				
				for (int64_t i = 0; i < cnt; i++) {
					tv[i].real = lv[i].real * rv[i];
					tv[i].imag = lv[i].imag * rv[i];
				}
			}
		}break;
		case ELEM_FLOAT:{
			if (!t->a.rnk) {
				t->a.j.real = l->a.j.real * r->a.f;
				t->a.j.imag = l->a.j.imag * r->a.f;
			} else if (!l->a.rnk) {
				struct apl_cmpx *restrict tv = t->a.host->j;
				struct apl_cmpx lv = l->a.j;
				double *restrict rv = r->a.host->f;
				
				for (int64_t i = 0; i < cnt; i++) {
					tv[i].real = lv.real * rv[i];
					tv[i].imag = lv.imag * rv[i];
				}
			} else if (!r->a.rnk) {
				struct apl_cmpx *restrict tv = t->a.host->j;
				struct apl_cmpx *restrict lv = l->a.host->j;
				double rv = r->a.f;
				
				for (int64_t i = 0; i < cnt; i++) {
					tv[i].real = lv[i].real * rv;
					tv[i].imag = lv[i].imag * rv;
				}
			} else {
				struct apl_cmpx *restrict tv = t->a.host->j;
				struct apl_cmpx *restrict lv = l->a.host->j;
				double *restrict rv = r->a.host->f;
				
				for (int64_t i = 0; i < cnt; i++) {
					tv[i].real = lv[i].real * rv[i];
					tv[i].imag = lv[i].imag * rv[i];
				}
			}
		}break;
		case ELEM_CMPX:{
			if (!t->a.rnk) {
				t->a.j.real = l->a.j.real * r->a.j.real - l->a.j.imag * r->a.j.imag;
				t->a.j.imag = l->a.j.imag * r->a.j.real + l->a.j.real * r->a.j.imag;
			} else if (!l->a.rnk) {
				struct apl_cmpx *restrict tv = t->a.host->j;
				struct apl_cmpx lv = l->a.j;
				struct apl_cmpx *restrict rv = r->a.host->j;
				
				for (int64_t i = 0; i < cnt; i++) {
					tv[i].real = lv.real * rv[i].real - lv.imag * rv[i].imag;
					tv[i].imag = lv.imag * rv[i].real + lv.real * rv[i].imag;
				}
			} else if (!r->a.rnk) {
				struct apl_cmpx *restrict tv = t->a.host->j;
				struct apl_cmpx *restrict lv = l->a.host->j;
				struct apl_cmpx rv = r->a.j;
				
				for (int64_t i = 0; i < cnt; i++) {
					tv[i].real = lv[i].real * rv.real - lv[i].imag * rv.imag;
					tv[i].imag = lv[i].imag * rv.real + lv[i].real * rv.imag;
				}
			} else {
				struct apl_cmpx *restrict tv = t->a.host->j;
				struct apl_cmpx *restrict lv = l->a.host->j;
				struct apl_cmpx *restrict rv = r->a.host->j;
				
				for (int64_t i = 0; i < cnt; i++) {
					tv[i].real = lv[i].real * rv[i].real - lv[i].imag * rv[i].imag;
					tv[i].imag = lv[i].imag * rv[i].real + lv[i].real * rv[i].imag;
				}
			}
		}break;
		case ELEM_CHAR:err = 99; goto fail;
		case ELEM_CELL:{
			struct cell x = {
				1, CELL_ARRAY, NULL, .a = {
					ELEM_CMPX, STG_HOST, 0, NULL, .j = {0, 0}
				}
			};
			
			if (!t->a.rnk) {
				err = times_f(NULL, &t->a.p, l, r->a.p, NULL);
				if (err) goto fail;
			} else if (!l->a.rnk) {
				struct cell **restrict tv = t->a.host->p;
				struct cell **restrict rv = r->a.host->p;

				for (int64_t i = 0; i < cnt; i++) {
					err = times_f(NULL, &tv[i], l, rv[i], NULL);
					if (err) goto fail;
				}
			} else if (!r->a.rnk) {
				struct cell **restrict tv = t->a.host->p;
				struct apl_cmpx *restrict lv = l->a.host->j;
				struct cell *rv = r->a.p;
				
				for (int64_t i = 0; i < cnt; i++) {
					x.a.j = lv[i];
					err = times_f(NULL, &tv[i], &x, rv, NULL);
					if (err) goto fail;
				}
			} else {
				struct cell **restrict tv = t->a.host->p;
				struct apl_cmpx *restrict lv = l->a.host->j;
				struct cell **restrict rv = r->a.host->p;
				
				for (int64_t i = 0; i < cnt; i++) {
					x.a.j = lv[i];
					err = times_f(NULL, &tv[i], &x, rv[i], NULL);
					if (err) goto fail;
				}
			}
		}break;
		default:err = 99; goto fail;
		}
	}break;
	case ELEM_CHAR:err = 99; goto fail;
	case ELEM_CELL:{
		switch (r->a.etyp) {
		case ELEM_INT:{
			struct cell x = {
				1, CELL_ARRAY, NULL, .a = {
					ELEM_INT, STG_HOST, 0, NULL, .i = 0
				}
			};
			
			if (!t->a.rnk) {
				err = times_f(NULL, &t->a.p, l->a.p, r, NULL);
				if (err) goto fail;
			} else if (!l->a.rnk) {
				struct cell **restrict tv = t->a.host->p;
				int64_t *restrict rv = r->a.host->i;

				for (int64_t i = 0; i < cnt; i++) {
					x.a.i = rv[i];
					err = times_f(NULL, &tv[i], l->a.p, &x, NULL);
					if (err) goto fail;
				}
			} else if (!r->a.rnk) {
				struct cell **restrict tv = t->a.host->p;
				struct cell **restrict lv = l->a.host->p;
				x.a.i = r->a.i;
				
				for (int64_t i = 0; i < cnt; i++) {
					err = times_f(NULL, &tv[i], lv[i], &x, NULL);
					if (err) goto fail;
				}
			} else {
				struct cell **restrict tv = t->a.host->p;
				struct cell **restrict lv = l->a.host->p;
				int64_t *restrict rv = r->a.host->i;
				
				for (int64_t i = 0; i < cnt; i++) {
					x.a.i = rv[i];
					err = times_f(NULL, &tv[i], lv[i], &x, NULL);
					if (err) goto fail;
				}
			}
		}break;
		case ELEM_FLOAT:{
			struct cell x = {
				1, CELL_ARRAY, NULL, .a = {
					ELEM_FLOAT, STG_HOST, 0, NULL, .f = 0
				}
			};
			
			if (!t->a.rnk) {
				err = times_f(NULL, &t->a.p, l->a.p, r, NULL);
				if (err) goto fail;
			} else if (!l->a.rnk) {
				struct cell **restrict tv = t->a.host->p;
				double *restrict rv = r->a.host->f;

				for (int64_t i = 0; i < cnt; i++) {
					x.a.f = rv[i];
					err = times_f(NULL, &tv[i], l->a.p, &x, NULL);
					if (err) goto fail;
				}
			} else if (!r->a.rnk) {
				struct cell **restrict tv = t->a.host->p;
				struct cell **restrict lv = l->a.host->p;
				x.a.f = r->a.f;
				
				for (int64_t i = 0; i < cnt; i++) {
					err = times_f(NULL, &tv[i], lv[i], &x, NULL);
					if (err) goto fail;
				}
			} else {
				struct cell **restrict tv = t->a.host->p;
				struct cell **restrict lv = l->a.host->p;
				double *restrict rv = r->a.host->f;
				
				for (int64_t i = 0; i < cnt; i++) {
					x.a.f = rv[i];
					err = times_f(NULL, &tv[i], lv[i], &x, NULL);
					if (err) goto fail;
				}
			}
		}break;
		case ELEM_CMPX:{
			struct cell x = {
				1, CELL_ARRAY, NULL, .a = {
					ELEM_CMPX, STG_HOST, 0, NULL, .j = {0, 0}
				}
			};
			
			if (!t->a.rnk) {
				err = times_f(NULL, &t->a.p, l->a.p, r, NULL);
				if (err) goto fail;
			} else if (!l->a.rnk) {
				struct cell **restrict tv = t->a.host->p;
				struct apl_cmpx *restrict rv = r->a.host->j;

				for (int64_t i = 0; i < cnt; i++) {
					x.a.j = rv[i];
					err = times_f(NULL, &tv[i], l->a.p, &x, NULL);
					if (err) goto fail;
				}
			} else if (!r->a.rnk) {
				struct cell **restrict tv = t->a.host->p;
				struct cell **restrict lv = l->a.host->p;
				x.a.j = r->a.j;
				
				for (int64_t i = 0; i < cnt; i++) {
					err = times_f(NULL, &tv[i], lv[i], &x, NULL);
					if (err) goto fail;
				}
			} else {
				struct cell **restrict tv = t->a.host->p;
				struct cell **restrict lv = l->a.host->p;
				struct apl_cmpx *restrict rv = r->a.host->j;
				
				for (int64_t i = 0; i < cnt; i++) {
					x.a.j = rv[i];
					err = times_f(NULL, &tv[i], lv[i], &x, NULL);
					if (err) goto fail;
				}
			}
		}break;
		case ELEM_CHAR:err = 99; goto fail;
		case ELEM_CELL:{
			if (!t->a.rnk) {
				err = times_f(NULL, &t->a.p, l->a.p, r->a.p, NULL);
				if (err) goto fail;
			} else if (!l->a.rnk) {
				struct cell **restrict tv = t->a.host->p;
				struct cell **restrict rv = r->a.host->p;

				for (int64_t i = 0; i < cnt; i++) {
					err = times_f(NULL, &tv[i], l->a.p, rv[i], NULL);
					if (err) goto fail;
				}
			} else if (!r->a.rnk) {
				struct cell **restrict tv = t->a.host->p;
				struct cell **restrict lv = l->a.host->p;
				
				for (int64_t i = 0; i < cnt; i++) {
					err = times_f(NULL, &tv[i], lv[i], r->a.p, NULL);
					if (err) goto fail;
				}
			} else {
				struct cell **restrict tv = t->a.host->p;
				struct cell **restrict lv = l->a.host->p;
				struct cell **restrict rv = r->a.host->p;
				
				for (int64_t i = 0; i < cnt; i++) {
					err = times_f(NULL, &tv[i], lv[i], rv[i], NULL);
					if (err) goto fail;
				}
			}
		}break;
		default:err = 99; goto fail;
		}
	}break;
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

int (*mul_fn[])(struct cell *, struct cell **, struct cell *, struct cell *, struct cell ***) = {
	sign_f, times_f
};
struct cell mul_c = {
	1, CELL_FUNC, NULL, .f = {
		mul_fn, NULL, NULL, NULL
	}
};
EXPORT struct cell *mul = &mul_c;

static struct apl_cmpx
div_cmpx(struct apl_cmpx x, struct apl_cmpx y)
{
	struct apl_cmpx z;
	double quot;
	
	quot = y.real * y.real + y.imag * y.imag;
	
	if (!quot) {
		z.real = 0;
		z.imag = 0;
		return z;
	}
	
	z.real = (x.real * y.real + x.imag * y.imag) / quot;
	z.imag = (x.imag * y.real - x.real * y.imag) / quot;
	
	return z;
}

EXPORT int
divide_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
{
	struct cell *t;
	int64_t cnt;
	int err;
	
	fv;
	
	if (s != NULL && s->f.axis != NULL)
		return 16;
	
	t = NULL;
	
	if (l->a.etyp == ELEM_CHAR || r->a.etyp == ELEM_CHAR) {
		err = 11;
		goto fail;
	}
	
	if ((err = get_scalar_cell(&t, l, r, ELEM_MAX)))
		goto fail;
		
	if (t->a.etyp == ELEM_INT)
		t->a.etyp = ELEM_FLOAT;
	
	if (t->a.stg == STG_DEVICE) {
		err = 16;
		goto fail;
	}
	
	cnt = array_count(t, 1);
	
	switch (l->a.etyp) {
	case ELEM_INT:{
		switch (r->a.etyp) {
		case ELEM_INT:{
			if (!t->a.rnk) {
				if (!r->a.i) { err = 11; goto fail; }
				t->a.f = (double)l->a.i / (double)r->a.i;
			} else if (!l->a.rnk) {
				double *restrict tv = t->a.host->f;
				int64_t lv = l->a.i;
				int64_t *restrict rv = r->a.host->i;
				
				for (int64_t i = 0; i < cnt; i++) {
					if (!rv[i]) { err = 11; goto fail; }
					tv[i] = (double)lv / (double)rv[i];
				}
			} else if (!r->a.rnk) {
				double *restrict tv = t->a.host->f;
				int64_t *restrict lv = l->a.host->i;
				int64_t rv = r->a.i;
				
				if (!rv) { err = 11; goto fail; }

				for (int64_t i = 0; i < cnt; i++)
					tv[i] = (double)lv[i] / (double)rv;
			} else {
				double *restrict tv = t->a.host->f;
				int64_t *restrict lv = l->a.host->i;
				int64_t *restrict rv = r->a.host->i;
				
				for (int64_t i = 0; i < cnt; i++) {
					if (!rv[i]) { err = 11; goto fail; }
					tv[i] = (double)lv[i] / (double)rv[i];
				}
			}
		}break;
		case ELEM_FLOAT:{
			if (!t->a.rnk) {
				if (!r->a.f) { err = 11; goto fail; } 
				t->a.f = l->a.i / r->a.f;
			} else if (!l->a.rnk) {
				double *restrict tv = t->a.host->f;
				int64_t lv = l->a.i;
				double *restrict rv = r->a.host->f;
				
				for (int64_t i = 0; i < cnt; i++) {
					if (!rv[i]) { err = 11; goto fail; }
					tv[i] = lv / rv[i];
				}
			} else if (!r->a.rnk) {
				double *restrict tv = t->a.host->f;
				int64_t *restrict lv = l->a.host->i;
				double rv = r->a.f;

				if (!rv) { err = 11; goto fail; }
				
				for (int64_t i = 0; i < cnt; i++)
					tv[i] = lv[i] / rv;
			} else {
				double *restrict tv = t->a.host->f;
				int64_t *restrict lv = l->a.host->i;
				double *restrict rv = r->a.host->f;
				
				for (int64_t i = 0; i < cnt; i++) {
					if (!rv[i]) { err = 11; goto fail; }
					tv[i] = lv[i] / rv[i];
				}
			}
		}break;
		case ELEM_CMPX:{
			if (!t->a.rnk) {
				struct apl_cmpx x = {(double)l->a.i, 0};
				if (!r->a.j.real && ! r->a.j.imag) { err = 11; goto fail; }
				t->a.j = div_cmpx(x, r->a.j);
			} else if (!l->a.rnk) {
				struct apl_cmpx *restrict tv = t->a.host->j;
				struct apl_cmpx lv = {(double)l->a.i, 0};
				struct apl_cmpx *restrict rv = r->a.host->j;
				
				for (int64_t i = 0; i < cnt; i++) {
					if (!rv[i].real && !rv[i].imag) { err = 11; goto fail; }
					tv[i] = div_cmpx(lv, rv[i]);
				}
			} else if (!r->a.rnk) {
				struct apl_cmpx *restrict tv = t->a.host->j;
				int64_t *restrict lv = l->a.host->i;
				struct apl_cmpx rv = r->a.j;
				
				if (!rv.real && !rv.imag) { err = 11; goto fail; }
				
				for (int64_t i = 0; i < cnt; i++) {
					struct apl_cmpx x = {(double)lv[i], 0};
					tv[i] = div_cmpx(x, rv);
				}
			} else {
				struct apl_cmpx *restrict tv = t->a.host->j;
				int64_t *restrict lv = l->a.host->i;
				struct apl_cmpx *restrict rv = r->a.host->j;
				
				for (int64_t i = 0; i < cnt; i++) {
					struct apl_cmpx x = {(double)lv[i], 0};
					if (!rv[i].real && ! rv[i].imag) { err = 11; goto fail; }
					tv[i] = div_cmpx(x, rv[i]);
				}
			}
		}break;
		case ELEM_CHAR:err = 99; goto fail;
		case ELEM_CELL:{
			struct cell x = {
				1, CELL_ARRAY, NULL, .a = {
					ELEM_INT, STG_HOST, 0, NULL, .i = 0
				}
			};
			
			if (!t->a.rnk) {
				err = divide_f(NULL, &t->a.p, l, r->a.p, NULL);
				if (err) goto fail;
			} else if (!l->a.rnk) {
				struct cell **restrict tv = t->a.host->p;
				struct cell **restrict rv = r->a.host->p;

				for (int64_t i = 0; i < cnt; i++) {
					err = divide_f(NULL, &tv[i], l, rv[i], NULL);
					if (err) goto fail;
				}
			} else if (!r->a.rnk) {
				struct cell **restrict tv = t->a.host->p;
				int64_t *restrict lv = l->a.host->i;
				struct cell *rv = r->a.p;
				
				for (int64_t i = 0; i < cnt; i++) {
					x.a.i = lv[i];
					err = divide_f(NULL, &tv[i], &x, rv, NULL);
					if (err) goto fail;
				}
			} else {
				struct cell **restrict tv = t->a.host->p;
				int64_t *restrict lv = l->a.host->i;
				struct cell **restrict rv = r->a.host->p;
				
				for (int64_t i = 0; i < cnt; i++) {
					x.a.i = lv[i];
					err = divide_f(NULL, &tv[i], &x, rv[i], NULL);
					if (err) goto fail;
				}
			}
		}break;
		default:err = 99; goto fail;
		}
	}break;
	case ELEM_FLOAT:{
		switch (r->a.etyp) {
		case ELEM_INT:{
			if (!t->a.rnk) {
				if(!r->a.i) { err = 11; goto fail; }
				t->a.f = l->a.f / r->a.i;
			} else if (!l->a.rnk) {
				double *restrict tv = t->a.host->f;
				double lv = l->a.f;
				int64_t *restrict rv = r->a.host->i;
				
				for (int64_t i = 0; i < cnt; i++) {
					if(!rv[i]) { err = 11; goto fail; }
					tv[i] = lv / rv[i];
				}
			} else if (!r->a.rnk) {
				double *restrict tv = t->a.host->f;
				double *restrict lv = l->a.host->f;
				int64_t rv = r->a.i;
				
				if(!rv) { err = 11; goto fail; }
				
				for (int64_t i = 0; i < cnt; i++)
					tv[i] = lv[i] / rv;
			} else {
				double *restrict tv = t->a.host->f;
				double *restrict lv = l->a.host->f;
				int64_t *restrict rv = r->a.host->i;
				
				for (int64_t i = 0; i < cnt; i++) {
					if(!rv[i]) { err = 11; goto fail; }
					tv[i] = lv[i] / rv[i];
				}
			}
		}break;
		case ELEM_FLOAT:{
			if (!t->a.rnk) {
				if(!r->a.f) { err = 11; goto fail; }
				t->a.f = l->a.f / r->a.f;
			} else if (!l->a.rnk) {
				double *restrict tv = t->a.host->f;
				double lv = l->a.f;
				double *restrict rv = r->a.host->f;
				
				for (int64_t i = 0; i < cnt; i++) {
					if(!rv[i]) { err = 11; goto fail; }
					tv[i] = lv / rv[i];
				}
			} else if (!r->a.rnk) {
				double *restrict tv = t->a.host->f;
				double *restrict lv = l->a.host->f;
				double rv = r->a.f;
				
				if(!rv) { err = 11; goto fail; }
				
				for (int64_t i = 0; i < cnt; i++)
					tv[i] = lv[i] / rv;
			} else {
				double *restrict tv = t->a.host->f;
				double *restrict lv = l->a.host->f;
				double *restrict rv = r->a.host->f;
				
				for (int64_t i = 0; i < cnt; i++) {
					if(!rv[i]) { err = 11; goto fail; }
					tv[i] = lv[i] / rv[i];
				}
			}
		}break;
		case ELEM_CMPX:{
			if (!t->a.rnk) {
				struct apl_cmpx x = {l->a.f, 0};
				if(!r->a.j.real && !r->a.j.imag) { err = 11; goto fail; }
				t->a.j = div_cmpx(x, r->a.j);
			} else if (!l->a.rnk) {
				struct apl_cmpx *restrict tv = t->a.host->j;
				struct apl_cmpx lv = {l->a.f, 0};
				struct apl_cmpx *restrict rv = r->a.host->j;
				
				for (int64_t i = 0; i < cnt; i++) {
					if(!rv[i].real && !rv[i].imag) { err = 11; goto fail; }
					tv[i] = div_cmpx(lv, rv[i]);
				}
			} else if (!r->a.rnk) {
				struct apl_cmpx *restrict tv = t->a.host->j;
				double *restrict lv = l->a.host->f;
				struct apl_cmpx rv = r->a.j;
				
				if(!rv.real && !rv.imag) { err = 11; goto fail; }
				
				for (int64_t i = 0; i < cnt; i++) {
					struct apl_cmpx x = {lv[i], 0};
					tv[i] = div_cmpx(x, rv);
				}
			} else {
				struct apl_cmpx *restrict tv = t->a.host->j;
				double *restrict lv = l->a.host->f;
				struct apl_cmpx *restrict rv = r->a.host->j;
				
				for (int64_t i = 0; i < cnt; i++) {
					struct apl_cmpx x = {lv[i], 0};
					if(!rv[i].real && !rv[i].imag) { err = 11; goto fail; }
					tv[i] = div_cmpx(x, rv[i]);
				}
			}
		}break;
		case ELEM_CHAR:err = 99; goto fail;
		case ELEM_CELL:{
			struct cell x = {
				1, CELL_ARRAY, NULL, .a = {
					ELEM_FLOAT, STG_HOST, 0, NULL, .f = 0
				}
			};
			
			if (!t->a.rnk) {
				err = divide_f(NULL, &t->a.p, l, r->a.p, NULL);
				if (err) goto fail;
			} else if (!l->a.rnk) {
				struct cell **restrict tv = t->a.host->p;
				struct cell **restrict rv = r->a.host->p;

				for (int64_t i = 0; i < cnt; i++) {
					err = divide_f(NULL, &tv[i], l, rv[i], NULL);
					if (err) goto fail;
				}
			} else if (!r->a.rnk) {
				struct cell **restrict tv = t->a.host->p;
				double *restrict lv = l->a.host->f;
				struct cell *rv = r->a.p;
				
				for (int64_t i = 0; i < cnt; i++) {
					x.a.f = lv[i];
					err = divide_f(NULL, &tv[i], &x, rv, NULL);
					if (err) goto fail;
				}
			} else {
				struct cell **restrict tv = t->a.host->p;
				double *restrict lv = l->a.host->f;
				struct cell **restrict rv = r->a.host->p;
				
				for (int64_t i = 0; i < cnt; i++) {
					x.a.f = lv[i];
					err = divide_f(NULL, &tv[i], &x, rv[i], NULL);
					if (err) goto fail;
				}
			}
		}break;
		default:err = 99; goto fail;
		}
	}break;
	case ELEM_CMPX:{
		switch (r->a.etyp) {
		case ELEM_INT:{
			if (!t->a.rnk) {
				struct apl_cmpx x = {(double)r->a.i, 0};
				if(!r->a.i) { err = 11; goto fail; }
				t->a.j = div_cmpx(l->a.j, x);
			} else if (!l->a.rnk) {
				struct apl_cmpx *restrict tv = t->a.host->j;
				struct apl_cmpx lv = l->a.j;
				int64_t *restrict rv = r->a.host->i;
				
				for (int64_t i = 0; i < cnt; i++) {
					struct apl_cmpx x = {(double)rv[i], 0};
					if(!rv[i]) { err = 11; goto fail; }
					tv[i] = div_cmpx(lv, x);
				}
			} else if (!r->a.rnk) {
				struct apl_cmpx *restrict tv = t->a.host->j;
				struct apl_cmpx *restrict lv = l->a.host->j;
				struct apl_cmpx rv = {(double)r->a.i, 0};
				
				if(!r->a.i) { err = 11; goto fail; }
				
				for (int64_t i = 0; i < cnt; i++) {
					tv[i] = div_cmpx(lv[i], rv);
				}
			} else {
				struct apl_cmpx *restrict tv = t->a.host->j;
				struct apl_cmpx *restrict lv = l->a.host->j;
				int64_t *restrict rv = r->a.host->i;
				
				for (int64_t i = 0; i < cnt; i++) {
					struct apl_cmpx x = {(double)rv[i], 0};
					if(!rv[i]) { err = 11; goto fail; }
					tv[i] = div_cmpx(lv[i], x);
				}
			}
		}break;
		case ELEM_FLOAT:{
			if (!t->a.rnk) {
				struct apl_cmpx x = {r->a.f, 0};
				if(!r->a.f) { err = 11; goto fail; }
				t->a.j = div_cmpx(l->a.j, x);
			} else if (!l->a.rnk) {
				struct apl_cmpx *restrict tv = t->a.host->j;
				struct apl_cmpx lv = l->a.j;
				double *restrict rv = r->a.host->f;
				
				for (int64_t i = 0; i < cnt; i++) {
					struct apl_cmpx x = {rv[i], 0};
					if(!rv[i]) { err = 11; goto fail; }
					tv[i] = div_cmpx(lv, x);
				}
			} else if (!r->a.rnk) {
				struct apl_cmpx *restrict tv = t->a.host->j;
				struct apl_cmpx *restrict lv = l->a.host->j;
				struct apl_cmpx rv = {r->a.f, 0};
				
				if(!r->a.f) { err = 11; goto fail; }
				
				for (int64_t i = 0; i < cnt; i++) {
					tv[i] = div_cmpx(lv[i], rv);
				}
			} else {
				struct apl_cmpx *restrict tv = t->a.host->j;
				struct apl_cmpx *restrict lv = l->a.host->j;
				double *restrict rv = r->a.host->f;
				
				for (int64_t i = 0; i < cnt; i++) {
					struct apl_cmpx x = {rv[i], 0};
					if(!rv[i]) { err = 11; goto fail; }
					tv[i] = div_cmpx(lv[i], x);
				}
			}
		}break;
		case ELEM_CMPX:{
			if (!t->a.rnk) {
				if(!r->a.j.real && !r->a.j.imag) { err = 11; goto fail; }
				t->a.j = div_cmpx(l->a.j, r->a.j);
			} else if (!l->a.rnk) {
				struct apl_cmpx *restrict tv = t->a.host->j;
				struct apl_cmpx lv = l->a.j;
				struct apl_cmpx *restrict rv = r->a.host->j;
				
				for (int64_t i = 0; i < cnt; i++) {
					if(!rv[i].real && !rv[i].imag) { err = 11; goto fail; }
					tv[i] = div_cmpx(lv, rv[i]);
				}
			} else if (!r->a.rnk) {
				struct apl_cmpx *restrict tv = t->a.host->j;
				struct apl_cmpx *restrict lv = l->a.host->j;
				struct apl_cmpx rv = r->a.j;
				
				if(!rv.real && ! rv.imag) { err = 11; goto fail; }
				
				for (int64_t i = 0; i < cnt; i++) {
					tv[i] = div_cmpx(lv[i], rv);
				}
			} else {
				struct apl_cmpx *restrict tv = t->a.host->j;
				struct apl_cmpx *restrict lv = l->a.host->j;
				struct apl_cmpx *restrict rv = r->a.host->j;
				
				for (int64_t i = 0; i < cnt; i++) {
					if(!rv[i].real && !rv[i].imag) { err = 11; goto fail; }
					tv[i] = div_cmpx(lv[i], rv[i]);
				}
			}
		}break;
		case ELEM_CHAR:err = 99; goto fail;
		case ELEM_CELL:{
			struct cell x = {
				1, CELL_ARRAY, NULL, .a = {
					ELEM_CMPX, STG_HOST, 0, NULL, .j = {0, 0}
				}
			};
			
			if (!t->a.rnk) {
				err = divide_f(NULL, &t->a.p, l, r->a.p, NULL);
				if (err) goto fail;
			} else if (!l->a.rnk) {
				struct cell **restrict tv = t->a.host->p;
				struct cell **restrict rv = r->a.host->p;

				for (int64_t i = 0; i < cnt; i++) {
					err = divide_f(NULL, &tv[i], l, rv[i], NULL);
					if (err) goto fail;
				}
			} else if (!r->a.rnk) {
				struct cell **restrict tv = t->a.host->p;
				struct apl_cmpx *restrict lv = l->a.host->j;
				struct cell *rv = r->a.p;
				
				for (int64_t i = 0; i < cnt; i++) {
					x.a.j = lv[i];
					err = divide_f(NULL, &tv[i], &x, rv, NULL);
					if (err) goto fail;
				}
			} else {
				struct cell **restrict tv = t->a.host->p;
				struct apl_cmpx *restrict lv = l->a.host->j;
				struct cell **restrict rv = r->a.host->p;
				
				for (int64_t i = 0; i < cnt; i++) {
					x.a.j = lv[i];
					err = divide_f(NULL, &tv[i], &x, rv[i], NULL);
					if (err) goto fail;
				}
			}
		}break;
		default:err = 99; goto fail;
		}
	}break;
	case ELEM_CHAR:err = 99; goto fail;
	case ELEM_CELL:{
		switch (r->a.etyp) {
		case ELEM_INT:{
			struct cell x = {
				1, CELL_ARRAY, NULL, .a = {
					ELEM_INT, STG_HOST, 0, NULL, .i = 0
				}
			};
			
			if (!t->a.rnk) {
				err = divide_f(NULL, &t->a.p, l->a.p, r, NULL);
				if (err) goto fail;
			} else if (!l->a.rnk) {
				struct cell **restrict tv = t->a.host->p;
				int64_t *restrict rv = r->a.host->i;

				for (int64_t i = 0; i < cnt; i++) {
					x.a.i = rv[i];
					err = divide_f(NULL, &tv[i], l->a.p, &x, NULL);
					if (err) goto fail;
				}
			} else if (!r->a.rnk) {
				struct cell **restrict tv = t->a.host->p;
				struct cell **restrict lv = l->a.host->p;
				x.a.i = r->a.i;
				
				for (int64_t i = 0; i < cnt; i++) {
					err = divide_f(NULL, &tv[i], lv[i], &x, NULL);
					if (err) goto fail;
				}
			} else {
				struct cell **restrict tv = t->a.host->p;
				struct cell **restrict lv = l->a.host->p;
				int64_t *restrict rv = r->a.host->i;
				
				for (int64_t i = 0; i < cnt; i++) {
					x.a.i = rv[i];
					err = divide_f(NULL, &tv[i], lv[i], &x, NULL);
					if (err) goto fail;
				}
			}
		}break;
		case ELEM_FLOAT:{
			struct cell x = {
				1, CELL_ARRAY, NULL, .a = {
					ELEM_FLOAT, STG_HOST, 0, NULL, .f = 0
				}
			};
			
			if (!t->a.rnk) {
				err = divide_f(NULL, &t->a.p, l->a.p, r, NULL);
				if (err) goto fail;
			} else if (!l->a.rnk) {
				struct cell **restrict tv = t->a.host->p;
				double *restrict rv = r->a.host->f;

				for (int64_t i = 0; i < cnt; i++) {
					x.a.f = rv[i];
					err = divide_f(NULL, &tv[i], l->a.p, &x, NULL);
					if (err) goto fail;
				}
			} else if (!r->a.rnk) {
				struct cell **restrict tv = t->a.host->p;
				struct cell **restrict lv = l->a.host->p;
				x.a.f = r->a.f;
				
				for (int64_t i = 0; i < cnt; i++) {
					err = divide_f(NULL, &tv[i], lv[i], &x, NULL);
					if (err) goto fail;
				}
			} else {
				struct cell **restrict tv = t->a.host->p;
				struct cell **restrict lv = l->a.host->p;
				double *restrict rv = r->a.host->f;
				
				for (int64_t i = 0; i < cnt; i++) {
					x.a.f = rv[i];
					err = divide_f(NULL, &tv[i], lv[i], &x, NULL);
					if (err) goto fail;
				}
			}
		}break;
		case ELEM_CMPX:{
			struct cell x = {
				1, CELL_ARRAY, NULL, .a = {
					ELEM_CMPX, STG_HOST, 0, NULL, .j = {0, 0}
				}
			};
			
			if (!t->a.rnk) {
				err = divide_f(NULL, &t->a.p, l->a.p, r, NULL);
				if (err) goto fail;
			} else if (!l->a.rnk) {
				struct cell **restrict tv = t->a.host->p;
				struct apl_cmpx *restrict rv = r->a.host->j;

				for (int64_t i = 0; i < cnt; i++) {
					x.a.j = rv[i];
					err = divide_f(NULL, &tv[i], l->a.p, &x, NULL);
					if (err) goto fail;
				}
			} else if (!r->a.rnk) {
				struct cell **restrict tv = t->a.host->p;
				struct cell **restrict lv = l->a.host->p;
				x.a.j = r->a.j;
				
				for (int64_t i = 0; i < cnt; i++) {
					err = divide_f(NULL, &tv[i], lv[i], &x, NULL);
					if (err) goto fail;
				}
			} else {
				struct cell **restrict tv = t->a.host->p;
				struct cell **restrict lv = l->a.host->p;
				struct apl_cmpx *restrict rv = r->a.host->j;
				
				for (int64_t i = 0; i < cnt; i++) {
					x.a.j = rv[i];
					err = divide_f(NULL, &tv[i], lv[i], &x, NULL);
					if (err) goto fail;
				}
			}
		}break;
		case ELEM_CHAR:err = 99; goto fail;
		case ELEM_CELL:{
			if (!t->a.rnk) {
				err = divide_f(NULL, &t->a.p, l->a.p, r->a.p, NULL);
				if (err) goto fail;
			} else if (!l->a.rnk) {
				struct cell **restrict tv = t->a.host->p;
				struct cell **restrict rv = r->a.host->p;

				for (int64_t i = 0; i < cnt; i++) {
					err = divide_f(NULL, &tv[i], l->a.p, rv[i], NULL);
					if (err) goto fail;
				}
			} else if (!r->a.rnk) {
				struct cell **restrict tv = t->a.host->p;
				struct cell **restrict lv = l->a.host->p;
				
				for (int64_t i = 0; i < cnt; i++) {
					err = divide_f(NULL, &tv[i], lv[i], r->a.p, NULL);
					if (err) goto fail;
				}
			} else {
				struct cell **restrict tv = t->a.host->p;
				struct cell **restrict lv = l->a.host->p;
				struct cell **restrict rv = r->a.host->p;
				
				for (int64_t i = 0; i < cnt; i++) {
					err = divide_f(NULL, &tv[i], lv[i], rv[i], NULL);
					if (err) goto fail;
				}
			}
		}break;
		default:err = 99; goto fail;
		}
	}break;
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
reciprocal_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
{
	l; fv;
	
	struct cell one = {
		1, CELL_ARRAY, NULL, .a = {
			ELEM_INT, STG_HOST, 0, NULL, .i = 1
		}
	};
	
	return divide_f(s, z, &one, r, NULL);
}

int (*div_fn[])(struct cell *, struct cell **, struct cell *, struct cell *, struct cell ***) = {
	reciprocal_f, divide_f
};
struct cell div_c = {
	1, CELL_FUNC, NULL, .f = {
		div_fn, NULL, NULL, NULL
	}
};
EXPORT struct cell *cd_div = &div_c;

EXPORT int
index_gen_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
{
	struct cell *t;
	int64_t cnt, rng, *restrict buf;
	int err;
	
	s; l; fv;
	
	if (r->a.rnk > 1) return 4;
	
	if (r->a.etyp != ELEM_INT) return 11;
	
	cnt = array_count(r, 0);
	
	if (cnt > 1) return 16;
	
	if (!(t = get_cell())) return 1;
	
	t->ctyp = CELL_ARRAY;
	
	if (!cnt) {
		t->a.etyp = ELEM_CELL;
		t->a.stg = STG_HOST;
		t->a.rnk = 0;
		t->a.shp = NULL;
		t->a.p = ref_cell(&mt_num_vec);
		
		goto done;
	}
	
	rng = r->a.rnk ? r->a.host->i[0] : r->a.i;
	
	t->a.etyp = ELEM_INT;
	t->a.stg = STG_HOST;
	t->a.rnk = 1;
	t->a.shp = get_host_buffer(buffer_size(ELEM_INT, 1));
	t->a.host = get_host_buffer(buffer_size(ELEM_INT, rng));
	
	if ((err = !t->a.shp)) goto fail;
	if ((err = !t->a.host)) goto fail;
	
	t->a.shp->i[0] = rng;
	
	buf = t->a.host->i;
	
	for (int64_t i = 0; i < rng; i++)
		buf[i] = i;
	
done:
	*z = t;
	
	return 0;
	
fail:
	free_cell(t);
	
	return err;
}

static int
reduce_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
{
	struct cell *t, **restrict pv, *fn, *x, *y;
	int64_t axis, ra, rb, rc;
	int err;
	
	l;
	
	x = y = t = NULL;
	
	if (!r->a.rnk) return 16;
	
	if (s->f.axis->a.rnk) return 5;
	if (s->f.axis->a.etyp != ELEM_INT) return 11;
	
	axis = s->f.axis->a.i;
	
	if (axis >= r->a.rnk) return 4;
	
	if (!(t = get_cell()))
		return 1;
	
	t->ctyp = CELL_ARRAY;
	t->a.stg = r->a.stg;
	t->a.rnk = r->a.rnk - 1;
	t->a.shp = NULL;
	t->a.host = NULL;
	
	if (t->a.rnk) {
		t->a.shp = get_host_buffer(buffer_size(ELEM_INT, t->a.rnk));
		
		if (!t->a.shp) { err = 1; goto fail; }
		
		for (int64_t i = 0, k = 0; i < t->a.rnk; i++)
			if (i != axis)
				t->a.shp->i[k++] = r->a.shp->i[i];
	}
	
	if (t->a.stg != STG_HOST) { err = 16; goto fail; }
	
	if (1 == r->a.shp->i[axis]) {
		t->a.host = r->a.host;
		t->a.host->refc++;
		
		goto done;
	}
	
	if (!t->a.rnk && s->f.aa == add) {
		int64_t cnt;
		
		cnt = array_count(r, 0);
		
		switch (r->a.etyp) {
		case ELEM_INT:{
			int64_t tv, *restrict rv;
			
			rv = r->a.host->i;
			tv = 0;
			t->a.etyp = ELEM_INT;
			
			for (int64_t i = 0; i < cnt; i++)
				tv += rv[i];
			
			t->a.i = tv;
		}break;
		case ELEM_FLOAT:{
			double tv, *restrict rv;
			
			rv = r->a.host->f;
			tv = 0;
			t->a.etyp = ELEM_FLOAT;
			
			for (int64_t i = 0; i < cnt; i++)
				tv += rv[i];
			
			t->a.f = tv;
		}break;
		case ELEM_CMPX: err = 16; goto fail;
		case ELEM_CHAR: err = 11; goto fail;
		case ELEM_CELL: err = 16; goto fail;
		default: err = 99; goto fail;
		}
		
		goto done;
	}
	
	t->a.etyp = ELEM_CELL;
	
	ra = rc = 1;
	rb = r->a.shp->i[axis];
	
	for (int64_t i = 0; i < axis; i++) 
		ra *= r->a.shp->i[i];
	for (int64_t i = axis + 1; i < r->a.rnk; i++)
		rc *= r->a.shp->i[i];
	
	if (!t->a.rnk) {
		pv = &t->a.p;
	} else {
		t->a.host = get_host_buffer(buffer_size(ELEM_CELL, ra * rc));
		
		if (!t->a.host) { err = 1; goto fail; }
		
		pv = t->a.host->p;
		
		memset(pv, 0, sizeof(*pv) * ra * rc);
	}
	
	fn = s->f.aa;
	
	switch (r->a.etyp) {
	case ELEM_INT:{
		int64_t *restrict rv = r->a.host->i;
		
		for (int64_t i = 0; i < ra; i++) {
			for (int64_t j = 0; j < rc; j++) {
				int64_t off = i * rb * rc + j;
				
				if (!(y = get_cell())) { err = 1; goto fail; }
				
				y->ctyp = CELL_ARRAY;
				y->a.etyp = r->a.etyp;
				y->a.stg = STG_HOST;
				y->a.rnk = 0;
				y->a.shp = NULL;
				y->a.i = rv[off + (rb - 1) * rc];
				
				for (int64_t k = rb - 2; k >= 0; k--) {
					struct cell *tmp = y;
					
					if (!(x = get_cell())) { err = 1; goto fail; }
					
					x->ctyp = CELL_ARRAY;
					x->a.etyp = r->a.etyp;
					x->a.stg = STG_HOST;
					x->a.rnk = 0;
					x->a.shp = NULL;
					x->a.i = rv[off + k * rc];
					
					if ((err = fn->f.fn[1](fn, &y, x, y, fv)))
						goto fail;
						
					free_cell(tmp);
					free_cell(x);
				}
				
				pv[off] = y;
			}
		}
	}break;
	case ELEM_FLOAT:{
		err = 16; goto fail;
	}break;
	case ELEM_CMPX:{
		err = 16; goto fail;
	}break;
	case ELEM_CHAR:{
		err = 16; goto fail;
	}break;
	case ELEM_CELL:{
		err = 16; goto fail;
	}break;
	default: err = 99; goto fail;
	}
	
	if ((err = squeeze(t))) goto fail;

done:
	*z = t;
	
	return 0;
	
fail:
	free_cell(t);
	free_cell(y);
	free_cell(x);
	
	return err;
	
}

static int
nwreduce_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
{
	struct cell *t;
	int64_t axis, win, cnt, ts[3], rs[3];
	int err, rev;
	
	fv;
	
	if (s->f.axis->a.rnk) return 5;		
	if (s->f.axis->a.etyp != ELEM_INT) return 11;
	
	axis = s->f.axis->a.i;
	rev = 0;
	
	if (axis < 0) {
		axis = -1 * axis;
		rev = 1;
	}
	
	if (l->a.rnk) return 4;	
	if (l->a.etyp != ELEM_INT) return 11;
	
	win = l->a.i;
	
	if (axis >= r->a.rnk) return 4;
	if (win > 1 + r->a.shp->i[axis]) return 5;
	
	if (rev) return 16;
	
	if (win == 1) {
		t = ref_cell(r);
		goto done;
	}
	
	if (!(t = get_cell())) return 1;
	
	t->ctyp = CELL_ARRAY;
	t->a.stg = r->a.stg;
	t->a.rnk = r->a.rnk;
	t->a.shp = NULL;
	t->a.host = NULL;
	
	t->a.shp = get_host_buffer(buffer_size(ELEM_INT, t->a.rnk));
	
	if (!t->a.shp) { err = 1; goto fail; }
	
	for (int64_t i = 0; i < t->a.rnk; i++)
		t->a.shp->i[i] = r->a.shp->i[i];
	
	t->a.shp->i[axis] = (1 + r->a.shp->i[axis]) - win;
	
	cnt = array_count(t, 0);
	
	if (t->a.stg != STG_HOST) { err = 16; goto fail; }
	
	ts[0] = ts[1] = ts[2] = rs[0] = rs[1] = rs[2] = 1;
	
	for (int64_t i = 0; i < t->a.rnk; i++) {
		if (i < axis) {
			ts[0] *= t->a.shp->i[i];
			rs[0] *= r->a.shp->i[i];
		} else if (i == axis) {
			ts[1] *= t->a.shp->i[i];
			rs[1] *= r->a.shp->i[i];
		} else {
			ts[2] *= t->a.shp->i[i];
			rs[2] *= r->a.shp->i[i];
		}
	}
		
	if (s->f.aa == add) {
		switch (r->a.etyp) {
		case ELEM_INT:{
			int64_t *restrict tv, *restrict rv;
			
			t->a.etyp = ELEM_INT;
			t->a.host = get_host_buffer(buffer_size(ELEM_INT, cnt ? cnt : 1));
			
			if (!t->a.host) { err = 1; goto fail; }
			
			tv = t->a.host->i;
			rv = r->a.host->i;
			
			if (!cnt) {
				tv[0] = 0;
				goto done;
			}
			
			for (int64_t i = 0; i < ts[0]; i++) {
				for (int64_t j = 0; j < ts[2]; j++) {
					for (int64_t k = 0; k < ts[1]; k++) {
						int64_t ti = i * ts[1] * ts[2] + j + k * ts[2];
						int64_t ri = i * rs[1] * rs[2] + j + k * rs[2];
						
						tv[ti] = 0;
						
						for (int64_t w = 0; w < win; w++) {
							tv[ti] += rv[ri + w * rs[2]];
						}
					}
				}
			}
		}break;
		case ELEM_FLOAT: err = 16; goto fail;
		case ELEM_CMPX: err = 16; goto fail;
		case ELEM_CHAR: err = 11; goto fail;
		case ELEM_CELL: err = 16; goto fail;
		default: err = 99; goto fail;
		}
		
		goto done;
	}
	
	err = 16;
	goto fail;

done:
	*z = t;
	
	return 0;
	
fail:
	free_cell(t);
	
	return err;
}

static int 
redfirst_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
{
	if (!s || l)
		return 99;
	
	if (s->f.axis)
		return reduce_f(s, z, NULL, r, fv);
	
	s->f.axis = ref_cell(&scl_zero);
	
	return reduce_f(s, z, NULL, r, fv);
}

static int
nwredfirst_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
{
	if (!s || !l)
		return 99;
	
	if (s->f.axis)
		return nwreduce_f(s, z, l, r, fv);
	
	s->f.axis = ref_cell(&scl_zero);
	
	return nwreduce_f(s, z, l, r, fv);
}

int (*rdf_fn[])(struct cell *, struct cell **, struct cell *, struct cell *, struct cell ***) = {
	syserr_f, syserr_f, redfirst_f, nwredfirst_f
};
struct cell rdf_c = {
	1, CELL_FUNC, NULL, .f = {
		rdf_fn, NULL, NULL, NULL
	}
};
EXPORT struct cell *rdf = &rdf_c;

static int
innerprod_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
{
	struct cell *t;
	int64_t la, lb, ra, rb, cnt;
	int err;
	
	fv;
	
	if (l->a.rnk && r->a.rnk && l->a.shp->i[l->a.rnk - 1] != r->a.shp->i[0])
		return 5;
		
	lb = l->a.rnk ? l->a.shp->i[l->a.rnk - 1] : 1;
	la = array_count(l, 0) / lb;
	ra = r->a.rnk ? r->a.shp->i[0] : 1;
	rb = array_count(r, 0) / ra;
	
	if (l->a.stg == STG_DEVICE || r->a.stg == STG_DEVICE)
		return 11;
	
	if (!(t = get_cell()))
		return 1;
		
	t->ctyp = CELL_ARRAY;
	t->a.stg = STG_HOST;
	t->a.shp = NULL;
	t->a.host = NULL;
	t->a.rnk = l->a.rnk ? l->a.rnk - 1 : 0;
	t->a.rnk += r->a.rnk ? r->a.rnk - 1 : 0;
	
	if (t->a.rnk) {
		int64_t *restrict ts, *restrict ls, *restrict rs;
		
		t->a.shp = get_host_buffer(buffer_size(ELEM_INT, t->a.rnk));
		
		if (!t->a.shp) { err = 1; goto fail; }
		
		ts = t->a.shp->i;
		ls = l->a.shp->i;
		rs = r->a.shp->i;
		
		for (int64_t i = 0; i < l->a.rnk - 1; i++)
			*ts++ = ls[i];
		
		for (int64_t i = 1; i < r->a.rnk; i++)
			*ts++ = rs[i];
	}
	
	cnt = la * ra;
	
	if (s->f.aa == add && s->f.ww == mul) {
		if (r->a.etyp == ELEM_CHAR || l->a.etyp == ELEM_CHAR) {
			err = 11;
			goto fail;
		}
		
		switch (l->a.etyp) {
		case ELEM_INT:{
			switch (r->a.etyp) {
			case ELEM_INT:{
				int64_t *restrict tv, *restrict rv, *restrict lv;
				
				t->a.etyp = ELEM_INT;
				
				if (!l->a.rnk && !r->a.rnk) {
					t->a.i = l->a.i * r->a.i;
					goto done;
				}
				
				lv = l->a.host->i;
				rv = r->a.host->i;

				if (!t->a.rnk) {
					t->a.i = 0;
					
					if (!l->a.rnk) {
						for (int64_t i = 0; i < rb; i++)
							t->a.i += l->a.i * rv[i];
					} else if (!r->a.rnk) {
						for (int64_t i = 0; i < lb; i++)
							t->a.i += lv[i] * r->a.i;
					} else {
						for (int64_t i = 0; i < lb; i++)
							t->a.i += lv[i] * rv[i];
					}
					
					goto done;
				}
				
				t->a.host = get_host_buffer(buffer_size(t->a.etyp, cnt ? cnt : 1));
				
				if (!t->a.host) { err = 1; goto fail; }
				
				tv = t->a.host->i;
				
				if (!cnt) {
					tv[0] = 0;
					goto done;
				}
				
				if (!l->a.rnk) {
					err = 16;
					goto fail;
				}
				
				if (!r->a.rnk) {
					err = 16;
					goto fail;
				}
				
				for (int64_t i = 0; i < la; i++) { 
					for (int64_t j = 0; j < rb; j++) {
						int64_t a = 0;
						for (int64_t k = 0; k < lb; k++)
							a += lv[i * lb + k] * rv[k * rb + j];
						*tv++ = a;
					}
				}
			}break;
			case ELEM_FLOAT: err = 16; goto fail;
			case ELEM_CMPX: err = 16; goto fail;
			case ELEM_CELL: err = 16; goto fail;
			default: err = 99; goto fail;
			}
		}break;
		case ELEM_FLOAT: err = 16; goto fail;
		case ELEM_CMPX: err = 16; goto fail;
		case ELEM_CELL: err = 16; goto fail;
		default: err = 99; goto fail;
		}
		
		goto done;
	}
	
	err = 16;
	goto fail;
	
done:
	*z = t;
	
	return 0;
	
fail:
	free_cell(t);
	
	return err;
}

int (*dot_fn[])(struct cell *, struct cell **, struct cell *, struct cell *, struct cell ***) = {
	syntaxerr_f, syntaxerr_f, syntaxerr_f, syntaxerr_f, syntaxerr_f, syntaxerr_f, 
	syntaxerr_f, innerprod_f
};
struct cell dot_c = {
	1, CELL_FUNC, NULL, .f = {
		dot_fn, NULL, NULL, NULL
	}
};
EXPORT struct cell *dot = &dot_c;

EXPORT int
exponent_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
{
	struct cell *t;
	int64_t cnt;
	int err;
	
	s; l; fv;
	
	t = NULL;
	
	if (r->a.etyp == ELEM_CHAR) { err = 11; goto fail; }
	
	cnt = array_count(r, 0);
	
	if (!cnt) {
		t = ref_cell(r);
		goto done;
	}
	
	if (r->a.stg == STG_DEVICE) { err = 16; goto fail; }
	
	if (!(t = get_cell())) { err = 1; goto fail; }
	
	t->ctyp = CELL_ARRAY;
	t->a = r->a;
	
	if (t->a.etyp == ELEM_INT) t->a.etyp = ELEM_FLOAT;
	if (t->a.rnk) {
		t->a.shp->refc++;
		t->a.host = get_host_buffer(buffer_size(t->a.etyp, cnt ? cnt : 1));
		
		if (!t->a.host) { err = 1; goto fail; }
	}
	
	switch (r->a.etyp) {
	case ELEM_INT:{
		if (!t->a.rnk) {
			t->a.f = exp((double)r->a.i);
		} else {
			double *restrict tv = t->a.host->f;
			int64_t *restrict rv = r->a.host->i;
			
			for (int64_t i = 0; i < cnt; i++)
				tv[i] = exp((double)rv[i]);
		}
	}break;
	case ELEM_FLOAT:{
		if (!t->a.rnk) {
			t->a.f = exp(r->a.f);
		} else {
			double *restrict tv = t->a.host->f;
			double *restrict rv = r->a.host->f;
			
			for (int64_t i = 0; i < cnt; i++)
				tv[i] = exp(rv[i]);
		}
	}break;
	case ELEM_CMPX: err = 16; goto fail;
	case ELEM_CELL: err = 16; goto fail;
	default: err = 99; goto fail;
	}
	
	
done:
	*z = t;
	
	return 0;
	
fail:
	free_cell(t);
	
	return err;
}

EXPORT int
power_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
{
	s; z; l; r; fv;
	
	return 16;
	
}

int (*exp_fn[])(struct cell *, struct cell **, struct cell *, struct cell *, struct cell ***) = {
	exponent_f, power_f
};
struct cell exp_c = {
	1, CELL_FUNC, NULL, .f = {
		exp_fn, NULL, NULL, NULL
	}
};
EXPORT struct cell *cd_exp = &exp_c;

static int
powofn_m(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
{
	s; z; l; r; fv;
	
	return 16;
}

static int
powofn_d(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
{
	s; z; l; r; fv;
	
	return 16;
}

static int
powoarr_m(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
{
	struct cell *t, *tmp, *fn;
	int64_t cnt;
	int err;
	
	if (s->f.ww->a.etyp != ELEM_INT) return 11;
	if (s->f.ww->a.rnk) return 4;
	if (s->f.ww->a.i < 0) return 16;
	
	cnt = s->f.ww->a.i;
	fn = s->f.aa;
	t = ref_cell(r);
	
	for (int64_t i = 0; i < cnt; i++) {
		tmp = t;
		if ((err = fn->f.fn[0](fn, &t, l, t, fv)))
			goto fail;
		free_cell(tmp);
	}
	
	*z = t;
	
	return 0;
		
fail:
	free_cell(tmp);
	
	return err;
}

static int
powoarr_d(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
{
	struct cell *t, *tmp, *fn;
	int64_t cnt;
	int err;
	
	if (s->f.ww->a.etyp != ELEM_INT) return 11;
	if (s->f.ww->a.rnk) return 4;
	if (s->f.ww->a.i < 0) return 16;
	
	cnt = s->f.ww->a.i;
	fn = s->f.aa;
	t = ref_cell(r);
	
	for (int64_t i = 0; i < cnt; i++) {
		tmp = t;
		if ((err = fn->f.fn[1](fn, &t, l, t, fv)))
			goto fail;
		free_cell(tmp);
	}
	
	*z = t;
	
	return 0;
		
fail:
	free_cell(tmp);
	
	return err;
}

int (*powo_fn[])(struct cell *, struct cell **, struct cell *, struct cell *, struct cell ***) = {
	syntaxerr_f, syntaxerr_f, powoarr_m, powoarr_d, syntaxerr_f, syntaxerr_f, 
	powofn_m, powofn_d
};
struct cell powo_c = {
	1, CELL_FUNC, NULL, .f = {
		powo_fn, NULL, NULL, NULL
	}
};
EXPORT struct cell *powo = &powo_c;

static int
coma_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
{
	l; r; fv;
	
	*z = ref_cell(s->f.aa);
	
	return 0;
}

static int
comf_m(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
{
	l;
	
	return s->f.aa->f.fn[1](s->f.aa, z, r, r, fv);
}

static int
comf_d(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
{
	return s->f.aa->f.fn[1](s->f.aa, z, r, l, fv);
}

int (*com_fn[])(struct cell *, struct cell **, struct cell *, struct cell *, struct cell ***) = {
	coma_f, coma_f, comf_m, comf_d
};
struct cell com_c = {
	1, CELL_FUNC, NULL, .f = {
		com_fn, NULL, NULL, NULL
	}
};
EXPORT struct cell *com = &com_c;

static int
oup_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
{
	struct cell *t, *fn, **restrict pv;
	int64_t cnt, lc, rc;
	int err;
	
	t = NULL;
	pv = NULL;
	
	if (l->a.stg == STG_DEVICE || r->a.stg == STG_DEVICE) { err = 16; goto fail; }
	
	if (!(t = get_cell())) { err = 1; goto fail; }
	
	t->ctyp = CELL_ARRAY;
	t->a.etyp = ELEM_CELL;
	t->a.stg = STG_HOST;
	t->a.rnk = l->a.rnk + r->a.rnk;
	t->a.shp = NULL;
	t->a.host = NULL;
	
	if (t->a.rnk) {
		int64_t *restrict ts;
		
		t->a.shp = get_host_buffer(buffer_size(ELEM_INT, t->a.rnk));
		
		if (!t->a.shp) { err = 1; goto fail; }
		
		ts = t->a.shp->i;
		
		for (int64_t i = 0; i < l->a.rnk; i++)
			*ts++ = l->a.shp->i[i];
		for (int64_t i = 0; i < r->a.rnk; i++)
			*ts++ = r->a.shp->i[i];
	}
	
	cnt = array_count(t, 0);
	
	if (!cnt) { err = 16; goto fail; }
	
	if (t->a.rnk) {
		t->a.host = get_host_buffer(buffer_size(ELEM_CELL, cnt));
		
		if (!t->a.host) { err = 1; goto fail; }

		pv = t->a.host->p;
		
		memset(pv, 0, sizeof(struct cell *) * cnt);
	}
	
	fn = s->f.aa;
	lc = array_count(l, 0);
	rc = array_count(r, 0);
	
	switch (l->a.etyp) {
	case ELEM_INT:{
		switch (r->a.etyp) {
		case ELEM_INT:{
			if (!t->a.rnk) {
				if ((err = fn->f.fn[1](fn, &t->a.p, l, r, fv)))
					goto fail;
			} else if (!l->a.rnk) {
				for (int64_t i = 0; i < cnt; i++) {
					struct cell *x = get_cell();
					
					if (!x) { err = 1; goto fail; }
					
					x->ctyp = CELL_ARRAY;
					x->a.etyp = r->a.etyp;
					x->a.stg = STG_HOST;
					x->a.rnk = 0;
					x->a.shp = NULL;
					x->a.i = r->a.host->i[i];
					
					err = fn->f.fn[1](fn, &pv[i], l, x, fv);
					
					if (err) goto fail;
					
					free_cell(x);
				}
			} else if (!r->a.rnk) {
				for (int64_t i = 0; i < cnt; i++) {
					struct cell *x = get_cell();
					
					if (!x) { err = 1; goto fail; }
					
					x->ctyp = CELL_ARRAY;
					x->a.etyp = l->a.etyp;
					x->a.stg = STG_HOST;
					x->a.rnk = 0;
					x->a.shp = NULL;
					x->a.i = l->a.host->i[i];
					
					err = fn->f.fn[1](fn, &pv[i], x, r, fv);
					
					if (err) goto fail;
					
					free_cell(x);
				}
			} else {
				for (int64_t i = 0; i < lc; i++) {
					for (int64_t j = 0; j < rc; j++) {
						struct cell *x = get_cell();
						struct cell *y = get_cell();
						
						if (!x) { err = 1; goto fail; }
						if (!y) { err = 1; goto fail; }
						
						x->ctyp = y->ctyp = CELL_ARRAY;
						x->a.etyp = l->a.etyp;
						y->a.etyp = r->a.etyp;
						x->a.stg = y->a.stg = STG_HOST;
						x->a.rnk = y->a.rnk = 0;
						x->a.shp = y->a.shp = NULL;
						x->a.i = l->a.host->i[i];
						y->a.i = r->a.host->i[j];
						
						err = fn->f.fn[1](fn, pv++, x, y, fv);
						
						if (err) goto fail;
						
						free_cell(x);
						free_cell(y);
					}
				}
			}
		}break;
		case ELEM_FLOAT: err = 16; goto fail;
		case ELEM_CMPX: err = 16; goto fail;
		case ELEM_CHAR: err = 16; goto fail;
		case ELEM_CELL: err = 16; goto fail;
		default: err = 99; goto fail;
		}
	}break;
	case ELEM_FLOAT: err = 16; goto fail;
	case ELEM_CMPX: err = 16; goto fail;
	case ELEM_CHAR: err = 16; goto fail;
	case ELEM_CELL: err = 16; goto fail;
	default: err = 99; goto fail;
	}
	
	if ((err = squeeze(t))) goto fail;
	
	*z = t;
	
	return 0;
	
fail:
	free_cell(t);
	
	return err;
}

int (*oup_fn[])(struct cell *, struct cell **, struct cell *, struct cell *, struct cell ***) = {
	syntaxerr_f, syntaxerr_f, syntaxerr_f, oup_f
};
struct cell oup_c = {
	1, CELL_FUNC, NULL, .f = {
		oup_fn, NULL, NULL, NULL
	}
};
EXPORT struct cell *oup = &oup_c;

