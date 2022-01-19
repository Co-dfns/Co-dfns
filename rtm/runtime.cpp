#include "codfns.h"
#include "internal.h"

dmx_t dmx;
std::wstring_convert<std::codecvt_utf8_utf16<wchar_t>> strconv;
std::wstring msg;

EXPORT I DyalogGetInterpreterFunctions(dwa*p){
 if(p)dwafns=p;else R 0;if(dwafns->z<(B)sizeof(S dwa))R 16;R 0;}

Z V derr(U n){dmx.n=n;dwafns->ws->er(&dmx);}
Z V err(U n,const wchar_t*e){dmx.e=e;throw n;}
Z V err(U n){err(n,L"");}

A::A(){}
A::A(B r):s(SHP(r,1)){}
A::A(B r,VALS v):s(SHP(r,1)),v(v){}

FN::FN(STR nm,I sm,I sd):nm(nm),sm(sm),sd(sd){}
FN::FN():nm(""),sm(0),sd(0){}
arr FN::id(SHP s){err(16);R arr();}
V FN::operator()(A&z,CA&r,ENV&e){err(99);}
V FN::operator()(A&z,CA&r,ENV&e,CA&ax){err(2);}
V FN::operator()(A&z,CA&l,CA&r,ENV&e){err(99);}
V FN::operator()(A&z,CA&l,CA&r,ENV&e,CA&ax){err(2);}

MOP::MOP(STR nm,I sm,I sd,CA&l):FN(nm,sm,sd),aa(l){ll=*llp;}
MOP::MOP(STR nm,I sm,I sd,FNP llp):FN(nm,sm,sd),llp(llp){ll=*llp;}

DOP::DOP(STR nm,I sm,I sd,FNP l,FNP r)
  :FN(nm,sm,sd),fl(1),fr(1),llp(l),rrp(r){ll=*llp;rr=*rrp;}
DOP::DOP(STR nm,I sm,I sd,CA&l,FNP r)
  :FN(nm,sm,sd),fl(0),fr(1),aa(l),rrp(r){rr=*rrp;}
DOP::DOP(STR nm,I sm,I sd,FNP l,CA&r)
  :FN(nm,sm,sd),fl(1),fr(0),ww(r),llp(l){ll=*llp;}
DOP::DOP(STR nm,I sm,I sd,CA&l,CA&r)
  :FN(nm,sm,sd),fl(0),fr(0),aa(l),ww(r){}

FNP MOK::operator()(FNP l){err(99);R std::make_shared<FN>();}
FNP MOK::operator()(CA&l){err(99);R std::make_shared<FN>();}

FNP DOK::operator()(FNP l,FNP r){err(99);R std::make_shared<FN>();}
FNP DOK::operator()(CA&l,CA&r){err(99);R std::make_shared<FN>();}
FNP DOK::operator()(FNP l,CA&r){err(99);R std::make_shared<FN>();}
FNP DOK::operator()(CA&l,FNP r){err(99);R std::make_shared<FN>();}

V DVSTR::operator()(NIL l,NIL r){err(6);}
V DVSTR::operator()(NIL l,carr&r){err(6);}
V DVSTR::operator()(NIL l,CVEC<A>&r){err(6);}
V DVSTR::operator()(carr&l,NIL r){err(6);}
V DVSTR::operator()(CVEC<A>&l,NIL r){err(6);}

V MVSTR::operator()(NIL r){err(6);}

std::wstring mkstr(const char*s){R strconv.from_bytes(s);}
I scm(FN&f){R f.sm;}I scm(const A&a){R 1;}I scm(FNP f){R (*f).sm;}
I scd(FN&f){R f.sd;}I scd(const A&a){R 1;}I scd(FNP f){R (*f).sd;}
B rnk(const SHP&s){R s.size();}
B rnk(const A&a){R rnk(a.s);}
B cnt(SHP s){B c=1;DOB(s.size(),c*=s[i]);R c;}
B cnt(const A&a){R cnt(a.s);}
B cnt(pkt*d){B c=1;DO(RANK(d),c*=SHAPE(d)[i]);R c;}
B cnt(arr&a){R a.elements();}
I geti(CA&a){I x;CVSWITCH(a.v,err(6),x=v.as(s32).scalar<I>(),err(11));R x;}
arr scl(D x){R constant(x,dim4(1),f64);}
arr scl(I x){R constant(x,dim4(1),s32);}
arr scl(B x){R constant(x,dim4(1),u64);}
A scl(arr v){R A(0,v);}
arr axis(carr&a,const SHP&s,B ax){B l=1,m=1,r=1;if(ax>=rnk(s))R a;m=s[ax];
 DOB(ax,l*=s[i])DOB(rnk(s)-ax-1,r*=s[ax+i+1])
 R moddims(a,l,m,r);}
