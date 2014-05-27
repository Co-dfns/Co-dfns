/* Co-dfns Foreign Structures and Helper Functions */

#pragma once

#include <stdlib.h>
#include <error.h>
#include <inttypes.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

/* Core Co-dfns array structure */

struct codfns_array {
	uint16_t  rank;
	uint64_t  size;
	uint8_t   type;
	uint32_t *shape;
	void  *elements;
};

/* Helper functions upon which the compiler relies */

uint64_t
ffi_get_size(struct codfns_array *);

uint16_t
ffi_get_rank(struct codfns_array *);

void
ffi_get_data_int(int64_t *, struct codfns_array *);

void
ffi_get_shape(uint32_t *, struct codfns_array *);

void
clean_env(struct codfns_array *, int);

/* Helper functions for in and outside the compiler */

int
ffi_make_array(struct codfns_array **,
    uint16_t, uint64_t, uint32_t *, int64_t *);

void
array_free(struct codfns_array *);

int
array_cp(struct codfns_array *, struct codfns_array *);

void
array_mt(struct codfns_array *);

/* Runtime functions */

int
codfns_add(struct codfns_array *,
    struct codfns_array *, struct codfns_array *);

int
codfns_subtract(struct codfns_array *,
    struct codfns_array *, struct codfns_array *);

int
codfns_multiply(struct codfns_array *,
    struct codfns_array *, struct codfns_array *);

int
codfns_divide(struct codfns_array *,
    struct codfns_array *, struct codfns_array *);

int
codfns_residue(struct codfns_array *,
    struct codfns_array *, struct codfns_array *);

int
codfns_power(struct codfns_array *,
    struct codfns_array *, struct codfns_array *);

int
codfns_log(struct codfns_array *,
    struct codfns_array *, struct codfns_array *);

int
codfns_max(struct codfns_array *,
    struct codfns_array *, struct codfns_array *);

int
codfns_min(struct codfns_array *,
    struct codfns_array *, struct codfns_array *);

int
codfns_less(struct codfns_array *,
    struct codfns_array *, struct codfns_array *);

int
codfns_less_or_equal(struct codfns_array *,
    struct codfns_array *, struct codfns_array *);

int
codfns_equal(struct codfns_array *,
    struct codfns_array *, struct codfns_array *);

int
codfns_not_equal(struct codfns_array *,
    struct codfns_array *, struct codfns_array *);

int
codfns_greater_or_equal(struct codfns_array *,
    struct codfns_array *, struct codfns_array *);

int
codfns_greater(struct codfns_array *,
    struct codfns_array *, struct codfns_array *);

int
codfns_not(struct codfns_array *,
    struct codfns_array *, struct codfns_array *);

