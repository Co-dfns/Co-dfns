#include "codfns.h"
#include "internal.h"

NM(gdu,"gdu",0,0,MT ,MFD,DFD,MT ,MT )
DEFN(gdu)
MF(gdu_f){B rr=rnk(r);if(rr<1)err(4);z.s=SHP(1,r.s[rr-1]);
 if(!cnt(r)){z.v=r.v;R;}B c=1;DOB(rr-1,c*=r.s[i])
 CVSWITCH(r.v,err(6)
  ,arr mt;arr a(v,c,r.s[rr-1]);arr zv=iota(dim4(z.s[0]),dim4(1),s32);
   DOB(c,sort(mt,zv,flat(a((I)(c-i-1),zv)),zv,0,true))z.v=zv
  ,err(16))}
DF(gdu_f){err(16);}
