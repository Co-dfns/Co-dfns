OM(map,"map",1,1,MFD,DFD,MT ,MT )
MF(map_o){if(scm(ll)){ll(z,r,e);R;}
 z.r=r.r;z.s=r.s;I c=(I)cnt(z);if(!c){z.v=scl(0);R;}
 A zs;A rs=scl(r.v(0));ll(zs,rs,e);if(c==1){z.v=zs.v;R;}
 array v=array(z.s,zs.v.type());v(0)=zs.v(0);
 DO(c-1,rs.v=r.v(i+1);ll(zs,rs,e);v(i+1)=zs.v(0))z.v=v;}
DF(map_o){if(scd(ll)){ll(z,l,r,e);R;}
 if((l.r==r.r&&l.s==r.s)||!l.r){z.r=r.r;z.s=r.s;}
 else if(!r.r){z.r=l.r;z.s=l.s;}else if(l.r!=r.r)err(4);
 else if(l.s!=r.s)err(5);else err(99);I c=(I)cnt(z);
 if(!c){z.v=scl(0);R;}A zs;A rs=scl(r.v(0));A ls=scl(l.v(0));
 ll(zs,ls,rs,e);if(c==1){z.v=zs.v;R;}
 array v=array(z.s,zs.v.type());v(0)=zs.v(0);
 if(!r.r){rs.v=r.v;
  DO(c-1,ls.v=l.v(i+1);ll(zs,ls,rs,e);v(i+1)=zs.v(0);)
  z.v=v;R;}
 if(!l.r){ls.v=l.v;
  DO(c-1,rs.v=r.v(i+1);ll(zs,ls,rs,e);v(i+1)=zs.v(0);)
  z.v=v;R;}
 DO(c-1,ls.v=l.v(i+1);rs.v=r.v(i+1);ll(zs,ls,rs,e);
  v(i+1)=zs.v(0))z.v=v;}
