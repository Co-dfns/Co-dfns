#include "codfns.h"
#include "internal.h"

NM(rol,"rol",1,0,MT ,MFD,DFD,MT ,MT )
DEFN(rol)
SMF(rol,arr rnd=randu(rv.dims(),f64);z.v=(0==rv)*rnd+trunc(rv*rnd))
DF(rol_f){if(cnt(r)!=1||cnt(l)!=1)err(5);
 D lv;CVSWITCH(l.v,err(6),lv=v.as(f64).scalar<D>(),err(11))
 D rv;CVSWITCH(r.v,err(6),rv=v.as(f64).scalar<D>(),err(11))
 if(lv>rv||lv!=floor(lv)||rv!=floor(rv)||lv<0||rv<0)err(11);
 I s=(I)lv;I t=(I)rv;z.s=SHP(1,s);if(!s){z.v=scl(0);R;}
 VEC<I> g(t);VEC<I> d(t);
 ((1+range(t))*randu(t)).as(s32).host(g.data());
 DO(t,I j=g[i];if(i!=j)d[i]=d[j];d[j]=i)z.v=arr(s,d.data());}
