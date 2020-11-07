NM(rdf,"rdf",0,0,DID,MT ,DFD,MT,DAD)
ID(rdf,1,s32)
OM(rdf,"rdf",0,0,MFD,DFD,MAD,DAD)
rdf_f rdf_c;
DA(rdf_f){red_c(z,l,r,e,ax);}
DF(rdf_f){A x=r;if(!r.r)cat_c(x,r,e);red_c(z,l,x,e,scl(scl(0)));}
MA(rdf_o){red_o mfn_c(ll);mfn_c(z,r,e,ax);}
MF(rdf_o){A t(r.r?r.r-1:0,dim4(1),r.v(0));DO(t.r,t.s[i]=r.s[i])
 I rc=(I)r.s[t.r];I zc=(I)cnt(t);map_o mfn_c(ll);
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
  mfn_c(t,A(t.r,t.s,r.v(x[0],x[1],x[2],x[3])),t,e));z=t;}
DA(rdf_o){red_o mfn_c(ll);mfn_c(z,l,r,e,ax);}
DF(rdf_o){if(!r.r)err(4);red_o mfn_c(ll);mfn_c(z,l,r,e,scl(scl(0)));}
