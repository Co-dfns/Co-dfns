OD(dot,"dot",0,0,MT,DFD,MT ,MT )
DF(dot_o){B lr=rnk(l),rrk=rnk(r),ra=rrk?rrk-1:0,la=lr?lr-1:0;
 if(rrk&&lr&&l.s[0]!=r.s[ra])err(5);
 A t(la+ra,scl(0));DOB(ra,t.s[i]=r.s[i])DOB(la,t.s[i+ra]=l.s[i+1])
 if(!cnt(t)){z=t;R;}if((lr&&!l.s[0])||(rrk&&!r.s[ra])){t.v=ll.id(t.s);z=t;R;}
 B c=lr?l.s[0]:rrk?r.s[ra]:1;
 std::visit(visitor{DVSTR(),
   [&](carr&lv,carr&rv){
    arr x=table(lv,l.s,1),y=table(rv,r.s,ra);
    if(!lr||1==l.s[0])x=tile(x,(U)c,1);if(!rrk||1==r.s[ra])y=tile(y,1,(U)c);
    if("add"==ll.nm&&"mul"==rr.nm){
     t.v=flat(matmul(y.as(f64),x.as(f64)));z=t;R;}
    if(x.isbool()&&y.isbool()&&"neq"==ll.nm&&"and"==rr.nm){
     t.v=flat((1&matmul(y.as(f32),x.as(f32)).as(s16)).as(b8));z=t;R;}
    B rc=1,lc=1;if(rrk)rc=cnt(r)/r.s[ra];if(lr)lc=cnt(l)/l.s[0];
    x=tile(arr(x,c,1,lc),1,(U)rc,1);y=tile(y.T(),1,1,(U)lc);
    A X(SHP{c,rc,lc},flat(x.as(f64)));A Y(SHP{c,rc,lc},flat(y.as(f64)));
    map_o mfn_c(rrp);red_o rfn_c(llp);mfn_c(X,X,Y,e);rfn_c(X,X,e);
    t.v=X.v;z=t;},
   [&](CVEC<A>&lv,carr&rv){err(16);},
   [&](carr&lv,CVEC<A>&rv){err(16);},
   [&](CVEC<A>&lv,CVEC<A>&rv){err(16);}},
  l.v,r.v);}
