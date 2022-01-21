#include "codfns.h"
#include "internal.h"

NM(scf,"scf",0,0,DID,MT ,DFD,MT ,DAD)
DEFN(scf)
ID(scf,1,s32)
DA(scf_f){scn_c(z,l,r,e,ax);}
DF(scf_f){A x=r;if(!rnk(x))cat_c(x,r,e);scn_c(z,l,x,e,scl(scl(0)));}

MA(scf_o){scn_o mfn_c(llp);mfn_c(z,r,e,ax);}
MF(scf_o){if(!rnk(r)){z=r;R;}scn_o mfn_c(llp);mfn_c(z,r,e,scl(scl(0)));}
