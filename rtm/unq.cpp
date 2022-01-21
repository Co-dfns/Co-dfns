#include "codfns.h"
#include "internal.h"

NM(unq,"unq",0,0,MT ,MFD,DFD,MT ,MT )
DEFN(unq)
MF(unq_f){if(rnk(r)>1)err(4);if(!cnt(r)){z.s=r.s;z.v=r.v;R;}
 CVSWITCH(r.v,err(6)
  ,arr a;arr b;sort(a,b,v);arr zv=a!=shift(a,1);zv(0)=1;
   zv=where(zv);sort(b,zv,b(zv),a(zv));z.s=SHP(1,zv.elements());z.v=zv
  ,err(16))}
DF(unq_f){if(rnk(r)>1||rnk(l)>1)err(4);
 B lc=cnt(l),rc=cnt(r);
 if(!cnt(l)){z.s=SHP(1,rc);z.v=r.v;R;}if(!cnt(r)){z.s=SHP(1,lc);z.v=l.v;R;}
 arr rv;CVSWITCH(r.v,err(6),rv=v,err(16))
 arr lv;CVSWITCH(l.v,err(6),lv=v,err(16))
 dtype mt=mxt(l,r);arr x=setUnique(lv);B c=x.elements();
 x=!anyTrue(tile(rv,1,(U)c)==tile(arr(x,1,c),(U)rc,1),1);
 x=join(0,lv.as(mt),rv(where(x)).as(mt));z.s=SHP(1,x.elements());z.v=x;}
