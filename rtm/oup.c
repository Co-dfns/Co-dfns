OM(oup,"oup",0,0,MT,DFD,MT ,MT )
DF(oup_o){z.f=1;B lr=rnk(l),rr=rnk(r),lc=cnt(l),rc=cnt(r);
 SHP sp(lr+rr);DO((I)rr,sp[i]=r.s[i])DO((I)lr,sp[i+rr]=l.s[i])
 if(!cnt(sp)){z.s=sp;z.v=scl(0);R;}
 arr x(l.v,1,lc),y(r.v,rc,1);x=flat(tile(x,(I)rc,1));y=flat(tile(y,1,(I)lc));
 map_o mfn_c(llp);A xa(sp,x),ya(sp,y);mfn_c(z,xa,ya,e);}
