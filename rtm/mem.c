NM(mem,"mem",0,0,MT ,MFD,DFD,MT ,MT )
MF(mem_f){z.r=1;z.s=dim4(cnt(r));z.v=flat(r.v);}
DF(mem_f){z.r=l.r;z.s=l.s;I lc=(I)cnt(z);if(!lc){z.v=scl(0);R;}
 if(!cnt(r)){z.v=array(z.s,b8);z.v=0;R;}
 array y=setUnique(flat(r.v));I rc=(I)y.elements();
 array x=array(flat(l.v),lc,1);y=array(y,1,rc);
 z.v=array(anyTrue(tile(x,1,rc)==tile(y,lc,1),1),z.s);}

