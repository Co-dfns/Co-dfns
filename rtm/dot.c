OD(dot,"dot",0,0,MT,DFD,MT ,MT )
DF(dot_o){z.f=1;I lr=(I)rnk(l),rrk=(I)rnk(r);if(lr>4||rrk>4)err(16);
 dim4 ls,rs;DO(lr,ls[i]=l.s[i])DO(rrk,rs[i]=r.s[i])
 arr lv=moddims(l.v,ls),rv=moddims(r.v,rs);
 I ra=rrk?rrk-1:0;if(rrk&&lr&&l.s[0]!=r.s[ra])err(5);
 I la=lr?lr-1:0;A t(la+ra,r.v(0));if(rnk(t)>4)err(10);
 DO(ra,t.s[i]=r.s[i])DO(la,t.s[i+ra]=l.s[i+1])
 if(!cnt(t)){t.v=scl(0);z=t;R;}
 if(!l.s[0]||!r.s[ra]){t.v=ll.id(t.s);z=t;R;}
 I c=(I)(lr?l.s[0]:r.s[ra]);
 I rc=(I)(cnt(r)/r.s[ra]);I lc=(I)(cnt(l)/l.s[0]);
 array x=array(l.v,(I)l.s[0],lc);array y=array(r.v,rc,(I)r.s[ra]);
 if(1==l.s[0]){x=tile(x,c,1);}if(1==r.s[ra]){y=tile(y,1,c);}
 dim4 ts;DO((I)rnk(t),ts[i]=t.s[i])
 if("add"==ll.nm&&"mul"==rr.nm){
  t.v=flat(matmul(y.as(f64),x.as(f64)));z=t;R;}
 if(x.isbool()&&y.isbool()&&"neq"==ll.nm&&"and"==rr.nm){
  t.v=flat((1&matmul(y.as(f32),x.as(f32)).as(s16)).as(b8));z=t;R;}
 x=tile(array(x,c,1,lc),1,rc,1);y=tile(y.T(),1,1,lc);
 A X(SHP{c,rc,lc},flat(x.as(f64)));A Y(SHP{c,rc,lc},flat(y.as(f64)));
 map_o mfn_c(rr);red_o rfn_c(ll);mfn_c(X,X,Y,e);rfn_c(X,X,e);
 t.v=X.v;z=t;}

