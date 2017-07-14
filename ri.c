MF(rol_f){z.r=r.r;z.s=r.s;if(!cnt(r)){z.v=r.v;R;}
 array rnd=randu(r.v.dims(),f64);z.v=(0==r.v)*rnd+trunc(r.v*rnd);}
DF(rol_f){if(cnt(r)!=1||cnt(l)!=1)err(5);
 D lv=l.v.as(f64).scalar<D>();D rv=r.v.as(f64).scalar<D>();
 if(lv>rv||lv!=floor(lv)||rv!=floor(rv)||lv<0||rv<0)err(11);
 I s=(I)lv;I t=(I)rv;z.r=1;z.s=dim4(s);if(!s){z.v=scl(0);R;}
 std::vector<I> g(t);std::vector<I> d(t);
 ((1+range(t))*randu(t)).as(s32).host(g.data());
 DO(t,I j=g[i];if(i!=j)d[i]=d[j];d[j]=i)z.v=array(z.s,d.data());}
MF(rot_f){z.r=r.r;z.s=r.s;z.v=flip(r.v,0);}
DF(rot_f){I lc=(I)cnt(l);if(lc==1){z.r=r.r;z.s=r.s;
  z.v=shift(r.v,-l.v.as(s32).scalar<I>());R;}
 if(l.r!=r.r-1)err(5);DO(l.r,if(l.s[i]!=r.s[i+1])err(5))
 std::vector<I> x(lc);l.v.as(s32).host(x.data());
 z.v=array(r.v,r.s[0],lc);z.r=r.r;z.s=r.s;
 DO(lc,z.v(span,i)=shift(z.v(span,i),-x[i]))z.v=array(z.v,z.s);}
MF(rtf_f){z.r=r.r;z.s=r.s;z.v=r.r?flip(r.v,r.r-1):r.v;}
DF(rtf_f){I lc=(I)cnt(l);I ra=r.r?r.r-1:0;I ix[]={0,0,0,0};
 if(lc==1){z.r=r.r;z.s=r.s;ix[ra]=-l.v.as(s32).scalar<I>();
  z.v=shift(r.v,ix[0],ix[1],ix[2],ix[3]);R;}
 if(l.r!=r.r-1)err(5);DO(l.r,if(l.s[i]!=r.s[i])err(5))
 std::vector<I> x(lc);l.v.as(s32).host(x.data());
 z.v=array(r.v,lc,r.s[ra]);z.r=r.r;z.s=r.s;
 DO(lc,z.v(i,span)=shift(z.v(i,span),0,-x[i]))
 z.v=array(z.v,z.s);}
DF(scn_f){if(r.s[0]!=1&&r.s[0]!=sum<I>(l.v>0))err(5);
 if(l.r>1)err(5);array ca=max(1,abs(l.v)).as(s32);I c=sum<I>(ca);
 if(!cnt(l))c=0;A t(r.r?r.r:1,r.s,scl(0));t.s[0]=c;
 if(!cnt(t)){z=t;R;}t.v=array(t.s,r.v.type());t.v=0;
 array pw=0<l.v;array pa=pw*l.v;I pc=sum<I>(pa);if(!pc){z=t;R;}
 pw=where(pw);pa=scan(pa(pw),0,AF_BINARY_ADD,false);
 array si(pc,s32);si=0;si(pa)=1;si=accum(si)-1;
 array ti(pc,s32);ti=1;ti(pa)=scan(ca,0,AF_BINARY_ADD,false)(pw);
 ti=scanByKey(si,ti);t.v(ti,span)=r.v(si,span);z=t;}
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
