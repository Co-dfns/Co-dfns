#pragma once

#include <stdlib.h>
#include <error.h>
#include <inttypes.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
#include "codfns.h"

typedef double D;typedef int I;typedef char C;typedef struct codfns_array A;
typedef uint16_t UI16;typedef uint64_t UI64;typedef uint8_t UI8;
typedef void V;typedef int64_t I64;

#define R return
#define ERR(c,m) {fprintf(stderr,(m));R(c);}
#define rnk(a) ((a)->rank)
#define shp(a) ((a)->shape)
#define siz(a) ((a)->size)
#define typ(a) ((a)->type)
#define elm(a) ((a)->elements)
#define DO(n,x){I i=0,_n=(n);for(;i<_n;++i){x;}}
#define ra(b,s,n) realloc((b),sizeof(s)*(n))
#define cp(d,s,z,n) memcpy((d),(s),sizeof(z)*(n))
#define Ps(s) printf("%s",(s))
#define Pi(x) printf("%ld",(x))
#define Pd(x) printf("%lf",(x))
#define P printf

