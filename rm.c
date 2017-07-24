MF(rnk_o){if(cnt(ww)!=1)err(4);I cr=ww.v.as(s32).scalar<I>();
 if(scm(ll)||cr>=r.r){ll(z,r,p);R;}
 if(cr<=-r.r||!cr){mapop(f,ll,p);f(z,r,p);R;}
 if(cr<0)cr=r.r+cr;if(cr>3)err(10);I dr=r.r-cr;
 dim4 sp(1);DO(dr,sp[cr]*=r.s[i+cr])DO(cr,sp[i]=r.s[i])
 std::vector<A> tv(sp[cr]);A b(cr+1,sp,array(r.v,sp));
 DO((I)sp[cr],sqdfn(tv[i],scl(scl(i)),b,p);ll(tv[i],tv[i],p))
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
 DOB(sz,A ta;A tb;A ai=scl(scl(i%sl[cl]));A bi=scl(scl(i%sr[cr]));
  sqdfn(ta,ai,a,p);sqdfn(tb,bi,b,p);ll(tv[i],ta,tb,p);
  if(mr<tv[i].r)mr=tv[i].r;mt=mxt(mt,tv[i]);A t=tv[i];
  DO(4,if(ms[i]<t.s[i])ms[i]=t.s[i]))
 B mc=cnt(ms);array v(mc*sz,mt);v=0;
 DOB(sz,seq ix((D)cnt(tv[i]));v(ix+(D)(i*mc))=flat(tv[i].v))
 z.r=mr+(dr>dl?dr:dl);z.s=ms;z.s[mr]=sz;z.v=array(v,z.s);}
MF(scn_o){z.r=r.r;z.s=r.s;I rc=(I)r.s[0];
 if(1==rc){z.v=r.v;R;}if(!cnt(z)){z.v=scl(0);R;}
 if("add"==ll.nm){z.v=scan(r.v.as(f64),0,AF_BINARY_ADD);R;}
 if("mul"==ll.nm){z.v=scan(r.v.as(f64),0,AF_BINARY_MUL);R;}
 if("min"==ll.nm){z.v=scan(r.v.as(f64),0,AF_BINARY_MIN);R;}
 if("max"==ll.nm){z.v=scan(r.v.as(f64),0,AF_BINARY_MAX);R;}
 mapop(mfn,ll,p);z.v=array(z.s,f64);A t(z.r?z.r-1:0,z.s,r.v(0));
 DO(t.r,t.s[i]=t.s[i+1]);t.s[t.r]=1;I tc=(I)cnt(t);
 DO(rc,t.v=r.v(i,span).as(f64);I c=i;
  DO(c,mfn(t,A(t.r,t.s,r.v(c-(i+1),span)),t,p))
  z.v(i,span)=t.v)}
MF(scf_o){z.r=r.r;z.s=r.s;I ra=r.r?r.r-1:0;I rc=(I)r.s[ra];
 if(1==rc){z.v=r.v;R;}if(!cnt(z)){z.v=scl(0);R;}
 if("add"==ll.nm){z.v=scan(r.v.as(f64),ra,AF_BINARY_ADD);R;}
 if("mul"==ll.nm){z.v=scan(r.v.as(f64),ra,AF_BINARY_MUL);R;}
 if("min"==ll.nm){z.v=scan(r.v.as(f64),ra,AF_BINARY_MIN);R;}
 if("max"==ll.nm){z.v=scan(r.v.as(f64),ra,AF_BINARY_MAX);R;}
 z.v=array(z.s,f64);A t(z.r?z.r-1:0,z.s,r.v(0));t.s[ra]=1;
 I tc=(I)cnt(t);af::index x[4];mapop(mfn,ll,p);
 DO(rc,x[ra]=i;t.v=r.v(x[0],x[1],x[2],x[3]).as(f64);I c=i;
  DO(c,x[ra]=c-(i+1);
   mfn(t,A(t.r,t.s,r.v(x[0],x[1],x[2],x[3])),t,p))
  x[ra]=i;z.v(x[0],x[1],x[2],x[3])=t.v)}

