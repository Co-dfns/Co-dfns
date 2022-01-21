#include "codfns.h"
#include "internal.h"

NM(dec,"dec",0,0,MT,MT,DFD,MT,MT)
DEFN(dec)
DF(dec_f){B rr=rnk(r),lr=rnk(l),ra=rr?rr-1:0,la=lr?lr-1:0;z.s=SHP(ra+la);
 if(rr&&lr)if(l.s[0]!=1&&l.s[0]!=r.s[ra]&&r.s[ra]!=1)err(5);
 DOB(ra,z.s[i]=r.s[i])DOB(la,z.s[i+ra]=l.s[i+1])
 if(!cnt(z)){z.v=scl(0);R;}
 if(!cnt(r)||!cnt(l)){z.v=constant(0,cnt(z),s32);R;}
 B lc=lr?l.s[0]:1;
 arr rv;CVSWITCH(r.v,err(6),rv=v,err(11))
 arr lv;CVSWITCH(l.v,err(6),lv=v,err(11))
 arr x=unrav(lv,l.s);if(lc==1){lc=r.s[ra];x=tile(x,(I)lc);}
 x=flip(scan(x,0,AF_BINARY_MUL,false),0);
 x=arr(x,lc,x.elements()/lc).as(f64);
 arr y=arr(rv,cnt(r)/r.s[ra],r.s[ra]).as(f64);
 z.v=flat(matmul(r.s[ra]==1?tile(y,1,(I)lc):y,x));}
