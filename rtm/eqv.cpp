#include "codfns.h"
#include "internal.h"

NM(eqv,"eqv",0,0,MT ,MFD,DFD,MT ,MT )
DEFN(eqv)
MF(eqv_f){z.s=SHP(0);z.v=scl(rnk(r)!=0);}
DF(eqv_f){z.s=SHP(0);z.v=scl(is_eqv(l,r));}
