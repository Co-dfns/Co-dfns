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
#define PUSH(x) s.emplace(BX(x))
#define POP(f,x) x=s.top().f;s.pop()
#define EX(x) delete x
#define EF(init,ex,fun) EXPORT V ex##_dwa(lp*z,lp*l,lp*r){try{\
  A cl,cr,za;fn##init##_c(za,cl,cr,e##init);\
  cpda(cr,r);cpda(cl,l);(*(*e##init[0])[fun].f)(za,cl,cr,e##init);cpad(z,za);}\
 catch(U n){derr(n);}\
 catch(exception&e){msg=mkstr(e.what());dmx.e=msg.c_str();derr(500);}}\
EXPORT V ex##_cdf(A*z,A*l,A*r){{A il,ir,iz;fn##init##_c(iz,il,ir,e##init);}\
 (*(*e##init[0])[fun].f)(*z,*l,*r,e##init);}
#define EV(init,ex,slt)
