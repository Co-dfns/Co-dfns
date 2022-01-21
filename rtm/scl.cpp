#include "codfns.h"
#include "internal.h"

V sclfn(A&z,CA&l,CA&r,ENV&e,CA&ax,FN&me_c){
 A a=l,b=r;I f=rnk(l)>rnk(r);if(f){a=r;b=l;}
 B ar=rnk(a),br=rnk(b);B d=br-ar;B rk=cnt(ax);if(rk!=ar)err(5);
 VEC<D> axd(rk);SHP axv(rk);
 if(rk)
  CVSWITCH(ax.v
   ,err(99,L"Unexpected value error.")
   ,v.as(f64).host(axd.data())
   ,err(99,L"Unexpected nested shape."))
 DOB(rk,if(axd[i]!=rint(axd[i]))err(11))DOB(rk,axv[i]=(B)axd[i])
 DOB(rk,if(axv[i]<0||br<=axv[i])err(11))
 VEC<B> t(br);VEC<U8> tf(br,1);DOB(rk,B j=axv[i];tf[j]=0;t[j]=d+i)
 B c=0;DOB(br,if(tf[i])t[i]=c++)A ta(SHP(1,br),arr(br,t.data()));
 trn_c(z,ta,b,e);rho_c(b,z,e);rho_c(a,b,a,e);
 if(f)me_c(b,z,a,e);else me_c(b,a,z,e);
 gdu_c(ta,ta,e);trn_c(z,ta,b,e);}
