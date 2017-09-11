MF(fac_f){z.r=r.r;z.s=r.s;z.v=factorial(r.v.as(f64));}
SF(fac_f,array lvf=lv.as(f64);array rvf=rv.as(f64);
 z.v=exp(log(tgamma(lvf))+log(tgamma(rvf))-log(tgamma(lvf+rvf))))
MF(fft_f){z.r=r.r;z.s=r.s;z.v=dft(r.v,1,r.s);}
MF(ift_f){z.r=r.r;z.s=r.s;z.v=idft(r.v,1,r.s);}
DF(fnd_f){A t(r.r,r.s,array(r.s,b8));if(!cnt(t)){t.v=scl(0);z=t;R;}
 t.v=0;if(l.r>r.r){z=t;R;}DO(4,if(l.s[i]>r.s[i]){z=t;R;})
 if(!cnt(l)){t.v=1;z=t;R;}dim4 sp;DO(4,sp[i]=1+(t.s[i]-l.s[i]))
 seq x[4];DO(4,x[i]=seq((D)sp[i]))t.v(x[0],x[1],x[2],x[3])=1;
 DO((I)l.s[0],I m=i;
  DO((I)l.s[1],I k=i;
   DO((I)l.s[2],I j=i;
    DO((I)l.s[3],t.v(x[0],x[1],x[2],x[3])=t.v(x[0],x[1],x[2],x[3])
     &(tile(l.v(m,k,j,i),sp)
      ==r.v(x[0]+(D)m,x[1]+(D)k,x[2]+(D)j,x[3]+(D)i))))))
 z=t;}
MF(gdd_f){if(r.r<1)err(4);z.r=1;z.s=dim4(r.s[r.r-1]);
 if(!cnt(r)){z.v=r.v;R;}I c=1;DO(r.r-1,c*=(I)r.s[i]);
 array mt,a=array(r.v,c,r.s[r.r-1]);z.v=iota(z.s,dim4(1),s32);
 DO(c,sort(mt,z.v,flat(a(c-(i+1),z.v)),z.v,0,false))}
DF(gdd_f){err(16);}
MF(gdu_f){if(r.r<1)err(4);z.r=1;z.s=dim4(r.s[r.r-1]);
 if(!cnt(r)){z.v=r.v;R;}I c=1;DO(r.r-1,c*=(I)r.s[i]);
 array mt,a=array(r.v,c,r.s[r.r-1]);z.v=iota(z.s,dim4(1),s32);
 DO(c,sort(mt,z.v,flat(a(c-(i+1),z.v)),z.v,0,true))}
DF(gdu_f){err(16);}
SF(gte_f,z.v=lv>=rv)
SF(gth_f,z.v=lv>rv)
DF(int_f){if(r.r>1||l.r>1)err(4);
 if(!cnt(r)||!cnt(l)){z.v=scl(0);z.s=dim4(0);z.r=1;R;}
 dtype mt=mxt(l.v,r.v);z.v=setIntersect(l.v.as(mt),r.v.as(mt));
 z.r=1;z.s=dim4(z.v.elements());}
MF(iot_f){if(r.r>1)err(4);B c=cnt(r);if(c>4)err(10);
 if(c>1)err(16);
 z.r=1;z.s=dim4(r.v.as(s32).scalar<I>());
 z.v=z.s[0]?iota(z.s,dim4(1),s32):scl(0);}
DF(iot_f){z.r=r.r;z.s=r.s;B c=cnt(r);if(!c){z.v=scl(0);R;}
 B lc=cnt(l)+1;if(lc==1){z.v=scl(0);R;};if(l.r>1)err(16);
 array rf=flat(r.v).T();dtype mt=mxt(l.v,rf);
 z.v=join(0,tile(l.v,1,(U)c).as(mt),rf.as(mt))==tile(rf,(U)lc,1);
 z.v=min((z.v*iota(dim4(lc),dim4(1,c),s32)+((!z.v)*lc).as(s32)),0);
 z.v=array(z.v,z.s);}
MF(lft_f){z=r;}
DF(lft_f){z=l;}
MF(log_f){z.r=r.r;z.s=r.s;z.v=log(r.v.as(f64));}
SF(log_f,z.v=log(rv.as(f64))/log(lv.as(f64)))
SF(lor_f,if(rv.isbool()&&lv.isbool())z.v=lv||rv;
 else if(lv.isbool()&&rv.isinteger())z.v=lv+(!lv)*abs(rv).as(rv.type());
 else if(rv.isbool()&&lv.isinteger())z.v=rv+(!rv)*abs(lv).as(lv.type());
 else if(lv.isinteger()&&rv.isinteger()){B c=cnt(z);
  std::vector<I> a(c);abs(lv).as(s32).host(a.data());
  std::vector<I> b(c);abs(rv).as(s32).host(b.data());
  DOB(c,while(b[i]){I t=b[i];b[i]=a[i]%b[i];a[i]=t;})
  z.v=array(z.s,a.data());}
 else{B c=cnt(z);
  std::vector<D> a(c);abs(lv).as(f64).host(a.data());
  std::vector<D> b(c);abs(rv).as(f64).host(b.data());
  DOB(c,while(b[i]>1e-12){D t=b[i];b[i]=fmod(a[i],b[i]);a[i]=t;})
  z.v=array(z.s,a.data());})
