SF(nan_f,z.v=!(lv&&rv))
SF(neq_f,z.v=lv!=rv)
SF(nor_f,z.v=!(lv||rv))
MF(not_f){z.r=r.r;z.s=r.s;z.v=!r.v;}
DF(not_f){err(16);}
MF(nqv_f){z.v=scl(r.r?(I)r.s[r.r-1]:1);z.r=0;z.s=dim4(1);}
DF(nqv_f){z.r=0;z.s=eshp;I t=l.r==r.r&&l.s==r.s;
 if(t)t=allTrue<I>(l.v==r.v);z.v=scl(!t);}
MF(par_f){err(16);}
DF(par_f){err(16);}
DF(red_f){if(l.r>1)err(4);z.r=r.r?r.r:1;z.s=r.s;
 if(l.r!=0&&l.s[0]!=1&&r.r!=0&&r.s[0]!=1&&l.s[0]!=r.s[0])err(5);
 array x=l.v;if(cnt(l)==1)x=tile(x,(I)r.s[0]);
 array y=r.v;if(r.s[0]==1)y=tile(y,(I)cnt(l));
 z.s[0]=sum<B>(abs(x));if(!cnt(z)){z.v=scl(0);R;}
 array w=where(x).as(s32);
 if(z.s[0]==w.elements()){z.v=y(w,span);R;}
 array i=shift(accum(abs(x(w))),1),d=shift(w,1);i(0)=0;d(0)=0;
 array v=array(z.s[0],s32),u=array(z.s[0],s32);v=0;u=0;
 array s=(!sign(x(w))).as(s32);array t=shift(s,1);t(0)=0;
 v(i)=w-d;u(i)=s-t;z.v=y(accum(v),span);
 z.v*=tile(accum(u),1,(I)z.s[1],(I)z.s[2],(I)z.s[3]);}
MF(res_f){z.r=r.r;z.s=r.s;z.v=abs(r.v).as(r.v.type());}
SF(res_f,z.v=rv-lv*floor(rv.as(f64)/(lv+(0==lv))))
DF(rdf_f){if(l.r>1)err(4);I ra=r.r?r.r-1:0;z.r=ra+1;z.s=r.s;
 if(l.r!=0&&l.s[0]!=1&&r.r!=0&&r.s[ra]!=1&&l.s[0]!=r.s[ra])err(5);
 array x=l.v;array y=r.v;if(cnt(l)==1)x=tile(x,(I)r.s[ra]);
 if(r.s[ra]==1){dim4 s(1);s[ra]=cnt(l);y=tile(y,s);}
 z.s[ra]=sum<B>(abs(x));if(!cnt(z)){z.v=scl(0);R;}
 array w=where(x).as(s32);af::index ix[4];if(z.s[ra]==w.elements()){
  ix[ra]=w;z.v=y(ix[0],ix[1],ix[2],ix[3]);R;}
 array i=shift(accum(abs(x(w))),1),d=shift(w,1);i(0)=0;d(0)=0;
 array v=array(z.s[ra],s32),u=array(z.s[ra],s32);v=0;u=0;
 array s=(!sign(x(w))).as(s32);array t=shift(s,1);t(0)=0;
 v(i)=w-d;u(i)=s-t;ix[ra]=accum(v);z.v=y(ix[0],ix[1],ix[2],ix[3]);
 dim4 s1(1),s2(z.s);s1[ra]=z.s[ra];s2[ra]=1;u=array(accum(u),s1);
 z.v*=tile(u,(I)s2[0],(I)s2[1],(I)s2[2],(I)s2[3]);}
MF(rgt_f){z=r;}
DF(rgt_f){z=r;}
MF(rho_f){z.r=1;z.s=dim4(r.r);if(!cnt(z)){z.v=scl(0);R;}
 I sp[4]={1,1,1,1};DO(r.r,sp[r.r-(i+1)]=(I)r.s[i]);
 z.v=array(z.s,sp);}
DF(rho_f){if(l.r>1)err(11);z.r=(U)cnt(l);if(z.r>4)err(16);
 B s[4];l.v.as(s64).host(s);DO(4,z.s[i]=i>=z.r?1:s[z.r-(i+1)]);
 B cz=cnt(z);B cr=cnt(r);if(!cz){z.v=scl(0);R;}
 z.v=array(cz==cr?r.v:flat(r.v)(iota(cz)%cr),z.s);}
