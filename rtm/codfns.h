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
  #define EXPORT __declspec(dllexport)
  #ifdef EXPORTING
    #define DECLSPEC EXPORT
  #else
    #define DECLSPEC __declspec(dllimport)
  #endif
#elif defined(__GNUC__)
 #define DECLSPEC __attribute__ ((visibility ("default")))
#else
 #define DECLSPEC
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

#define DECLF(n) extern DECLSPEC FN& n##_c;extern DECLSPEC FNP n##_p;
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
#define MFD V operator()(A&z,CA&r,ENV&e)
#define MAD V operator()(A&z,CA&r,ENV&e,CA&ax)
#define DFD V operator()(A&z,CA&l,CA&r,ENV&e)
#define DAD V operator()(A&z,CA&l,CA&r,ENV&e,CA&ax)
#define DI(n) array n::id(SHP s)
#define ID(n,x,t) DI(n##_f){R constant(x,dim4(cnt(s)),t);}
#define MF(n) V n::operator()(A&z,CA&r,ENV&e)
#define MA(n) V n::operator()(A&z,CA&r,ENV&e,CA&ax)
#define DF(n) V n::operator()(A&z,CA&l,CA&r,ENV&e)
#define DA(n) V n::operator()(A&z,CA&l,CA&r,ENV&e,CA&ax)
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
S pkt{L l;B c;U t:4;U r:4;U e:4;U _:13;U _1:16;U _2:16;B s[1];};
S lp{pkt*p;V*i;};
typedef VEC<dim_t> SHP;S A;
typedef std::variant<NIL,arr,VEC<A>> VALS;
S A{SHP s;VALS v;A();A(B);A(SHP,VALS);A(B,VALS);};
typedef const A CA;S FN;S MOK;S DOK;typedef std::shared_ptr<FN> FNP;
typedef std::shared_ptr<MOK> MOKP;typedef std::shared_ptr<DOK> DOKP;
typedef std::variant<A,FNP,MOKP,DOKP> BX;
typedef VEC<BX> FRM;typedef std::unique_ptr<FRM> FRMP;
typedef VEC<FRMP> ENV;typedef std::stack<BX> STK;

S DECLSPEC FN{I sm;I sd;STR nm;FNP this_p;
 virtual ~FN() = default;
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
 virtual FNP operator()(FNP);
 virtual FNP operator()(CA&);};
S DOK{virtual ~DOK() = default;
 virtual FNP operator()(FNP,FNP);
 virtual FNP operator()(CA&,CA&);
 virtual FNP operator()(FNP,CA&);
 virtual FNP operator()(CA&,FNP);};

DECLSPEC I scm(FN&);
DECLSPEC I scm(const A&);
DECLSPEC I scm(FNP);
DECLSPEC I scd(FN&);
DECLSPEC I scd(const A&);
DECLSPEC I scd(FNP);
DECLSPEC std::wstring mkstr(const char*);
DECLSPEC B rnk(const SHP&);
DECLSPEC B rnk(const A&);
DECLSPEC B cnt(SHP);
DECLSPEC B cnt(const A&);
DECLSPEC B cnt(pkt*);
DECLSPEC B cnt(arr&);
DECLSPEC I geti(CA&);
DECLSPEC arr scl(D);
DECLSPEC arr scl(I);
DECLSPEC arr scl(B);
DECLSPEC A scl(arr);
DECLSPEC arr axis(carr&,const SHP&,B);
DECLSPEC arr table(carr&,const SHP&,B);
DECLSPEC arr unrav(carr&,const SHP&);
DECLSPEC V af2cd(A&,const arr&);
DECLSPEC dtype mxt(dtype,dtype);
DECLSPEC dtype mxt(carr&,carr&);
DECLSPEC dtype mxt(dtype,CA&);
DECLSPEC dtype mxt(CA&,CA&);
DECLSPEC I isint(D);
DECLSPEC I isint(CA&);
DECLSPEC I isbool(carr&);
DECLSPEC I isbool(CA&);
DECLSPEC I is_eqv(CA&,CA&);

DECLSPEC V coal(A&);
DECLSPEC arr proto(carr&);
DECLSPEC VEC<A> proto(CVEC<A>&);
DECLSPEC A proto(CA&);

S dmx_t {U f=3;U n;U x=0;const wchar_t*v=L"Co-dfns";const wchar_t*e;V*c;};

extern DECLSPEC dmx_t dmx;
extern DECLSPEC std::wstring msg;

DECLSPEC V derr(U);
DECLSPEC V err(U,const wchar_t*);
DECLSPEC V err(U);

DECLSPEC arr da16(B,pkt*);
DECLSPEC arr da8(B,pkt*);
DECLSPEC pkt*cpad(lp*,CA&);
DECLSPEC V cpda(A&,pkt*);
DECLSPEC V cpda(A&,lp*);

DECLSPEC V sclfn(A&,CA&,CA&,ENV&,CA&,FN&);

#define VSWITCH(x,nil,arry,vec) \
 std::visit(\
  visitor{[&](NIL v){nil;},[&](arr&v){arry;},[&](VEC<A>&v){vec;}},\
  (x));
