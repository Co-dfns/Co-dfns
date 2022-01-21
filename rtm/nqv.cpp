#include "codfns.h"
#include "internal.h"

NM(nqv,"nqv",0,0,MT ,MFD,DFD,MT ,MT )
DEFN(nqv)
MF(nqv_f){B rr=rnk(r);z.v=scl(rr?(I)r.s[rr-1]:1);z.s=SHP(0);}
DF(nqv_f){z.s=SHP(0);z.v=scl(!is_eqv(l,r));}
