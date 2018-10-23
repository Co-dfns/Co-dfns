NM(int,"int",0,0,MT ,MT ,DFD,MT ,MT )
int_f int_c;
DF(int_f){if(r.r>1||l.r>1)err(4);
 if(!cnt(r)||!cnt(l)){z.v=scl(0);z.s=dim4(0);z.r=1;R;}
 dtype mt=mxt(l.v,r.v);z.v=setIntersect(l.v.as(mt),r.v.as(mt));
 z.r=1;z.s=dim4(z.v.elements());}

