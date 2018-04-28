MF(brk_o){ll(z,r,(r.r?r.r-1:0)-ww.v.as(f64).scalar<D>(),p);}
DF(brk_o){D ax=l.r;if(r.r>l.r)ax=r.r;if(ax)ax--;
 ll(z,l,r,ax-ww.v.as(f64).scalar<D>(),p);}
MF(com_o){ll(z,r,r,p);}DF(com_o){ll(z,r,l,p);}
DF(dot_o){I ra=r.r?r.r-1:0;if(r.r&&l.r&&l.s[0]!=r.s[ra])err(5);
 I la=l.r?l.r-1:0;A t(la+ra,r.s,r.v(0));if(t.r>4)err(10);
 t.s[ra]=1;DO(la,t.s[i+ra]=l.s[i+1])if(!cnt(t)){t.v=scl(0);z=t;R;}
 if(!l.s[0]||!r.s[ra]){t.v=ll.id(t.s);z=t;R;}
 I c=(I)(l.r?l.s[0]:r.s[ra]);
 I rc=(I)(cnt(r)/r.s[ra]);I lc=(I)(cnt(l)/l.s[0]);
 array x=array(l.v,(I)l.s[0],lc);array y=array(r.v,rc,(I)r.s[ra]);
 if(1==l.s[0]){x=tile(x,c,1);}if(1==r.s[ra]){y=tile(y,1,c);}
 if("add"==ll.nm&&"mul"==rr.nm){
  t.v=array(matmul(y.as(f64),x.as(f64)),t.s);z=t;R;}
 x=tile(array(x,c,1,lc),1,rc,1);y=tile(y.T(),1,1,lc);
 A X(3,dim4(c,rc,lc),x.as(f64));A Y(3,dim4(c,rc,lc),y.as(f64));
 mapop(mfn,rr,p);redop(rfn,ll,p);mfn(X,X,Y,p);rfn(X,X,p);
 t.v=array(X.v,t.s);z=t;}
MF(jot_o){if(!fl){rr(z,aa,r,p);R;}if(!fr){ll(z,r,ww,p);R;}
 rr(z,r,p);ll(z,z,p);}
DF(jot_o){if(!fl||!fr){err(2);}rr(z,r,p);ll(z,l,z,p);}
MF(map_o){if(scm(ll)){ll(z,r,p);R;}
 z.r=r.r;z.s=r.s;I c=(I)cnt(z);if(!c){z.v=scl(0);R;}
 A zs;A rs=scl(r.v(0));ll(zs,rs,p);if(c==1){z.v=zs.v;R;}
 array v=array(z.s,zs.v.type());v(0)=zs.v(0);
 DO(c-1,rs.v=r.v(i+1);ll(zs,rs,p);v(i+1)=zs.v(0))z.v=v;}
DF(map_o){if(scd(ll)){ll(z,l,r,p);R;}
 if((l.r==r.r&&l.s==r.s)||!l.r){z.r=r.r;z.s=r.s;}
 else if(!r.r){z.r=l.r;z.s=l.s;}else if(l.r!=r.r)err(4);
 else if(l.s!=r.s)err(5);else err(99);I c=(I)cnt(z);
 if(!c){z.v=scl(0);R;}A zs;A rs=scl(r.v(0));A ls=scl(l.v(0));
 ll(zs,ls,rs,p);if(c==1){z.v=zs.v;R;}
 array v=array(z.s,zs.v.type());v(0)=zs.v(0);
 if(!r.r){rs.v=r.v;
  DO(c-1,ls.v=l.v(i+1);ll(zs,ls,rs,p);v(i+1)=zs.v(0);)
  z.v=v;R;}
 if(!l.r){ls.v=l.v;
  DO(c-1,rs.v=r.v(i+1);ll(zs,ls,rs,p);v(i+1)=zs.v(0);)
  z.v=v;R;}
 DO(c-1,ls.v=l.v(i+1);rs.v=r.v(i+1);ll(zs,ls,rs,p);
  v(i+1)=zs.v(0))z.v=v;}
DF(oup_o){A t(l.r+r.r,r.s,r.v(0));if(t.r>4)err(10);
 DO(l.r,t.s[i+r.r]=l.s[i])if(!cnt(t)){t.v=scl(0);z=t;R;}
 array x(flat(l.v),1,cnt(l));array y(flat(r.v),cnt(r),1);
 dim4 ts(cnt(r),cnt(l));x=tile(x,(I)ts[0],1);y=tile(y,1,(I)ts[1]);
 mapop(mfn,ll,p);A xa(2,ts,x);A ya(2,ts,y);mfn(xa,xa,ya,p);
 t.v=array(xa.v,t.s);z=t;}
