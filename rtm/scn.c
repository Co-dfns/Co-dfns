NM(scn,"scn",0,0,DID,MT ,DFD,MT ,MT )
scn_f scn_c;
ID(scn,1,s32)
OM(scn,"scn",1,1,MFD,MT)
DF(scn_f){if(r.s[0]!=1&&r.s[0]!=sum<I>(l.v>0))err(5);
 if(l.r>1)err(5);array ca=max(1,abs(l.v)).as(s32);I c=sum<I>(ca);
 if(!cnt(l))c=0;A t(r.r?r.r:1,r.s,scl(0));t.s[0]=c;
 if(!cnt(t)){z=t;R;}t.v=array(t.s,r.v.type());t.v=0;
 array pw=0<l.v;array pa=pw*l.v;I pc=sum<I>(pa);if(!pc){z=t;R;}
 pw=where(pw);pa=scan(pa(pw),0,AF_BINARY_ADD,false);
 array si(pc,s32);si=0;si(pa)=1;si=accum(si)-1;
 array ti(pc,s32);ti=1;ti(pa)=scan(ca,0,AF_BINARY_ADD,false)(pw);
 ti=scanByKey(si,ti);t.v(ti,span)=r.v(si,span);z=t;}

MF(scn_o){z.r=r.r;z.s=r.s;I rc=(I)r.s[0];
 if(1==rc){z.v=r.v;R;}if(!cnt(z)){z.v=scl(0);R;}
 if("add"==ll.nm){z.v=scan(r.v.as(f64),0,AF_BINARY_ADD);R;}
 if("mul"==ll.nm){z.v=scan(r.v.as(f64),0,AF_BINARY_MUL);R;}
 if("min"==ll.nm){z.v=scan(r.v.as(f64),0,AF_BINARY_MIN);R;}
 if("max"==ll.nm){z.v=scan(r.v.as(f64),0,AF_BINARY_MAX);R;}
 map_o mfn(ll);z.v=array(z.s,f64);A t(z.r?z.r-1:0,z.s,r.v(0));
 DO(t.r,t.s[i]=t.s[i+1]);t.s[t.r]=1;I tc=(I)cnt(t);
 DO(rc,t.v=r.v(i,span).as(f64);I c=i;
  DO(c,mfn(t,A(t.r,t.s,r.v(c-(i+1),span)),t))
  z.v(i,span)=t.v)}

