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
	ELEM_INT, ELEM_FLOAT, ELEM_CMPX, ELEM_CHAR, ELEM_DEV, ELEM_IOTA, ELEM_CELL
};

enum cell_type { CELL_VOID, CELL_SCALAR, CELL_VECTOR, CELL_ARRAY, CELL_FUNC };

struct apl_cmpx {
	double real, imag;
};

struct iota_range {
	double shift, step;
};

struct cell_scalar {
	enum elem_type etyp;
	union {
		int64_t i;
		double f;
		struct apl_cmpx j;
		uint64_t c;
		struct cell *p;
	};
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

struct cell_vector {
	enum elem_type etyp;
	int64_t cnt, bnd;
	union {
		struct host_buffer *host;
		af_array dev;
		struct iota_range iota;
	};
};

struct cell_array {
	struct cell *s, *e;
};

struct cell_func {
	int (**fn)(struct cell *, struct cell **, struct cell *, struct cell *, struct cell **);
	struct cell *aa, *ww, *axis;
};

struct cell {
	int refc;
	enum cell_type ctyp;
	struct cell *next;
	union {
		struct cell_scalar s;
		struct cell_vector v;
		struct cell_array a;
		struct cell_func f;
	};
};

struct cell *next_cell;
struct host_buffer *next_buffer[7]; /* 32 128 512 2048 8192 16384 */

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
		free_cell(c->a.s);
		free_cell(c->a.e);
		break;
	case CELL_VECTOR:
		switch (c->v.etyp) {
		case ELEM_INT:
		case ELEM_FLOAT:
		case ELEM_CMPX:
		case ELEM_CHAR:
			free_host_buffer(c->v.host);
			break;
			
		case ELEM_CELL:
			for (int64_t i = 0; i < c->v.bnd; i++)
				free_cell(c->v.host->p[i]);
			
			free_host_buffer(c->v.host);
			break;
			
		case ELEM_DEV:
			af_release_array(c->v.dev);
			break;
		
		case ELEM_IOTA:
		default:
			break;
		}
		break;
		
	case CELL_FUNC:
		/* XXX */
		break;
		
	case CELL_SCALAR:
	default:
		break;
	}
}

