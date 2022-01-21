#include "codfns.h"
#include "internal.h"

NM(int,"int",0,0,MT ,MT ,DFD,MT ,MT )
DEFN(int)
DF(int_f){if(rnk(r)>1||rnk(l)>1)err(4);
 if(!cnt(r)||!cnt(l)){z.v=scl(0);z.s=SHP(1,0);R;}
 arr rv;CVSWITCH(r.v,err(6),rv=v,err(16))
 arr lv;CVSWITCH(l.v,err(6),lv=v,err(16))
 arr pv=setUnique(rv);B pc=pv.elements();arr zv=constant(0,cnt(l),s64);
 for(B h;h=pc/2;pc-=h){arr t=zv+h;replace(zv,pv(t)>lv,t);}
 arr ix=where(pv(zv)==lv);z.s=SHP(1,ix.elements());
 z.v=z.s[0]?lv(ix):scl(0);}
