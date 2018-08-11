OD(dot,"dot",0,0,MT,DFD)
#define dotop(zz,ll,rr) dot_o zz(ll,rr)

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
 mapop(mfn,rr);redop(rfn,ll);mfn(X,X,Y);rfn(X,X);
 t.v=array(X.v,t.s);z=t;}

