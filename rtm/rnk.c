OD(rnk,"rnk",scm(l),0,MFD,DFD,MT ,MT )
MF(rnk_o){z.f=1;I rr=(I)rnk(r);
 if(cnt(ww)!=1)err(4);I cr=ww.v.as(s32).scalar<I>();
 if(scm(ll)||cr>=rr){ll(z,r,e);R;}
 if(cr<=-rr||!cr){map_o f(ll);f(z,r,e);R;}
 if(cr<0)cr=rr+cr;if(cr>3)err(10);I dr=rr-cr;
 A b(cr+1,r.v);DO(dr,b.s[cr]*=r.s[i+cr])DO(cr,b.s[i]=r.s[i])
 VEC<A> tv(b.s[cr]);I mr=0;SHP ms;dtype mt=b8;
 DO((I)b.s[cr],A t;sqd_c(t,scl(scl(i)),b,e);ll(tv[i],t,e);
  t=tv[i];I tr=(I)rnk(t);if(tr>mr)mr=tr;if(mr>3)err(10);mt=mxt(mt,t);
  ms.resize(mr,1);
  DO(tr<mr?tr:mr,B mi=mr-i-1;B ti=tr-i-1;if(ms[mi]<t.s[ti])ms[mi]=t.s[ti]))
 B mc=cnt(ms);array v(mc*b.s[cr],mt);v=0;
 DO((I)b.s[cr],seq ix((D)cnt(tv[i]));v(ix+(D)(i*mc))=flat(tv[i].v))
 z.s=SHP(mr+dr);DO(dr,z.s[mr+i]=r.s[cr+i])DO(mr,z.s[i]=ms[i])
 z.v=v;}
DF(rnk_o){z.f=1;I rr=(I)rnk(r),lr=(I)rnk(l),cl,cr,dl,dr;dim4 sl(1),sr(1);
 arr wwv=ww.v.as(s32);if(cnt(ww)==1)cl=cr=wwv.scalar<I>();
 else if(cnt(ww)==2){cl=wwv.scalar<I>();cr=wwv(1).scalar<I>();}
 else err(4);
 if(cl>lr)cl=lr;if(cr>rr)cr=rr;if(cl<-lr)cl=0;if(cr<-rr)cr=0;
 if(cl<0)cl=lr+cl;if(cr<0)cr=rr+cr;if(cr>3||cl>3)err(10);
 dl=lr-cl;dr=rr-cr;if(dl!=dr&&dl&&dr)err(4);
 if(dl==dr)DO(dr,if(l.s[i+cl]!=r.s[i+cr])err(5))
 DO(dl,sl[cl]*=l.s[i+cl])DO(cl,sl[i]=l.s[i])
 DO(dr,sr[cr]*=r.s[i+cr])DO(cr,sr[i]=r.s[i])
 B sz=dl>dr?sl[cl]:sr[cr];VEC<A> tv(sz);
 A a(cl+1,l.v);DO(cl+1,a.s[i]=sl[i])A b(cr+1,r.v);DO(cr+1,b.s[i]=sr[i])
 I mr=0;SHP ms;dtype mt=b8;
 DO((I)sz,A ta;A tb;A ai=scl(scl((I)(i%sl[cl])));A bi=scl(scl((I)(i%sr[cr])));
  sqd_c(ta,ai,a,e);sqd_c(tb,bi,b,e);ll(tv[i],ta,tb,e);
  I tr=(I)rnk(tv[i]);if(mr<tr)mr=rr;mt=mxt(mt,tv[i]);A t=tv[i];
  ms.resize(mr,1);
  DO(tr<mr?tr:mr,B mi=mr-i-1;B ti=tr-i-1;if(ms[mi]<t.s[ti])ms[mi]=t.s[ti]))
 B mc=cnt(ms);arr v(mc*sz,mt);v=0;
 DOB(sz,seq ix((D)cnt(tv[i]));v(ix+(D)(i*mc))=flat(tv[i].v))
 if(dr>dl){z.s=SHP(mr+dr);DO(dr,z.s[mr+i]=r.s[cr+i])}
 else{z.s=SHP(mr+dl);DO(dl,z.s[mr+i]=l.s[cl+i])}
 DO(mr,z.s[i]=ms[i])z.v=v;}
