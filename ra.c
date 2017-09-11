#include <time.h>
#include <stdint.h>
#include <inttypes.h>
#include <limits.h>
#include <float.h>
#include <math.h>
#include <memory>
#include <algorithm>
#include <string>
#include <cstring>
#include <vector>
#include <unordered_map>
#include <arrayfire.h>
using namespace af;

#ifdef _WIN32
 #define EXPORT extern "C" __declspec(dllexport)
#elif defined(__GNUC__)
 #define EXPORT extern "C" __attribute__ ((visibility ("default")))
#else
 #define EXPORT extern "C"
#endif
#ifdef _MSC_VER
 #define RSTCT __restrict
#else
 #define RSTCT restrict
#endif
#define S struct
#define Z static
#define R return
#define RANK(lp) ((lp)->p->r)
#define TYPE(lp) ((lp)->p->t)
#define SHAPE(lp) ((lp)->p->s)
#define ETYPE(lp) ((lp)->p->e)
#define DATA(lp) ((V*)&SHAPE(lp)[RANK(lp)])
#define CS(n,x) case n:x;break;
#define DO(n,x) {I i=0,_i=(n);for(;i<_i;++i){x;}}
#define DOB(n,x) {B i=0,_i=(n);for(;i<_i;++i){x;}}

typedef enum{APLNC=0,APLU8,APLTI,APLSI,APLI,APLD,APLP,APLU,APLV,APLW,APLZ,
 APLR,APLF,APLQ}APLTYPE;
typedef long long L;typedef int I;typedef int16_t S16;
typedef int8_t S8;typedef double D;typedef unsigned char U8;
typedef dim_t B;typedef unsigned U;typedef cdouble DZ;
typedef void V;typedef std::string STR;
