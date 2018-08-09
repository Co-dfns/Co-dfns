MF(drp_f){if(r.r)err(16);z=r;}
DF(drp_f){I lv[4];seq it[4];seq ix[4];B c=cnt(l);
 if(l.r>1||(c>r.r&&r.r))err(4);if(!c){z=r;R;}
 U rk=r.r?r.r:(U)l.s[0];z.r=rk;z.s=r.s;l.v.as(s32).host(lv);
 DO((I)c,{U j=rk-(i+1);I a=std::abs(lv[i]);
  if(a>=r.s[j]){z.s[j]=0;ix[j]=seq(0);it[j]=seq(0);}
  else if(lv[i]<0){
   z.s[j]=r.s[j]-a;ix[j]=seq((D)z.s[j]);it[j]=ix[j];}
  else{z.s[j]=r.s[j]-a;ix[j]=seq(a,(D)r.s[j]-1);it[j]=ix[j]-(D)a;}})
 if(!cnt(z)){z.v=scl(0);R;}z.v=array(z.s,r.v.type());z.v=0;
 z.v(it[0],it[1],it[2],it[3])=r.v(ix[0],ix[1],ix[2],ix[3]);}
DF(enc_f){I rk=r.r+l.r;if(rk>4)err(16);dim4 sp=r.s;DO(l.r,sp[i+r.r]=l.s[i])
 if(!cnt(sp)){z.r=rk;z.s=sp;z.v=scl(0);R;}dim4 lt=sp,rt=sp;I k=l.r?l.r-1:0;
 DO(r.r,rt[i]=1)DO(l.r,lt[i+r.r]=1)array rv=tile(r.v,rt);z.r=rk;z.s=sp;
 array sv=flip(scan(flip(l.v,k),k,AF_BINARY_MUL),k);
 array lv=tile(array(sv,rt),lt);af::index x[4];x[k]=0;
 array dv=sv;dv(x[0],x[1],x[2],x[3])=1;I s[]={0,0,0,0};s[k]=-1;
 dv=shift(dv,s[0],s[1],s[2],s[3]);dv=tile(array(dv,rt),lt);
 z.v=(lv!=0)*rem(rv,lv)+(lv==0)*rv;z.v=(dv!=0)*(z.v/dv).as(s32);}
SF(eql_f,z.v=lv==rv)
MF(eqv_f){z.r=0;z.s=eshp;z.v=scl(r.r!=0);}
DF(eqv_f){z.r=0;z.s=eshp;
 if(l.r==r.r&&l.s==r.s){z.v=allTrue(l.v==r.v);R;}z.v=scl(0);}
MF(exp_f){z.r=r.r;z.s=r.s;z.v=exp(r.v.as(f64));}
SF(exp_f,z.v=pow(lv.as(f64),rv.as(f64)))
MF(fac_f){z.r=r.r;z.s=r.s;z.v=factorial(r.v.as(f64));}
SF(fac_f,array lvf=lv.as(f64);array rvf=rv.as(f64);
 z.v=exp(log(tgamma(lvf))+log(tgamma(rvf))-log(tgamma(lvf+rvf))))
MF(fft_f){z.r=r.r;z.s=r.s;z.v=dft(r.v.type()==c64?r.v:r.v.as(c64),1,r.s);}
MF(ift_f){z.r=r.r;z.s=r.s;z.v=idft(r.v.type()==c64?r.v:r.v.as(c64),1,r.s);}
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
