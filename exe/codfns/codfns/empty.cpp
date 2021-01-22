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
#define RANK(lp) ((lp)->p->r)
#define TYPE(lp) ((lp)->p->t)
#define SHAPE(lp) ((lp)->p->s)
#define ETYPE(lp) ((lp)->p->e)
#define DATA(lp) ((V*)&SHAPE(lp)[RANK(lp)])
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
#define MFD inline V operator()(A&,CA&,ENV&)
#define MAD inline V operator()(A&,CA&,ENV&,CA&)
#define DFD inline V operator()(A&,CA&,CA&,ENV&)
#define DAD inline V operator()(A&,CA&,CA&,ENV&,CA&)
#define DI(n) inline array n::id(SHP s)
#define ID(n,x,t) DI(n##_f){R constant(x,dim4(cnt(s)),t);}
#define MF(n) inline V n::operator()(A&z,CA&r,ENV&e)
#define MA(n) inline V n::operator()(A&z,CA&r,ENV&e,CA&ax)
#define DF(n) inline V n::operator()(A&z,CA&l,CA&r,ENV&e)
#define DA(n) inline V n::operator()(A&z,CA&l,CA&r,ENV&e,CA&ax)
#define SF(n,x) \
 DF(n##_f){z.f=1;B lr=rnk(l),rr=rnk(r);\
  if(lr==rr){\
   DOB(rr,if(l.s[i]!=r.s[i])err(5))z.s=l.s;carr&lv=l.v;carr&rv=r.v;x;R;}\
  if(!lr){z.s=r.s;carr&rv=r.v;arr lv=tile(l.v,r.v.dims());x;R;}\
  if(!rr){z.s=l.s;carr rv=tile(r.v,l.v.dims());carr&lv=l.v;x;R;}\
  if(lr!=rr)err(4);err(99);}\
 DA(n##_f){z.f=1;A a=l,b=r;I f=rnk(l)>rnk(r);if(f){a=r;b=l;}\
  B ar=rnk(a),br=rnk(b);B d=br-ar;B rk=cnt(ax);if(rk!=ar)err(5);\
  VEC<D> axd(rk);SHP axv(rk);if(rk)ax.v.as(f64).host(axd.data());\
  DOB(rk,if(axd[i]!=rint(axd[i]))err(11))DOB(rk,axv[i]=(B)axd[i])\
  DOB(rk,if(axv[i]<0||br<=axv[i])err(11))\
  VEC<B> t(br);VEC<U8> tf(br,1);DOB(rk,B j=axv[i];tf[j]=0;t[j]=d+i)\
  B c=0;DOB(br,if(tf[i])t[i]=c++)A ta(SHP(1,br),array(br,t.data()));\
  trn_c(z,ta,b,e);rho_c(b,z,e);rho_c(a,b,a,e);\
  if(f)n##_c(b,z,a,e);else n##_c(b,a,z,e);\
  gdu_c(ta,ta,e);trn_c(z,ta,b,e);}
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
typedef enum{APLNC=0,APLU8,APLTI,APLSI,APLI,APLD,APLP,APLU,APLV,APLW,APLZ,
 APLR,APLF,APLQ}APLTYPE;
typedef long long L;typedef int I;typedef int16_t S16;typedef int8_t S8;
typedef double D;typedef unsigned char U8;typedef unsigned U;
typedef dim_t B;typedef cdouble DZ;typedef void V;typedef std::string STR;
typedef VEC<dim_t> SHP;typedef array arr;typedef const array carr;
typedef af::index IDX;
S{U f=3;U n;U x=0;const wchar_t*v=L"Co-dfns";const wchar_t*e;V*c;}dmx;
S lp{S{L l;B c;U t:4;U r:4;U e:4;U _:13;U _1:16;U _2:16;B s[1];}*p;};
S dwa{B z;S{B z;V*(*ga)(U,U,B*,S lp*);V(*p[16])();V(*er)(V*);}*ws;V*p[4];};
S dwa*dwafns;Z V derr(U n){dmx.n=n;dwafns->ws->er(&dmx);}
EXPORT I DyalogGetInterpreterFunctions(dwa*p){
 if(p)dwafns=p;else R 0;if(dwafns->z<(B)sizeof(S dwa))R 16;R 0;}
Z V err(U n,const wchar_t*e){dmx.e=e;throw n;}Z V err(U n){err(n,L"");}
SHP eshp=SHP(0);std::wstring msg;
std::wstring_convert<std::codecvt_utf8_utf16<wchar_t>> strconv;
S A{I f;SHP s;arr v;VEC<A> nv;
 A(SHP s,arr v):f(1),s(s),v(v){}
 A(SHP s,VEC<A> nv):f(1),s(s),nv(nv){}
 A(B r,arr v):f(1),s(SHP(r,1)),v(v){}
 A(B r,VEC<A> nv):f(1),s(SHP(r,1)),nv(nv){}
 A():f(0){}};
