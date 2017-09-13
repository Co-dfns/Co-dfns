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
