NM(scn,"scn",0,0,DID,MT ,DFD,MT ,DAD)
scn_f scn_c;
ID(scn,1,s32)
OM(scn,"scn",1,1,MFD,MT,MAD,MT )
DA(scn_f){if(ax.r>1||cnt(ax)!=1)err(5);if(!ax.v.isinteger())err(11);
 I ra=ax.v.as(s32).scalar<I>();if(ra<0)err(11);if(ra>=r.r)err(4);
 if(l.r>1)err(4);ra=r.r-ra-1;if(r.s[ra]!=1&&r.s[ra]!=sum<I>(l.v>0))err(5);
 index sx[4],tx[4];array ca=max(1,abs(l.v)).as(s32);I c=sum<I>(ca);
 if(!cnt(l))c=0;A t(r.r,r.s,scl(0));t.s[ra]=c;
 if(!cnt(t)){z=t;R;}t.v=array(t.s,r.v.type());t.v=0;
 array pw=0<l.v;array pa=pw*l.v;I pc=sum<I>(pa);if(!pc){z=t;R;}
 pw=where(pw);pa=scan(pa(pw),0,AF_BINARY_ADD,false);
 array si(pc,s32);si=0;si(pa)=1;si=accum(si)-1;sx[ra]=si;
 array ti(pc,s32);ti=1;ti(pa)=scan(ca,0,AF_BINARY_ADD,false)(pw);
 ti=scanByKey(si,ti);tx[ra]=ti;
 t.v(tx[0],tx[1],tx[2],tx[3])=r.v(sx[0],sx[1],sx[2],sx[3]);z=t;
}
DF(scn_f){A x=r;if(!x.r)cat_c(x,r,e);scn_c(z,l,x,e,scl(scl(x.r-1)));}

MA(scn_o){if(ax.r>1)err(4);if(cnt(ax)!=1)err(5);
 if(!isint(ax))err(11);I av;ax.v.as(s32).host(&av);
 if(av<0)err(11);if(av>=r.r)err(4);av=r.r-av-1;
 z.r=r.r;z.s=r.s;I rc=(I)r.s[av];I ib=isbool(r);
 if(1==rc){z.v=r.v;R;}if(!cnt(z)){z.v=scl(0);R;}
 if("add"==ll.nm){z.v=scan(r.v.as(f64),av,AF_BINARY_ADD);R;}
 if("mul"==ll.nm){z.v=scan(r.v.as(f64),av,AF_BINARY_MUL);R;}
 if("min"==ll.nm){z.v=scan(r.v.as(f64),av,AF_BINARY_MIN);R;}
 if("max"==ll.nm){z.v=scan(r.v.as(f64),av,AF_BINARY_MAX);R;}
 if("and"==ll.nm&&ib){z.v=scan(r.v,av,AF_BINARY_MIN);R;}
 if("lor"==ll.nm&&ib){z.v=scan(r.v,av,AF_BINARY_MAX);R;}
 A t(z.r-1,dim4(1),r.v(0));af::index x[4];map_o mfn_c(ll);z.v=array(z.s,f64);
 DO(av,t.s[i]=r.s[i])DO(t.r-av,t.s[av+i]=r.s[av+i+1])dim4 sp=z.s;sp[av]=1;
 DO(rc,x[av]=i;t.v=moddims(r.v(x[0],x[1],x[2],x[3]).as(f64),t.s);I c=i;
  DO(c,x[av]=c-i-1;A y(t.r,t.s,moddims(r.v(x[0],x[1],x[2],x[3]),t.s));
   mfn_c(t,y,t,e))
  x[av]=i;z.v(x[0],x[1],x[2],x[3])=moddims(t.v,sp))}
MF(scn_o){if(!r.r){z=r;R;}scn_o mfn_c(ll);mfn_c(z,r,e,scl(scl(r.r-1)));}
