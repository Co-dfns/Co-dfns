#pragma once

#define _SILENCE_CXX17_CODECVT_HEADER_DEPRECATION_WARNING

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
#include <variant>
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
#define CVEC const std::vector
#define RANK(pp) ((pp)->r)
#define TYPE(pp) ((pp)->t)
#define SHAPE(pp) ((pp)->s)
#define ETYPE(pp) ((pp)->e)
#define DATA(pp) ((V*)&SHAPE(pp)[RANK(pp)])
#define CS(n,x) case n:x;break;
#define DO(n,x) {I _i=(n),i=0;for(;i<_i;++i){x;}}
#define DOB(n,x) {B _i=(n),i=0;for(;i<_i;++i){x;}}
#define MT
#define PUSH(x) s.emplace(x)
#define POP(f,x) x=std::get<f>(s.top());s.pop()

#define DEFN(n) FNP n##_p=std::make_shared<n##_f>();FN&n##_c=*n##_p;
#define NM(n,nm,sm,sd,di,mf,df,ma,da) S n##_f:FN{di;mf;df;ma;da;\
 n##_f():FN(nm,sm,sd){}};
#define OM(n,nm,sm,sd,mf,df,ma,da) S n##_o:MOP{mf;df;ma;da;\
 n##_o(FNP l):MOP(nm,sm,sd,l){}\
 n##_o(CA&l):MOP(nm,sm,sd,l){}};\
 S n##_k:MOK{\
  FNP operator()(FNP l){R std::make_shared<n##_o>(l);}\
  FNP operator()(CA&l){R std::make_shared<n##_o>(l);}};
#define OD(n,nm,sm,sd,mf,df,ma,da) S n##_o:DOP{mf;df;ma;da;\
 n##_o(FNP l,FNP r):DOP(nm,sm,sd,l,r){}\
 n##_o(CA&l,FNP r):DOP(nm,sm,sd,l,r){}\
 n##_o(FNP l,CA&r):DOP(nm,sm,sd,l,r){}\
 n##_o(CA&l,CA&r):DOP(nm,sm,sd,l,r){}};\
 S n##_k:DOK{\
  FNP operator()(FNP l,FNP r){R std::make_shared<n##_o>(l,r);}\
  FNP operator()(CA&l,CA&r){R std::make_shared<n##_o>(l,r);}\
  FNP operator()(FNP l,CA&r){R std::make_shared<n##_o>(l,r);}\
  FNP operator()(CA&l,FNP r){R std::make_shared<n##_o>(l,r);}};
#define DID inline array id(SHP)
#define MFD inline V operator()(A&z,CA&r,ENV&e)
#define MAD inline V operator()(A&z,CA&r,ENV&e,CA&ax)
#define DFD inline V operator()(A&z,CA&l,CA&r,ENV&e)
#define DAD inline V operator()(A&z,CA&l,CA&r,ENV&e,CA&ax)
#define DI(n) inline array n::id(SHP s)
#define ID(n,x,t) DI(n##_f){R constant(x,dim4(cnt(s)),t);}
#define MF(n) inline V n::operator()(A&z,CA&r,ENV&e)
#define MA(n) inline V n::operator()(A&z,CA&r,ENV&e,CA&ax)
#define DF(n) inline V n::operator()(A&z,CA&l,CA&r,ENV&e)
#define DA(n) inline V n::operator()(A&z,CA&l,CA&r,ENV&e,CA&ax)
#define SF(n,lb) \
 DF(n##_f){sclfn(z,l,r,e,[&](A&z,carr&lv,carr&rv,ENV&e){lb;});}\
 DA(n##_f){sclfn(z,l,r,e,ax,n##_c);}
#define SMF(n,lb) \
 MF(n##_f){msclfn(z,r,e,n##_c,[](A&z,carr&rv,ENV&e){lb;});}
#define EF(init,ex,fun) EXPORT V ex##_dwa(lp*z,lp*l,lp*r){try{\
  A cl,cr,za;fn##init##_f fn_c;fn_c(za,cl,cr,e##init);\
  cpda(cr,r);cpda(cl,l);\
  (*std::get<FNP>((*e##init[0])[fun]))(za,cl,cr,e##init);\
  cpad(z,za);}\
 catch(U n){derr(n);}\
 catch(exception&e){msg=mkstr(e.what());dmx.e=msg.c_str();derr(500);}}\
EXPORT V ex##_cdf(A*z,A*l,A*r){{A il,ir,iz;\
 fn##init##_f fn_c;fn_c(iz,il,ir,e##init);}\
 (*std::get<FNP>((*e##init[0])[fun]))(*z,*l,*r,e##init);}
#define EV(init,ex,slt)
#define EO(init,ex,slt)

typedef enum{APLNC=0,APLU8,APLTI,APLSI,APLI,APLD,APLP,APLU,APLV,APLW,APLZ,
 APLR,APLF,APLQ}APLTYPE;
typedef long long L;typedef int I;typedef int16_t S16;typedef int8_t S8;
typedef double D;typedef unsigned char U8;typedef unsigned U;
typedef dim_t B;typedef cdouble DZ;typedef void V;typedef std::string STR;
typedef array arr;typedef const array carr;typedef af::index IDX;
typedef std::monostate NIL;
S dmx_t{U f=3;U n;U x=0;const wchar_t*v=L"Co-dfns";const wchar_t*e;V*c;};
S pkt{L l;B c;U t:4;U r:4;U e:4;U _:13;U _1:16;U _2:16;B s[1];};
S lp{pkt*p;V*i;};
S dwa{B z;S{B z;pkt*(*ga)(U,U,B*,S lp*);V(*p[16])();V(*er)(V*);}*ws;V*p[4];};
S dwa*dwafns;Z V derr(U n);Z V err(U n,const wchar_t*e);Z V err(U n);
typedef VEC<dim_t> SHP;S A;
typedef std::variant<NIL,arr,VEC<A>> VALS;
S A{SHP s;VALS v;A();A(B);A(B,VALS);};
typedef const A CA;S FN;S MOK;S DOK;typedef std::shared_ptr<FN> FNP;
typedef std::shared_ptr<MOK> MOKP;typedef std::shared_ptr<DOK> DOKP;
typedef std::variant<A,FNP,MOKP,DOKP> BX;
typedef VEC<BX> FRM;typedef std::unique_ptr<FRM> FRMP;
typedef VEC<FRMP> ENV;typedef std::stack<BX> STK;

S FN{STR nm;I sm;I sd;FNP this_p;virtual ~FN() = default;
 FN(STR,I,I);FN();virtual arr id(SHP);
 virtual V operator()(A&,CA&,ENV&);
 virtual V operator()(A&,CA&,ENV&,CA&);
 virtual V operator()(A&,CA&,CA&,ENV&);
 virtual V operator()(A&,CA&,CA&,ENV&,CA&);};
S MOP:FN{CA aa;FNP llp;FN&ll=*llp;MOP(STR,I,I,CA&);MOP(STR,I,I,FNP);};
S DOP:FN{I fl;I fr;CA aa;CA ww;FNP llp;FNP rrp;FN&ll=*llp;FN&rr=*rrp;
 DOP(STR,I,I,FNP,FNP);
 DOP(STR,I,I,CA&,FNP);
 DOP(STR,I,I,FNP,CA&);
 DOP(STR,I,I,CA&,CA&);};
S MOK{virtual ~MOK() = default;
 virtual FNP operator()(FNP);virtual FNP operator()(CA&);};
S DOK{virtual ~DOK() = default;
 virtual FNP operator()(FNP,FNP);
 virtual FNP operator()(CA&,CA&);
 virtual FNP operator()(FNP,CA&);
 virtual FNP operator()(CA&,FNP);};

EXPORT A*mkarray(lp*);
EXPORT V frea(A*);
EXPORT V exarray(lp*,A*);
EXPORT V afsync();
EXPORT Window *w_new(char *);
EXPORT I w_close(Window*);
EXPORT V w_del(Window*);
EXPORT V w_img(lp*,Window*);
EXPORT V w_plot(lp*,Window*);
EXPORT V w_hist(lp*,D,D,Window*);
EXPORT V loadimg(lp*,char*,I);
EXPORT V saveimg(lp*,char*);
EXPORT V cd_sync(V);