arr table(carr&a,const SHP&s,B ax){B l=1,r=1;if(ax>=rnk(s))R a;
 DOB(ax,l*=s[i])DOB(rnk(s)-ax,r*=s[ax+i])
 R moddims(a,l,r);}
arr unrav(carr&a,const SHP&sp){if(rnk(sp)>4)err(99);
 dim4 s(1);DO((I)rnk(sp),s[i]=sp[i])
 R moddims(a,s);}
V af2cd(A&a,const arr&b){dim4 bs=b.dims();a.s=SHP(4,1);DO(4,a.s[i]=bs[i])
 a.v=flat(b);}
dtype mxt(dtype at,dtype bt){if(at==c64||bt==c64)R c64;
 if(at==f64||bt==f64)R f64;
 if(at==s32||bt==s32)R s32;if(at==s16||bt==s16)R s16;
 if(at==b8||bt==b8)R b8;err(16);R f64;}
dtype mxt(carr&a,carr&b){R mxt(a.type(),b.type());}
dtype mxt(dtype at,CA&b){
 R std::visit(visitor{
   [&](NIL _){err(99,L"Unexpected value error.");R s32;},
   [&](carr&v){R mxt(at,v.type());},
   [&](CVEC<A>&v){dtype zt=at;DOB(v.size(),zt=mxt(zt,v[i]));R zt;}},
  b.v);}
dtype mxt(CA&a,CA&b){R mxt(mxt(b8,a),mxt(b8,b));}
inline I isint(D x){R x==nearbyint(x);}
inline I isint(CA&x){I res=1;
 CVSWITCH(x.v
  ,err(99,L"Unexpected value error.")
  ,res=v.isinteger()||v.isbool()||(v.isreal()&&allTrue<I>(v==trunc(v)))
  ,DOB(v.size(),if(!isint(v[i])){res=0;R;}))
 R res;}
inline I isbool(carr&v){R v.isbool()||(v.isreal()&&allTrue<I>(v==0||v==1));}
inline I isbool(CA&x){I res=1;
 CVSWITCH(x.v
  ,err(99,L"Unexpected value error.")
  ,res=isbool(v)
  ,DOB(v.size(),if(!isbool(v[i])){res=0;R;}))
 R res;}
V coal(A&a){
 VSWITCH(a.v,,,
  B c=cnt(a);I can=1;
  DOB(c,A&b=v[i];
   coal(b);if(rnk(b))can=0;CVSWITCH(b.v,can=0,,can=0)
   if(!can)break)
  if(can){dtype tp=mxt(b8,a);arr nv(c,tp);
   const wchar_t*msg=L"Unexpected non-simple array type.";
   DOB(c,CVSWITCH(v[i].v,err(99,msg),nv((I)i)=v(0).as(tp),err(99,msg)))
   a.v=nv;})}
arr proto(carr&a){arr z=a;z=0;R z;}
VEC<A> proto(CVEC<A>&a){VEC<A> z(a.size());DOB(a.size(),z[i]=proto(a[i]));R z;}
A proto(CA&a){A z;z.s=a.s;CVSWITCH(a.v,err(6),z.v=proto(v),z.v=proto(v));R z;}

Z arr da16(B c,pkt*d){VEC<S16>b(c);S8*v=(S8*)DATA(d);
 DOB(c,b[i]=v[i]);R arr(c,b.data());}
Z arr da8(B c,pkt*d){VEC<char>b(c);U8*v=(U8*)DATA(d);
 DOB(c,b[i]=1&(v[i/8]>>(7-(i%8))))R arr(c,b.data());}
