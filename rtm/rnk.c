OD(rnk,"rnk",scm(l),0,MFD,DFD)
MF(rnk_o){if(cnt(ww)!=1)err(4);I cr=ww.v.as(s32).scalar<I>();
 if(scm(ll)||cr>=r.r){ll(z,r);R;}
 if(cr<=-r.r||!cr){map_o f(ll);f(z,r);R;}
 if(cr<0)cr=r.r+cr;if(cr>3)err(10);I dr=r.r-cr;
 dim4 sp(1);DO(dr,sp[cr]*=r.s[i+cr])DO(cr,sp[i]=r.s[i])
 std::vector<A> tv(sp[cr]);A b(cr+1,sp,array(r.v,sp));
 DO((I)sp[cr],sqd_c(tv[i],scl(scl(i)),b);ll(tv[i],tv[i]))
 I mr=0;dim4 ms(1);dtype mt=b8;if(mr>3)err(10);
 DO((I)sp[cr],if(mr<tv[i].r)mr=tv[i].r;mt=mxt(mt,tv[i]);I si=i;
  DO(4,if(ms[3-i]<tv[si].s[3-i]){ms=tv[si].s;break;}))
 I mc=(I)cnt(ms);array v(mc*sp[cr],mt);v=0;
 DO((I)sp[cr],seq ix((D)cnt(tv[i]));v(ix+(D)(i*mc))=flat(tv[i].v))
 z.r=mr+dr;z.s=ms;z.s[mr]=sp[cr];z.v=array(v,z.s);}
DF(rnk_o){I cl,cr,dl,dr;dim4 sl(1),sr(1);array wwv=ww.v.as(s32);
 if(cnt(ww)==1)cl=cr=wwv.scalar<I>();
 else if(cnt(ww)==2){cl=wwv.scalar<I>();cr=wwv(1).scalar<I>();}
 else err(4);
 if(cl>l.r)cl=l.r;if(cr>r.r)cr=r.r;if(cl<-l.r)cl=0;if(cr<-r.r)cr=0;
 if(cl<0)cl=l.r+cl;if(cr<0)cr=r.r+cr;if(cr>3||cl>3)err(10);
 dl=l.r-cl;dr=r.r-cr;if(dl!=dr&&dl&&dr)err(4);
 if(dl==dr)DO(dr,if(l.s[i+cl]!=r.s[i+cr])err(5))
 DO(dl,sl[cl]*=l.s[i+cl])DO(cl,sl[i]=l.s[i])
 DO(dr,sr[cr]*=r.s[i+cr])DO(cr,sr[i]=r.s[i])
 B sz=dl>dr?sl[cl]:sr[cr];std::vector<A> tv(sz);
 A a(cl+1,sl,array(l.v,sl));A b(cr+1,sr,array(r.v,sr));
 I mr=0;dim4 ms(1);dtype mt=b8;
 DO((I)sz,A ta;A tb;A ai=scl(scl(i%sl[cl]));A bi=scl(scl(i%sr[cr]));
  sqd_c(ta,ai,a);sqd_c(tb,bi,b);ll(tv[i],ta,tb);
  if(mr<tv[i].r)mr=tv[i].r;mt=mxt(mt,tv[i]);A t=tv[i];
  DO(4,if(ms[i]<t.s[i])ms[i]=t.s[i]))
 B mc=cnt(ms);array v(mc*sz,mt);v=0;
 DOB(sz,seq ix((D)cnt(tv[i]));v(ix+(D)(i*mc))=flat(tv[i].v))
 z.r=mr+(dr>dl?dr:dl);z.s=ms;z.s[mr]=sz;z.v=array(v,z.s);}

