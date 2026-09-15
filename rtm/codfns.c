#include <complex.h>
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
	ELEM_BOOL, ELEM_INT, ELEM_FLOAT, ELEM_CMPX, ELEM_CHAR, ELEM_CELL, ELEM_MAX
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
		char *b;
		int64_t *i;
		double *f;
		struct apl_cmpx *j;
		uint32_t *c;
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
		char b;
		int64_t i;
		double f;
		struct apl_cmpx j;
		uint32_t c;
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
	switch (t) {
	case ELEM_BOOL: return sizeof(char) * c;
	case ELEM_INT: return sizeof(int64_t) * c;
	case ELEM_FLOAT: return sizeof(double) * c;
	case ELEM_CMPX: return sizeof(struct apl_cmpx) * c;
	case ELEM_CHAR: return sizeof(uint32_t) * c;
	case ELEM_CELL: return sizeof(struct cell *) * c;
	default: return sizeof(int64_t) * c;
	}
}

enum elem_type elem_type_merge_map[ELEM_MAX][ELEM_MAX] = {
	ELEM_BOOL, ELEM_INT, ELEM_FLOAT, ELEM_CMPX, ELEM_CELL, ELEM_CELL,
	ELEM_INT, ELEM_INT, ELEM_FLOAT, ELEM_CMPX, ELEM_CELL, ELEM_CELL,
	ELEM_FLOAT, ELEM_FLOAT, ELEM_FLOAT, ELEM_CMPX, ELEM_CELL, ELEM_CELL,
	ELEM_CMPX, ELEM_CMPX, ELEM_CMPX, ELEM_CMPX, ELEM_CELL, ELEM_CELL,
	ELEM_CELL, ELEM_CELL, ELEM_CELL, ELEM_CELL, ELEM_CHAR, ELEM_CELL,
	ELEM_CELL, ELEM_CELL, ELEM_CELL, ELEM_CELL, ELEM_CELL, ELEM_CELL
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
		case ELEM_BOOL:
			c->a.etyp = ELEM_BOOL;
			c->a.b = x->a.b;
			break;
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
	case ELEM_BOOL:
		for (int64_t i = 0; i < cnt; i++) {
			struct cell *t = p[i];
			
			v->b[i] = t->a.b;
			free_cell(t);
		}
		break;
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
print_char(uint32_t point)
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
		case ELEM_BOOL:
			printf("%d", r->a.b);
			return 0;
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
	case ELEM_BOOL:
		for (int64_t i = 0; i < cnt; i++) {
			if (i > 0) printf(" ");
			printf("%d", r->a.host->b[i]);
		}
		break;
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
				case ELEM_BOOL:
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

char zero_list[] = {0};
struct host_buffer zero_buf = {2, 0, NULL, .b = zero_list};
struct cell mt_num_vec = {
	1, CELL_ARRAY, NULL, .a = {
		ELEM_BOOL, STG_HOST, 1, &zero_buf, .host = &zero_buf
	}
};
 
struct cell scl_zero = {
	1, CELL_ARRAY, NULL, .a = {ELEM_BOOL, STG_HOST, 0, NULL, .b = 0}
};

struct cell scl_one = {
	1, CELL_ARRAY, NULL, .a = {ELEM_BOOL, STG_HOST, 0, NULL, .b = 1}
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
		case ELEM_BOOL: t->a.host->b[0] = r->a.b; break;
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
		case ELEM_BOOL: t->a.b = r->a.host->b[0]; break;
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
		case ELEM_BOOL:
			l->a.i = l->a.b;
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
			case ELEM_BOOL: t->a.b = r->a.host->b[l->a.i]; break;
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
		
		#define SET_HOST_REAL(zt, zf, rt, rf) {				\
			zt * restrict zv = (*z)->a.host->zf;			\
										\
			if (r->a.rnk) {						\
				rt * restrict rv = r->a.host->rf;		\
										\
				for (int64_t i = 0; i < cnt; i++)		\
					zv[*zi + iv[i]] = (zt)rv[(*ri)++];	\
			} else {						\
				for (int64_t i = 0; i < cnt; i++)		\
					zv[*zi + iv[i]] = (zt)r->a.rf;		\
			}							\
		}break;
		
