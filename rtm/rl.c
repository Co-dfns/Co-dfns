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
MF(sqd_f){z=r;}
DF(sqd_f){if(l.r>1)err(4);B s=!l.r?1:l.s[l.r-1];
 if(s>r.r)err(5);if(!cnt(l)){z=r;R;}
 I sv[4];af::index x[4];l.v.as(s32).host(sv);
 DO((I)s,if(sv[i]<0||sv[i]>=r.s[i])err(3));
 DO((I)s,x[r.r-(i+1)]=sv[i]);z.r=r.r-(U)s;z.s=dim4(z.r,r.s.get());
 z.v=r.v(x[0],x[1],x[2],x[3]);}
MF(sub_f){z.r=r.r;z.s=r.s;z.v=-r.v;}
SF(sub_f,z.v=lv-rv)
MF(tke_f){z=r;}
DF(tke_f){I lv[4];seq it[4];seq ix[4];B c=cnt(l);
 if(l.r>1||(c>r.r&&r.r))err(4);if(!c){z=r;R;}
 U rk=r.r?r.r:(U)l.s[0];z.r=rk;z.s=r.s;l.v.as(s32).host(lv);
 DO((I)c,{U j=rk-(i+1);I a=std::abs(lv[i]);z.s[j]=a;
  if(a>r.s[j])ix[j]=seq((D)r.s[j]);
  else if(lv[i]<0)ix[j]=seq((D)r.s[j]-a,(D)r.s[j]-1);
  else ix[j]=seq(a);
  it[j]=ix[j]+(lv[i]<0)*(a-(D)r.s[j]);})
 if(!cnt(z)){z.v=scl(0);R;}z.v=array(z.s,r.v.type());z.v=0;
 z.v(it[0],it[1],it[2],it[3])=r.v(ix[0],ix[1],ix[2],ix[3]);}