#define CVSWITCH(x,nil,arr,vec) \
 std::visit(\
  visitor{[&](NIL v){nil;},[&](carr&v){arr;},[&](CVEC<A>&v){vec;}},\
  (x));

S DVSTR {
 V operator()(NIL,NIL);
 V operator()(NIL,carr&);
 V operator()(NIL,CVEC<A>&);
 V operator()(carr&,NIL);
 V operator()(CVEC<A>&,NIL);};
S MVSTR {V operator()(NIL);};
template<class... Ts> S visitor : Ts... { using Ts::operator()...; };
template<class... Ts> visitor(Ts...) -> visitor<Ts...>;
template<class fncls> inline V msclfn(A&z,CA&r,ENV&e,FN&rec_c,fncls fn){
 z.s=r.s;
 CVSWITCH(r.v,err(6),fn(z,v,e)
  ,B cr=cnt(r);z.v=VEC<A>(cr);VEC<A>&zv=std::get<VEC<A>>(z.v);
   DOB(cr,rec_c(zv[i],v[i],e)))}
template<class fncls> inline V sclfn(A&z,CA&l,CA&r,ENV&e,fncls fn){
 B lr=rnk(l),rr=rnk(r);
 if(lr==rr){DOB(rr,if(l.s[i]!=r.s[i])err(5));z.s=l.s;}
 else if(!lr){z.s=r.s;}else if(!rr){z.s=l.s;}else if(lr!=rr)err(4);
 std::visit(visitor{DVSTR(),
   [&](CVEC<A>&lv,carr&rv){err(16);},
   [&](carr&lv,CVEC<A>&rv){err(16);},
   [&](CVEC<A>&lv,CVEC<A>&rv){err(16);},
   [&](carr&lv,carr&rv){
    if(lr==rr){fn(z,lv,rv,e);}
    else if(!lr){fn(z,tile(lv,rv.dims()),rv,e);}
    else if(!rr){fn(z,lv,tile(rv,lv.dims()),e);}}},
  l.v,r.v);}

DECLSPEC A*mkarray(lp*);
DECLSPEC V frea(A*);
DECLSPEC V exarray(lp*,A*);
DECLSPEC V afsync();
DECLSPEC Window *w_new(char *);
DECLSPEC I w_close(Window*);
DECLSPEC V w_del(Window*);
DECLSPEC V w_img(lp*,Window*);
DECLSPEC V w_plot(lp*,Window*);
DECLSPEC V w_hist(lp*,D,D,Window*);
DECLSPEC V loadimg(lp*,char*,I);
DECLSPEC V saveimg(lp*,char*);
DECLSPEC V cd_sync(V);

DECLF(add);
DECLF(and);
DECLF(brk);
DECLF(cat);
DECLF(cir);
DECLF(ctf);
DECLF(dec);
DECLF(dis);
DECLF(div);
DECLF(drp);
DECLF(enc);
DECLF(eql);
DECLF(eqv);
DECLF(exp);
DECLF(fac);
DECLF(fft);
DECLF(fnd);
DECLF(gdd);
DECLF(gdu);
DECLF(get);
DECLF(gte);
DECLF(gth);
DECLF(ift);
DECLF(int);
DECLF(iot);
DECLF(lft);
DECLF(log);
DECLF(lor);
DECLF(lte);
DECLF(lth);
DECLF(max);
DECLF(mdv);
DECLF(mem);
DECLF(min);
DECLF(mul);
DECLF(nan);
DECLF(neq);
DECLF(nor);
DECLF(not);
DECLF(nqv);
DECLF(nst);
DECLF(par);
DECLF(rdf);
DECLF(red);
DECLF(res);
DECLF(rgt);
DECLF(rho);
DECLF(rol);
DECLF(rot);
DECLF(rtf);
DECLF(scf);
DECLF(scn);
DECLF(sqd);
DECLF(sub);
DECLF(tke);
DECLF(trn);
DECLF(unq);

OD(brk,"brk",scm(l),scd(l),MFD,DFD,MT ,MT );
OM(com,"com",scm(l),scd(l),MFD,DFD,MT ,MT )
OD(dot,"dot",0,0,MT,DFD,MT ,MT )
OM(get,"get",0,0,MT,DFD,MT,MT)
OD(jot,"jot",(scm(l)&&scm(r)),(scd(l)&&scd(r)),MFD,DFD,MT ,MT )
OM(map,"map",1,1,MFD,DFD,MT ,MT )
OM(oup,"oup",0,0,MT,DFD,MT ,MT )
OD(pow,"pow",scm(l),scd(l),MFD,DFD,MT ,MT )
OM(rdf,"rdf",0,0,MFD,DFD,MAD,DAD)
OM(red,"red",0,0,MFD,DFD,MAD,DAD)
OD(rnk,"rnk",scm(l),0,MFD,DFD,MT ,MT )
OM(scf,"scf",1,1,MFD,MT,MAD,MT )
OM(scn,"scn",1,1,MFD,MT,MAD,MT )
