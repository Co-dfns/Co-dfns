#include "codfns.h"
#include "internal.h"

MF(rnk_o){if(cnt(ww)!=1)err(4);B cr=geti(ww);
 B rr=rnk(r);if(scm(ll)||cr>=rr){ll(z,r,e);R;}
 if(cr<=-rr)cr=0;if(cr<0)cr=rr+cr;B dr=rr-cr;
 A x(cr+1,r.v);DOB(cr,x.s[i]=r.s[i])DOB(dr,x.s[cr]*=r.s[rr-i-1])
 B dc=x.s[cr];A y(dr,VEC<A>(dc?dc:1));DOB(dr,y.s[dr-i-1]=r.s[rr-i-1])
 VEC<A>&yv=std::get<VEC<A>>(y.v);
 if(!dc)tke_c(x,scl(scl(1)),x,e);
 DOB(dc?dc:1,A t;sqd_c(t,scl(scl(i)),x,e);ll(yv[i],t,e))
 if(!dc)y=proto(y);tke_c(z,y,e);}
DF(rnk_o){I rr=(I)rnk(r),lr=(I)rnk(l),cl,cr,dl,dr;dim4 sl(1),sr(1);
 arr wwv;CVSWITCH(ww.v,err(6),wwv=v.as(s32),err(11))
 switch(cnt(ww)){
  CS(1,cl=cr=wwv.scalar<I>())
  CS(2,cl=wwv.scalar<I>();cr=wwv(1).scalar<I>())
  default:err(4);}
 if(cl>lr)cl=lr;if(cr>rr)cr=rr;if(cl<-lr)cl=0;if(cr<-rr)cr=0;
 if(cl<0)cl=lr+cl;if(cr<0)cr=rr+cr;if(cr>3||cl>3)err(10);
 dl=lr-cl;dr=rr-cr;if(dl!=dr&&dl&&dr)err(4);
 if(dl==dr)DO(dr,if(l.s[i+cl]!=r.s[i+cr])err(5))
 DO(dl,sl[cl]*=l.s[i+cl])DO(cl,sl[i]=l.s[i])
 DO(dr,sr[cr]*=r.s[i+cr])DO(cr,sr[i]=r.s[i])
 B sz=dl>dr?sl[cl]:sr[cr];VEC<A> tv(sz);
 A a(cl+1,l.v);DO(cl+1,a.s[i]=sl[i])A b(cr+1,r.v);DO(cr+1,b.s[i]=sr[i])
 DOB(sz,A ta;A tb; A ai=scl(scl((I)(i%sl[cl])));A bi=scl(scl((I)(i%sr[cr])));
  sqd_c(ta,ai,a,e);sqd_c(tb,bi,b,e);ll(tv[i],ta,tb,e))
 if(dr>=dl){z.s=SHP(dr);DOB(dr,z.s[i]=r.s[cr+i])}
 if(dr<dl){z.s=SHP(dl);DOB(dl,z.s[i]=l.s[cl+i])}
 z.v=tv;tke_c(z,z,e);}
