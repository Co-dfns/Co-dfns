NM(mem,"mem",0,0,MT ,MFD,DFD,MT ,MT )
DEFN(mem)
MF(mem_f){z.s=SHP(1,cnt(r));z.v=r.v;}
DF(mem_f){z.s=l.s;B lc=cnt(z);if(!lc){z.v=scl(0);R;}
 if(!cnt(r)){z.v=arr(lc,b8);z.v=0;R;}
 arr y=setUnique(r.v);B rc=y.elements();
 arr x=arr(l.v,lc,1);y=arr(y,1,rc);
 z.v=arr(anyTrue(tile(x,1,(I)rc)==tile(y,(I)lc,1),1),lc);}

