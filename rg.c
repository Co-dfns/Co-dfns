MF(cir_f){z.r=r.r;z.s=r.s;z.v=Pi*r.v.as(f64);}
SF(cir_f,array fv=rv.as(f64);
 if(!l.r){I x=l.v.as(s32).scalar<I>();if(abs(x)>10)err(16);
  switch(x){CS(0,z.v=sqrt(1-fv*fv))CS(1,z.v=sin(fv))CS(2,z.v=cos(fv))
   CS(3,z.v=tan(fv))CS(4,z.v=sqrt(1+fv*fv))CS(5,z.v=sinh(fv))
   CS(6,z.v=cosh(fv))CS(7,z.v=tanh(fv))CS(8,z.v=sqrt(fv*fv-1))CS(9,z.v=fv)
   CS(10,z.v=abs(fv))CS(-1,z.v=asin(fv))CS(-2,z.v=acos(fv))
   CS(-3,z.v=atan(fv))CS(-4,z.v=(fv+1)*sqrt((fv-1)/(fv+1)))
   CS(-5,z.v=asinh(fv))CS(-6,z.v=acosh(fv))CS(-7,z.v=atanh(fv))
   CS(-8,z.v=-sqrt(fv*fv-1))CS(-9,z.v=fv)CS(-10,z.v=fv)}R;}
 if(anyTrue<I>(abs(lv)>10))err(16);B c=cnt(z);std::vector<I> a(c);
 std::vector<D> b(c);lv.as(s32).host(a.data());fv.host(b.data());
 std::vector<D> zv(c);
 DOB(c,switch(a[i]){CS(0,zv[i]=sqrt(1-b[i]*b[i]))CS(1,zv[i]=sin(b[i]))
  CS(2,zv[i]=cos(b[i]))CS(3,zv[i]=tan(b[i]))CS(4,zv[i]=sqrt(1+b[i]*b[i]))
  CS(5,zv[i]=sinh(b[i]))CS(6,zv[i]=cosh(b[i]))CS(7,zv[i]=tanh(b[i]))
  CS(8,zv[i]=sqrt(b[i]*b[i]-1))CS(9,zv[i]=b[i])CS(10,zv[i]=abs(b[i]))
  CS(-1,zv[i]=asin(b[i]))CS(-2,zv[i]=acos(b[i]))CS(-3,zv[i]=atan(b[i]))
  CS(-4,zv[i]=(b[i]==-1)?0:(b[i]+1)*sqrt((b[i]-1)/(b[i]+1)))
  CS(-5,zv[i]=asinh(b[i]))CS(-6,zv[i]=acosh(b[i]))CS(-7,zv[i]=atanh(b[i]))
  CS(-8,zv[i]=-sqrt(b[i]*b[i]-1))CS(-9,zv[i]=b[i])CS(-10,zv[i]=b[i])})
 z.v=array(z.s,zv.data());)
MF(ctf_f){dim4 sp=z.s;sp[1]=r.r?r.s[r.r-1]:1;sp[0]=sp[1]?cnt(r)/sp[1]:1;
 sp[2]=sp[3]=1;z.r=2;z.s=sp;z.v=!cnt(z)?scl(0):array(r.v,z.s);}
DF(ctf_f){I x=l.r>r.r?l.r:r.r;if(l.r||r.r){catfn(z,l,r,x-1,p);R;}
 A a,b;catfn(a,l,p);catfn(b,r,p);catfn(z,a,b,0,p);}
DF(dec_f){I ra=r.r?r.r-1:0;I la=l.r?l.r-1:0;z.r=ra+la;z.s=dim4(1);
 if(l.s[0]!=1&&l.s[0]!=r.s[ra]&&r.s[ra]!=1)err(5);
 DO(ra,z.s[i]=r.s[i])DO(la,z.s[i+ra]=l.s[i+1])
 if(!cnt(z)){z.v=scl(0);R;}
 if(!cnt(r)||!cnt(l)){z.v=constant(0,z.s,s32);R;}
 B lc=l.s[0];array x=l.v;if(lc==1){lc=r.s[ra];x=tile(x,(I)lc);}
 x=flip(scan(x,0,AF_BINARY_MUL,false),0);
 x=array(x,lc,x.elements()/lc).as(f64);
 array y=array(r.v,cnt(r)/r.s[ra],r.s[ra]).as(f64);
 z.v=array(matmul(r.s[ra]==1?tile(y,1,(I)l.s[0]):y,x),z.s);}
MF(dis_f){z.r=0;z.s=eshp;z.v=r.v(0);}
DF(dis_f){if(l.v.isfloating())err(1);if(l.r>1)err(4);
 B lc=cnt(l);if(!lc){z=r;R;}if(lc!=1||r.r!=1)err(4);
 if(allTrue<char>(cnt(r)<=l.v(0)))err(3);
 z.r=0;z.s=eshp;array i=l.v(0);z.v=r.v(i);}
MF(div_f){z.r=r.r;z.s=r.s;z.v=1.0/r.v.as(f64);}
SF(div_f,z.v=lv.as(f64)/rv.as(f64))
