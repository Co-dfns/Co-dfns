NM(scf,"scf",0,0,DID,MT ,DFD,MT ,MT )
ID(scf,1,s32)
OM(scf,"scf",1,1,MFD,MT)
DF(scf_f){I ra=r.r?r.r-1:0;af::index sx[4];af::index tx[4];
 if(r.s[ra]!=1&&r.s[ra]!=sum<I>(l.v>0))err(5);
 if(l.r>1)err(5);array ca=max(1,abs(l.v)).as(s32);I c=sum<I>(ca);
 if(!cnt(l))c=0;A t(ra+1,r.s,scl(0));t.s[ra]=c;
 if(!cnt(t)){z=t;R;}t.v=array(t.s,r.v.type());t.v=0;
 array pw=0<l.v;array pa=pw*l.v;I pc=sum<I>(pa);if(!pc){z=t;R;}
 pw=where(pw);pa=scan(pa(pw),0,AF_BINARY_ADD,false);
 array si(pc,s32);si=0;si(pa)=1;si=accum(si)-1;sx[ra]=si;
 array ti(pc,s32);ti=1;ti(pa)=scan(ca,0,AF_BINARY_ADD,false)(pw);
 ti=scanByKey(si,ti);tx[ra]=ti;
 t.v(tx[0],tx[1],tx[2],tx[3])=r.v(sx[0],sx[1],sx[2],sx[3]);z=t;}

#define scfop(zz,rr) scf_o zz(rr)

MF(scf_o){z.r=r.r;z.s=r.s;I ra=r.r?r.r-1:0;I rc=(I)r.s[ra];
 if(1==rc){z.v=r.v;R;}if(!cnt(z)){z.v=scl(0);R;}
 if("add"==ll.nm){z.v=scan(r.v.as(f64),ra,AF_BINARY_ADD);R;}
 if("mul"==ll.nm){z.v=scan(r.v.as(f64),ra,AF_BINARY_MUL);R;}
 if("min"==ll.nm){z.v=scan(r.v.as(f64),ra,AF_BINARY_MIN);R;}
 if("max"==ll.nm){z.v=scan(r.v.as(f64),ra,AF_BINARY_MAX);R;}
 z.v=array(z.s,f64);A t(z.r?z.r-1:0,z.s,r.v(0));t.s[ra]=1;
 I tc=(I)cnt(t);af::index x[4];mapop(mfn,ll);
 DO(rc,x[ra]=i;t.v=r.v(x[0],x[1],x[2],x[3]).as(f64);I c=i;
  DO(c,x[ra]=c-(i+1);
   mfn(t,A(t.r,t.s,r.v(x[0],x[1],x[2],x[3])),t))
  x[ra]=i;z.v(x[0],x[1],x[2],x[3])=t.v)}

