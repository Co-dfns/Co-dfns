NM(int,"int",0,0,MT ,MT ,DFD,MT ,MT )
int_f int_c;
DF(int_f){z.f=1;if(r.r>1||l.r>1)err(4);
 if(!cnt(r)||!cnt(l)){z.v=scl(0);z.s=dim4(0);z.r=1;R;}
 array pv=setUnique(r.v);B pc=pv.elements();z.v=constant(0,cnt(l),s64);
 for(B h;h=pc/2;pc-=h){array t=z.v+h;replace(z.v,pv(t)>l.v,t);}
 array ix=where(pv(z.v)==l.v);z.r=1;z.s=dim4(ix.elements());
 z.v=z.s[0]?l.v(ix):scl(0);}

