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
MF(rho_f){I sp[4]={1,1,1,1};DO(r.r,sp[r.r-(i+1)]=(I)r.s[i]);
 z.s=dim4(r.r);z.r=1;if(!cnt(z)){z.v=scl(0);R;}z.v=array(z.s,sp);}
DF(rho_f){B cr=cnt(r);B cl=cnt(l);B s[4];if(l.r>1)err(11);if(cl>4)err(16);
 l.v.as(s64).host(s);z.r=(I)cl;DO(4,z.s[i]=i>=z.r?1:s[z.r-(i+1)])B cz=cnt(z);
 if(!cz){z.v=scl(0);R;}z.v=array(cz==cr?r.v:flat(r.v)(iota(cz)%cr),z.s);}
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
