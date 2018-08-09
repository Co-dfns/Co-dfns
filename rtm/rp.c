MF(pow_o){if(fr){A t;A v=r;
  do{A u;ll(u,v);rr(t,u,v);if(t.r)err(5);v=u;}
  while(!t.v.as(s32).scalar<I>());z=v;R;}
 if(ww.r)err(4);I c=ww.v.as(s32).scalar<I>();z=r;DO(c,ll(z,z))}
DF(pow_o){if(fr){A t;A v=r;
  do{A u;ll(u,l,v);rr(t,u,v);if(t.r)err(5);v=u;}
  while(!t.v.as(s32).scalar<I>());z=v;R;}
 if(ww.r)err(4);I c=ww.v.as(s32).scalar<I>();
 A t=r;DO(c,ll(t,l,t))z=t;}
MF(rdf_o){A t(r.r?r.r-1:0,dim4(1),r.v(0));DO(t.r,t.s[i]=r.s[i])
 I rc=(I)r.s[t.r];I zc=(I)cnt(t);mapop(mfn,ll);
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
  mfn(t,A(t.r,t.s,r.v(x[0],x[1],x[2],x[3])),t));z=t;}
DF(rdf_o){if(l.r!=0&&(l.r!=1||l.s[0]!=1))err(5);if(!r.r)err(4);
 I lv=l.v.as(s32).scalar<I>();I ra=r.r-1;
  if((r.s[ra]+1)<lv)err(5);I rc=(I)((1+r.s[ra])-abs(lv));
 mapop(mfn,ll);A t(r.r,r.s,scl(0));t.s[ra]=rc;if(!cnt(t)){z=t;R;}
 if(!lv){t.v=ll.id(t.s);z=t;R;}seq rng(rc);af::index x[4];
 if(lv>=0){x[ra]=rng+((D)lv-1);t.v=r.v(x[0],x[1],x[2],x[3]);
  DO(lv-1,x[ra]=rng+((D)lv-(i+2));
   mfn(t,A(t.r,t.s,r.v(x[0],x[1],x[2],x[3])),t))
 }else{x[ra]=rng;t.v=r.v(x[0],x[1],x[2],x[3]);
  DO(abs(lv)-1,x[ra]=rng+(D)(i+1);
   mfn(t,A(t.r,t.s,r.v(x[0],x[1],x[2],x[3])),t))}
 z=t;}
