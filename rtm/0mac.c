#include <time.h>
#include <stdint.h>
#include <inttypes.h>
#include <limits.h>
#include <float.h>
#include <locale>
#include <codecvt>
#include <math.h>
#include <memory>
#include <algorithm>
#include <string>
#include <cstring>
#include <vector>
#include <unordered_map>
#include <arrayfire.h>
using namespace af;

#if AF_API_VERSION < 35
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
#define RANK(lp) ((lp)->p->r)
#define TYPE(lp) ((lp)->p->t)
#define SHAPE(lp) ((lp)->p->s)
#define ETYPE(lp) ((lp)->p->e)
#define DATA(lp) ((V*)&SHAPE(lp)[RANK(lp)])
#define CS(n,x) case n:x;break;
#define DO(n,x) {I i=0,_i=(n);for(;i<_i;++i){x;}}
#define DOB(n,x) {B i=0,_i=(n);for(;i<_i;++i){x;}}
#define NM(n,nm,sm,sd,di,mf,df,ma,da) S n##_f:FN{di;mf;df;ma;da;\
 n##_f():FN(){}n##_f(STR s,I m,I d):FN(s,m,d){}} n##_c;
#define OM(n,nm,sm,sd,mf,df) S n##_o:MOP{mf;df;\
 n##_o(FN&l):MOP(nm,sm,sd,l){}};
#define OD(n,nm,sm,sd,mf,df) S n##_o:DOP{mf;df;\
 n##_o(FN&l,FN&r):DOP(nm,sm,sd,l,r){}\
 n##_o(const A&l,FN&r):DOP(nm,sm,sd,l,r){}\
 n##_o(FN&l,const A&r):DOP(nm,sm,sd,l,r){}};
#define MT
#define DID inline array id(dim4)
#define MFD inline V operator()(A&,const A&)
#define MAD inline V operator()(A&,const A&,D)
#define DFD inline V operator()(A&,const A&,const A&)
#define DAD inline V operator()(A&,const A&,const A&,D)
#define DI(n) inline array n::id(dim4 s)
#define ID(n,x,t) DI(n##_f){R constant(x,s,t);}
#define MF(n) inline V n::operator()(A&z,const A&r)
#define MA(n) inline V n::operator()(A&z,const A&r,D ax)
#define DF(n) inline V n::operator()(A&z,const A&l,const A&r)
#define DA(n) inline V n::operator()(A&z,const A&l,const A&r,D ax)
#define SF(n,x) inline V n::operator()(A&z,const A&l,const A&r){\
 if(l.r==r.r&&l.s==r.s){\
  z.r=l.r;z.s=l.s;const array&lv=l.v;const array&rv=r.v;x;R;}\
 if(!l.r){\
  z.r=r.r;z.s=r.s;const array&rv=r.v;array lv=tile(l.v,r.s);x;R;}\
 if(!r.r){\
  z.r=l.r;z.s=l.s;array rv=tile(r.v,l.s);const array&lv=l.v;x;R;}\
 if(l.r!=r.r)err(4);if(l.s!=r.s)err(5);err(99);}
#define FP(n) NM(n,"",0,0,MT,MFD,DFD,MT,MT);MF(n##_f){n##_c(z,A(),r);}
#define EF(ex,fun,init) EXPORT V ex##_dwa(lp*z,lp*l,lp*r){try{\
  A cl,cr,za;if(!is##init){init##_c(za,cl,cr);is##init=1;}\
  cpda(cr,r);cpda(cl,l);fun##_c(za,cl,cr);cpad(z,za);}\
 catch(U n){derr(n);}\
 catch(exception e){dmx.e=mkstr.from_bytes(e.what()).c_str();derr(500);}}\
EXPORT V ex##_cdf(A*z,A*l,A*r){try{fun##_c(*z,*l,*r);}catch(U n){derr(n);}\
 catch(exception x){dmx.e=mkstr.from_bytes(x.what()).c_str();derr(500);}}

