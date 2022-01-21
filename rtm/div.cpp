#include "codfns.h"
#include "internal.h"

NM(div,"div",1,1,DID,MFD,DFD,MT,DAD)
DEFN(div)
ID(div,1,s32)
SMF(div,z.v=1.0/rv.as(f64))
SF(div,z.v=lv.as(f64)/rv.as(f64))