		#define SET_HOST_CMPX(rt, rf) {					\
			if (r->a.rnk) {						\
				rt * restrict rv = r->a.host->rf;		\
										\
				for (int64_t i = 0; i < cnt; i++) {		\
					int64_t j = *zi + iv[i];		\
										\
					zv[j].real = (double)rv[(*ri)++];	\
					zv[j].imag = 0;				\
				}						\
			} else {						\
				for (int64_t i = 0; i < cnt; i++) {		\
					int64_t j = *zi + iv[i];		\
										\
					zv[j].real = (double)r->a.rf;		\
					zv[j].imag = 0;				\
				}						\
			}							\
		}break;
		
		#define SET_HOST_CELL(rt, rf) {				\
			if (r->a.rnk) {					\
				rt * restrict rv = r->a.host->rf;	\
									\
				for (int64_t i = 0; i < cnt; i++) {	\
					struct cell *c = get_cell();	\
					int64_t j = *zi + iv[i];	\
									\
					if (!c) return 1;		\
									\
					c->ctyp = CELL_ARRAY;		\
					c->a.etyp = r->a.etyp;		\
					c->a.stg = STG_HOST;		\
					c->a.rnk = 0;			\
					c->a.shp = NULL;		\
					c->a.rf = rv[(*ri)++];		\
									\
					free_cell(zv[j]);		\
					zv[j] = c;			\
				}					\
			} else {					\
				for (int64_t i = 0; i < cnt; i++) {	\
					struct cell *c = get_cell();	\
					int64_t j = *zi + iv[i];	\
									\
					if (!c) return 1;		\
									\
					c->ctyp = CELL_ARRAY;		\
					c->a.etyp = r->a.etyp;		\
					c->a.stg = STG_HOST;		\
					c->a.rnk = 0;			\
					c->a.shp = NULL;		\
					c->a.rf = r->a.rf;		\
									\
					free_cell(zv[j]);		\
					zv[j] = c;			\
				}					\
			}						\
		}break;
		
		switch ((*z)->a.etyp) {
		case ELEM_BOOL:
			switch (r->a.etyp) {
			case ELEM_BOOL: SET_HOST_REAL(char, b, char, b);
			default: return 99;
			}break;
		case ELEM_INT:
			switch (r->a.etyp) {
			case ELEM_BOOL: SET_HOST_REAL(int64_t, i, char, b);
			case ELEM_INT: SET_HOST_REAL(int64_t, i, int64_t, i);
			default: return 99;
			}break;
		
		case ELEM_FLOAT:
			switch (r->a.etyp) {
			case ELEM_BOOL: SET_HOST_REAL(double, f, char, b);
			case ELEM_INT: SET_HOST_REAL(double, f, int64_t, i);
			case ELEM_FLOAT: SET_HOST_REAL(double, f, double, f);
			default: return 99;
			}break;
				
		case ELEM_CMPX:{
			struct apl_cmpx * restrict zv = (*z)->a.host->j;
			
			switch (r->a.etyp) {
			case ELEM_BOOL: SET_HOST_CMPX(char, b);
			case ELEM_INT: SET_HOST_CMPX(int64_t, i);
			case ELEM_FLOAT: SET_HOST_CMPX(double, f);
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
		
		case ELEM_CHAR:
			switch (r->a.etyp) {
			case ELEM_CHAR: SET_HOST_REAL(uint32_t, c, uint32_t, c);
			default: return 99;
			}break;
		
		case ELEM_CELL:{
			struct cell ** restrict zv = (*z)->a.host->p;
			
			switch (r->a.etyp) {
			case ELEM_BOOL: SET_HOST_CELL(char, b);
			case ELEM_INT: SET_HOST_CELL(int64_t, i);
			case ELEM_FLOAT: SET_HOST_CELL(double, f);
			case ELEM_CMPX: SET_HOST_CELL(struct apl_cmpx, j);
			case ELEM_CHAR: SET_HOST_CELL(uint32_t, c);
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
			
		#define SET_CPY_REAL(ht, hf, zf)			\
			for (int64_t i = 0; i < zc; i++)		\
				h->hf[i] = (ht)(*z)->a.host->zf[i];	\
			break;
		
		#define SET_CPY_CMPX(zf)					\
			for (int64_t i = 0; i < zc; i++) {			\
				h->j[i].real = (double)(*z)->a.host->zf[i];	\
				h->j[i].imag = 0;				\
			}							\
			break;
		
		#define SET_CPY_CELL(zf)			\
			for (int64_t i = 0; i < zc; i++) {      \
				struct cell *c = get_cell();    \
								\
				if (!c) {                       \
					free_host_buffer(h);    \
					return 1;               \
				}                               \
								\
				c->ctyp = CELL_ARRAY;           \
				c->a.etyp = (*z)->a.etyp;       \
				c->a.stg = STG_HOST;            \
				c->a.rnk = 0;                   \
				c->a.shp = NULL;                \
				c->a.zf = (*z)->a.host->zf[i];  \
								\
				h->p[i] = c;                    \
			}                                       \
			break;
		
		switch (ztyp) {
		
		case ELEM_BOOL: SET_CPY_REAL(char, b, b);
		case ELEM_INT:
			switch ((*z)->a.etyp) {
			case ELEM_BOOL: SET_CPY_REAL(int64_t, i, b);
			case ELEM_INT: SET_CPY_REAL(int64_t, i, i);
			}break;
		case ELEM_FLOAT:
			switch ((*z)->a.etyp) {
			case ELEM_BOOL: SET_CPY_REAL(double, f, b);
			case ELEM_INT: SET_CPY_REAL(double, f, i);
			case ELEM_FLOAT: SET_CPY_REAL(double, f, f);
			}break;
		case ELEM_CMPX:
			switch ((*z)->a.etyp) {
			case ELEM_BOOL: SET_CPY_CMPX(b);
			case ELEM_INT: SET_CPY_CMPX(i);
			case ELEM_FLOAT: SET_CPY_CMPX(f);
			case ELEM_CMPX:
				for (int64_t i = 0; i < zc; i++) 
					h->j[i] = (*z)->a.host->j[i];
				break;
			}break;
		case ELEM_CHAR: SET_CPY_REAL(uint32_t, c, c);
		case ELEM_CELL:
			switch ((*z)->a.etyp) {
			case ELEM_BOOL: SET_CPY_CELL(b);
			case ELEM_INT: SET_CPY_CELL(i);
			case ELEM_FLOAT: SET_CPY_CELL(f);
			case ELEM_CMPX: SET_CPY_CELL(j);
			case ELEM_CHAR: SET_CPY_CELL(c);
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
get_scalar_cell(struct cell **z, struct cell *l, struct cell *r, enum elem_type mnt, enum elem_type mxt)
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
	t->a.etyp = elem_type_merge_map[l->a.etyp][r->a.etyp];
	if (t->a.etyp < mnt) t->a.etyp = mnt;
	if (t->a.etyp > mxt) t->a.etyp = mxt;
	
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

#define SCALAR_SIMP(zt, zf, lt, lf, rt, rf, fn) {	\
	if (!t->a.rnk) {                                \
		fn(zt, t->a.zf, l->a.lf, r->a.rf);      \
	} else if (!l->a.rnk) {                         \
		zt *restrict tv = t->a.host->zf;        \
		lt lv = l->a.lf;                        \
		rt *restrict rv = r->a.host->rf;        \
							\
		for (int64_t i = 0; i < cnt; i++)       \
			fn(zt, tv[i], lv, rv[i]);       \
	} else if (!r->a.rnk) {                         \
		zt *restrict tv = t->a.host->zf;        \
		lt *restrict lv = l->a.host->lf;        \
		rt rv = r->a.rf;                        \
							\
		for (int64_t i = 0; i < cnt; i++)       \
			fn(zt, tv[i], lv[i], rv);       \
	} else {                                        \
		zt *restrict tv = t->a.host->zf;        \
		lt *restrict lv = l->a.host->lf;        \
		rt *restrict rv = r->a.host->rf;        \
							\
		for (int64_t i = 0; i < cnt; i++)       \
			fn(zt, tv[i], lv[i], rv[i]);    \
	}                                               \
}break;

#define SCALAR_SIMP_CELL(lt, lf, fn) {					\
	struct cell x = {                                               \
		1, CELL_ARRAY, NULL, .a = {                             \
			l->a.etyp, STG_HOST, 0, NULL, .lf = 0           \
		}                                                       \
	};                                                              \
									\
	if (!t->a.rnk) {                                                \
		err = fn(NULL, &t->a.p, l, r->a.p, NULL);               \
		if (err) goto fail;                                     \
	} else if (!l->a.rnk) {                                         \
		struct cell **restrict tv = t->a.host->p;               \
		struct cell **restrict rv = r->a.host->p;               \
									\
		for (int64_t i = 0; i < cnt; i++) {                     \
			err = fn(NULL, &tv[i], l, rv[i], NULL);         \
			if (err) goto fail;                             \
		}                                                       \
	} else if (!r->a.rnk) {                                         \
		struct cell **restrict tv = t->a.host->p;               \
		lt *restrict lv = l->a.host->lf;                        \
		struct cell *rv = r->a.p;                               \
									\
		for (int64_t i = 0; i < cnt; i++) {                     \
			x.a.lf = lv[i];                                 \
			err = fn(NULL, &tv[i], &x, rv, NULL);           \
			if (err) goto fail;                             \
		}                                                       \
	} else {                                                        \
		struct cell **restrict tv = t->a.host->p;               \
		lt *restrict lv = l->a.host->lf;                        \
		struct cell **restrict rv = r->a.host->p;               \
									\
		for (int64_t i = 0; i < cnt; i++) {                     \
			x.a.lf = lv[i];                                 \
			err = fn(NULL, &tv[i], &x, rv[i], NULL);        \
			if (err) goto fail;                             \
		}                                                       \
	}                                                               \
}break;

#define SCALAR_CELL_SIMP(rt, rf, fn) {					\
	struct cell x = {                                               \
		1, CELL_ARRAY, NULL, .a = {                             \
			r->a.etyp, STG_HOST, 0, NULL, .rf = 0           \
		}                                                       \
	};                                                              \
									\
	if (!t->a.rnk) {                                                \
		err = fn(NULL, &t->a.p, l->a.p, r, NULL);          	\
		if (err) goto fail;                                     \
	} else if (!l->a.rnk) {                                         \
		struct cell **restrict tv = t->a.host->p;               \
		rt *restrict rv = r->a.host->rf;                        \
									\
		for (int64_t i = 0; i < cnt; i++) {                     \
			x.a.rf = rv[i];                                 \
			err = fn(NULL, &tv[i], l->a.p, &x, NULL);   	\
			if (err) goto fail;                             \
		}                                                       \
	} else if (!r->a.rnk) {                                         \
		struct cell **restrict tv = t->a.host->p;               \
		struct cell **restrict lv = l->a.host->p;               \
		x.a.rf = r->a.rf;                                       \
									\
		for (int64_t i = 0; i < cnt; i++) {                     \
			err = fn(NULL, &tv[i], lv[i], &x, NULL);    	\
			if (err) goto fail;                             \
		}                                                       \
	} else {                                                        \
		struct cell **restrict tv = t->a.host->p;               \
		struct cell **restrict lv = l->a.host->p;               \
		rt *restrict rv = r->a.host->rf;                        \
									\
		for (int64_t i = 0; i < cnt; i++) {                     \
			x.a.rf = rv[i];                                 \
			err = fn(NULL, &tv[i], lv[i], &x, NULL);    	\
			if (err) goto fail;                             \
		}                                                       \
	}                                                               \
}break;

#define SCALAR_CELL_CELL(fn) {						\
	if (!t->a.rnk) {                                                \
		err = fn(NULL, &t->a.p, l->a.p, r->a.p, NULL);          \
		if (err) goto fail;                                     \
	} else if (!l->a.rnk) {                                         \
		struct cell **restrict tv = t->a.host->p;               \
		struct cell **restrict rv = r->a.host->p;               \
									\
		for (int64_t i = 0; i < cnt; i++) {                     \
			err = fn(NULL, &tv[i], l->a.p, rv[i], NULL);    \
			if (err) goto fail;                             \
		}                                                       \
	} else if (!r->a.rnk) {                                         \
		struct cell **restrict tv = t->a.host->p;               \
		struct cell **restrict lv = l->a.host->p;               \
									\
		for (int64_t i = 0; i < cnt; i++) {                     \
			err = fn(NULL, &tv[i], lv[i], r->a.p, NULL);    \
			if (err) goto fail;                             \
		}                                                       \
	} else {                                                        \
		struct cell **restrict tv = t->a.host->p;               \
		struct cell **restrict lv = l->a.host->p;               \
		struct cell **restrict rv = r->a.host->p;               \
									\
		for (int64_t i = 0; i < cnt; i++) {                     \
			err = fn(NULL, &tv[i], lv[i], rv[i], NULL);     \
			if (err) goto fail;                             \
		}                                                       \
	}                                                               \
}break;

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
	
	if ((err = get_scalar_cell(&t, l, r, ELEM_INT, ELEM_MAX)))
		goto fail;
	
	if (t->a.stg == STG_DEVICE) {
		err = 16;
		goto fail;
	}
	
	cnt = array_count(t, 0);
	
	if (!cnt) { 
		free_cell(t);
		if (!l->a.rnk) t = ref_cell(r);
		else if (!r->a.rnk) t = ref_cell(l);
		else t = ref_cell(r);
		goto done;
	}
	
	#define add_real(zt, z, l, r) (z) = (zt)(l) + (zt)(r)
	#define add_real_cmpx(zt, z, l, r) {	\
		(z).real = (l) + (r).real;	\
		(z).imag = (r).imag;		\
	}
	#define add_cmpx_real(zt, z, l, r) {	\
		(z).real = (l).real + (r);	\
		(z).imag = (l).imag;		\
	}
	#define add_cmpx_cmpx(zt, z, l, r) {	\
		(z).real = (l).real + (r).real;	\
		(z).imag = (l).imag + (l).imag;	\
	}
		
	switch (l->a.etyp) {
	case ELEM_BOOL:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_SIMP(int64_t, i, char, b, char, b, add_real);
		case ELEM_INT: SCALAR_SIMP(int64_t, i, char, b, int64_t, i, add_real);
		case ELEM_FLOAT: SCALAR_SIMP(double, f, char, b, double, f, add_real);
		case ELEM_CMPX: SCALAR_SIMP(struct apl_cmpx, j, char, b, struct apl_cmpx, j, add_real_cmpx);
		case ELEM_CHAR:err = 99; goto fail;
		case ELEM_CELL: SCALAR_SIMP_CELL(char, b, plus_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_INT:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_SIMP(int64_t, i, int64_t, i, char, b, add_real);
		case ELEM_INT: SCALAR_SIMP(int64_t, i, int64_t, i, int64_t, i, add_real);
		case ELEM_FLOAT: SCALAR_SIMP(double, f, int64_t, i, double, f, add_real);
		case ELEM_CMPX: SCALAR_SIMP(struct apl_cmpx, j, int64_t, i, struct apl_cmpx, j, add_real_cmpx);
		case ELEM_CHAR:err = 99; goto fail;
		case ELEM_CELL: SCALAR_SIMP_CELL(int64_t, i, plus_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_FLOAT:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_SIMP(double, f, double, f, char, b, add_real);
		case ELEM_INT: SCALAR_SIMP(double, f, double, f, int64_t, i, add_real);
		case ELEM_FLOAT: SCALAR_SIMP(double, f, double, f, double, f, add_real);
		case ELEM_CMPX:  SCALAR_SIMP(struct apl_cmpx, j, double, f, struct apl_cmpx, j, add_real_cmpx);
		case ELEM_CHAR:err = 99; goto fail;
		case ELEM_CELL: SCALAR_SIMP_CELL(double, f, plus_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_CMPX:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_SIMP(struct apl_cmpx, j, struct apl_cmpx, j, char, b, add_cmpx_real);
		case ELEM_INT: SCALAR_SIMP(struct apl_cmpx, j, struct apl_cmpx, j, int64_t, i, add_cmpx_real);
		case ELEM_FLOAT: SCALAR_SIMP(struct apl_cmpx, j, struct apl_cmpx, j, double, f, add_cmpx_real);
		case ELEM_CMPX: SCALAR_SIMP(struct apl_cmpx, j, struct apl_cmpx, j, struct apl_cmpx, j, add_cmpx_cmpx);
		case ELEM_CHAR:err = 99; goto fail;
		case ELEM_CELL: SCALAR_SIMP_CELL(struct apl_cmpx, j, plus_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_CHAR:err = 99; goto fail;
	case ELEM_CELL:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_CELL_SIMP(char, b, plus_f);
		case ELEM_INT: SCALAR_CELL_SIMP(int64_t, i, plus_f);
		case ELEM_FLOAT: SCALAR_CELL_SIMP(double, f, plus_f);
		case ELEM_CMPX: SCALAR_CELL_SIMP(struct apl_cmpx, j, plus_f);
		case ELEM_CHAR:err = 99; goto fail;
		case ELEM_CELL: SCALAR_CELL_CELL(plus_f);
		default:err = 99; goto fail;
		}break;
	default:
		err = 99;
		goto fail;
	}

done:
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

#define SCALAR_MON(zt, zf, rt, rf, fn) {		\
	if (!t->a.rnk) {                                \
		fn(zt, t->a.zf, r->a.rf);               \
	} else {                                        \
		zt *restrict tv = t->a.host->zf;        \
		rt *restrict rv = r->a.host->rf;        \
							\
		for (int64_t i = 0; i < cnt; i++)       \
			fn(zt, tv[i], rv[i]);           \
	}                                               \
}break;

EXPORT int
sign_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
{
	struct cell *t;
	int64_t cnt;
	int err;
	
	s; l; fv;
	
	t = NULL;
	
	if (r->a.etyp == ELEM_CHAR) return 11;
	if (r->a.stg == STG_DEVICE) return 16;

	cnt = array_count(r, 0);
	
	if (!cnt || r->a.etyp == ELEM_BOOL) {
		t = ref_cell(r);
		goto done;
	}
	
	if (!(t = get_cell())) { err = 1; goto fail; }
		
	t->ctyp = CELL_ARRAY;
	t->a = r->a;
	
	if (t->a.etyp == ELEM_FLOAT) t->a.etyp = ELEM_INT;
	if (t->a.rnk) {
		t->a.shp->refc++;
		t->a.host = get_host_buffer(buffer_size(t->a.etyp, cnt ? cnt : 1));
		
		if (!t->a.host) { err = 1; goto fail; }
		
		if (t->a.etyp == ELEM_CELL)
			memset(t->a.host->p, 0, sizeof(struct cell *) * cnt);
	}
	
	#define sign_real(zt, z, r) {		\
		if ((r) < 0) (z) = -1;          \
		else if ((r) > 0) (z) = 1;      \
		else (z) = 0;                   \
	}
	
	#define sign_cmpx(zt, z, r) {			\
		if (!(r).real && !(r).imag) {           \
			(z).real = 0;                   \
			(z).imag = 0;                   \
		} else {                                \
			double q;                       \
							\
			q = (r).real * (r).real;        \
			q += (r).imag * (r).imag;       \
			q = sqrt(q);                    \
							\
			(z).real = (r).real / q;        \
			(z).imag = (r).imag / q;        \
		}		                        \
	}
	
	#define sign_cell(zt, z, r) {				\
		err = sign_f(NULL, &(z), NULL, (r), NULL);      \
		if (err) goto fail;                             \
	}
	
	switch (r->a.etyp) {
	case ELEM_BOOL: err = 99; goto fail;
	case ELEM_INT: SCALAR_MON(int64_t, i, int64_t, i, sign_real);
	case ELEM_FLOAT: SCALAR_MON(int64_t, i, double, f, sign_real);
	case ELEM_CMPX: SCALAR_MON(struct apl_cmpx, j, struct apl_cmpx, j, sign_cmpx);
	case ELEM_CHAR: err = 99; goto fail;
	case ELEM_CELL: SCALAR_MON(struct cell *, p, struct cell *, p, sign_cell);
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
	
	if ((err = get_scalar_cell(&t, l, r, ELEM_BOOL, ELEM_MAX)))
		goto fail;
	
	if (t->a.stg == STG_DEVICE) {
		err = 16;
		goto fail;
	}
	
	cnt = array_count(t, 0);
	
	if (!cnt) { 
		free_cell(t);
		if (!l->a.rnk) t = ref_cell(r);
		else if (!r->a.rnk) t = ref_cell(l);
		else t = ref_cell(r);
		goto done;
	}
	
	#define times_real(zt, z, l, r) (z) = (zt)(l) * (zt)(r)
	#define times_real_cmpx(zt, z, l, r) {	\
		(z).real = (l) * (r).real;	\
		(z).imag = (l) * (r).imag;	\
	}
	#define times_cmpx_real(zt, z, l, r) {	\
		(z).real = (l).real * (r);	\
		(z).imag = (l).imag * (r);	\
	}
	#define times_cmpx_cmpx(zt, z, l, r) {	\
		(z).real = (l).real * (r).real - (l).imag * (r).imag;	\
		(z).imag = (l).imag * (r).real + (l).real * (r).imag;	\
	}
		
	switch (l->a.etyp) {
	case ELEM_BOOL:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_SIMP(char, b, char, b, char, b, times_real);
		case ELEM_INT: SCALAR_SIMP(int64_t, i, char, b, int64_t, i, times_real);
		case ELEM_FLOAT: SCALAR_SIMP(double, f, char, b, double, f, times_real);
		case ELEM_CMPX: SCALAR_SIMP(struct apl_cmpx, j, char, b, struct apl_cmpx, j, times_real_cmpx);
		case ELEM_CHAR:err = 99; goto fail;
		case ELEM_CELL: SCALAR_SIMP_CELL(char, b, times_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_INT:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_SIMP(int64_t, i, int64_t, i, char, b, times_real);
		case ELEM_INT: SCALAR_SIMP(int64_t, i, int64_t, i, int64_t, i, times_real);
		case ELEM_FLOAT: SCALAR_SIMP(double, f, int64_t, i, double, f, times_real);
		case ELEM_CMPX: SCALAR_SIMP(struct apl_cmpx, j, int64_t, i, struct apl_cmpx, j, times_real_cmpx);
		case ELEM_CHAR:err = 99; goto fail;
		case ELEM_CELL: SCALAR_SIMP_CELL(int64_t, i, times_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_FLOAT:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_SIMP(double, f, double, f, char, b, times_real);
		case ELEM_INT: SCALAR_SIMP(double, f, double, f, int64_t, i, times_real);
		case ELEM_FLOAT: SCALAR_SIMP(double, f, double, f, double, f, times_real);
		case ELEM_CMPX:  SCALAR_SIMP(struct apl_cmpx, j, double, f, struct apl_cmpx, j, times_real_cmpx);
		case ELEM_CHAR:err = 99; goto fail;
		case ELEM_CELL: SCALAR_SIMP_CELL(double, f, times_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_CMPX:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_SIMP(struct apl_cmpx, j, struct apl_cmpx, j, char, b, times_cmpx_real);
		case ELEM_INT: SCALAR_SIMP(struct apl_cmpx, j, struct apl_cmpx, j, int64_t, i, times_cmpx_real);
		case ELEM_FLOAT: SCALAR_SIMP(struct apl_cmpx, j, struct apl_cmpx, j, double, f, times_cmpx_real);
		case ELEM_CMPX: SCALAR_SIMP(struct apl_cmpx, j, struct apl_cmpx, j, struct apl_cmpx, j, times_cmpx_cmpx);
		case ELEM_CHAR:err = 99; goto fail;
		case ELEM_CELL: SCALAR_SIMP_CELL(struct apl_cmpx, j, times_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_CHAR:err = 99; goto fail;
	case ELEM_CELL:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_CELL_SIMP(char, b, times_f);
		case ELEM_INT: SCALAR_CELL_SIMP(int64_t, i, times_f);
		case ELEM_FLOAT: SCALAR_CELL_SIMP(double, f, times_f);
		case ELEM_CMPX: SCALAR_CELL_SIMP(struct apl_cmpx, j, times_f);
		case ELEM_CHAR:err = 99; goto fail;
		case ELEM_CELL: SCALAR_CELL_CELL(times_f);
		default:err = 99; goto fail;
		}break;
	default:
		err = 99;
		goto fail;
	}
		

done:
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
	
	if ((err = get_scalar_cell(&t, l, r, ELEM_BOOL, ELEM_MAX)))
		goto fail;
		
	if (t->a.etyp == ELEM_INT)
		t->a.etyp = ELEM_FLOAT;
	
	if (t->a.stg == STG_DEVICE) {
		err = 16;
		goto fail;
	}
	
	cnt = array_count(t, 0);
	
	if (!cnt) { 
		free_cell(t);
		if (!l->a.rnk) t = ref_cell(r);
		else if (!r->a.rnk) t = ref_cell(l);
		else t = ref_cell(r);
		goto done;
	}
	
	if (r->a.etyp == ELEM_BOOL) {
		if (!r->a.rnk) {
			if (!r->a.b) { err = 11; goto fail; }
		} else {
			char *restrict rv = r->a.host->b;
			
			for (int64_t i = 0; i < cnt; i++)
				if (!rv[i]) { err = 11; goto fail; }
		}
		
		if (l->a.rnk == t->a.rnk) {
			free_cell(t);
		
			t = ref_cell(l);
		} else {
			#define DIV_BOOL(lt, lf) {			\
				lt *restrict tv = t->a.host->lf;        \
									\
				for (int64_t i = 0; i < cnt; i++)       \
					tv[i] = l->a.lf;                \
			}break;
			
			switch (t->a.etyp) {
			case ELEM_BOOL: DIV_BOOL(char, b);
			case ELEM_INT: DIV_BOOL(int64_t, i);
			case ELEM_FLOAT: DIV_BOOL(double, f);
			case ELEM_CMPX: DIV_BOOL(struct apl_cmpx, j);
			default: err = 99; goto fail;
			}
		}
		
		goto done;
	}
	
	#define div_real(zt, z, l, r) {			\
		if (!(r)) { err = 11; goto fail; }      \
		(z) = (zt)(l) / (zt)(r);                \
	}
	
	#define div_real_cmpx(zt, z, l, r) {				\
		struct apl_cmpx x = {(double)(l), 0};  			\
		if (!(r).real && ! (r).imag) { err = 11; goto fail; }	\
		(z) = div_cmpx(x, (r));         			\
	}
	
	#define div_cmpx_real(zt, z, l, r) {		\
		struct apl_cmpx y = {(double)(r), 0};   \
		if (!(r)) { err = 11; goto fail; }	\
		(z) = div_cmpx((l), y);         	\
	}
	
	#define div_cmpx_cmpx(zt, z, l, r) {				\
		if (!(r).real && !(r).imag) { err = 11; goto fail; }	\
		(z) = div_cmpx((l), (r));				\
	}
		
	switch (l->a.etyp) {
	case ELEM_BOOL:
		switch (r->a.etyp) {
		case ELEM_INT: SCALAR_SIMP(double, f, char, b, int64_t, i, div_real);
		case ELEM_FLOAT: SCALAR_SIMP(double, f, char, b, double, f, div_real);
		case ELEM_CMPX: SCALAR_SIMP(struct apl_cmpx, j, char, b, struct apl_cmpx, j, div_real_cmpx);
		case ELEM_CHAR:err = 99; goto fail;
		case ELEM_CELL: SCALAR_SIMP_CELL(char, b, divide_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_INT:
		switch (r->a.etyp) {
		case ELEM_INT: SCALAR_SIMP(double, f, int64_t, i, int64_t, i, div_real);
		case ELEM_FLOAT: SCALAR_SIMP(double, f, int64_t, i, double, f, div_real);
		case ELEM_CMPX: SCALAR_SIMP(struct apl_cmpx, j, int64_t, i, struct apl_cmpx, j, div_real_cmpx);
		case ELEM_CHAR:err = 99; goto fail;
		case ELEM_CELL: SCALAR_SIMP_CELL(int64_t, i, divide_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_FLOAT:
		switch (r->a.etyp) {
		case ELEM_INT: SCALAR_SIMP(double, f, double, f, int64_t, i, div_real);
		case ELEM_FLOAT: SCALAR_SIMP(double, f, double, f, double, f, div_real);
		case ELEM_CMPX: SCALAR_SIMP(struct apl_cmpx, j, double, f, struct apl_cmpx, j, div_real_cmpx);
		case ELEM_CHAR:err = 99; goto fail;
		case ELEM_CELL: SCALAR_SIMP_CELL(double, f, divide_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_CMPX:
		switch (r->a.etyp) {
		case ELEM_INT: SCALAR_SIMP(struct apl_cmpx, j, struct apl_cmpx, j, int64_t, i, div_cmpx_real);
		case ELEM_FLOAT: SCALAR_SIMP(struct apl_cmpx, j, struct apl_cmpx, j, double, f, div_cmpx_real);
		case ELEM_CMPX: SCALAR_SIMP(struct apl_cmpx, j, struct apl_cmpx, j, struct apl_cmpx, j, div_cmpx_cmpx);
		case ELEM_CHAR:err = 99; goto fail;
		case ELEM_CELL: SCALAR_SIMP_CELL(struct apl_cmpx, j, divide_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_CHAR:err = 99; goto fail;
	case ELEM_CELL:
		switch (r->a.etyp) {
		case ELEM_INT: SCALAR_CELL_SIMP(int64_t, i, divide_f);
		case ELEM_FLOAT: SCALAR_CELL_SIMP(double, f, divide_f);
		case ELEM_CMPX: SCALAR_CELL_SIMP(struct apl_cmpx, j, divide_f);
		case ELEM_CHAR:err = 99; goto fail;
		case ELEM_CELL: SCALAR_CELL_CELL(divide_f);
		default:err = 99; goto fail;
		}break;
	default:
		err = 99;
		goto fail;
	}

done:
	*z = t;
	
	return 0;
	
fail:
	free_cell(t);
	
	return err;
}

EXPORT int
recip_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
{
	l; fv;
	
	return divide_f(s, z, &scl_one, r, NULL);
}

int (*div_fn[])(struct cell *, struct cell **, struct cell *, struct cell *, struct cell ***) = {
	recip_f, divide_f
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
	
	if (r->a.etyp != ELEM_INT && r->a.etyp != ELEM_BOOL) return 11;
	
	if (r->a.etyp == ELEM_BOOL) r->a.i = r->a.b;
	
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
	
	switch (s->f.axis->a.etyp) {
	case ELEM_BOOL: axis = s->f.axis->a.b; break;
	case ELEM_INT: axis = s->f.axis->a.i; break;
	default: return 11;
	}
	
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
		
		#define REDUCE_ADD1(zk, zt, zf, rt, rf) {	\
			zt tv;                                  \
			rt *restrict rv;                        \
								\
			rv = r->a.host->rf;                     \
			tv = 0;                                 \
			t->a.etyp = zk;                         \
								\
			for (int64_t i = 0; i < cnt; i++)       \
				tv += rv[i];                    \
								\
			t->a.zf = tv;                           \
		}break;
		
		switch (r->a.etyp) {
		case ELEM_BOOL:REDUCE_ADD1(ELEM_INT, int64_t, i, char, b);
		case ELEM_INT:REDUCE_ADD1(ELEM_INT, int64_t, i, int64_t, i);
		case ELEM_FLOAT:REDUCE_ADD1(ELEM_FLOAT, double, f, double, f);
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
	
	#define REDUCE_CELL(rt, rf) {							\
		rt *restrict rv = r->a.host->rf;                                        \
											\
		for (int64_t i = 0; i < ra; i++) {                                      \
			for (int64_t j = 0; j < rc; j++) {                              \
				int64_t off = i * rb * rc + j;                          \
											\
				if (!(y = get_cell())) { err = 1; goto fail; }          \
											\
				y->ctyp = CELL_ARRAY;                                   \
				y->a.etyp = r->a.etyp;                                  \
				y->a.stg = STG_HOST;                                    \
				y->a.rnk = 0;                                           \
				y->a.shp = NULL;                                        \
				y->a.rf = rv[off + (rb - 1) * rc];                      \
											\
				for (int64_t k = rb - 2; k >= 0; k--) {                 \
					struct cell *tmp = y;                           \
											\
					if (!(x = get_cell())) { err = 1; goto fail; }  \
											\
					x->ctyp = CELL_ARRAY;                           \
					x->a.etyp = r->a.etyp;                          \
					x->a.stg = STG_HOST;                            \
					x->a.rnk = 0;                                   \
					x->a.shp = NULL;                                \
					x->a.rf = rv[off + k * rc];                     \
											\
					if ((err = fn->f.fn[1](fn, &y, x, y, fv)))      \
						goto fail;                              \
											\
					free_cell(tmp);                                 \
					free_cell(x);                                   \
				}                                                       \
											\
				pv[off] = y;                                            \
			}                                                               \
		}                                                                       \
	}break;
	
	switch (r->a.etyp) {
	case ELEM_BOOL: REDUCE_CELL(char, b);
	case ELEM_INT: REDUCE_CELL(int64_t, i);
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
	
	switch (s->f.axis->a.etyp) {
	case ELEM_BOOL: axis = s->f.axis->a.b; break;
	case ELEM_INT: axis = s->f.axis->a.i; break;
	default: return 11;
	}

	rev = 0;
	
	if (axis < 0) {
		axis = -1 * axis;
		rev = 1;
	}
	
	if (l->a.rnk) return 4;	
	if (l->a.etyp != ELEM_INT && l->a.etyp != ELEM_BOOL) return 11;
	
	if (l->a.etyp == ELEM_BOOL) l->a.i = l->a.b;
	
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
		#define NWREDUCE_ADD(zk, zt, zf, rt, rf) {					\
			zt *restrict tv;                                                        \
			rt *restrict rv;                                                        \
												\
			t->a.etyp = zk;                                                         \
			t->a.host = get_host_buffer(buffer_size(t->a.etyp, cnt ? cnt : 1));     \
												\
			if (!t->a.host) { err = 1; goto fail; }                                 \
												\
			tv = t->a.host->zf;                                                     \
			rv = r->a.host->rf;                                                     \
												\
			if (!cnt) {                                                             \
				tv[0] = 0;                                                      \
				goto done;                                                      \
			}                                                                       \
												\
			for (int64_t i = 0; i < ts[0]; i++) {                                   \
				for (int64_t j = 0; j < ts[2]; j++) {                           \
					for (int64_t k = 0; k < ts[1]; k++) {                   \
						int64_t ti = i * ts[1] * ts[2] + j + k * ts[2]; \
						int64_t ri = i * rs[1] * rs[2] + j + k * rs[2]; \
												\
						tv[ti] = 0;                                     \
												\
						for (int64_t w = 0; w < win; w++) {             \
							tv[ti] += rv[ri + w * rs[2]];           \
						}                                               \
					}                                                       \
				}                                                               \
			}                                                                       \
		}break;
	
		switch (r->a.etyp) {
		case ELEM_BOOL:NWREDUCE_ADD(ELEM_INT, int64_t, i, char, b);
		case ELEM_INT:NWREDUCE_ADD(ELEM_INT, int64_t, i, int64_t, i);
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
		
		#define MATMUL(zk, zt, zf, lt, lf, rt, rf) {					\
			zt *restrict tv;                                                        \
			lt *restrict lv;                                                        \
			rt *restrict rv;                                                        \
												\
			t->a.etyp = zk;                                                         \
												\
			if (!l->a.rnk && !r->a.rnk) {                                           \
				t->a.zf = l->a.lf * r->a.rf;                                    \
				goto done;                                                      \
			}                                                                       \
												\
			lv = l->a.host->lf;                                                     \
			rv = r->a.host->rf;                                                     \
												\
			if (!t->a.rnk) {                                                        \
				t->a.zf = 0;                                                    \
												\
				if (!l->a.rnk) {                                                \
					for (int64_t i = 0; i < rb; i++)                        \
						t->a.zf += l->a.lf * rv[i];                     \
				} else if (!r->a.rnk) {                                         \
					for (int64_t i = 0; i < lb; i++)                        \
						t->a.zf += lv[i] * r->a.rf;                     \
				} else {                                                        \
					for (int64_t i = 0; i < lb; i++)                        \
						t->a.zf += lv[i] * rv[i];                       \
				}                                                               \
												\
				goto done;                                                      \
			}                                                                       \
												\
			t->a.host = get_host_buffer(buffer_size(t->a.etyp, cnt ? cnt : 1));     \
												\
			if (!t->a.host) { err = 1; goto fail; }                                 \
												\
			tv = t->a.host->zf;                                                     \
												\
			if (!cnt) {                                                             \
				tv[0] = 0;                                                      \
				goto done;                                                      \
			}                                                                       \
												\
			if (!l->a.rnk) {                                                        \
				err = 16;                                                       \
				goto fail;                                                      \
			}                                                                       \
												\
			if (!r->a.rnk) {                                                        \
				err = 16;                                                       \
				goto fail;                                                      \
			}                                                                       \
												\
			for (int64_t i = 0; i < la; i++) {                                      \
				for (int64_t j = 0; j < rb; j++) {                              \
					int64_t a = 0;                                          \
					for (int64_t k = 0; k < lb; k++)                        \
						a += lv[i * lb + k] * rv[k * rb + j];           \
					*tv++ = a;                                              \
				}                                                               \
			}                                                                       \
		}break;
		
		switch (l->a.etyp) {
		case ELEM_BOOL:
			switch (r->a.etyp) {
			case ELEM_BOOL: MATMUL(ELEM_INT, int64_t, i, char, b, char, b);
			case ELEM_INT: MATMUL(ELEM_INT, int64_t, i, char, b, int64_t, i);
			case ELEM_FLOAT: err = 16; goto fail;
			case ELEM_CMPX: err = 16; goto fail;
			case ELEM_CELL: err = 16; goto fail;
			default: err = 99; goto fail;
			}break;
		case ELEM_INT:
			switch (r->a.etyp) {
			case ELEM_BOOL: MATMUL(ELEM_INT, int64_t, i, int64_t, i, char, b);
			case ELEM_INT: MATMUL(ELEM_INT, int64_t, i, int64_t, i, int64_t, i);
			case ELEM_FLOAT: err = 16; goto fail;
			case ELEM_CMPX: err = 16; goto fail;
			case ELEM_CELL: err = 16; goto fail;
			default: err = 99; goto fail;
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

static struct apl_cmpx
exp_cmpx(struct apl_cmpx x)
{
	struct apl_cmpx z;

#ifdef _MSC_VER
	_Dcomplex tx = {x.real, x.imag};
	_Dcomplex tz;
#else
	double complex tx, tz;

	tx = x.real + x.imag * I;
#endif

	tz = cexp(tx);	

	z.real = creal(tz);	
	z.imag = cimag(tz);	

	return z;		
}

EXPORT int
exponent_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
{
	struct cell *t;
	int64_t cnt;
	int err;
	
	s; l; fv;
	
	t = NULL;
	
	if (r->a.etyp == ELEM_CHAR) { err = 11; goto fail; }
	if (r->a.stg == STG_DEVICE) { err = 16; goto fail; }
	
	cnt = array_count(r, 0);
	
	if (!cnt) {
		t = ref_cell(r);
		goto done;
	}
	
	if (!(t = get_cell())) { err = 1; goto fail; }
	
	t->ctyp = CELL_ARRAY;
	t->a = r->a;
	
	if (t->a.etyp == ELEM_INT || t->a.etyp == ELEM_BOOL) t->a.etyp = ELEM_FLOAT;
	if (t->a.rnk) {
		t->a.shp->refc++;
		t->a.host = get_host_buffer(buffer_size(t->a.etyp, cnt ? cnt : 1));
		
		if (!t->a.host) { err = 1; goto fail; }
		if (t->a.etyp == ELEM_CELL) memset(t->a.host->p, 0, sizeof(struct cell *) * cnt);
	}
	
	#define exp_real(zt, z, r) (z) = exp((double)r)
	#define exp_cmpx_(zt, z, r) (z) = exp_cmpx(r)
	#define exp_cell(zt, z, r) {				\
		err = exponent_f(NULL, &(z), NULL, (r), NULL);	\
		if (err) goto fail;				\
	}
	
	switch (r->a.etyp) {
	case ELEM_BOOL: SCALAR_MON(double, f, char, b, exp_real);
	case ELEM_INT: SCALAR_MON(double, f, int64_t, i, exp_real);
	case ELEM_FLOAT: SCALAR_MON(double, f, double, f, exp_real);
	case ELEM_CMPX: SCALAR_MON(struct apl_cmpx, j, struct apl_cmpx, j, exp_cmpx_);
	case ELEM_CELL: SCALAR_MON(struct cell *, p, struct cell *, p, exp_cell);
	default: err = 99; goto fail;
	}
	
	
done:
	*z = t;
	
	return 0;
	
fail:
	free_cell(t);
	
	return err;
}

static struct apl_cmpx
pow_cmpx(struct apl_cmpx x, struct apl_cmpx y)
{
	struct apl_cmpx z;

#ifdef _MSC_VER
	_Dcomplex tx = {x.real, x.imag};
	_Dcomplex ty = {y.real, y.imag};
	_Dcomplex tz;
#else
	double complex tx, ty, tz;

	tx = x.real + x.imag * I;
	ty = y.real + y.imag * I;
#endif

	tz = cpow(tx, ty);	

	z.real = creal(tz);	
	z.imag = cimag(tz);	

	return z;		
}

EXPORT int
power_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
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
	
	if ((err = get_scalar_cell(&t, l, r, ELEM_FLOAT, ELEM_MAX)))
		goto fail;

	if (t->a.stg == STG_DEVICE) {
		err = 16;
		goto fail;
	}
	
	cnt = array_count(t, 0);
	
	if (!cnt) { 
		free_cell(t);
		if (!l->a.rnk) t = ref_cell(r);
		else if (!r->a.rnk) t = ref_cell(l);
		else t = ref_cell(r);
		goto done;
	}
	
	#define pow_rr(zt, z, l, r) (z) = pow((double)(l), (double)(r));
	#define pow_rj(zt, z, l, r) {			\
		struct apl_cmpx x = {(double)(l), 0};   \
		(z) = pow_cmpx(x, (r));                 \
	}
	#define pow_jb(zt, z, l, r) {		\
		struct apl_cmpx one = {1, 0};	\
		(z) = (r) ? (l) : one;          \
	}
	#define pow_jr(zt, z, l, r) {			\
		struct apl_cmpx x = {(double)(r), 0};	\
		(z) = pow_cmpx((l), x);			\
	}
	#define pow_jj(zt, z, l, r) (z) = pow_cmpx((l), (r));
	
	switch (l->a.etyp) {
	case ELEM_BOOL:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_SIMP(double, f, char, b, char, b, pow_rr);
		case ELEM_INT: SCALAR_SIMP(double, f, char, b, int64_t, i, pow_rr);
		case ELEM_FLOAT: SCALAR_SIMP(double, f, char, b, double, f, pow_rr);
		case ELEM_CMPX: SCALAR_SIMP(struct apl_cmpx, j, char, b, struct apl_cmpx, j, pow_rj);
		case ELEM_CHAR:err = 99; goto fail;
		case ELEM_CELL: SCALAR_SIMP_CELL(char, b, power_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_INT:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_SIMP(double, f, int64_t, i, char, b, pow_rr);
		case ELEM_INT: SCALAR_SIMP(double, f, int64_t, i, int64_t, i, pow_rr);
		case ELEM_FLOAT: SCALAR_SIMP(double, f, int64_t, i, double, f, pow_rr);
		case ELEM_CMPX: SCALAR_SIMP(struct apl_cmpx, j, int64_t, i, struct apl_cmpx, j, pow_rj);
		case ELEM_CHAR:err = 99; goto fail;
		case ELEM_CELL: SCALAR_SIMP_CELL(int64_t, i, power_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_FLOAT:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_SIMP(double, f, double, f, char, b, pow_rr);
		case ELEM_INT: SCALAR_SIMP(double, f, double, f, int64_t, i, pow_rr);
		case ELEM_FLOAT: SCALAR_SIMP(double, f, double, f, double, f, pow_rr);
		case ELEM_CMPX: SCALAR_SIMP(struct apl_cmpx, j, double, f, struct apl_cmpx, j, pow_rj);
		case ELEM_CHAR:err = 99; goto fail;
		case ELEM_CELL: SCALAR_SIMP_CELL(double, f, power_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_CMPX:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_SIMP(struct apl_cmpx, j, struct apl_cmpx, j, char, b, pow_jr);
		case ELEM_INT: SCALAR_SIMP(struct apl_cmpx, j, struct apl_cmpx, j, int64_t, i, pow_jr);
		case ELEM_FLOAT: SCALAR_SIMP(struct apl_cmpx, j, struct apl_cmpx, j, double, f, pow_jr);
		case ELEM_CMPX: SCALAR_SIMP(struct apl_cmpx, j, struct apl_cmpx, j, struct apl_cmpx, j, pow_jj);
		case ELEM_CHAR:err = 99; goto fail;
		case ELEM_CELL: SCALAR_SIMP_CELL(struct apl_cmpx, j, power_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_CHAR:err = 99; goto fail;
	case ELEM_CELL:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_CELL_SIMP(char, b, power_f);
		case ELEM_INT: SCALAR_CELL_SIMP(int64_t, i, power_f);
		case ELEM_FLOAT: SCALAR_CELL_SIMP(double, f, power_f);
		case ELEM_CMPX: SCALAR_CELL_SIMP(struct apl_cmpx, j, power_f);
		case ELEM_CHAR:err = 99; goto fail;
		case ELEM_CELL: SCALAR_CELL_CELL(power_f);
		default:err = 99; goto fail;
		}break;
	default:
		err = 99;
		goto fail;
	}

done:
	*z = t;
	
	return 0;
	
fail:
	free_cell(t);
	
	return err;
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
	
	if (s->f.ww->a.etyp != ELEM_INT && s->f.ww->a.etyp != ELEM_BOOL) return 11;
	if (s->f.ww->a.etyp == ELEM_BOOL) s->f.ww->a.i = s->f.ww->a.b;
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
	
	if (s->f.ww->a.etyp != ELEM_INT && s->f.ww->a.etyp != ELEM_BOOL) return 11;
	if (s->f.ww->a.etyp == ELEM_BOOL) s->f.ww->a.i = s->f.ww->a.b;
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
	
	#define OUP_HOST(lf, rf) {						\
		if (!t->a.rnk) {                                                \
			if ((err = fn->f.fn[1](fn, &t->a.p, l, r, fv)))         \
				goto fail;                                      \
		} else if (!l->a.rnk) {                                         \
			for (int64_t i = 0; i < cnt; i++) {                     \
				struct cell *x = get_cell();                    \
										\
				if (!x) { err = 1; goto fail; }                 \
										\
				x->ctyp = CELL_ARRAY;                           \
				x->a.etyp = r->a.etyp;                          \
				x->a.stg = STG_HOST;                            \
				x->a.rnk = 0;                                   \
				x->a.shp = NULL;                                \
				x->a.rf = r->a.host->rf[i];                     \
										\
				err = fn->f.fn[1](fn, &pv[i], l, x, fv);        \
										\
				if (err) goto fail;                             \
										\
				free_cell(x);                                   \
			}                                                       \
		} else if (!r->a.rnk) {                                         \
			for (int64_t i = 0; i < cnt; i++) {                     \
				struct cell *x = get_cell();                    \
										\
				if (!x) { err = 1; goto fail; }                 \
										\
				x->ctyp = CELL_ARRAY;                           \
				x->a.etyp = l->a.etyp;                          \
				x->a.stg = STG_HOST;                            \
				x->a.rnk = 0;                                   \
				x->a.shp = NULL;                                \
				x->a.lf = l->a.host->lf[i];                     \
										\
				err = fn->f.fn[1](fn, &pv[i], x, r, fv);        \
										\
				if (err) goto fail;                             \
										\
				free_cell(x);                                   \
			}                                                       \
		} else {                                                        \
			for (int64_t i = 0; i < lc; i++) {                      \
				for (int64_t j = 0; j < rc; j++) {              \
					struct cell *x = get_cell();            \
					struct cell *y = get_cell();            \
										\
					if (!x) { err = 1; goto fail; }         \
					if (!y) { err = 1; goto fail; }         \
										\
					x->ctyp = y->ctyp = CELL_ARRAY;         \
					x->a.etyp = l->a.etyp;                  \
					y->a.etyp = r->a.etyp;                  \
					x->a.stg = y->a.stg = STG_HOST;         \
					x->a.rnk = y->a.rnk = 0;                \
					x->a.shp = y->a.shp = NULL;             \
					x->a.lf = l->a.host->lf[i];             \
					y->a.rf = r->a.host->rf[j];             \
										\
					err = fn->f.fn[1](fn, pv++, x, y, fv);  \
										\
					if (err) goto fail;                     \
										\
					free_cell(x);                           \
					free_cell(y);                           \
				}                                               \
			}                                                       \
		}                                                               \
	}break;
	
	switch (l->a.etyp) {
	case ELEM_BOOL:
		switch (r->a.etyp) {
		case ELEM_BOOL: OUP_HOST(b, b);
		case ELEM_INT: OUP_HOST(b, i);
		case ELEM_FLOAT: OUP_HOST(b, f);
		case ELEM_CMPX: OUP_HOST(b, j);
		case ELEM_CHAR: OUP_HOST(b, c);
		case ELEM_CELL: OUP_HOST(b, p);
		default: err = 99; goto fail;
		}break;
	case ELEM_INT:
		switch (r->a.etyp) {
		case ELEM_BOOL: OUP_HOST(i, b);
		case ELEM_INT: OUP_HOST(i, i);
		case ELEM_FLOAT: OUP_HOST(i, f);
		case ELEM_CMPX: OUP_HOST(i, j);
		case ELEM_CHAR: OUP_HOST(i, c);
		case ELEM_CELL: OUP_HOST(i, p);
		default: err = 99; goto fail;
		}break;
	case ELEM_FLOAT:
		switch (r->a.etyp) {
		case ELEM_BOOL: OUP_HOST(f, b);
		case ELEM_INT: OUP_HOST(f, i);
		case ELEM_FLOAT: OUP_HOST(f, f);
		case ELEM_CMPX: OUP_HOST(f, j);
		case ELEM_CHAR: OUP_HOST(f, c);
		case ELEM_CELL: OUP_HOST(f, p);
		default: err = 99; goto fail;
		}break;
	case ELEM_CMPX:
		switch (r->a.etyp) {
		case ELEM_BOOL: OUP_HOST(j, b);
		case ELEM_INT: OUP_HOST(j, i);
		case ELEM_FLOAT: OUP_HOST(j, f);
		case ELEM_CMPX: OUP_HOST(j, j);
		case ELEM_CHAR: OUP_HOST(j, c);
		case ELEM_CELL: OUP_HOST(j, p);
		default: err = 99; goto fail;
		}break;	
	case ELEM_CHAR:
		switch (r->a.etyp) {
		case ELEM_BOOL: OUP_HOST(c, b);
		case ELEM_INT: OUP_HOST(c, i);
		case ELEM_FLOAT: OUP_HOST(c, f);
		case ELEM_CMPX: OUP_HOST(c, j);
		case ELEM_CHAR: OUP_HOST(c, c);
		case ELEM_CELL: OUP_HOST(c, p);
		default: err = 99; goto fail;
		}break;
	case ELEM_CELL:
		switch (r->a.etyp) {
		case ELEM_BOOL: OUP_HOST(p, b);
		case ELEM_INT: OUP_HOST(p, i);
		case ELEM_FLOAT: OUP_HOST(p, f);
		case ELEM_CMPX: OUP_HOST(p, j);
		case ELEM_CHAR: OUP_HOST(p, c);
		case ELEM_CELL: OUP_HOST(p, p);
		default: err = 99; goto fail;
		}break;
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

static int
jotff_m(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
{
	struct cell *t;
	int err;
	
	l;
	
	if ((err = s->f.ww->f.fn[0](s->f.ww, &t, NULL, r, fv)))
		return err;
	
	err = s->f.aa->f.fn[0](s->f.aa, z, NULL, t, fv);
	
	free_cell(t);
	
	return err;
}

static int
jotff_d(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
{
	struct cell *t;
	int err;
	
	if ((err = s->f.ww->f.fn[0](s->f.ww, &t, NULL, r, fv)))
		return err;
	
	err = s->f.aa->f.fn[1](s->f.aa, z, l, t, fv);
	
	free_cell(t);
	
	return err;
}

static int
jotaf_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
{
	l;
	
	return s->f.ww->f.fn[1](s->f.ww, z, s->f.aa, r, fv);
}

static int
jotfa_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
{
	l;
	
	return s->f.aa->f.fn[1](s->f.aa, z, r, s->f.ww, fv);
}

int (*jot_fn[])(struct cell *, struct cell **, struct cell *, struct cell *, struct cell ***) = {
	syntaxerr_f, syntaxerr_f, jotfa_f, syntaxerr_f, jotaf_f, syntaxerr_f, jotff_m, jotff_d
};
struct cell jot_c = {
	1, CELL_FUNC, NULL, .f = {
		jot_fn, NULL, NULL, NULL
	}
};
EXPORT struct cell *jot = &jot_c;

EXPORT int
equal_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
{
	struct cell *t;
	int64_t cnt;
	int err;
	
	fv;
	
	if (s != NULL && s->f.axis != NULL)
		return 16;
	
	t = NULL;
	
	if ((err = get_scalar_cell(&t, l, r, ELEM_BOOL, ELEM_BOOL)))
		goto fail;
	
	if (t->a.stg == STG_DEVICE) {
		err = 16;
		goto fail;
	}
	
	cnt = array_count(t, 1);
	
	#define eql_rr(zt, z, l, r) (z) = (l) == (r);
	#define eql_rj(zt, z, l, r) (z) = ((l) == (r).real) && !(r).imag;
	#define eql_jr(zt, z, l, r) (z) = ((l).real == (r)) && !(l).imag;
	#define eql_jj(zt, z, l, r) (z) = ((l).real == (r).real) && ((l).imag == (r).imag);
	#define eql_zero {				\
		if (!t->a.rnk) {                        \
			t->a.b = 0;                     \
		} else {                                \
			memset(t->a.host->b, 0, cnt);   \
		}                                       \
	}break;
	
	switch (l->a.etyp) {
	case ELEM_BOOL:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_SIMP(char, b, char, b, char, b, eql_rr);
		case ELEM_INT: SCALAR_SIMP(char, b, char, b, int64_t, i, eql_rr);
		case ELEM_FLOAT: SCALAR_SIMP(char, b, char, b, double, f, eql_rr);
		case ELEM_CMPX: SCALAR_SIMP(char, b, char, b, struct apl_cmpx, j, eql_rj);
		case ELEM_CHAR: eql_zero;
		case ELEM_CELL: SCALAR_SIMP_CELL(int64_t, i, equal_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_INT:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_SIMP(char, b, int64_t, i, char, b, eql_rr);
		case ELEM_INT: SCALAR_SIMP(char, b, int64_t, i, int64_t, i, eql_rr);
		case ELEM_FLOAT: SCALAR_SIMP(char, b, int64_t, i, double, f, eql_rr);
		case ELEM_CMPX: SCALAR_SIMP(char, b, int64_t, i, struct apl_cmpx, j, eql_rj);
		case ELEM_CHAR: eql_zero;
		case ELEM_CELL: SCALAR_SIMP_CELL(int64_t, i, equal_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_FLOAT:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_SIMP(char, b, double, f, char, b, eql_rr);
		case ELEM_INT: SCALAR_SIMP(char, b, double, f, int64_t, i, eql_rr);
		case ELEM_FLOAT: SCALAR_SIMP(char, b, double, f, double, f, eql_rr);
		case ELEM_CMPX: SCALAR_SIMP(char, b, double, f, struct apl_cmpx, j, eql_rj);
		case ELEM_CHAR: eql_zero;
		case ELEM_CELL: SCALAR_SIMP_CELL(double, f, equal_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_CMPX:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_SIMP(char, b, struct apl_cmpx, j, char, b, eql_jr);
		case ELEM_INT: SCALAR_SIMP(char, b, struct apl_cmpx, j, int64_t, i, eql_jr);
		case ELEM_FLOAT: SCALAR_SIMP(char, b, struct apl_cmpx, j, double, f, eql_jr);
		case ELEM_CMPX: SCALAR_SIMP(char, b, struct apl_cmpx, j, struct apl_cmpx, j, eql_jj);
		case ELEM_CHAR: eql_zero;
		case ELEM_CELL: SCALAR_SIMP_CELL(struct apl_cmpx, j, equal_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_CHAR:
		switch (r->a.etyp) {
		case ELEM_BOOL:
		case ELEM_INT:
		case ELEM_FLOAT:
		case ELEM_CMPX: eql_zero;
		case ELEM_CHAR: SCALAR_SIMP(char, b, uint32_t, c, uint32_t, c, eql_rr);
		case ELEM_CELL: SCALAR_SIMP_CELL(uint32_t, c, equal_f);
		default: err = 99; goto fail;
		}break;
	case ELEM_CELL:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_CELL_SIMP(char, b, equal_f);
		case ELEM_INT: SCALAR_CELL_SIMP(int64_t, i, equal_f);
		case ELEM_FLOAT: SCALAR_CELL_SIMP(double, f, equal_f);
		case ELEM_CMPX: SCALAR_CELL_SIMP(struct apl_cmpx, j, equal_f);
		case ELEM_CHAR: SCALAR_CELL_SIMP(uint32_t, c, equal_f);
		case ELEM_CELL: SCALAR_CELL_CELL(equal_f);
		default:err = 99; goto fail;
		}break;
	default:err = 99; goto fail;
	}
	
	*z = t;
	
	return 0;
	
fail:
	free_cell(t);
	
	return err;
}

int (*eql_fn[])(struct cell *, struct cell **, struct cell *, struct cell *, struct cell ***) = {
	syntaxerr_f, equal_f
};
struct cell eql_c = {
	1, CELL_FUNC, NULL, .f = {
		eql_fn, NULL, NULL, NULL
	}
};
EXPORT struct cell *eql = &eql_c;

EXPORT int
minus_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
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
	
	if ((err = get_scalar_cell(&t, l, r, ELEM_INT, ELEM_MAX)))
		goto fail;
	
	if (t->a.stg == STG_DEVICE) {
		err = 16;
		goto fail;
	}
	
	cnt = array_count(t, 1);
	
	#define sub_real(zt, z, l, r) (z) = (zt)(l) - (zt)(r)
	#define sub_real_cmpx(zt, z, l, r) {	\
		(z).real = (l) - (r).real;	\
		(z).imag = (r).imag;		\
	}
	#define sub_cmpx_real(zt, z, l, r) {	\
		(z).real = (l).real - (r);	\
		(z).imag = (l).imag;		\
	}
	#define sub_cmpx_cmpx(zt, z, l, r) {	\
		(z).real = (l).real - (r).real;	\
		(z).imag = (l).imag - (l).imag;	\
	}
		
	switch (l->a.etyp) {
	case ELEM_BOOL:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_SIMP(int64_t, i, char, b, char, b, sub_real);
		case ELEM_INT: SCALAR_SIMP(int64_t, i, char, b, int64_t, i, sub_real);
		case ELEM_FLOAT: SCALAR_SIMP(double, f, char, b, double, f, sub_real);
		case ELEM_CMPX: SCALAR_SIMP(struct apl_cmpx, j, char, b, struct apl_cmpx, j, sub_real_cmpx);
		case ELEM_CHAR:err = 99; goto fail;
		case ELEM_CELL: SCALAR_SIMP_CELL(char, b, minus_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_INT:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_SIMP(int64_t, i, int64_t, i, char, b, sub_real);
		case ELEM_INT: SCALAR_SIMP(int64_t, i, int64_t, i, int64_t, i, sub_real);
		case ELEM_FLOAT: SCALAR_SIMP(double, f, int64_t, i, double, f, sub_real);
		case ELEM_CMPX: SCALAR_SIMP(struct apl_cmpx, j, int64_t, i, struct apl_cmpx, j, sub_real_cmpx);
		case ELEM_CHAR:err = 99; goto fail;
		case ELEM_CELL: SCALAR_SIMP_CELL(int64_t, i, minus_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_FLOAT:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_SIMP(double, f, double, f, char, b, sub_real);
		case ELEM_INT: SCALAR_SIMP(double, f, double, f, int64_t, i, sub_real);
		case ELEM_FLOAT: SCALAR_SIMP(double, f, double, f, double, f, sub_real);
		case ELEM_CMPX:  SCALAR_SIMP(struct apl_cmpx, j, double, f, struct apl_cmpx, j, sub_real_cmpx);
		case ELEM_CHAR:err = 99; goto fail;
		case ELEM_CELL: SCALAR_SIMP_CELL(double, f, minus_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_CMPX:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_SIMP(struct apl_cmpx, j, struct apl_cmpx, j, char, b, sub_cmpx_real);
		case ELEM_INT: SCALAR_SIMP(struct apl_cmpx, j, struct apl_cmpx, j, int64_t, i, sub_cmpx_real);
		case ELEM_FLOAT: SCALAR_SIMP(struct apl_cmpx, j, struct apl_cmpx, j, double, f, sub_cmpx_real);
		case ELEM_CMPX: SCALAR_SIMP(struct apl_cmpx, j, struct apl_cmpx, j, struct apl_cmpx, j, sub_cmpx_cmpx);
		case ELEM_CHAR:err = 99; goto fail;
		case ELEM_CELL: SCALAR_SIMP_CELL(struct apl_cmpx, j, minus_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_CHAR:err = 99; goto fail;
	case ELEM_CELL:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_CELL_SIMP(char, b, minus_f);
		case ELEM_INT: SCALAR_CELL_SIMP(int64_t, i, minus_f);
		case ELEM_FLOAT: SCALAR_CELL_SIMP(double, f, minus_f);
		case ELEM_CMPX: SCALAR_CELL_SIMP(struct apl_cmpx, j, minus_f);
		case ELEM_CHAR:err = 99; goto fail;
		case ELEM_CELL: SCALAR_CELL_CELL(minus_f);
		default:err = 99; goto fail;
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
negate_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
{
	l; fv;
	
	return minus_f(s, z, &scl_zero, r, NULL);
}

int (*sub_fn[])(struct cell *, struct cell **, struct cell *, struct cell *, struct cell ***) = {
	negate_f, minus_f
};
struct cell sub_c = {
	1, CELL_FUNC, NULL, .f = {
		sub_fn, NULL, NULL, NULL
	}
};
EXPORT struct cell *sub = &sub_c;

static struct apl_cmpx
nlg_cmpx(struct apl_cmpx x)
{
	struct apl_cmpx z;
	
#ifdef _MSC_VER
	_Dcomplex tx = {x.real, x.imag};	
	_Dcomplex tz;
#else
	double complex tz, tx;

	tx = x.real + x.imag * I;
#endif
	
	tz = clog(tx);
	
	z.real = creal(tz);
	z.imag = cimag(tz);
	
	return z;
}

EXPORT int
natlog_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
{
	struct cell *t;
	int64_t cnt;
	int err;
	
	s; l; fv;
	
	t = NULL;
	
	if (r->a.etyp == ELEM_CHAR) { err = 11; goto fail; }
	if (r->a.stg == STG_DEVICE) { err = 16; goto fail; }
	
	cnt = array_count(r, 0);
	
	if (!cnt) {
		t = ref_cell(r);
		goto done;
	}
	
	if (!(t = get_cell())) { err = 1; goto fail; }
	
	t->ctyp = CELL_ARRAY;
	t->a = r->a;
	
	if (t->a.etyp == ELEM_INT) t->a.etyp = ELEM_FLOAT;
	if (t->a.rnk) {
		t->a.shp->refc++;
		t->a.host = get_host_buffer(buffer_size(t->a.etyp, cnt));
		
		if (!t->a.host) { err = 1; goto fail; }
		if (t->a.etyp == ELEM_CELL) 
			memset(t->a.host->p, 0, sizeof(struct cell *) * cnt);
	}
	
	#define nlg_r(zt, z, r) (z) = log((double)(r));
	#define nlg_j(zt, z, r) (z) = nlg_cmpx(r);
	#define nlg_p(zt, z, r) {				\
		err = natlog_f(NULL, &(z), NULL, (r), NULL);    \
		if (err) goto fail;                             \
	}
	
	switch (r->a.etyp) {
	case ELEM_BOOL: SCALAR_MON(double, f, char, b, nlg_r);
	case ELEM_INT: SCALAR_MON(double, f, int64_t, i, nlg_r);
	case ELEM_FLOAT: SCALAR_MON(double, f, double, f, nlg_r);
	case ELEM_CMPX: SCALAR_MON(struct apl_cmpx, j, struct apl_cmpx, j, nlg_j);
	case ELEM_CELL: SCALAR_MON(struct cell *, p, struct cell *, p, nlg_p);
	default: err = 99; goto fail;
	}
	
	
done:
	*z = t;
	
	return 0;
	
fail:
	free_cell(t);
	
	return err;
}

static struct apl_cmpx
log_cmpx(struct apl_cmpx x, struct apl_cmpx y)
{
	struct apl_cmpx a, b;

#ifdef _MSC_VER
	_Dcomplex tx = {x.real, x.imag};
	_Dcomplex ty = {y.real, y.imag};
	_Dcomplex tz;
#else
	double complex tx, ty, tz;

	tx = x.real + x.imag * I;
	ty = y.real + y.imag * I;
#endif

	tz = clog(tx);
	a.real = creal(tz);
	a.imag = cimag(tz);
	
	tz = clog(ty);
	b.real = creal(tz);
	b.imag = cimag(tz);
	
	return div_cmpx(b, a);
}

EXPORT int
logarithm_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
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
	
	if ((err = get_scalar_cell(&t, l, r, ELEM_FLOAT, ELEM_MAX)))
		goto fail;
	
	if (t->a.stg == STG_DEVICE) {
		err = 16;
		goto fail;
	}
	
	cnt = array_count(t, 0);
	
	if (!cnt) { 
		free_cell(t);
		if (!l->a.rnk) t = ref_cell(r);
		else if (!r->a.rnk) t = ref_cell(l);
		else t = ref_cell(r);
		goto done;
	}
	
	#define log_rr(zt, z, l, r) (z) = log((double)(r)) / log((double)(l));
	#define log_rj(zt, z, l, r) {			\
		struct apl_cmpx x = {(double)(l), 0};	\
		(z) = log_cmpx(x, (r));			\
	}
	#define log_jr(zt, z, l, r) {			\
		struct apl_cmpx y = {(double)(r), 0};	\
		(z) = log_cmpx((l), y);			\
	}
	#define log_jj(zt, z, l, r) (z) = log_cmpx((l), (r));
	
	switch (l->a.etyp) {
	case ELEM_BOOL:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_SIMP(double, f, char, b, char, b, log_rr);
		case ELEM_INT: SCALAR_SIMP(double, f, char, b, int64_t, i, log_rr);
		case ELEM_FLOAT: SCALAR_SIMP(double, f, char, b, double, f, log_rr);
		case ELEM_CMPX: SCALAR_SIMP(struct apl_cmpx, j, char, b, struct apl_cmpx, j, log_rj);
		case ELEM_CHAR:err = 99; goto fail;
		case ELEM_CELL: SCALAR_SIMP_CELL(char, b, logarithm_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_INT:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_SIMP(double, f, int64_t, i, char, b, log_rr);
		case ELEM_INT: SCALAR_SIMP(double, f, int64_t, i, int64_t, i, log_rr);
		case ELEM_FLOAT: SCALAR_SIMP(double, f, int64_t, i, double, f, log_rr);
		case ELEM_CMPX: SCALAR_SIMP(struct apl_cmpx, j, int64_t, i, struct apl_cmpx, j, log_rj);
		case ELEM_CHAR:err = 99; goto fail;
		case ELEM_CELL: SCALAR_SIMP_CELL(int64_t, i, logarithm_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_FLOAT:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_SIMP(double, f, double, f, char, b, log_rr);
		case ELEM_INT: SCALAR_SIMP(double, f, double, f, int64_t, i, log_rr);
		case ELEM_FLOAT: SCALAR_SIMP(double, f, double, f, double, f, log_rr);
		case ELEM_CMPX:  SCALAR_SIMP(struct apl_cmpx, j, double, f, struct apl_cmpx, j, log_rj);
		case ELEM_CHAR:err = 99; goto fail;
		case ELEM_CELL: SCALAR_SIMP_CELL(double, f, logarithm_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_CMPX:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_SIMP(struct apl_cmpx, j, struct apl_cmpx, j, char, b, log_jr);
		case ELEM_INT: SCALAR_SIMP(struct apl_cmpx, j, struct apl_cmpx, j, int64_t, i, log_jr);
		case ELEM_FLOAT: SCALAR_SIMP(struct apl_cmpx, j, struct apl_cmpx, j, double, f, log_jr);
		case ELEM_CMPX: SCALAR_SIMP(struct apl_cmpx, j, struct apl_cmpx, j, struct apl_cmpx, j, log_jj);
		case ELEM_CHAR:err = 99; goto fail;
		case ELEM_CELL: SCALAR_SIMP_CELL(struct apl_cmpx, j, logarithm_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_CHAR:err = 99; goto fail;
	case ELEM_CELL:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_CELL_SIMP(char, b, logarithm_f);
		case ELEM_INT: SCALAR_CELL_SIMP(int64_t, i, logarithm_f);
		case ELEM_FLOAT: SCALAR_CELL_SIMP(double, f, logarithm_f);
		case ELEM_CMPX: SCALAR_CELL_SIMP(struct apl_cmpx, j, logarithm_f);
		case ELEM_CHAR:err = 99; goto fail;
		case ELEM_CELL: SCALAR_CELL_CELL(logarithm_f);
		default:err = 99; goto fail;
		}break;
	default:
		err = 99;
		goto fail;
	}

done:
	*z = t;
	
	return 0;
	
fail:
	free_cell(t);
	
	return err;
}

int (*log_fn[])(struct cell *, struct cell **, struct cell *, struct cell *, struct cell ***) = {
	natlog_f, logarithm_f
};
struct cell log_c = {
	1, CELL_FUNC, NULL, .f = {
		log_fn, NULL, NULL, NULL
	}
};
EXPORT struct cell *cd_log = &log_c;

double
abs_cmpx(struct apl_cmpx x)
{
#ifdef _MSC_VER
	_Dcomplex tx = {x.real, x.imag};	
#else
	double complex tx;

	tx = x.real + x.imag * I;
#endif
	
	return cabs(tx);
}

EXPORT int
absolute_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
{
	struct cell *t;
	int64_t cnt;
	int err;
	
	s; l; fv;
	
	t = NULL;
	
	if (r->a.etyp == ELEM_CHAR) { err = 11; goto fail; }
	if (r->a.stg == STG_DEVICE) { err = 16; goto fail; }
	
	cnt = array_count(r, 0);
	
	if (!cnt || r->a.etyp == ELEM_BOOL) {
		t = ref_cell(r);
		goto done;
	}
	
	if (!(t = get_cell())) { err = 1; goto fail; }
	
	t->ctyp = CELL_ARRAY;
	t->a = r->a;
	
	if (t->a.etyp == ELEM_CMPX) t->a.etyp = ELEM_FLOAT;
	if (t->a.rnk) {
		t->a.shp->refc++;
		t->a.host = get_host_buffer(buffer_size(t->a.etyp, cnt));
		
		if (!t->a.host) { err = 1; goto fail; }
		if (t->a.etyp == ELEM_CELL) 
			memset(t->a.host->p, 0, sizeof(struct cell *) * cnt);
	}
	
	#define abs_i(zt, z, r) (z) = llabs(r);
	#define abs_f(zt, z, r) (z) = fabs(r);
	#define abs_j(zt, z, r) (z) = abs_cmpx(r);
	#define abs_p(zt, z, r) {				\
		err = absolute_f(NULL, &(z), NULL, (r), NULL);	\
		if (err) goto fail;				\
	}
	
	switch (r->a.etyp) {
	case ELEM_INT: SCALAR_MON(int64_t, i, int64_t, i, abs_i);
	case ELEM_FLOAT: SCALAR_MON(double, f, double, f, abs_f);
	case ELEM_CMPX: SCALAR_MON(double, f, struct apl_cmpx, j, abs_j);
	case ELEM_CELL: SCALAR_MON(struct cell *, p, struct cell *, p, abs_p);
	default: err = 99; goto fail;
	}
	
	
done:
	*z = t;
	
	return 0;
	
fail:
	free_cell(t);
	
	return err;
}

static struct apl_cmpx
floor_cmpx(struct apl_cmpx x)
{
	struct apl_cmpx z;
	double ad, bd, af, bf;
	
	af = floor(x.real);
	bf = floor(x.imag);
	ad = x.real - af;
	bd = x.imag - bf;
	
	if (1 > ad + bd) {
		z.real = af;
		z.imag = bf;
	} else if (ad < bd) {
		z.real = af;
		z.imag = 1 + bf;
	} else {
		z.real = 1 + af;
		z.imag = bf;
	}

	return z;
}

static struct apl_cmpx
residue_cmpx(struct apl_cmpx x, struct apl_cmpx y)
{
	struct apl_cmpx z;
	
	if (!x.real && !x.imag)
		x.real++;
	
	z = div_cmpx(y, x);
	z = floor_cmpx(z);
	
	z.real = x.real * z.real - x.imag * z.imag;
	z.imag = x.imag * z.real + x.real * z.imag;
	
	z.real = y.real - z.real;
	z.imag = y.imag - z.real;
	
	return z;
}

static char
residue_bool(char x, char y)
{
	return x < y;
}

static int64_t
residue_int(int64_t x, int64_t y)
{
	if (!x)
		return y;
	else if (y >= 0 && x >= 0) {
		return y % x;
	} else {
		return ((y % x) + x) % x;
	}
}

static double
residue_dbl(double x, double y)
{
	if (!x)
		return y;
	else if (y >= 0 && x >= 0) {
		return fmod(y, x);
	} else {
		return fmod(fmod(y, x) + x, x);
	}
}

EXPORT int
residue_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
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
	
	if ((err = get_scalar_cell(&t, l, r, ELEM_BOOL, ELEM_MAX)))
		goto fail;
			
	if (t->a.stg == STG_DEVICE) {
		err = 16;
		goto fail;
	}
	
	cnt = array_count(t, 0);
	
	if (!cnt) { 
		free_cell(t);
		if (!l->a.rnk) t = ref_cell(r);
		else if (!r->a.rnk) t = ref_cell(l);
		else t = ref_cell(r);
		goto done;
	}
	
	#define res_bb(zt, z, l, r) (z) = residue_bool((l), (r));
	#define res_ii(zt, z, l, r) (z) = residue_int((l), (r));
	#define res_ff(zt, z, l, r) (z) = residue_dbl((double)(l), (double)(r));
	#define res_rj(zt, z, l, r) {			\
		struct apl_cmpx x = {(double)(l), 0};	\
		(z) = residue_cmpx(x, (r));		\
	}
	#define res_jr(zt, z, l, r) {			\
		struct apl_cmpx y = {(double)(r), 0};	\
		(z) = residue_cmpx((l), y);		\
	}
	#define res_jj(zt, z, l, r) (z) = residue_cmpx((l), (r));

	switch (l->a.etyp) {
	case ELEM_BOOL:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_SIMP(char, b, char, b, char, b, res_bb);
		case ELEM_INT: SCALAR_SIMP(int64_t, i, char, b, int64_t, i, res_ii);
		case ELEM_FLOAT: SCALAR_SIMP(double, f, char, b, double, f, res_ff);
		case ELEM_CMPX: SCALAR_SIMP(struct apl_cmpx, j, char, b, struct apl_cmpx, j, res_rj);
		case ELEM_CHAR:err = 99; goto fail;
		case ELEM_CELL: SCALAR_SIMP_CELL(char, b, residue_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_INT:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_SIMP(int64_t, i, int64_t, i, char, b, res_ii);
		case ELEM_INT: SCALAR_SIMP(int64_t, i, int64_t, i, int64_t, i, res_ii);
		case ELEM_FLOAT: SCALAR_SIMP(double, f, int64_t, i, double, f, res_ff);
		case ELEM_CMPX: SCALAR_SIMP(struct apl_cmpx, j, int64_t, i, struct apl_cmpx, j, res_rj);
		case ELEM_CHAR:err = 99; goto fail;
		case ELEM_CELL: SCALAR_SIMP_CELL(int64_t, i, residue_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_FLOAT:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_SIMP(double, f, double, f, char, b, res_ff);
		case ELEM_INT: SCALAR_SIMP(double, f, double, f, int64_t, i, res_ff);
		case ELEM_FLOAT: SCALAR_SIMP(double, f, double, f, double, f, res_ff);
		case ELEM_CMPX:  SCALAR_SIMP(struct apl_cmpx, j, double, f, struct apl_cmpx, j, res_rj);
		case ELEM_CHAR:err = 99; goto fail;
		case ELEM_CELL: SCALAR_SIMP_CELL(double, f, residue_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_CMPX:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_SIMP(struct apl_cmpx, j, struct apl_cmpx, j, char, b, res_jr);
		case ELEM_INT: SCALAR_SIMP(struct apl_cmpx, j, struct apl_cmpx, j, int64_t, i, res_jr);
		case ELEM_FLOAT: SCALAR_SIMP(struct apl_cmpx, j, struct apl_cmpx, j, double, f, res_jr);
		case ELEM_CMPX: SCALAR_SIMP(struct apl_cmpx, j, struct apl_cmpx, j, struct apl_cmpx, j, res_jj);
		case ELEM_CHAR:err = 99; goto fail;
		case ELEM_CELL: SCALAR_SIMP_CELL(struct apl_cmpx, j, residue_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_CHAR:err = 99; goto fail;
	case ELEM_CELL:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_CELL_SIMP(char, b, residue_f);
		case ELEM_INT: SCALAR_CELL_SIMP(int64_t, i, residue_f);
		case ELEM_FLOAT: SCALAR_CELL_SIMP(double, f, residue_f);
		case ELEM_CMPX: SCALAR_CELL_SIMP(struct apl_cmpx, j, residue_f);
		case ELEM_CHAR:err = 99; goto fail;
		case ELEM_CELL: SCALAR_CELL_CELL(residue_f);
		default:err = 99; goto fail;
		}break;
	default:
		err = 99;
		goto fail;
	}

done:
	*z = t;
	
	return 0;
	
fail:
	free_cell(t);
	
	return err;
}

int (*res_fn[])(struct cell *, struct cell **, struct cell *, struct cell *, struct cell ***) = {
	absolute_f, residue_f
};
struct cell res_c = {
	1, CELL_FUNC, NULL, .f = {
		res_fn, NULL, NULL, NULL
	}
};
EXPORT struct cell *cd_res = &res_c;

EXPORT int
floor_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
{
	struct cell *t;
	int64_t cnt;
	int err;
	
	s; l; fv;
	
	t = NULL;
	
	if (r->a.etyp == ELEM_CHAR) { err = 11; goto fail; }
	if (r->a.stg == STG_DEVICE) { err = 16; goto fail; }
	
	cnt = array_count(r, 0);
	
	if (!cnt || r->a.etyp == ELEM_BOOL || r->a.etyp == ELEM_INT) {
		t = ref_cell(r);
		goto done;
	}
	
	if (!(t = get_cell())) { err = 1; goto fail; }
	
	t->ctyp = CELL_ARRAY;
	t->a = r->a;
	
	if (t->a.rnk) {
		t->a.shp->refc++;
		t->a.host = get_host_buffer(buffer_size(t->a.etyp, cnt));
		
		if (!t->a.host) { err = 1; goto fail; }
		if (t->a.etyp == ELEM_CELL)
			memset(t->a.host->p, 0, sizeof(struct cell *) * cnt);
	}
	
	#define floor_r(zt, z, r) (z) = floor(r);
	#define floor_j(zt, z, r) (z) = floor_cmpx(r);
	#define floor_p(zt, z, r) {				\
		err = floor_f(NULL, &(z), NULL, (r), NULL);     \
		if (err) goto fail;                             \
	}
	
	switch (r->a.etyp) {
	case ELEM_FLOAT: SCALAR_MON(double, f, double, f, floor_r);
	case ELEM_CMPX: SCALAR_MON(struct apl_cmpx, j, struct apl_cmpx, j, floor_j);
	case ELEM_CELL: SCALAR_MON(struct cell *, p, struct cell *, p, floor_p);
	default: err = 99; goto fail;
	}
	
done:
	*z = t;
	
	return 0;
	
fail:
	free_cell(t);
	
	return err;
}

#define min_real(x, y) (x < y ? x : y)

EXPORT int
minimum_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
{
	struct cell *t;
	int64_t cnt;
	int err;
	
	fv;
	
	if (s != NULL && s->f.axis != NULL)
		return 16;
	
	t = NULL;
	
	if (l->a.etyp == ELEM_CHAR || r->a.etyp == ELEM_CHAR
	    || l->a.etyp == ELEM_CMPX || r->a.etyp == ELEM_CMPX) {
		err = 11;
		goto fail;
	}
	
	if ((err = get_scalar_cell(&t, l, r, ELEM_BOOL, ELEM_MAX)))
		goto fail;
			
	if (t->a.stg == STG_DEVICE) {
		err = 16;
		goto fail;
	}
	
	cnt = array_count(t, 0);
	
	if (!cnt) { 
		free_cell(t);
		if (!l->a.rnk) t = ref_cell(r);
		else if (!r->a.rnk) t = ref_cell(l);
		else t = ref_cell(r);
		goto done;
	}
	
	#define min_r(zt, z, l, r) (z) = (zt)((l) < (r) ? (l) : (r));
	
	switch (l->a.etyp) {
	case ELEM_BOOL:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_SIMP(char, b, char, b, char, b, min_r);
		case ELEM_INT: SCALAR_SIMP(int64_t, i, char, b, int64_t, i, min_r);
		case ELEM_FLOAT: SCALAR_SIMP(double, f, char, b, double, f, min_r);
		case ELEM_CHAR:err = 99; goto fail;
		case ELEM_CELL: SCALAR_SIMP_CELL(char, b, minimum_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_INT:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_SIMP(int64_t, i, int64_t, i, char, b, min_r);
		case ELEM_INT: SCALAR_SIMP(int64_t, i, int64_t, i, int64_t, i, min_r);
		case ELEM_FLOAT: SCALAR_SIMP(double, f, int64_t, i, double, f, min_r);
		case ELEM_CHAR:err = 99; goto fail;
		case ELEM_CELL: SCALAR_SIMP_CELL(int64_t, i, minimum_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_FLOAT:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_SIMP(double, f, double, f, char, b, min_r);
		case ELEM_INT: SCALAR_SIMP(double, f, double, f, int64_t, i, min_r);
		case ELEM_FLOAT: SCALAR_SIMP(double, f, double, f, double, f, min_r);
		case ELEM_CHAR:err = 99; goto fail;
		case ELEM_CELL: SCALAR_SIMP_CELL(double, f, minimum_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_CELL:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_CELL_SIMP(char, b, minimum_f);
		case ELEM_INT: SCALAR_CELL_SIMP(int64_t, i, minimum_f);
		case ELEM_FLOAT: SCALAR_CELL_SIMP(double, f, minimum_f);
		case ELEM_CHAR:err = 99; goto fail;
		case ELEM_CELL: SCALAR_CELL_CELL(minimum_f);
		default:err = 99; goto fail;
		}break;
	default:
		err = 99;
		goto fail;
	}

done:
	*z = t;
	
	return 0;
	
fail:
	free_cell(t);
	
	return err;
}

int (*min_fn[])(struct cell *, struct cell **, struct cell *, struct cell *, struct cell ***) = {
	floor_f, minimum_f
};
struct cell min_c = {
	1, CELL_FUNC, NULL, .f = {
		min_fn, NULL, NULL, NULL
	}
};
EXPORT struct cell *min = &min_c;

struct apl_cmpx
ceil_cmpx(struct apl_cmpx x)
{
	struct apl_cmpx z;
	
	z.real = -x.real;
	z.imag = -x.imag;
	
	z = floor_cmpx(z);
	
	z.real = -z.real;
	z.imag = -z.imag;
	
	return z;
}

EXPORT int
ceiling_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
{
	struct cell *t;
	int64_t cnt;
	int err;
	
	s; l; fv;
	
	t = NULL;
	
	if (r->a.etyp == ELEM_CHAR) { err = 11; goto fail; }
	if (r->a.stg == STG_DEVICE) { err = 16; goto fail; }
	
	cnt = array_count(r, 0);
	
	if (!cnt || r->a.etyp == ELEM_BOOL || r->a.etyp == ELEM_INT) {
		t = ref_cell(r);
		goto done;
	}
	
	if (!(t = get_cell())) { err = 1; goto fail; }
	
	t->ctyp = CELL_ARRAY;
	t->a = r->a;
	
	if (t->a.rnk) {
		t->a.shp->refc++;
		t->a.host = get_host_buffer(buffer_size(t->a.etyp, cnt));
		
		if (!t->a.host) { err = 1; goto fail; }
		if (t->a.etyp == ELEM_CELL)
			memset(t->a.host->p, 0, sizeof(struct cell *) * cnt);
	}
	
	#define ceil_r(zt, z, r) (z) = ceil(r);
	#define ceil_j(zt, z, r) (z) = ceil_cmpx(r);
	#define ceil_p(zt, z, r) {				\
		err = ceiling_f(NULL, &(z), NULL, (r), NULL);   \
		if (err) goto fail;                             \
	}
	
	switch (r->a.etyp) {
	case ELEM_FLOAT: SCALAR_MON(double, f, double, f, ceil_r);
	case ELEM_CMPX: SCALAR_MON(struct apl_cmpx, j, struct apl_cmpx, j, ceil_j);
	case ELEM_CELL: SCALAR_MON(struct cell *, p, struct cell *, p, ceil_p);
	default: err = 99; goto fail;
	}
	
done:
	*z = t;
	
	return 0;
	
fail:
	free_cell(t);
	
	return err;
}

#define max_real(x, y) (x > y ? x : y)

EXPORT int
maximum_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
{
	struct cell *t;
	int64_t cnt;
	int err;
	
	fv;
	
	if (s != NULL && s->f.axis != NULL)
		return 16;
	
	t = NULL;
	
	if (l->a.etyp == ELEM_CHAR || r->a.etyp == ELEM_CHAR
	    || l->a.etyp == ELEM_CMPX || r->a.etyp == ELEM_CMPX) {
		err = 11;
		goto fail;
	}
	
	if ((err = get_scalar_cell(&t, l, r, ELEM_BOOL, ELEM_MAX)))
		goto fail;
			
	if (t->a.stg == STG_DEVICE) {
		err = 16;
		goto fail;
	}
	
	cnt = array_count(t, 0);
	
	if (!cnt) { 
		free_cell(t);
		if (!l->a.rnk) t = ref_cell(r);
		else if (!r->a.rnk) t = ref_cell(l);
		else t = ref_cell(r);
		goto done;
	}
	
	#define max_r(zt, z, l, r) (z) = (zt)((l) > (r) ? (l) : (r));

	switch (l->a.etyp) {
	case ELEM_BOOL:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_SIMP(char, b, char, b, char, b, max_r);
		case ELEM_INT: SCALAR_SIMP(int64_t, i, char, b, int64_t, i, max_r);
		case ELEM_FLOAT: SCALAR_SIMP(double, f, char, b, double, f, max_r);
		case ELEM_CHAR:err = 99; goto fail;
		case ELEM_CELL: SCALAR_SIMP_CELL(char, b, maximum_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_INT:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_SIMP(int64_t, i, int64_t, i, char, b, max_r);
		case ELEM_INT: SCALAR_SIMP(int64_t, i, int64_t, i, int64_t, i, max_r);
		case ELEM_FLOAT: SCALAR_SIMP(double, f, int64_t, i, double, f, max_r);
		case ELEM_CHAR:err = 99; goto fail;
		case ELEM_CELL: SCALAR_SIMP_CELL(int64_t, i, maximum_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_FLOAT:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_SIMP(double, f, double, f, char, b, max_r);
		case ELEM_INT: SCALAR_SIMP(double, f, double, f, int64_t, i, max_r);
		case ELEM_FLOAT: SCALAR_SIMP(double, f, double, f, double, f, max_r);
		case ELEM_CHAR:err = 99; goto fail;
		case ELEM_CELL: SCALAR_SIMP_CELL(double, f, maximum_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_CELL:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_CELL_SIMP(char, b, maximum_f);
		case ELEM_INT: SCALAR_CELL_SIMP(int64_t, i, maximum_f);
		case ELEM_FLOAT: SCALAR_CELL_SIMP(double, f, maximum_f);
		case ELEM_CHAR:err = 99; goto fail;
		case ELEM_CELL: SCALAR_CELL_CELL(maximum_f);
		default:err = 99; goto fail;
		}break;
	default:
		err = 99;
		goto fail;
	}
	
done:
	*z = t;
	
	return 0;
	
fail:
	free_cell(t);
	
	return err;
}

int (*max_fn[])(struct cell *, struct cell **, struct cell *, struct cell *, struct cell ***) = {
	ceiling_f, maximum_f
};
struct cell max_c = {
	1, CELL_FUNC, NULL, .f = {
		max_fn, NULL, NULL, NULL
	}
};
EXPORT struct cell *max = &max_c;

EXPORT int
without_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
{
	s; z; l; r; fv;
	
	return 16;
}

EXPORT int
notscl_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
{
	struct cell *t;
	int64_t cnt;
	int err;
	
	s; l; fv;
	
	t = NULL;
	
	if (r->a.etyp == ELEM_INT) { err = 11; goto fail; }
	if (r->a.etyp == ELEM_CHAR) { err = 11; goto fail; }
	if (r->a.etyp == ELEM_CMPX) { err = 11; goto fail; }
	if (r->a.etyp == ELEM_FLOAT) { err = 11; goto fail; }
	if (r->a.stg == STG_DEVICE) { err = 16; goto fail; }
	
	cnt = array_count(r, 0);
	
	if (!cnt) {
		t = ref_cell(r);
		goto done;
	}
	
	if (!(t = get_cell())) { err = 1; goto fail; }
	
	t->ctyp = CELL_ARRAY;
	t->a = r->a;
	t->a.etyp = ELEM_BOOL;
	
	if (t->a.rnk) {
		t->a.shp->refc++;
		t->a.host = get_host_buffer(buffer_size(t->a.etyp, cnt));
		
		if (!t->a.host) { err = 1; goto fail; }
		if (t->a.etyp == ELEM_CELL)
			memset(t->a.host->p, 0, sizeof(struct cell *) * cnt);
	}
	
	#define not_r(zt, z, r) (z) = !(r);
	#define not_p(zt, z, r) {				\
		err = notscl_f(NULL, &(z), NULL, (r), NULL);    \
		if (err) goto fail;                             \
	}
	
	switch (r->a.etyp) {
	case ELEM_BOOL: SCALAR_MON(char, b, char, b, not_r);
	case ELEM_CELL: SCALAR_MON(struct cell *, p, struct cell *, p, not_p);
	default: err = 99; goto fail;
	}
	
done:
	*z = t;
	
	return 0;
	
fail:
	free_cell(t);
	
	return err;
}

int (*not_fn[])(struct cell *, struct cell **, struct cell *, struct cell *, struct cell ***) = {
	notscl_f, without_f
};
struct cell not_c = {
	1, CELL_FUNC, NULL, .f = {
		not_fn, NULL, NULL, NULL
	}
};
EXPORT struct cell *not = &not_c;

EXPORT int
factorial_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
{
	struct cell *t;
	int64_t cnt;
	int err;
	
	s; l; fv;
	
	t = NULL;
	
	if (r->a.etyp == ELEM_CHAR) { err = 11; goto fail; }
	if (r->a.stg == STG_DEVICE) { err = 16; goto fail; }
	
	cnt = array_count(r, 0);
	
	if (!cnt) {
		t = ref_cell(r);
		goto done;
	}
	
	if (!(t = get_cell())) { err = 1; goto fail; }
	
	t->ctyp = CELL_ARRAY;
	t->a = r->a;
	
	if (t->a.etyp == ELEM_INT) t->a.etyp = ELEM_FLOAT;
	
	if (t->a.rnk) {
		t->a.shp->refc++;
		t->a.host = get_host_buffer(buffer_size(t->a.etyp, cnt));
		
		if (!t->a.host) { err = 1; goto fail; }
		if (t->a.etyp == ELEM_CELL)
			memset(t->a.host->p, 0, sizeof(struct cell *) * cnt);
	}
	
	#define fac_b(zt, z, r) { (r); (z) = 1; }
	#define fac_r(zt, z, r) (z) = tgamma((double)(1 + (r)));
	#define fac_p(zt, z, r) {				\
		err = factorial_f(NULL, &(z), NULL, (r), NULL); \
		if (err) goto fail;                             \
	}
	
	switch (r->a.etyp) {
	case ELEM_BOOL: SCALAR_MON(char, b, char, b, fac_b);
	case ELEM_INT: SCALAR_MON(double, f, int64_t, i, fac_r);
	case ELEM_FLOAT: SCALAR_MON(double, f, double, f, fac_r);
	case ELEM_CMPX: err = 16; goto fail;
	case ELEM_CELL: SCALAR_MON(struct cell *, p, struct cell *, p, fac_p);
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
binomial_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
{
	s; z; l; r; fv;
	
	return 16;
}

int (*fac_fn[])(struct cell *, struct cell **, struct cell *, struct cell *, struct cell ***) = {
	factorial_f, binomial_f
};
struct cell fac_c = {
	1, CELL_FUNC, NULL, .f = {
		fac_fn, NULL, NULL, NULL
	}
};
EXPORT struct cell *fac = &fac_c;

EXPORT int
materialize_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
{
	int err;
	
	s; l; fv;
	
	if ((err = squeeze(r)))
		return err;
	
	*z = ref_cell(r);
	
	return 0;
}

EXPORT int
sqd_idx_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
{
	s; z; l; r; fv;
	
	return 16;
}

int (*sqd_fn[])(struct cell *, struct cell **, struct cell *, struct cell *, struct cell ***) = {
	materialize_f, sqd_idx_f
};
struct cell sqd_c = {
	1, CELL_FUNC, NULL, .f = {
		sqd_fn, NULL, NULL, NULL
	}
};
EXPORT struct cell *sqd = &sqd_c;

EXPORT int
lessthan_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
{
	struct cell *t;
	int64_t cnt;
	int err;
	
	fv;
	
	if (s != NULL && s->f.axis != NULL)
		return 16;
	
	if (l->a.etyp == ELEM_CHAR || r->a.etyp == ELEM_CHAR 
	    || l->a.etyp == ELEM_CMPX || r->a.etyp == ELEM_CMPX)
		return 11;
	
	t = NULL;
	
	if ((err = get_scalar_cell(&t, l, r, ELEM_BOOL, ELEM_BOOL)))
		goto fail;
	
	if (t->a.stg == STG_DEVICE) {
		err = 16;
		goto fail;
	}
	
	cnt = array_count(t, 1);
	
	#define lth_rr(zt, z, l, r) (z) = (l) < (r);
	
	switch (l->a.etyp) {
	case ELEM_BOOL:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_SIMP(char, b, char, b, char, b, lth_rr);
		case ELEM_INT: SCALAR_SIMP(char, b, char, b, int64_t, i, lth_rr);
		case ELEM_FLOAT: SCALAR_SIMP(char, b, char, b, double, f, lth_rr);
		case ELEM_CELL: SCALAR_SIMP_CELL(int64_t, i, lessthan_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_INT:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_SIMP(char, b, int64_t, i, char, b, lth_rr);
		case ELEM_INT: SCALAR_SIMP(char, b, int64_t, i, int64_t, i, lth_rr);
		case ELEM_FLOAT: SCALAR_SIMP(char, b, int64_t, i, double, f, lth_rr);
		case ELEM_CELL: SCALAR_SIMP_CELL(int64_t, i, lessthan_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_FLOAT:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_SIMP(char, b, double, f, char, b, lth_rr);
		case ELEM_INT: SCALAR_SIMP(char, b, double, f, int64_t, i, lth_rr);
		case ELEM_FLOAT: SCALAR_SIMP(char, b, double, f, double, f, lth_rr);
		case ELEM_CELL: SCALAR_SIMP_CELL(double, f, lessthan_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_CELL:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_CELL_SIMP(char, b, lessthan_f);
		case ELEM_INT: SCALAR_CELL_SIMP(int64_t, i, lessthan_f);
		case ELEM_FLOAT: SCALAR_CELL_SIMP(double, f, lessthan_f);
		case ELEM_CMPX: SCALAR_CELL_SIMP(struct apl_cmpx, j, lessthan_f);
		case ELEM_CELL: SCALAR_CELL_CELL(lessthan_f);
		default:err = 99; goto fail;
		}break;
	default:err = 99; goto fail;
	}
	
	*z = t;
	
	return 0;
	
fail:
	free_cell(t);
	
	return err;
}

int (*lth_fn[])(struct cell *, struct cell **, struct cell *, struct cell *, struct cell ***) = {
	syntaxerr_f, lessthan_f
};
struct cell lth_c = {
	1, CELL_FUNC, NULL, .f = {
		lth_fn, NULL, NULL, NULL
	}
};
EXPORT struct cell *lth = &lth_c;

EXPORT int
lesseql_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
{
	struct cell *t;
	int64_t cnt;
	int err;
	
	fv;
	
	if (s != NULL && s->f.axis != NULL)
		return 16;
	
	if (l->a.etyp == ELEM_CHAR || r->a.etyp == ELEM_CHAR 
	    || l->a.etyp == ELEM_CMPX || r->a.etyp == ELEM_CMPX)
		return 11;
	
	t = NULL;
	
	if ((err = get_scalar_cell(&t, l, r, ELEM_BOOL, ELEM_BOOL)))
		goto fail;
	
	if (t->a.stg == STG_DEVICE) {
		err = 16;
		goto fail;
	}
	
	cnt = array_count(t, 1);
	
	#define lte_rr(zt, z, l, r) (z) = (l) <= (r);
	
	switch (l->a.etyp) {
	case ELEM_BOOL:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_SIMP(char, b, char, b, char, b, lte_rr);
		case ELEM_INT: SCALAR_SIMP(char, b, char, b, int64_t, i, lte_rr);
		case ELEM_FLOAT: SCALAR_SIMP(char, b, char, b, double, f, lte_rr);
		case ELEM_CELL: SCALAR_SIMP_CELL(int64_t, i, lesseql_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_INT:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_SIMP(char, b, int64_t, i, char, b, lte_rr);
		case ELEM_INT: SCALAR_SIMP(char, b, int64_t, i, int64_t, i, lte_rr);
		case ELEM_FLOAT: SCALAR_SIMP(char, b, int64_t, i, double, f, lte_rr);
		case ELEM_CELL: SCALAR_SIMP_CELL(int64_t, i, lesseql_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_FLOAT:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_SIMP(char, b, double, f, char, b, lte_rr);
		case ELEM_INT: SCALAR_SIMP(char, b, double, f, int64_t, i, lte_rr);
		case ELEM_FLOAT: SCALAR_SIMP(char, b, double, f, double, f, lte_rr);
		case ELEM_CELL: SCALAR_SIMP_CELL(double, f, lesseql_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_CELL:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_CELL_SIMP(char, b, lesseql_f);
		case ELEM_INT: SCALAR_CELL_SIMP(int64_t, i, lesseql_f);
		case ELEM_FLOAT: SCALAR_CELL_SIMP(double, f, lesseql_f);
		case ELEM_CMPX: SCALAR_CELL_SIMP(struct apl_cmpx, j, lesseql_f);
		case ELEM_CELL: SCALAR_CELL_CELL(lesseql_f);
		default:err = 99; goto fail;
		}break;
	default:err = 99; goto fail;
	}
	
	*z = t;
	
	return 0;
	
fail:
	free_cell(t);
	
	return err;
}

int (*lte_fn[])(struct cell *, struct cell **, struct cell *, struct cell *, struct cell ***) = {
	syntaxerr_f, lesseql_f
};
struct cell lte_c = {
	1, CELL_FUNC, NULL, .f = {
		lte_fn, NULL, NULL, NULL
	}
};
EXPORT struct cell *lte = &lte_c;

EXPORT int
greatereql_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
{
	struct cell *t;
	int64_t cnt;
	int err;
	
	fv;
	
	if (s != NULL && s->f.axis != NULL)
		return 16;
	
	if (l->a.etyp == ELEM_CHAR || r->a.etyp == ELEM_CHAR 
	    || l->a.etyp == ELEM_CMPX || r->a.etyp == ELEM_CMPX)
		return 11;
	
	t = NULL;
	
	if ((err = get_scalar_cell(&t, l, r, ELEM_BOOL, ELEM_BOOL)))
		goto fail;
	
	if (t->a.stg == STG_DEVICE) {
		err = 16;
		goto fail;
	}
	
	cnt = array_count(t, 1);
	
	#define gte_rr(zt, z, l, r) (z) = (l) >= (r);
	
	switch (l->a.etyp) {
	case ELEM_BOOL:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_SIMP(char, b, char, b, char, b, gte_rr);
		case ELEM_INT: SCALAR_SIMP(char, b, char, b, int64_t, i, gte_rr);
		case ELEM_FLOAT: SCALAR_SIMP(char, b, char, b, double, f, gte_rr);
		case ELEM_CELL: SCALAR_SIMP_CELL(int64_t, i, greatereql_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_INT:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_SIMP(char, b, int64_t, i, char, b, gte_rr);
		case ELEM_INT: SCALAR_SIMP(char, b, int64_t, i, int64_t, i, gte_rr);
		case ELEM_FLOAT: SCALAR_SIMP(char, b, int64_t, i, double, f, gte_rr);
		case ELEM_CELL: SCALAR_SIMP_CELL(int64_t, i, greatereql_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_FLOAT:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_SIMP(char, b, double, f, char, b, gte_rr);
		case ELEM_INT: SCALAR_SIMP(char, b, double, f, int64_t, i, gte_rr);
		case ELEM_FLOAT: SCALAR_SIMP(char, b, double, f, double, f, gte_rr);
		case ELEM_CELL: SCALAR_SIMP_CELL(double, f, greatereql_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_CELL:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_CELL_SIMP(char, b, greatereql_f);
		case ELEM_INT: SCALAR_CELL_SIMP(int64_t, i, greatereql_f);
		case ELEM_FLOAT: SCALAR_CELL_SIMP(double, f, greatereql_f);
		case ELEM_CMPX: SCALAR_CELL_SIMP(struct apl_cmpx, j, greatereql_f);
		case ELEM_CELL: SCALAR_CELL_CELL(greatereql_f);
		default:err = 99; goto fail;
		}break;
	default:err = 99; goto fail;
	}
	
	*z = t;
	
	return 0;
	
fail:
	free_cell(t);
	
	return err;
}

int (*gte_fn[])(struct cell *, struct cell **, struct cell *, struct cell *, struct cell ***) = {
	syntaxerr_f, greatereql_f
};
struct cell gte_c = {
	1, CELL_FUNC, NULL, .f = {
		gte_fn, NULL, NULL, NULL
	}
};
EXPORT struct cell *gte = &gte_c;

EXPORT int
greaterthan_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
{
	struct cell *t;
	int64_t cnt;
	int err;
	
	fv;
	
	if (s != NULL && s->f.axis != NULL)
		return 16;
	
	if (l->a.etyp == ELEM_CHAR || r->a.etyp == ELEM_CHAR 
	    || l->a.etyp == ELEM_CMPX || r->a.etyp == ELEM_CMPX)
		return 11;
	
	t = NULL;
	
	if ((err = get_scalar_cell(&t, l, r, ELEM_BOOL, ELEM_BOOL)))
		goto fail;
	
	if (t->a.stg == STG_DEVICE) {
		err = 16;
		goto fail;
	}
	
	cnt = array_count(t, 1);
	
	#define gth_rr(zt, z, l, r) (z) = (l) > (r);
	
	switch (l->a.etyp) {
	case ELEM_BOOL:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_SIMP(char, b, char, b, char, b, gth_rr);
		case ELEM_INT: SCALAR_SIMP(char, b, char, b, int64_t, i, gth_rr);
		case ELEM_FLOAT: SCALAR_SIMP(char, b, char, b, double, f, gth_rr);
		case ELEM_CELL: SCALAR_SIMP_CELL(int64_t, i, greaterthan_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_INT:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_SIMP(char, b, int64_t, i, char, b, gth_rr);
		case ELEM_INT: SCALAR_SIMP(char, b, int64_t, i, int64_t, i, gth_rr);
		case ELEM_FLOAT: SCALAR_SIMP(char, b, int64_t, i, double, f, gth_rr);
		case ELEM_CELL: SCALAR_SIMP_CELL(int64_t, i, greaterthan_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_FLOAT:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_SIMP(char, b, double, f, char, b, gth_rr);
		case ELEM_INT: SCALAR_SIMP(char, b, double, f, int64_t, i, gth_rr);
		case ELEM_FLOAT: SCALAR_SIMP(char, b, double, f, double, f, gth_rr);
		case ELEM_CELL: SCALAR_SIMP_CELL(double, f, greaterthan_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_CELL:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_CELL_SIMP(char, b, greaterthan_f);
		case ELEM_INT: SCALAR_CELL_SIMP(int64_t, i, greaterthan_f);
		case ELEM_FLOAT: SCALAR_CELL_SIMP(double, f, greaterthan_f);
		case ELEM_CMPX: SCALAR_CELL_SIMP(struct apl_cmpx, j, greaterthan_f);
		case ELEM_CELL: SCALAR_CELL_CELL(greaterthan_f);
		default:err = 99; goto fail;
		}break;
	default:err = 99; goto fail;
	}
	
	*z = t;
	
	return 0;
	
fail:
	free_cell(t);
	
	return err;
}

int (*gth_fn[])(struct cell *, struct cell **, struct cell *, struct cell *, struct cell ***) = {
	syntaxerr_f, greaterthan_f
};
struct cell gth_c = {
	1, CELL_FUNC, NULL, .f = {
		gth_fn, NULL, NULL, NULL
	}
};
EXPORT struct cell *gth = &gth_c;

EXPORT int
noteq_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
{
	struct cell *t;
	int64_t cnt;
	int err;
	
	fv;
	
	if (s != NULL && s->f.axis != NULL)
		return 16;
	
	t = NULL;
	
	if ((err = get_scalar_cell(&t, l, r, ELEM_BOOL, ELEM_BOOL)))
		goto fail;
	
	if (t->a.stg == STG_DEVICE) {
		err = 16;
		goto fail;
	}
	
	cnt = array_count(t, 1);
	
	#define neq_rr(zt, z, l, r) (z) = (l) != (r);
	#define neq_rj(zt, z, l, r) (z) = ((l) != (r).real) || !(r).imag;
	#define neq_jr(zt, z, l, r) (z) = ((l).real != (r)) || !(l).imag;
	#define neq_jj(zt, z, l, r) (z) = ((l).real != (r).real) || ((l).imag != (r).imag);
	#define neq_one {					\
		if (!t->a.rnk) {                        	\
			t->a.b = 1;                     	\
		} else {                                	\
			char *restrict tv = t->a.host->b;	\
			for (int64_t i = 0; i < cnt; i++)	\
				tv[i] = 1;			\
		}                                       	\
	}break;
	
	switch (l->a.etyp) {
	case ELEM_BOOL:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_SIMP(char, b, char, b, char, b, neq_rr);
		case ELEM_INT: SCALAR_SIMP(char, b, char, b, int64_t, i, neq_rr);
		case ELEM_FLOAT: SCALAR_SIMP(char, b, char, b, double, f, neq_rr);
		case ELEM_CMPX: SCALAR_SIMP(char, b, char, b, struct apl_cmpx, j, neq_rj);
		case ELEM_CHAR: neq_one;
		case ELEM_CELL: SCALAR_SIMP_CELL(int64_t, i, noteq_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_INT:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_SIMP(char, b, int64_t, i, char, b, neq_rr);
		case ELEM_INT: SCALAR_SIMP(char, b, int64_t, i, int64_t, i, neq_rr);
		case ELEM_FLOAT: SCALAR_SIMP(char, b, int64_t, i, double, f, neq_rr);
		case ELEM_CMPX: SCALAR_SIMP(char, b, int64_t, i, struct apl_cmpx, j, neq_rj);
		case ELEM_CHAR: neq_one;
		case ELEM_CELL: SCALAR_SIMP_CELL(int64_t, i, noteq_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_FLOAT:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_SIMP(char, b, double, f, char, b, neq_rr);
		case ELEM_INT: SCALAR_SIMP(char, b, double, f, int64_t, i, neq_rr);
		case ELEM_FLOAT: SCALAR_SIMP(char, b, double, f, double, f, neq_rr);
		case ELEM_CMPX: SCALAR_SIMP(char, b, double, f, struct apl_cmpx, j, neq_rj);
		case ELEM_CHAR: neq_one;
		case ELEM_CELL: SCALAR_SIMP_CELL(double, f, noteq_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_CMPX:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_SIMP(char, b, struct apl_cmpx, j, char, b, neq_jr);
		case ELEM_INT: SCALAR_SIMP(char, b, struct apl_cmpx, j, int64_t, i, neq_jr);
		case ELEM_FLOAT: SCALAR_SIMP(char, b, struct apl_cmpx, j, double, f, neq_jr);
		case ELEM_CMPX: SCALAR_SIMP(char, b, struct apl_cmpx, j, struct apl_cmpx, j, neq_jj);
		case ELEM_CHAR: neq_one;
		case ELEM_CELL: SCALAR_SIMP_CELL(struct apl_cmpx, j, noteq_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_CHAR:
		switch (r->a.etyp) {
		case ELEM_BOOL:
		case ELEM_INT:
		case ELEM_FLOAT:
		case ELEM_CMPX: neq_one;
		case ELEM_CHAR: SCALAR_SIMP(char, b, uint32_t, c, uint32_t, c, neq_rr);
		case ELEM_CELL: SCALAR_SIMP_CELL(uint32_t, c, noteq_f);
		default: err = 99; goto fail;
		}break;
	case ELEM_CELL:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_CELL_SIMP(char, b, noteq_f);
		case ELEM_INT: SCALAR_CELL_SIMP(int64_t, i, noteq_f);
		case ELEM_FLOAT: SCALAR_CELL_SIMP(double, f, noteq_f);
		case ELEM_CMPX: SCALAR_CELL_SIMP(struct apl_cmpx, j, noteq_f);
		case ELEM_CHAR: SCALAR_CELL_SIMP(uint32_t, c, noteq_f);
		case ELEM_CELL: SCALAR_CELL_CELL(noteq_f);
		default:err = 99; goto fail;
		}break;
	default:err = 99; goto fail;
	}
	
	*z = t;
	
	return 0;
	
fail:
	free_cell(t);
	
	return err;
}

int (*neq_fn[])(struct cell *, struct cell **, struct cell *, struct cell *, struct cell ***) = {
	syntaxerr_f, noteq_f
};
struct cell neq_c = {
	1, CELL_FUNC, NULL, .f = {
		neq_fn, NULL, NULL, NULL
	}
};
EXPORT struct cell *neq = &neq_c;

static int64_t
gcd_int(int64_t a, int64_t b)
{
	int64_t t, u;
	
	a = llabs(a);
	b = llabs(b);

	while (a) {
		t = a < b ? a : b;
		u = a > b ? a : b;
		b = t ? u % t : u;
		a = t;
	}

	return b;
}

static int64_t
lcm_int(int64_t a, int64_t b)
{
	if (!a || !b)
		return 0;

	return a * (b / gcd_int(a, b));
}

static void
rational(int64_t *n, int64_t *d, double r)
{
	double a, b, x, y;
	double c[2][2] = {1, 0, 0, 1};
	
	b = r;
	
	while (1) {
		a = floor(b);
		x = c[1][0] + a * c[0][0];
		y = c[1][1] + a * c[0][1];
		
		if (r == x / y) break;
		
		c[1][0] = c[0][0];
		c[1][1] = c[0][1];
		c[0][0] = x;
		c[0][1] = y;
		
		b = 1 / (b - a);
	}
	
	*n = (int64_t)x;
	*d = (int64_t)y;
}

static double
gcd_dbl(double x, double y)
{
	int64_t a, b, c, d;
	
	x = fabs(x);
	y = fabs(y);
	
	rational(&a, &b, x);
	rational(&c, &d, y);
	
	return (double)gcd_int(a, c) / (double)lcm_int(b, d);
}

static double
lcm_dbl(double a, double b)
{
	if (!a || !b)
		return 0;
		
	return a * (b / gcd_dbl(a, b));
}

EXPORT int
logor_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
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
	
	if ((err = get_scalar_cell(&t, l, r, ELEM_BOOL, ELEM_MAX)))
		goto fail;
	
	if (t->a.stg == STG_DEVICE) {
		err = 16;
		goto fail;
	}
	
	cnt = array_count(t, 0);
	
	if (!cnt) { 
		free_cell(t);
		if (!l->a.rnk) t = ref_cell(r);
		else if (!r->a.rnk) t = ref_cell(l);
		else t = ref_cell(r);
		goto done;
	}
	
	#define lor_bb(zt, z, l, r) (z) = (zt)(l) || (zt)(r);
	#define lor_bi(zt, z, l, r) (z) = (l) ? 1 : llabs(r);
	#define lor_ib(zt, z, l, r) (z) = (r) ? 1 : llabs(l);
	#define lor_ii(zt, z, l, r) (z) = gcd_int((l), (r));
	#define lor_rr(zt, z, l, r) (z) = gcd_dbl((double)(l), (double)(r));
	#define lor_jj(zt, z, l, r) (z) = gcd_cmpx((l), (r));
	#define lor_rj(zt, z, l, r) {			\
		struct apl_cmpx x = {(double)(l), 0};   \
		(z) = gcd_cmpx(x, (r));                 \
	}
	#define lor_jr(zt, z, l, r) {			\
		struct apl_cmpx y = {(double)(r), 0};	\
		(z) = gcd_cmpx((l), y);			\
	}
		
	switch (l->a.etyp) {
	case ELEM_BOOL:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_SIMP(char, b, char, b, char, b, lor_bb);
		case ELEM_INT: SCALAR_SIMP(int64_t, i, char, b, int64_t, i, lor_bi);
		case ELEM_FLOAT: SCALAR_SIMP(double, f, char, b, double, f, lor_rr);
		case ELEM_CMPX: err = 16; goto fail;
		case ELEM_CELL: SCALAR_SIMP_CELL(char, b, logor_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_INT:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_SIMP(int64_t, i, int64_t, i, char, b, lor_ib);
		case ELEM_INT: SCALAR_SIMP(int64_t, i, int64_t, i, int64_t, i, lor_ii);
		case ELEM_FLOAT: SCALAR_SIMP(double, f, int64_t, i, double, f, lor_rr);
		case ELEM_CMPX: err = 16; goto fail;
		case ELEM_CELL: SCALAR_SIMP_CELL(int64_t, i, logor_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_FLOAT:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_SIMP(double, f, double, f, char, b, lor_rr);
		case ELEM_INT: SCALAR_SIMP(double, f, double, f, int64_t, i, lor_rr);
		case ELEM_FLOAT: SCALAR_SIMP(double, f, double, f, double, f, lor_rr);
		case ELEM_CMPX: err = 16; goto fail;
		case ELEM_CELL: SCALAR_SIMP_CELL(double, f, logor_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_CMPX: err = 16; goto fail;
	case ELEM_CELL:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_CELL_SIMP(char, b, logor_f);
		case ELEM_INT: SCALAR_CELL_SIMP(int64_t, i, logor_f);
		case ELEM_FLOAT: SCALAR_CELL_SIMP(double, f, logor_f);
		case ELEM_CMPX: SCALAR_CELL_SIMP(struct apl_cmpx, j, logor_f);
		case ELEM_CHAR:err = 99; goto fail;
		case ELEM_CELL: SCALAR_CELL_CELL(logor_f);
		default:err = 99; goto fail;
		}break;
	default:
		err = 99;
		goto fail;
	}

done:
	*z = t;
	
	return 0;
	
fail:
	free_cell(t);
	
	return err;
}

int (*lor_fn[])(struct cell *, struct cell **, struct cell *, struct cell *, struct cell ***) = {
	conjugate_f, logor_f
};
struct cell lor_c = {
	1, CELL_FUNC, NULL, .f = {
		lor_fn, NULL, NULL, NULL
	}
};
EXPORT struct cell *lor = &lor_c;

EXPORT int
logand_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
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
	
	if ((err = get_scalar_cell(&t, l, r, ELEM_BOOL, ELEM_MAX)))
		goto fail;
	
	if (t->a.stg == STG_DEVICE) {
		err = 16;
		goto fail;
	}
	
	cnt = array_count(t, 0);
	
	if (!cnt) { 
		free_cell(t);
		if (!l->a.rnk) t = ref_cell(r);
		else if (!r->a.rnk) t = ref_cell(l);
		else t = ref_cell(r);
		goto done;
	}
	
	#define and_bb(zt, z, l, r) (z) = (zt)(l) && (zt)(r);
	#define and_bi(zt, z, l, r) (z) = (l) ? (r) : 0;
	#define and_ib(zt, z, l, r) (z) = (r) ? (l) : 0;
	#define and_ii(zt, z, l, r) (z) = lcm_int((l), (r));
	#define and_rr(zt, z, l, r) (z) = lcm_dbl((double)(l), (double)(r));
	#define and_jj(zt, z, l, r) (z) = lcm_cmpx((l), (r));
	#define and_rj(zt, z, l, r) {			\
		struct apl_cmpx x = {(double)(l), 0};   \
		(z) = lcm_cmpx(x, (r));                 \
	}
	#define and_jr(zt, z, l, r) {			\
		struct apl_cmpx y = {(double)(r), 0};	\
		(z) = lcm_cmpx((l), y);			\
	}
		
	switch (l->a.etyp) {
	case ELEM_BOOL:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_SIMP(char, b, char, b, char, b, and_bb);
		case ELEM_INT: SCALAR_SIMP(int64_t, i, char, b, int64_t, i, and_bi);
		case ELEM_FLOAT: SCALAR_SIMP(double, f, char, b, double, f, and_rr);
		case ELEM_CMPX: err = 16; goto fail;
		case ELEM_CELL: SCALAR_SIMP_CELL(char, b, logand_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_INT:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_SIMP(int64_t, i, int64_t, i, char, b, and_ib);
		case ELEM_INT: SCALAR_SIMP(int64_t, i, int64_t, i, int64_t, i, and_ii);
		case ELEM_FLOAT: SCALAR_SIMP(double, f, int64_t, i, double, f, and_rr);
		case ELEM_CMPX: err = 16; goto fail;
		case ELEM_CELL: SCALAR_SIMP_CELL(int64_t, i, logand_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_FLOAT:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_SIMP(double, f, double, f, char, b, and_rr);
		case ELEM_INT: SCALAR_SIMP(double, f, double, f, int64_t, i, and_rr);
		case ELEM_FLOAT: SCALAR_SIMP(double, f, double, f, double, f, and_rr);
		case ELEM_CMPX: err = 16; goto fail;
		case ELEM_CELL: SCALAR_SIMP_CELL(double, f, logand_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_CMPX: err = 16; goto fail;
	case ELEM_CELL:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_CELL_SIMP(char, b, logand_f);
		case ELEM_INT: SCALAR_CELL_SIMP(int64_t, i, logand_f);
		case ELEM_FLOAT: SCALAR_CELL_SIMP(double, f, logand_f);
		case ELEM_CMPX: SCALAR_CELL_SIMP(struct apl_cmpx, j, logand_f);
		case ELEM_CHAR:err = 99; goto fail;
		case ELEM_CELL: SCALAR_CELL_CELL(logand_f);
		default:err = 99; goto fail;
		}break;
	default:
		err = 99;
		goto fail;
	}

done:
	*z = t;
	
	return 0;
	
fail:
	free_cell(t);
	
	return err;
}

int (*and_fn[])(struct cell *, struct cell **, struct cell *, struct cell *, struct cell ***) = {
	conjugate_f, logand_f
};
struct cell and_c = {
	1, CELL_FUNC, NULL, .f = {
		and_fn, NULL, NULL, NULL
	}
};
EXPORT struct cell *and = &and_c;

EXPORT int
lognan_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
{
	struct cell *t;
	int64_t cnt;
	int err;
	
	fv;
	
	if (s != NULL && s->f.axis != NULL)
		return 16;
		
	if (l->a.etyp != ELEM_BOOL && l->a.etyp != ELEM_CELL
	    && r->a.etyp != ELEM_BOOL && r->a.etyp != ELEM_CELL)
		return 11;
	
	t = NULL;
	
	if ((err = get_scalar_cell(&t, l, r, ELEM_BOOL, ELEM_BOOL)))
		goto fail;
	
	if (t->a.stg == STG_DEVICE) {
		err = 16;
		goto fail;
	}
	
	cnt = array_count(t, 1);
	
	#define nan_bb(zt, z, l, r) (z) = !((l) && (r));
	
	switch (l->a.etyp) {
	case ELEM_BOOL:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_SIMP(char, b, char, b, char, b, nan_bb);
		case ELEM_CELL: SCALAR_SIMP_CELL(int64_t, i, lognan_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_CELL:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_CELL_SIMP(char, b, lognan_f);
		case ELEM_CELL: SCALAR_CELL_CELL(lognan_f);
		default:err = 99; goto fail;
		}break;
	default:err = 99; goto fail;
	}
	
	*z = t;
	
	return 0;
	
fail:
	free_cell(t);
	
	return err;
}

int (*nan_fn[])(struct cell *, struct cell **, struct cell *, struct cell *, struct cell ***) = {
	syntaxerr_f, lognan_f
};
struct cell nan_c = {
	1, CELL_FUNC, NULL, .f = {
		nan_fn, NULL, NULL, NULL
	}
};
EXPORT struct cell *cd_nan = &nan_c;

EXPORT int
lognor_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***fv)
{
	struct cell *t;
	int64_t cnt;
	int err;
	
	fv;
	
	if (s != NULL && s->f.axis != NULL)
		return 16;
		
	if (l->a.etyp != ELEM_BOOL && l->a.etyp != ELEM_CELL
	    && r->a.etyp != ELEM_BOOL && r->a.etyp != ELEM_CELL)
		return 11;
	
	t = NULL;
	
	if ((err = get_scalar_cell(&t, l, r, ELEM_BOOL, ELEM_BOOL)))
		goto fail;
	
	if (t->a.stg == STG_DEVICE) {
		err = 16;
		goto fail;
	}
	
	cnt = array_count(t, 1);
	
	#define nor_bb(zt, z, l, r) (z) = !((l) || (r));
	
	switch (l->a.etyp) {
	case ELEM_BOOL:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_SIMP(char, b, char, b, char, b, nor_bb);
		case ELEM_CELL: SCALAR_SIMP_CELL(int64_t, i, lognor_f);
		default:err = 99; goto fail;
		}break;
	case ELEM_CELL:
		switch (r->a.etyp) {
		case ELEM_BOOL: SCALAR_CELL_SIMP(char, b, lognor_f);
		case ELEM_CELL: SCALAR_CELL_CELL(lognor_f);
		default:err = 99; goto fail;
		}break;
	default:err = 99; goto fail;
	}
	
	*z = t;
	
	return 0;
	
fail:
	free_cell(t);
	
	return err;
}

int (*nor_fn[])(struct cell *, struct cell **, struct cell *, struct cell *, struct cell ***) = {
	syntaxerr_f, lognor_f
};
struct cell nor_c = {
	1, CELL_FUNC, NULL, .f = {
		nor_fn, NULL, NULL, NULL
	}
};
EXPORT struct cell *nor = &nor_c;
