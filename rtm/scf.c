NM(scf,"scf",0,0,DID,MT ,DFD,MT ,DAD)
scf_f scf_c;
ID(scf,1,s32)
OM(scf,"scf",1,1,MFD,MT)
DA(scf_f){scn_c(z,l,r,e,ax);}
DF(scf_f){A x=r;if(!x.r)cat_c(x,r,e);scn_c(z,l,x,e,scl(scl(0)));}

MF(scf_o){z.r=r.r;z.s=r.s;I ra=r.r?r.r-1:0;I rc=(I)r.s[ra];
 if(1==rc){z.v=r.v;R;}if(!cnt(z)){z.v=scl(0);R;}
 if("add"==ll.nm){z.v=scan(r.v.as(f64),ra,AF_BINARY_ADD);R;}
 if("mul"==ll.nm){z.v=scan(r.v.as(f64),ra,AF_BINARY_MUL);R;}
 if("min"==ll.nm){z.v=scan(r.v.as(f64),ra,AF_BINARY_MIN);R;}
 if("max"==ll.nm){z.v=scan(r.v.as(f64),ra,AF_BINARY_MAX);R;}
 if("and"==ll.nm&&r.v.isbool()){z.v=scan(r.v,ra,AF_BINARY_MIN);R;}
 if("lor"==ll.nm&&r.v.isbool()){z.v=scan(r.v,ra,AF_BINARY_MAX);R;}
 z.v=array(z.s,f64);A t(z.r?z.r-1:0,z.s,r.v(0));t.s[ra]=1;
 I tc=(I)cnt(t);af::index x[4];map_o mfn(ll);
 DO(rc,x[ra]=i;t.v=r.v(x[0],x[1],x[2],x[3]).as(f64);I c=i;
  DO(c,x[ra]=c-(i+1);
   mfn(t,A(t.r,t.s,r.v(x[0],x[1],x[2],x[3])),t,e))
  x[ra]=i;z.v(x[0],x[1],x[2],x[3])=t.v)}

