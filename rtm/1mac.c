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
#define MAD inline V operator()(A&,const A&,ENV&,const A&)
#define DFD inline V operator()(A&,const A&,const A&,ENV&)
#define DAD inline V operator()(A&,const A&,const A&,ENV&,const A&)
#define DI(n) inline array n::id(dim4 s)
#define ID(n,x,t) DI(n##_f){R constant(x,s,t);}
#define MF(n) inline V n::operator()(A&z,const A&r,ENV&e)
#define MA(n) inline V n::operator()(A&z,const A&r,ENV&e,const A&ax)
#define DF(n) inline V n::operator()(A&z,const A&l,const A&r,ENV&e)
#define DA(n) inline V n::operator()(A&z,const A&l,const A&r,ENV&e,const A&ax)
#define SF(n,x) \
 DF(n##_f){\
  if(l.r==r.r){\
   DO(r.r,if(l.s[i]!=r.s[i])err(5))\
   z.r=l.r;z.s=l.s;const array&lv=l.v;const array&rv=r.v;x;R;}\
  if(!l.r){\
   z.r=r.r;z.s=r.s;const array&rv=r.v;array lv=tile(l.v,r.s);x;R;}\
  if(!r.r){\
   z.r=l.r;z.s=l.s;array rv=tile(r.v,l.s);const array&lv=l.v;x;R;}\
  if(l.r!=r.r)err(4);err(99);}\
 DA(n##_f){A a=l,b=r;I f=l.r>r.r;if(f){a=r;b=l;}I d=b.r-a.r;I rk=(I)cnt(ax);\
  if(rk>4)err(16);if(rk!=a.r)err(5000);D axd[4];I axv[4];ax.v.as(f64).host(axd);\
  DO(rk,if(axd[i]!=rint(axd[i]))err(11))DO(rk,axv[i]=(I)axd[i])\
  DO(rk,if(axv[i]<0||b.r<=axv[i])err(11))\
  I t[4];U8 tf[]={1,1,1,1};DO(rk,I j=axv[i];tf[j]=0;t[j]=d+i)\
  I c=0;DO(b.r,if(tf[i])t[i]=c++)A ta(1,dim4(b.r),array(b.r,t));\
  trn_c(z,ta,b,e);rho_c(b,z,e);rho_c(a,b,a,e);\
  if(f)n##_c(b,z,a,e);else n##_c(b,a,z,e);\
  gdu_c(ta,ta,e);trn_c(z,ta,b,e);}
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
