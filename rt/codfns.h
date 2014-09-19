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
	uint64_t *shape;
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
ffi_get_shape(uint64_t *, struct codfns_array *);

void
clean_env(struct codfns_array *, int);

void
init_env(struct codfns_array *, int);

/* Helper functions for in and outside the compiler */

int
ffi_make_array(struct codfns_array **,
    uint16_t, uint64_t, uint64_t *, int64_t *);

void
array_free(struct codfns_array *);

int
array_cp(struct codfns_array *, struct codfns_array *);

/* Scalar Type Enumerations
 * 
 * These enumerations aid in the use of these macros and definitions. 
 * In particular, we use notations like d and i to represent types 
 * during the invocation of the macros. These type enumerations help 
 * to make sure that they resolve to the right type number in the 
 * type field of the struct codfns_array structures.
 */

enum { apl_type_e, apl_type_b, apl_type_i, apl_type_d, apl_type_c };

/* Typedefs for macros
 *
 * Like the enumerations above, these allow us to map specific types 
 * to the shortcuts d, i, and so forth inside of our macros.
 */

typedef int64_t type_i;
typedef double type_d;

/* Standard Function Signature */
#define UDF(nm) \
int nm(struct codfns_array*,struct codfns_array*,struct codfns_array*,\
 struct codfns_array **); \
int \
nm##m(struct codfns_array*res,struct codfns_array*lft,struct codfns_array*rgt,\
 struct codfns_array *env[]){return nm(res,lft,rgt,env);} \
int \
nm##d(struct codfns_array*res,struct codfns_array*lft,struct codfns_array*rgt,\
 struct codfns_array *env[]){return nm(res,lft,rgt,env);} \
int \
nm(struct codfns_array*res,struct codfns_array*lft,struct codfns_array*rgt,\
 struct codfns_array *onv[])


/* Runtime functions */

#define runtime_array(nm) \
int \
nm(struct codfns_array *, struct codfns_array *, struct codfns_array *,\
 struct codfns_array **)

#define primitive(nm, mdt, mit, dddt, ddit, didt, diit) \
runtime_array(codfns_##nm##m); \
runtime_array(codfns_##nm##d);

#define primitived(nm, dddt, ddit, didt, diit) \
runtime_array(codfns_##nm##d);

#define primitivem(nm, mdt, mit) \
runtime_array(codfns_##nm##m);

primitive(add, i, d, d, d, d, i)
primitive(subtract, d, i, d, d, d, i)
primitive(multiply, d, i, d, d, d, i)
primitive(divide, d, d, d, d, d, d)
primitive(residue, d, i, d, d, d, i)
primitive(power, d, i, d, d, d, i)
primitive(log, d, d, d, d, d, d)
primitive(max, d, i, d, d, d, i)
primitive(min, d, i, d, d, d, i)
primitived(less, i, i, i, i)
primitived(lesseq, i, i, i, i)
primitived(equal, i, i, i, i)
primitived(neq, i, i, i, i)
primitived(greateq, i, i, i, i)
primitived(greater, i, i, i, i)
primitivem(not, i, i)
primitive(indexgen,d,i,d,d,d,i)
primitived(ptred,d,d,d,i)

/* Runtime operators */

#define operator_type(nm) \
int \
nm(struct codfns_array *,struct codfns_array *,struct codfns_array *,\
 int(*)(struct codfns_array *,struct codfns_array *,struct codfns_array *,\
  struct codfns_array **),\
 struct codfns_array **);
#define operator(nm) \
operator_type(codfns_##nm##m)\
operator_type(codfns_##nm##d)

operator(each)

