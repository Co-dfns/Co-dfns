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
#define this_c *this
#define RANK(lp) ((lp)->p->r)
#define TYPE(lp) ((lp)->p->t)
#define SHAPE(lp) ((lp)->p->s)
#define ETYPE(lp) ((lp)->p->e)
#define DATA(lp) ((V*)&SHAPE(lp)[RANK(lp)])
#define CS(n,x) case n:x;break;
#define DO(n,x) {I i=0,_i=(n);for(;i<_i;++i){x;}}
#define DOB(n,x) {B i=0,_i=(n);for(;i<_i;++i){x;}}
#define NM(n,nm,sm,sd,di,mf,df,ma,da) S n##_f:FN{di;mf;df;ma;da;\
 n##_f():FN(nm,sm,sd){}};
#define OM(n,nm,sm,sd,mf,df) S n##_o:MOP{mf;df;\
 n##_o(FN&l):MOP(nm,sm,sd,l){}};\
 S n##_k:MOK{V operator()(FN*&f,FN&l){f=new n##_o(l);}};
#define OD(n,nm,sm,sd,mf,df) S n##_o:DOP{mf;df;\
 n##_o(FN&l,FN&r):DOP(nm,sm,sd,l,r){}\
 n##_o(const A&l,FN&r):DOP(nm,sm,sd,l,r){}\
 n##_o(FN&l,const A&r):DOP(nm,sm,sd,l,r){}};\
 S n##_k:DOK{V operator()(FN*&f,FN&l,FN&r){f=new n##_o(l,r);}\
  V operator()(FN*&f,const A&l,FN&r){f=new n##_o(l,r);}\
  V operator()(FN*&f,FN&l,const A&r){f=new n##_o(l,r);}};
#define MT
#define DID inline array id(dim4)
#define MFD inline V operator()(A&,const A&,ENV&)
#define MAD inline V operator()(A&,const A&,D,ENV&)
#define DFD inline V operator()(A&,const A&,const A&,ENV&)
#define DAD inline V operator()(A&,const A&,const A&,D,ENV&)
#define DI(n) inline array n::id(dim4 s)
#define ID(n,x,t) DI(n##_f){R constant(x,s,t);}
#define MF(n) inline V n::operator()(A&z,const A&r,ENV&e)
#define MA(n) inline V n::operator()(A&z,const A&r,D ax,ENV&e)
#define DF(n) inline V n::operator()(A&z,const A&l,const A&r,ENV&e)
#define DA(n) inline V n::operator()(A&z,const A&l,const A&r,D ax,ENV&e)
#define SF(n,x) inline V n::operator()(A&z,const A&l,const A&r,ENV&e){\
 if(l.r==r.r&&l.s==r.s){\
  z.r=l.r;z.s=l.s;const array&lv=l.v;const array&rv=r.v;x;R;}\
 if(!l.r){\
  z.r=r.r;z.s=r.s;const array&rv=r.v;array lv=tile(l.v,r.s);x;R;}\
 if(!r.r){\
  z.r=l.r;z.s=l.s;array rv=tile(r.v,l.s);const array&lv=l.v;x;R;}\
 if(l.r!=r.r)err(4);if(l.s!=r.s)err(5);err(99);}
#define PUSH(x) s.emplace(BX(x))
#define POP(f,x) x=s.top().f;s.pop()
#define EX(x) delete x
#define EF(init,ex,fun) EXPORT V ex##_dwa(lp*z,lp*l,lp*r){try{\
  A cl,cr,za;fn##init##_c(za,cl,cr,e##init);\
  cpda(cr,r);cpda(cl,l);(*(*e##init[0])[fun].f)(za,cl,cr,e##init);cpad(z,za);}\
 catch(U n){derr(n);}\
 catch(exception e){msg=mkstr(e.what());dmx.e=msg.c_str();derr(500);}}\
EXPORT V ex##_cdf(A*z,A*l,A*r){{A il,ir,iz;fn##init##_c(iz,il,ir,e##init);}\
 (*(*e##init[0])[fun].f)(*z,*l,*r,e##init);}
#define EV(init,ex,slt)
