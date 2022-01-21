#include "codfns.h"
#include "internal.h"

NM(not,"not",1,0,MT ,MFD,DFD,MT ,MT )
DEFN(not)
SMF(not,z.v=!rv)
DF(not_f){err(16);}

