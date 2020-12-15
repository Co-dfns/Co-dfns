NM(scn,"scn",0,0,DID,MT ,DFD,MT ,DAD)
scn_f scn_c;
ID(scn,1,s32)
OM(scn,"scn",1,1,MFD,MT,MAD,MT )
DA(scn_f){z.f=1;if(rnk(ax)>1||cnt(ax)!=1)err(5);if(!isint(ax))err(11);
 I ra=ax.v.as(s32).scalar<I>();B rr=rnk(r),lr=rnk(l);
 if(ra<0)err(11);if(ra>=rr)err(4);if(lr>1)err(4);ra=(I)rr-ra-1;
 if(r.s[ra]!=1&&r.s[ra]!=sum<I>(l.v>0))err(5);
 arr ca=max(1,abs(l.v)).as(s32);I c=sum<I>(ca);
 if(!cnt(l))c=0;z.s=r.s;z.s[ra]=c;B zc=cnt(z);if(!zc)R;
 z.v=arr(zc,r.v.type());z.v=0;z.v=axis(z,ra);
 arr pw=0<l.v,pa=pw*l.v;I pc=sum<I>(pa);if(!pc)R;
 pw=where(pw);pa=scan(pa(pw),0,AF_BINARY_ADD,false);
 arr si(pc,s32);si=0;si(pa)=1;si=accum(si)-1;
 arr ti(pc,s32);ti=1;ti(pa)=scan(ca,0,AF_BINARY_ADD,false)(pw);
 ti=scanByKey(si,ti);
 z.v(span,ti,span)=axis(r,ra)(span,si,span);z.v=flat(z.v);}
DF(scn_f){A x=r;if(!rnk(r))cat_c(x,r,e);
 scn_c(z,l,x,e,scl(scl(rnk(x)-1)));}

MA(scn_o){z.f=1;if(rnk(ax)>1)err(4);if(cnt(ax)!=1)err(5);
 if(!isint(ax))err(11);I av=ax.v.as(s32).scalar<I>();if(av<0)err(11);
 B rr=rnk(r);if(av>=rr)err(4);av=(I)rr-av-1;z.s=r.s;
 I rc=(I)r.s[av];if(rc==1){z.v=r.v;R;}if(!cnt(z)){z.v=scl(0);R;}
 I ib=isbool(r);arr rv=axis(r,av);
 if("add"==ll.nm){z.v=flat(scan(rv.as(f64),1,AF_BINARY_ADD));R;}
 if("mul"==ll.nm){z.v=flat(scan(rv.as(f64),1,AF_BINARY_MUL));R;}
 if("min"==ll.nm){z.v=flat(scan(rv.as(f64),1,AF_BINARY_MIN));R;}
 if("max"==ll.nm){z.v=flat(scan(rv.as(f64),1,AF_BINARY_MAX));R;}
 if("and"==ll.nm&&ib){z.v=flat(scan(rv,1,AF_BINARY_MIN));R;}
 if("lor"==ll.nm&&ib){z.v=flat(scan(rv,1,AF_BINARY_MAX));R;}
 map_o mfn_c(ll);A t(rnk(z)-1,scl(0));rv=rv.as(f64);z.v=axis(z,av).as(f64);
 DOB(av,t.s[i]=r.s[i])DOB(rnk(t)-av,t.s[av+i]=r.s[av+i+1])
 DO(rc,t.v=flat(rv(span,i,span));I c=i;
  DO(c,A y(t.s,flat(rv(span,c-i-1,span)));mfn_c(t,y,t,e))
  z.v(span,i,span)=t.v)
 z.v=flat(z.v);}
MF(scn_o){B rr=rnk(r);if(!rr){z=r;R;}
 scn_o mfn_c(ll);mfn_c(z,r,e,scl(scl(rr-1)));}