pkt*cpad(lp*l,CA&a){I t;B c=cnt(a),ar=rnk(a);pkt*p=NULL;
 if(ar>15)err(16,L"Dyalog APL does not support ranks > 15.");
 B s[15];DOB(ar,s[ar-i-1]=a.s[i]);
 std::visit(visitor{
   [&](NIL _){if(l)l->p=NULL;},
   [&](carr&v){
    switch(v.type()){
     CS(c64,t=APLZ);CS(s32,t=APLI);CS(s16,t=APLSI);
     CS(b8,t=APLTI);CS(f64,t=APLD);
     default:if(c)err(16);t=APLI;}
    p=dwafns->ws->ga(t,(U)ar,s,l);if(c)v.host(DATA(p));},
   [&](CVEC<A>&v){
    p=dwafns->ws->ga(APLP,(U)ar,s,l);pkt**d=(pkt**)DATA(p);
    DOB(c,if(!(d[i]=cpad(NULL,v[i])))err(6))}},
  a.v);
  R p;}
V cpda(A&a,pkt*d){
 B c=cnt(d);a.s=SHP(RANK(d));DO(RANK(d),a.s[RANK(d)-i-1]=SHAPE(d)[i]);
 switch(TYPE(d)){
  CS(15,
   if(!c){a.v=scl(0);R;}
   switch(ETYPE(d)){
    CS(APLZ ,a.v=arr(c,(DZ*)DATA(d))) CS(APLI ,a.v=arr(c,(I*)DATA(d)))
    CS(APLD ,a.v=arr(c,(D*)DATA(d)))  CS(APLSI,a.v=arr(c,(S16*)DATA(d)))
    CS(APLTI,a.v=da16(c,d))           CS(APLU8,a.v=da8(c,d))
    default:err(16);})
  CS(7,{if(APLP!=ETYPE(d))err(16);
   pkt**dv=(pkt**)DATA(d);
   if(!c)c++;a.v=VEC<A>(c);
   DOB(c,cpda(std::get<VEC<A>>(a.v)[i],dv[i]))})
  default:err(16);}}
V cpda(A&a,lp*d){if(d==NULL)R;cpda(a,d->p);}

EXPORT A*mkarray(lp*d){A*z=new A;cpda(*z,d);R z;}
EXPORT V frea(A*a){delete a;}
EXPORT V exarray(lp*d,A*a){cpad(d,*a);}
EXPORT V afsync(){sync();}
EXPORT Window *w_new(char *k){R new Window(k);}
EXPORT I w_close(Window*w){R w->close();}
EXPORT V w_del(Window*w){delete w;}
EXPORT V w_img(lp*d,Window*w){A a;cpda(a,d);
 std::visit(visitor{
   [&](NIL&_){err(6);},
   [&](VEC<A>&v){err(16,L"Image requires a flat array.");},
   [&](carr&v){w->image(v.as(rnk(a)==2?f32:u8));}},
  a.v);}
EXPORT V w_plot(lp*d,Window*w){A a;cpda(a,d);
 std::visit(visitor{
   [&](NIL&_){err(6);},
   [&](VEC<A>&v){err(16,L"Plot requires a flat array.");},
   [&](carr&v){w->plot(v.as(f32));}},
  a.v);}
EXPORT V w_hist(lp*d,D l,D h,Window*w){A a;cpda(a,d);
 std::visit(visitor{
   [&](NIL&_){err(6);},
   [&](VEC<A>&v){err(16,L"Hist requires a flat array.");},
   [&](carr&v){w->hist(v.as(u32),l,h);}},
  a.v);}
EXPORT V loadimg(lp*z,char*p,I c){array a=loadImage(p,c);
 I rk=a.numdims();dim4 s=a.dims();
 A b(rk,flat(a).as(s16));DO(rk,b.s[i]=s[i])cpad(z,b);}
EXPORT V saveimg(lp*im,char*p){A a;cpda(a,im);
 std::visit(visitor{
   [&](NIL&_){err(6);},
   [&](VEC<A>&v){err(16,L"Save requires a flat array.");},
   [&](carr&v){saveImageNative(p,v.as(v.type()==s32?u16:u8));}},
  a.v);}
EXPORT V cd_sync(V){sync();}
