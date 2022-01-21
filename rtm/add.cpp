#include "codfns.h"
#include "internal.h"

NM(add,"add",1,1,DID,MFD,DFD,MT,DAD)
DEFN(add)
ID(add,0,s32)
MF(add_f){z=r;}
SF(add,z.v=lv+rv)
