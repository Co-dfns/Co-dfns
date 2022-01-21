#include "codfns.h"
#include "internal.h"

NM(fft,"fft",1,0,MT ,MFD,MT ,MT ,MT )
DEFN(fft)
MF(fft_f){arr rv;CVSWITCH(r.v,err(6),rv=unrav(v,r.s),err(11))
 z.s=r.s;z.v=dft(rv.type()==c64?rv:rv.as(c64),1,rv.dims());}

