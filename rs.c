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
