/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * Core runtime header
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

/* Enumerations */

enum otype { OPFUN, OPARR };
enum etype { ELCHR, ELINT, ELFLT, ELMIX, ELUNSET };

/* Basic Value Types */

typedef int64_t AplInt;
typedef wchar_t AplChr;
typedef double  AplFlt;

union mixed_value {
	AplInt integer;
	AplChr character;
	AplFlt floating;
};

typedef struct mixed {
	enum etype type;
	union mixed_value value;
} AplMix;

union value {
	AplInt integer;
	AplChr character;
	AplFlt floating;
	AplMix mixed;
};

/* Array Types */

#define MAXRANK 64

typedef unsigned long dimension_t;
#define SHAPEEND ULONG_MAX

struct array {
	dimension_t shape[MAXRANK];
	enum etype type;
	size_t size;
	void *data;
	size_t sasize;
	void *saflg;
};

/* Function Types*/

struct function {
	void (*code)(struct array *, struct array *, struct array *, 
	    struct function *);
	struct operand *lop;
	struct operand *rop;
	struct operand *env;
};

typedef void (*AplFunction)(struct array *, struct array *, struct array *,
    struct function *);

union operand_value {
	struct function *fun;
	struct array *arr;
};

struct operand {
	enum otype type;
	union operand_value value;
};

/* Function Prototypes */

void *alloc_elems(size_t, enum etype);
void free_elems(size_t, enum etype);
void init_array(struct array *, enum etype);
void init_data(struct array *, size_t);
void init_function(struct function *, AplFunction, struct operand *,
    struct operand *, struct operand *);
void call(struct function *, struct array *, struct array *, struct array *);
void apl_print(struct array *);
void apl_assign(struct array *, size_t, union value);
void apl_copy(struct array *, struct array *);
unsigned short rank(struct array *);
size_t product(struct array *);
void apl_iota(struct array *, struct array *, struct array *, 
    struct function *);
void apl_plus(struct array *, struct array *, struct array *,
    struct function *);
void apl_each(struct array *, struct array *, struct array *,
    struct function *);
void apl_reduce(struct array *, struct array *, struct array *,
    struct function *);
