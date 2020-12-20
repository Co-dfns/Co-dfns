NM(int,"int",0,0,MT ,MT ,DFD,MT ,MT )
int_f int_c;
DF(int_f){z.f=1;if(rnk(r)>1||rnk(l)>1)err(4);
 if(!cnt(r)||!cnt(l)){z.v=scl(0);z.s=SHP(1,0);R;}
 arr pv=setUnique(r.v);B pc=pv.elements();z.v=constant(0,cnt(l),s64);
 for(B h;h=pc/2;pc-=h){arr t=z.v+h;replace(z.v,pv(t)>l.v,t);}
 arr ix=where(pv(z.v)==l.v);z.s=SHP(1,ix.elements());
 z.v=z.s[0]?l.v(ix):scl(0);}
