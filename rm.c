MF(rdf_o){A t(r.r?r.r-1:0,dim4(1),r.v(0));DO(t.r,t.s[i]=r.s[i])
 I rc=(I)r.s[t.r];I zc=(I)cnt(t);mapop(mfn,ll,p);
 if(!zc){t.v=scl(0);z=t;R;}if(!rc){t.v=ll.id(t.s);z=t;R;}
 if(1==rc){t.v=array(r.v,t.s);z=t;R;}
 if("add"==ll.nm){if(r.v.isbool())t.v=count(r.v,t.r).as(s32);
  else t.v=sum(r.v.as(f64),t.r);z=t;R;}
 if("mul"==ll.nm){t.v=product(r.v.as(f64),t.r);z=t;R;}
 if("min"==ll.nm){t.v=min(r.v,t.r);z=t;R;}
 if("max"==ll.nm){t.v=max(r.v,t.r);z=t;R;}
 if("and"==ll.nm){t.v=allTrue(r.v,t.r);z=t;R;}
 if("lor"==ll.nm){t.v=anyTrue(r.v,t.r);z=t;R;}
 af::index x[4];x[t.r]=rc-1;t.v=r.v(x[0],x[1],x[2],x[3]);
 DO(rc-1,x[t.r]=rc-(i+2);
  mfn(t,A(t.r,t.s,r.v(x[0],x[1],x[2],x[3])),t,p));z=t;}
DF(rdf_o){if(l.r!=0&&(l.r!=1||l.s[0]!=1))err(5);if(!r.r)err(4);
 I lv=l.v.as(s32).scalar<I>();I ra=r.r-1;
  if((r.s[ra]+1)<lv)err(5);I rc=(I)((1+r.s[ra])-abs(lv));
 mapop(mfn,ll,p);A t(r.r,r.s,scl(0));t.s[ra]=rc;if(!cnt(t)){z=t;R;}
 if(!lv){t.v=ll.id(t.s);z=t;R;}seq rng(rc);af::index x[4];
 if(lv>=0){x[ra]=rng+((D)lv-1);t.v=r.v(x[0],x[1],x[2],x[3]);
  DO(lv-1,x[ra]=rng+((D)lv-(i+2));
   mfn(t,A(t.r,t.s,r.v(x[0],x[1],x[2],x[3])),t,p))
 }else{x[ra]=rng;t.v=r.v(x[0],x[1],x[2],x[3]);
  DO(abs(lv)-1,x[ra]=rng+(D)(i+1);
   mfn(t,A(t.r,t.s,r.v(x[0],x[1],x[2],x[3])),t,p))}
 z=t;}
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

