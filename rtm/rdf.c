NM(rdf,"rdf",0,0,DID,MT ,DFD,MT,DAD)
ID(rdf,1,s32)
OM(rdf,"rdf",0,0,MFD,DFD,MAD,DAD)
rdf_f rdf_c;
DA(rdf_f){red_c(z,l,r,e,ax);}
DF(rdf_f){A x=r;if(!rnk(r))cat_c(x,r,e);red_c(z,l,x,e,scl(scl(0)));}
MA(rdf_o){red_o mfn_c(ll);mfn_c(z,r,e,ax);}
MF(rdf_o){B rr=rnk(r);if(rr>4)err(16);
 dim4 rs;DO((I)rr,rs[i]=r.s[i])
 arr rv=moddims(r.v,rs);
 A t(rr?rr-1:0,rv(0));I tr=(I)rnk(t);DO((I)tr,t.s[i]=r.s[i])
 I rc=(I)r.s[tr];I zc=(I)cnt(t);map_o mfn_c(ll);
 if(!zc){t.v=scl(0);z=t;R;}if(!rc){t.v=ll.id(t.s);z=t;R;}
 if(1==rc){t.v=r.v;z=t;R;}
 if("add"==ll.nm){if(r.v.isbool())t.v=count(rv,tr).as(s32);
  else t.v=sum(rv.as(f64),tr);z=t;z.v=flat(z.v);R;}
 if("mul"==ll.nm){t.v=product(rv.as(f64),tr);z=t;z.v=flat(z.v);R;}
 if("min"==ll.nm){t.v=min(rv,tr);z=t;z.v=flat(z.v);R;}
 if("max"==ll.nm){t.v=max(rv,tr);z=t;z.v=flat(z.v);R;}
 if("and"==ll.nm){t.v=allTrue(rv,tr);z=t;z.v=flat(z.v);R;}
 if("lor"==ll.nm){t.v=anyTrue(rv,tr);z=t;z.v=flat(z.v);R;}
 af::index x[4];x[tr]=rc-1;t.v=flat(rv(x[0],x[1],x[2],x[3]));
 DO(rc-1,x[tr]=rc-(i+2);
  mfn_c(t,A(t.s,flat(rv(x[0],x[1],x[2],x[3]))),t,e));z=t;}
DA(rdf_o){red_o mfn_c(ll);mfn_c(z,l,r,e,ax);}
DF(rdf_o){if(!rnk(r))err(4);red_o mfn_c(ll);mfn_c(z,l,r,e,scl(scl(0)));}
