#include <time.h>
#include <stdint.h>
#include <stdio.h>
#include <inttypes.h>
#include <limits.h>
#include <float.h>
#include <locale>
#include <codecvt>
#include <math.h>
#include <memory>
#include <algorithm>
#include <stack>
#include <string>
#include <cstring>
#include <vector>
#include <unordered_map>
#include <arrayfire.h>
using namespace af;

#if AF_API_VERSION < 36
#error "Your ArrayFire version is too old."
#endif
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
#define this_c (*this)
#define VEC std::vector
#define RANK(lp) ((lp)->p->r)
#define TYPE(lp) ((lp)->p->t)
#define SHAPE(lp) ((lp)->p->s)
#define ETYPE(lp) ((lp)->p->e)
#define DATA(lp) ((V*)&SHAPE(lp)[RANK(lp)])
#define CS(n,x) case n:x;break;
#define DO(n,x) {I _i=(n),i=0;for(;i<_i;++i){x;}}
#define DOB(n,x) {B _i=(n),i=0;for(;i<_i;++i){x;}}
