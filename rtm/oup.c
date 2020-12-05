OM(oup,"oup",0,0,MT,DFD,MT ,MT )
DF(oup_o){z.f=1;A t(l.r+r.r,r.s,r.v(0));if(t.r>4)err(10);
 DO(l.r,t.s[i+r.r]=l.s[i])if(!cnt(t)){t.v=scl(0);z=t;R;}
 array x(flat(l.v),1,cnt(l));array y(flat(r.v),cnt(r),1);
 dim4 ts(cnt(r),cnt(l));x=tile(x,(I)ts[0],1);y=tile(y,1,(I)ts[1]);
 map_o mfn(ll);A xa(2,ts,x);A ya(2,ts,y);mfn(xa,xa,ya,e);
 t.v=array(xa.v,t.s);z=t;}

