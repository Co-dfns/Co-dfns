#define NM(n,nm,sm,sd,di,mf,df,ma,da) S n##_f:FN{di;mf;df;ma;da;\
 n##_f():FN(nm,sm,sd){}};
#define OM(n,nm,sm,sd,mf,df,ma,da) S n##_o:MOP{mf;df;ma;da;\
 n##_o(FN&l):MOP(nm,sm,sd,l){}};\
 S n##_k:MOK{V operator()(FN*&f,FN&l){f=new n##_o(l);}};
#define OD(n,nm,sm,sd,mf,df,ma,da) S n##_o:DOP{mf;df;ma;da;\
 n##_o(FN&l,FN&r):DOP(nm,sm,sd,l,r){}\
 n##_o(CA&l,FN&r):DOP(nm,sm,sd,l,r){}\
 n##_o(FN&l,CA&r):DOP(nm,sm,sd,l,r){}};\
 S n##_k:DOK{V operator()(FN*&f,FN&l,FN&r){f=new n##_o(l,r);}\
  V operator()(FN*&f,CA&l,FN&r){f=new n##_o(l,r);}\
  V operator()(FN*&f,FN&l,CA&r){f=new n##_o(l,r);}};
#define MT
#define DID inline array id(SHP)
#define MFD inline V operator()(A&,CA&,ENV&)
#define MAD inline V operator()(A&,CA&,ENV&,CA&)
#define DFD inline V operator()(A&,CA&,CA&,ENV&)
#define DAD inline V operator()(A&,CA&,CA&,ENV&,CA&)
#define DI(n) inline array n::id(SHP s)
#define ID(n,x,t) DI(n##_f){R CTant(x,s,t);}
#define MF(n) inline V n::operator()(A&z,CA&r,ENV&e)
#define MA(n) inline V n::operator()(A&z,CA&r,ENV&e,CA&ax)
#define DF(n) inline V n::operator()(A&z,CA&l,CA&r,ENV&e)
#define DA(n) inline V n::operator()(A&z,CA&l,CA&r,ENV&e,CA&ax)
#define SF(n,x) \
 DF(n##_f){B lr=rnk(l),rr=rnk(r);\
  if(lr==rr){\
   DOB(rr,if(l.s[i]!=r.s[i])err(5))z.s=l.s;Carr&lv=l.v;Carr&rv=r.v;x;R;}\
  if(!l.r){z.s=r.s;Carr&rv=r.v;arr lv=tile(l.v,r.v.dims());x;R;}\
  if(!r.r){z.s=l.s;arr rv=tile(r.v,l.v.dims());Carr&lv=l.v;x;R;}\
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