EXPORT struct cell *
ref_cell(struct cell *c)
{
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

EXPORT void
squeeze(struct cell *c)
{
	switch (c->ctyp) {
	case CELL_SCALAR:{
		struct cell *p;
		
		if (c->s.etyp != ELEM_CELL)
			return;
			
		p = c->s.p;
		
		if (p->ctyp != CELL_SCALAR)
			return;
		
		squeeze(p);
		
		switch (p->s.etyp) {
		case ELEM_INT:
			c->s.etyp = ELEM_INT;
			c->s.i = p->s.i;
			break;
			
		case ELEM_FLOAT:
			c->s.etyp = ELEM_FLOAT;
			c->s.f = p->s.f;
			break;
			
		case ELEM_CMPX:
			c->s.etyp = ELEM_CMPX;
			c->s.j = p->s.j;
			break;
		
		case ELEM_CHAR:
			c->s.etyp = ELEM_CHAR;
			c->s.c = p->s.c;
			break;
			
		default:
			return;
		}
		
		free_cell(p);
	}return;
		
	case CELL_VECTOR:{
		enum elem_type sqzt;
		struct cell **p;
		
		if (c->v.etyp != ELEM_CELL)
			return;
		
		if (!c->v.cnt)
			return;
			
		p = c->v.host->p;
			
		if (p[0]->ctyp != CELL_SCALAR)
			return;
			
		squeeze(p[0]);
		
		sqzt = p[0]->s.etyp;
		
		switch (sqzt) {
		case ELEM_INT:
		case ELEM_FLOAT:
		case ELEM_CMPX:
		case ELEM_CHAR:
			break;
		default:
			return;
		}
		
		for (int64_t i = 1; i < c->v.bnd; i++) {
			if (p[i]->ctyp != CELL_SCALAR)
				return;
				
			squeeze(p[i]);
				
			if (p[i]->s.etyp != sqzt)
				return;
		}
		
		switch (sqzt) {
		case ELEM_INT:
			for (int64_t i = 0; i < c->v.bnd; i++) {
				struct cell *t = p[i];
				
				c->v.host->i[i] = t->s.i;
				free_cell(t);
			}
			break;
			
		case ELEM_FLOAT:
			for (int64_t i = 0; i < c->v.bnd; i++) {
				struct cell *t = p[i];
				
				c->v.host->f[i] = t->s.f;
				free_cell(t);
			}
			break;

		case ELEM_CHAR:
			for (int64_t i = 0; i < c->v.bnd; i++) {
				struct cell *t = p[i];
				
				c->v.host->c[i] = t->s.c;
				free_cell(t);
			}
			break;

		case ELEM_CMPX:
			struct host_buffer *buf;
			
			buf = get_host_buffer(buffer_size(ELEM_CMPX, c->v.bnd));
			
			if (!buf)
				return;
			
			for (int64_t i = 0; i < c->v.bnd; i++) {
				struct cell *t = p[i];
				
				buf->j[i] = t->s.j;
				free_cell(t);
			}
			
			free_host_buffer(c->v.host);
			
			c->v.host = buf;
			
			break;
		}
		
		c->v.etyp = sqzt;
	}return;
	
	case CELL_ARRAY:
		squeeze(c->a.e);
		
	case CELL_VOID:
	case CELL_FUNC:
	default:
		return;
	}
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
	switch (r->ctyp) {
	case CELL_VOID: return 6;
	case CELL_SCALAR:
		switch (r->s.etyp) {
		case ELEM_INT:
			printf("%lld", r->s.i);
			break;
		case ELEM_FLOAT:
			printf("%f", r->s.f);
			break;
		case ELEM_CMPX:
			printf("%fJ%f", r->s.j.real, r->s.j.imag);
			break;
		case ELEM_CHAR:
			print_char(r->s.c);
			break;
		case ELEM_CELL:
			printf(" ");
			println_pad(r->s.p);
			printf(" ");
			break;
		default:
			return 99;
		}
		break;
	case CELL_VECTOR:
		switch (r->v.etyp) {
		case ELEM_INT:
			for (int64_t i = 0; i < r->v.cnt; i++) {
				if (i > 0) printf(" ");
				printf("%lld", r->v.host->i[i % r->v.bnd]);
			}
			break;
		case ELEM_FLOAT:
			for (int64_t i = 0; i < r->v.cnt; i++) {
				if (i > 0) printf(" ");
				printf("%f", r->v.host->f[i % r->v.bnd]);
			}
			break;
		case ELEM_CHAR:
			for (int64_t i = 0; i < r->v.cnt; i++) {
				print_char(r->v.host->c[i % r->v.bnd]);
			}
			break;
		case ELEM_CMPX:
			for (int64_t i = 0; i < r->v.cnt; i++) {
				struct apl_cmpx x;
			
				x = r->v.host->j[i % r->v.bnd];
				
				if (i > 0) printf(" ");
				printf("%fJ%f", x.real, x.imag);
			}
			break;
		case ELEM_DEV:
		case ELEM_IOTA:
		case ELEM_CELL:
			struct cell **p;
			int nst;
			
			p = r->v.host->p;
			nst = 1;
			
			for (int64_t i = 0; i < r->v.cnt; i++) {
				int64_t ib;
				int err, prv;
				
				ib = i % r->v.bnd;
				prv = nst;
				nst = 1;
				
				if (p[ib]->ctyp == CELL_SCALAR) {
					switch (p[ib]->s.etyp) {
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
				
				if ((err = println_pad(p[i % r->v.bnd])))
					return err;
					
				if (nst)
					printf(" ");
			}
			break;
		default:
			return 99;
		}
		break;
	default:
		return 16;
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
	
	switch (r->ctyp){
	case CELL_VOID: return 6;
	case CELL_SCALAR:
		if (!(t = get_cell()))
			return 1;
		
		t->ctyp = CELL_VECTOR;
		t->v.etyp = r->s.etyp;
		t->v.cnt = t->v.bnd = 1;
		t->v.host = get_host_buffer(buffer_size(t->v.etyp, 1));
		
		if (!t->v.host) {
			err = 1;
			goto fail;
		}
		
		switch (t->v.etyp) {
		case ELEM_INT: t->v.host->i[0] = r->s.i; break;
		case ELEM_FLOAT: t->v.host->f[0] = r->s.f; break;
		case ELEM_CMPX: t->v.host->j[0] = r->s.j; break;
		case ELEM_CHAR: t->v.host->c[0] = r->s.c; break;
		case ELEM_CELL: t->v.host->p[0] = ref_cell(r->s.p); break;
		default:
			err = 99;
			goto fail;
		}
		
		break;
		
	case CELL_VECTOR: t = ref_cell(r); break;
	case CELL_ARRAY: t = ref_cell(r->a.e); break;
	default:
		return 99;
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
	
	switch (r->ctyp) {
	case CELL_VOID: return 6;
	
	case CELL_SCALAR:
		switch (r->s.etyp) {
		case ELEM_INT:
		case ELEM_FLOAT:
		case ELEM_CMPX:
		case ELEM_CHAR:
			*z = ref_cell(r);
			break;
			
		case ELEM_CELL:
			*z = ref_cell(r->s.p);
			break;
			
		default:
			return 99;
		}
		
		return 0;
		
	case CELL_ARRAY:
		r = r->a.e; /* Fall through */
		
	case CELL_VECTOR:
		if (r->v.etyp == ELEM_CELL) {
			*z = ref_cell(r->v.host->p[0]);
			
			return 0;
		}
		
		t = get_cell();
		t->ctyp = CELL_SCALAR;
		
		if (r->v.etyp == ELEM_DEV)
			t->s.etyp = convert_af_dtype(r->v.dev);
		else
			t->s.etyp = r->v.etyp;
		
		switch (r->v.etyp) {
		case ELEM_INT:
			t->s.i = r->v.host->i[0];
			break;
			
		case ELEM_FLOAT:
			t->s.f = r->v.host->f[0];
			break;
			
		case ELEM_CMPX:
			t->s.j = r->v.host->j[0];
			break;
			
		case ELEM_CHAR:
			t->s.c = r->v.host->c[0];
			break;
			
		case ELEM_DEV:
			CHKAF(af_get_scalar(&t->s.i, r->v.dev), fail);
			break;
		
		case ELEM_IOTA:
			err =16; goto fail;
			
		default:
			err = 99; goto fail;
		}
		
		*z = t;
		
		return 0;

	default:
		return 99;
	}
	
fail:
	free_cell(t);
	
	return err;
}

EXPORT int
pick_f(struct cell *s, struct cell **z, struct cell *l, struct cell *r, struct cell ***env)
{
	struct cell *t;
	
	s; env;
	
	switch (l->ctyp) {
	case CELL_SCALAR:
		switch (l->s.etyp) {
		case ELEM_INT:
			switch (r->ctyp) {
			case CELL_SCALAR:
			case CELL_ARRAY:
				return 4;
				
			case CELL_VECTOR:
				break;
				
			default:
				return 99;
			}
			
			if (l->s.i >= r->v.cnt)
				return 3;
			
			if (r->v.etyp == ELEM_CELL) {
				*z = ref_cell(r->v.host->p[l->s.i]);
				return 0;
			}
			
			if (!(*z = t = get_cell()))
				return 1;
			
			t->ctyp = CELL_SCALAR;
			t->s.etyp = r->v.etyp;
				
			switch (r->v.etyp) {
			case ELEM_INT: t->s.i = r->v.host->i[l->s.i % r->v.bnd]; return 0;
			case ELEM_FLOAT: t->s.f = r->v.host->f[l->s.i % r->v.bnd]; return 0;
			case ELEM_CMPX: t->s.j = r->v.host->j[l->s.i % r->v.bnd]; return 0;
			case ELEM_CHAR: t->s.c = r->v.host->c[l->s.i % r->v.bnd]; return 0;
			case ELEM_DEV:
				return 16;
				
			case ELEM_IOTA:
				return 16;
				
			default:
				return 99;
			}
		
		case ELEM_FLOAT:
		case ELEM_CMPX:
			return 11;
			
		case ELEM_CELL:
			return 16;
			
		case ELEM_CHAR:
			return 11;
			
		default:
			return 99;
		}
		
	case CELL_VECTOR:
		return 16;
		
	case CELL_ARRAY:
		return 4;
	default:
		return 99;
	}
}