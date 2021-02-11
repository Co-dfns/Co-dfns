NM(mem,"mem",0,0,MT ,MFD,DFD,MT ,MT )
DEFN(mem)
MF(mem_f){z.s=SHP(1,cnt(r));z.v=r.v;}
DF(mem_f){z.s=l.s;B lc=cnt(z);if(!lc){z.v=scl(0);R;}
 if(!cnt(r)){arr zv(lc,b8);zv=0;z.v=zv;R;}
 arr y;CVSWITCH(r.v,err(6),y=setUnique(v),err(16))
 B rc=y.elements();
 arr x;CVSWITCH(l.v,err(6),x=arr(v,lc,1),err(16))
 y=arr(y,1,rc);
 z.v=arr(anyTrue(tile(x,1,(I)rc)==tile(y,(I)lc,1),1),lc);}

