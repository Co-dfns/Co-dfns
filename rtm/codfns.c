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

enum elem_type { 
	ELEM_VOID, ELEM_INT, ELEM_FLOAT, ELEM_CMPX, ELEM_CHAR, ELEM_DEV, ELEM_IOTA, ELEM_CELL
};

enum cell_type { CELL_SCALAR, CELL_VECTOR, CELL_ARRAY, CELL_FUNC };

struct apl_cmpx {
	double real;
	double imag;
};

struct iota_range {
	double shift;
	double step;
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
	struct cell *s;
	struct cell *e;
};

struct cell_func {
	int cnt;
	struct host_buffer *env;
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
struct host_buffer *next_buffer[6]; /* 32 128 512 2048 8192 16384 */

struct host_buffer *
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
		return NULL;
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
	
	if (!b->refc)
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

struct cell *
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

void
free_cell(struct cell *c)
{
	if (!c->refc)
		return;
		
	c->refc--;
	
	if (c->refc) {
		return;
	}
	
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
		case ELEM_VOID:
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

int64_t
buffer_size(enum elem_type t, int64_t c)
{
	if (t == ELEM_CMPX)
		return sizeof(struct apl_cmpx) * c;
	
	return sizeof(int64_t) * c;
}

int
main(void)
{
	printf("Scalar: %zd\n", sizeof(struct cell_scalar));
	printf("Vector: %zd\n", sizeof(struct cell_vector));
	printf("Array: %zd\n", sizeof(struct cell_array));
	printf("Cell: %zd\n", sizeof(struct cell));
			
	return 0;
}