typedef const A CA;S FN;S MOK;S DOK;typedef std::shared_ptr<FN> FNP;
typedef std::shared_ptr<MOK> MOKP;typedef std::shared_ptr<DOK> DOKP;
typedef std::variant<A,FNP,MOKP,DOKP> BX;
typedef VEC<BX> FRM;typedef std::unique_ptr<FRM> FRMP;
typedef VEC<FRMP> ENV;typedef std::stack<BX> STK;
S FN{STR nm;I sm;I sd;FNP this_p;virtual ~FN() = default;
 FN(STR nm,I sm,I sd):nm(nm),sm(sm),sd(sd){}
 FN():nm(""),sm(0),sd(0){}
 virtual arr id(SHP s){err(16);R arr();}
 virtual V operator()(A&z,CA&r,ENV&e){err(99);}
 virtual V operator()(A&z,CA&r,ENV&e,CA&ax){err(2);}
 virtual V operator()(A&z,CA&l,CA&r,ENV&e){err(99);}
 virtual V operator()(A&z,CA&l,CA&r,ENV&e,CA&ax){err(2);}};
FNP MTFN = std::make_shared<FN>();
S MOP:FN{CA aa;FNP llp=MTFN;FN&ll=*llp;
 MOP(STR nm,I sm,I sd,CA&l):FN(nm,sm,sd),aa(l),llp(MTFN){ll=*llp;}
 MOP(STR nm,I sm,I sd,FNP llp):FN(nm,sm,sd),llp(llp){ll=*llp;}};
S DOP:FN{I fl;I fr;CA aa;CA ww;FNP llp=MTFN;FNP rrp=MTFN;FN&ll=*llp;FN&rr=*rrp;
 DOP(STR nm,I sm,I sd,FNP l,FNP r)
  :FN(nm,sm,sd),fl(1),fr(1),llp(l),rrp(r){ll=*llp;rr=*rrp;}
 DOP(STR nm,I sm,I sd,CA&l,FNP r)
  :FN(nm,sm,sd),fl(0),fr(1),aa(l),rrp(r){rr=*rrp;}
 DOP(STR nm,I sm,I sd,FNP l,CA&r)
  :FN(nm,sm,sd),fl(1),fr(0),ww(r),llp(l){ll=*llp;}
 DOP(STR nm,I sm,I sd,CA&l,CA&r)
  :FN(nm,sm,sd),fl(0),fr(0),aa(l),ww(r){}};
S MOK{virtual ~MOK() = default;
 virtual FNP operator()(FNP l){err(99);R MTFN;}
 virtual FNP operator()(CA&l){err(99);R MTFN;}};
S DOK{virtual ~DOK() = default;
 virtual FNP operator()(FNP l,FNP r){err(99);R MTFN;}
 virtual FNP operator()(CA&l,CA&r){err(99);R MTFN;}
 virtual FNP operator()(FNP l,CA&r){err(99);R MTFN;}
 virtual FNP operator()(CA&l,FNP r){err(99);R MTFN;}};
std::wstring mkstr(const char*s){R strconv.from_bytes(s);}
I scm(FN&f){R f.sm;}I scm(const A&a){R 1;}I scm(FNP f){R (*f).sm;}
I scd(FN&f){R f.sd;}I scd(const A&a){R 1;}I scd(FNP f){R (*f).sd;}
B rnk(const A&a){R a.s.size();}
B cnt(SHP s){B c=1;DOB(s.size(),c*=s[i]);R c;}
B cnt(const A&a){B c=1;DOB(rnk(a),c*=a.s[i]);R c;}
B cnt(lp*d){B c=1;DO(RANK(d),c*=SHAPE(d)[i]);R c;}
B cnt(arr&a){R a.elements();}
arr scl(D x){R constant(x,dim4(1),f64);}
arr scl(I x){R constant(x,dim4(1),s32);}
arr scl(B x){R constant(x,dim4(1),u64);}
A scl(arr v){R A(0,v);}
arr axis(CA&a,B ax){B l=1,m=1,r=1;if(ax>=rnk(a))R a.v;m=a.s[ax];
 DOB(ax,l*=a.s[i])DOB(rnk(a)-ax-1,r*=a.s[ax+i+1])
 R moddims(a.v,l,m,r);}
