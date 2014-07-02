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
codfns_addm(struct codfns_array *, 
    struct codfns_array *, struct codfns_array *);

int
codfns_addd(struct codfns_array *,
    struct codfns_array *, struct codfns_array *);

int
codfns_subtractm(struct codfns_array *, 
    struct codfns_array *, struct codfns_array *);

int
codfns_subtractd(struct codfns_array *,
    struct codfns_array *, struct codfns_array *);

int
codfns_multiplym(struct codfns_array *, 
    struct codfns_array *, struct codfns_array *);

int
codfns_multiplyd(struct codfns_array *,
    struct codfns_array *, struct codfns_array *);

int
codfns_dividem(struct codfns_array *, 
    struct codfns_array *, struct codfns_array *);

int
codfns_divided(struct codfns_array *,
    struct codfns_array *, struct codfns_array *);

int
codfns_residuem(struct codfns_array *, 
    struct codfns_array *, struct codfns_array *);

int
codfns_residued(struct codfns_array *,
    struct codfns_array *, struct codfns_array *);

int
codfns_powerm(struct codfns_array *, 
    struct codfns_array *, struct codfns_array *);

int
codfns_powerd(struct codfns_array *,
    struct codfns_array *, struct codfns_array *);

int
codfns_logm(struct codfns_array *, 
    struct codfns_array *, struct codfns_array *);

int
codfns_logd(struct codfns_array *,
    struct codfns_array *, struct codfns_array *);

int
codfns_maxm(struct codfns_array *, 
    struct codfns_array *, struct codfns_array *);

int
codfns_maxd(struct codfns_array *,
    struct codfns_array *, struct codfns_array *);

int
codfns_minm(struct codfns_array *, 
    struct codfns_array *, struct codfns_array *);

int
codfns_mind(struct codfns_array *,
    struct codfns_array *, struct codfns_array *);

int
codfns_lessd(struct codfns_array *,
    struct codfns_array *, struct codfns_array *);

int
codfns_lesseqd(struct codfns_array *,
    struct codfns_array *, struct codfns_array *);

int
codfns_equald(struct codfns_array *,
    struct codfns_array *, struct codfns_array *);

int
codfns_neqd(struct codfns_array *,
    struct codfns_array *, struct codfns_array *);

int
codfns_greateqd(struct codfns_array *,
    struct codfns_array *, struct codfns_array *);

int
codfns_greaterd(struct codfns_array *,
    struct codfns_array *, struct codfns_array *);

int
codfns_notm(struct codfns_array *, 
    struct codfns_array *, struct codfns_array *);
    

