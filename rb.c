#define NM(n,nm,sm,sd,di,mf,df,ma,da) S n##_f:FN{di;mf;df;ma;da;\
 n##_f(STR s,I m,I d):FN(s,m,d){}} n##fn(nm,sm,sd);
#define OM(n,nm,sm,sd,mf,df) S n##_o:MOP{mf;df;\
 n##_o(FN&l,A*p[]):MOP(nm,sm,sd,l,p){}};
#define OD(n,nm,sm,sd,mf,df) S n##_o:DOP{mf;df;\
 n##_o(FN&l,FN&r,A*p[]):DOP(nm,sm,sd,l,r,p){}\
 n##_o(const A&l,FN&r,A*p[]):DOP(nm,sm,sd,l,r,p){}\
 n##_o(FN&l,const A&r,A*p[]):DOP(nm,sm,sd,l,r,p){}};
#define MT
#define DID inline array id(dim4)
#define MFD inline V operator()(A&,const A&,A*[])
#define MAD inline V operator()(A&,const A&,D,A*[])
#define DFD inline V operator()(A&,const A&,const A&,A*[])
#define DAD inline V operator()(A&,const A&,const A&,D,A*[])
#define DI(n) inline array n::id(dim4 s)
#define ID(n,x,t) DI(n##_f){R constant(x,s,t);}
#define MF(n) inline V n::operator()(A&z,const A&r,A*p[])
#define MA(n) inline V n::operator()(A&z,const A&r,D ax,A*p[])
#define DF(n) inline V n::operator()(A&z,const A&l,const A&r,A*p[])
#define DA(n) inline V n::operator()(A&z,const A&l,const A&r,D ax,A*p[])
#define SF(n,x) inline V n::operator()(A&z,const A&l,const A&r,A*p[]){\
 if(l.r==r.r&&l.s==r.s){\
  z.r=l.r;z.s=l.s;const array&lv=l.v;const array&rv=r.v;x;R;}\
 if(!l.r){\
  z.r=r.r;z.s=r.s;const array&rv=r.v;array lv=tile(l.v,r.s);x;R;}\
 if(!r.r){\
  z.r=l.r;z.s=l.s;array rv=tile(r.v,l.s);const array&lv=l.v;x;R;}\
 if(l.r!=r.r)err(4);if(l.s!=r.s)err(5);err(99);}
#define FP(n) NM(n,"",0,0,MT,MFD,DFD,MT,MT);MF(n##_f){n##fn(z,A(),r,p);}
#define EF(n,m) EXPORT V n##_dwa(lp*z,lp*l,lp*r){try{\
  A cl,cr,za;if(!isinit){Initfn(za,cl,cr,NULL);isinit=1;}\
  cpda(cr,r);if(l!=NULL)cpda(cl,l);m##fn(za,cl,cr,env);cpad(z,za);}\
 catch(U n){derr(n);}\
 catch(exception e){msg=mkstr(e.what());dmx.e=msg.c_str();derr(500);}}\
EXPORT V n##_cdf(A*z,A*l,A*r){try{m##fn(*z,*l,*r,env);}catch(U n){derr(n);}\
 catch(exception x){msg=mkstr(x.what());dmx.e=msg.c_str();derr(500);}}

S A{I r;dim4 s;array v;A(I r,dim4 s,array v):r(r),s(s),v(v){}
 A():r(0),s(dim4()),v(array()){}};
int isinit=0;dim4 eshp=dim4(0,(B*)NULL);std::wstring msg;
S FN{STR nm;I sm;I sd;FN(STR nm,I sm,I sd):nm(nm),sm(sm),sd(sd){}
 FN():nm(""),sm(0),sd(0){}
 virtual array id(dim4 s){err(16);R array();}
 virtual V operator()(A&z,const A&r,A*p[]){err(99);}
 virtual V operator()(A&z,const A&r,D ax,A*p[]){err(99);}
 virtual V operator()(A&z,const A&l,const A&r,A*p[]){err(99);}
 virtual V operator()(A&z,const A&l,const A&r,D ax,A*p[]){err(99);}};
FN MTFN;