arr table(CA&a,B ax){B l=1,r=1;if(ax>=rnk(a))R a.v;
 DOB(ax,l*=a.s[i])DOB(rnk(a)-ax,r*=a.s[ax+i])
 R moddims(a.v,l,r);}
arr unrav(CA&a){if(rnk(a)>4)err(99);dim4 s(1);DO((I)rnk(a),s[i]=a.s[i])
 R moddims(a.v,s);}
dtype mxt(dtype at,dtype bt){if(at==c64||bt==c64)R c64;
 if(at==f64||bt==f64)R f64;
 if(at==s32||bt==s32)R s32;if(at==s16||bt==s16)R s16;
 if(at==b8||bt==b8)R b8;err(16);R f64;}
dtype mxt(carr&a,carr&b){R mxt(a.type(),b.type());}
dtype mxt(dtype at,const A&b){R mxt(at,b.v.type());}
Z arr da16(B c,lp*d){VEC<S16>b(c);S8*v=(S8*)DATA(d);
 DOB(c,b[i]=v[i]);R arr(c,b.data());}
Z arr da8(B c,lp*d){VEC<char>b(c);U8*v=(U8*)DATA(d);
 DOB(c,b[i]=1&(v[i/8]>>(7-(i%8))))R arr(c,b.data());}
V cpad(lp*d,A&a){I t;B c=cnt(a),ar=rnk(a);if(!a.f){d->p=NULL;R;}
 switch(a.v.type()){CS(c64,t=APLZ);
  CS(s32,t=APLI);CS(s16,t=APLSI);CS(b8,t=APLTI);CS(f64,t=APLD);
  default:if(c)err(16);t=APLI;}
 if(ar>15)err(16);B s[15];DOB(ar,s[ar-i-1]=a.s[i]);dwafns->ws->ga(t,(U)ar,s,d);
 if(c)a.v.host(DATA(d));}
V cpda(A&a,lp*d){if(d==NULL)R;if(15!=TYPE(d))err(16);a.f=1;a.v=scl(0);
 a.s=SHP(RANK(d));DO(RANK(d),a.s[RANK(d)-i-1]=SHAPE(d)[i]);B c=cnt(d);
 if(c){
  switch(ETYPE(d)){
   CS(APLZ ,a.v=arr(c,(DZ*)DATA(d))) CS(APLI ,a.v=arr(c,(I*)DATA(d)))
   CS(APLD ,a.v=arr(c,(D*)DATA(d)))  CS(APLSI,a.v=arr(c,(S16*)DATA(d)))
   CS(APLTI,a.v=da16(c,d))             CS(APLU8,a.v=da8(c,d))
   default:err(16);}}}
inline I isint(D x){R x==nearbyint(x);}
inline I isint(A x){R x.v.isinteger()||x.v.isbool()
  ||(x.v.isreal()&&allTrue<I>(x.v==trunc(x.v)));}
inline I isbool(A x){R x.v.isbool()
  ||(x.v.isreal()&&allTrue<I>(x.v==0||x.v==1));}
EXPORT A*mkarray(lp*d){A*z=new A;cpda(*z,d);R z;}
EXPORT V frea(A*a){delete a;}
EXPORT V exarray(lp*d,A*a){cpad(d,*a);}
EXPORT V afsync(){sync();}
EXPORT Window *w_new(char *k){R new Window(k);}
EXPORT I w_close(Window*w){R w->close();}
EXPORT V w_del(Window*w){delete w;}
EXPORT V w_img(lp*d,Window*w){A a;cpda(a,d);
 w->image(a.v.as(rnk(a)==2?f32:u8));}
EXPORT V w_plot(lp*d,Window*w){A a;cpda(a,d);w->plot(a.v.as(f32));}
EXPORT V w_hist(lp*d,D l,D h,Window*w){A a;cpda(a,d);
 w->hist(a.v.as(u32),l,h);}
EXPORT V loadimg(lp*z,char*p,I c){array a=loadImage(p,c);
 I rk=a.numdims();dim4 s=a.dims();
 A b(rk,flat(a).as(s16));DO(rk,b.s[i]=s[i])cpad(z,b);}
EXPORT V saveimg(lp*im,char*p){A a;cpda(a,im);
 saveImageNative(p,a.v.as(a.v.type()==s32?u16:u8));}
EXPORT V cd_sync(V){sync();}
S fn0_f:FN{MFD;DFD;fn0_f():FN("fn0",0,0){};};
DEFN(fn0)
MF(fn0_f){this_c(z,A(),r,e);}

ENV e0(1);I is0=0;
DF(fn0_f){if(is0)R;STK s;e[0]=std::make_unique<FRM>(0);
 is0=1;}

