S{U f=3;U n;U x=0;wchar_t*v=L"Co-dfns";const wchar_t*e;V*c;}dmx;
S lp{S{L l;B c;U t:4;U r:4;U e:4;U _:13;U _1:16;U _2:16;B s[1];}*p;};
S dwa{B z;S{B z;V*(*ga)(U,U,B*,S lp*);V(*p[16])();V(*er)(V*);}*ws;V*p[4];};
S dwa*dwafns;Z V derr(U n){dmx.n=n;dwafns->ws->er(&dmx);}
EXPORT I DyalogGetInterpreterFunctions(dwa*p){
 if(p)dwafns=p;else R 0;if(dwafns->z<sizeof(S dwa))R 16;R 0;}
Z V err(U n,wchar_t*e){dmx.e=e;throw n;}Z V err(U n){dmx.e=L"";throw n;}
S A{I r;dim4 s;array v;A(I r,dim4 s,array v):r(r),s(s),v(v){}
 A():r(0),s(dim4()),v(array()){}};
int isinit=0;dim4 eshp=dim4(0,(B*)NULL);std::wstring msg;

#define NM(n,nm,sm,sd,di,mf,df,ma,da) S n##_f:FN{di;mf;df;ma;da;\
 n##_f(STR s,I m,I d):FN(s,m,d){}} n##fn(nm,sm,sd);
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
#define FP(n) NM(n,"",0,0,MT,MFD,DFD,MT,MT);MF(n##_f){n##fn(z,A(),r);}
#define EF(ex,fun,init) EXPORT V ex##_dwa(lp*z,lp*l,lp*r){try{\
  A cl,cr,za;if(!is##init){init##fn(za,cl,cr);is##init=1;}\
  cpda(cr,r);if(l!=NULL)cpda(cl,l);fun##fn(za,cl,cr);cpad(z,za);}\
 catch(U n){derr(n);}\
 catch(exception e){msg=mkstr(e.what());dmx.e=msg.c_str();derr(500);}}\
EXPORT V ex##_cdf(A*z,A*l,A*r){try{fun##fn(*z,*l,*r);}catch(U n){derr(n);}\
 catch(exception x){msg=mkstr(x.what());dmx.e=msg.c_str();derr(500);}}
