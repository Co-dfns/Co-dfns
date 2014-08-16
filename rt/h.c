#include "h.h"

I same_shape(A*la,A*ra){if(rnk(la)!=rnk(ra))R 0;
 DO(rnk(ra),if(shp(la)[i]!=shp(ra)[i])R 0;)R 1;}
I copy_shape(A*t,A*s){UI64*b=shp(t);if(rnk(s)>rnk(t))b=ra(b,UI64,rnk(s));
 rnk(t)=rnk(s);shp(t)=b;cp(b,shp(s),UI64,rnk(t));R 0;}
I scale_elements(A*a,UI64 s){V*b=elm(a);if(s>siz(a))b=ra(b,I64,s);
 siz(a)=s;elm(a)=b;R 0;}
I scale_shape(A*a,UI16 r){UI64*b=shp(a);if(r>rnk(a))b=ra(b,UI64,r);
 rnk(a)=r;shp(a)=b;R 0;}
I scale(A*a,UI16 r,UI64 s){scale_shape(a,r);scale_elements(a,s);R 0;}
I prep(V**b,A*r,A*p){if(scale_elements(r,siz(p)))R 99;
 if(copy_shape(r,p))R 99;*b=elm(r);R 0;}
UI64 tr(UI64 r,UI64*d){UI64 z=1;DO(r,z*=d[i]);R z;}
V pr(A*a){Ps("Rank: ");P("%d",rnk(a));Ps("\n");}
V ps(A*a){pr(a);Ps("Shape: ");DO(rnk(a),P("%"PRIu64" ",shp(a)[i]));Ps("\n");}
V pz(A*a){Ps("Size: ");Pi(siz(a));Ps("\n");}
V pt(A*a){Ps("Type: ");P("%d",typ(a));Ps("\n");}
V pa(A*a){ps(a);pt(a);pz(a);if(typ(a)==2)pei(a);else ped(a);}
V pei(A*a){I64*d=elm(a);DO(siz(a),Pi(d[i]);Ps(" "););Ps("\n");}
V ped(A*a){D*d=elm(a);DO(siz(a),Pd(d[i]);Ps(" "););Ps("\n");}
V array_free(A*a){free(elm(a));free(shp(a));
 siz(a)=rnk(a)=0;shp(a)=elm(a)=NULL;typ(a)=0;}
I array_cp(A*t,A*s){if(t==s)R 0;UI64*p=shp(t);V*e=elm(t);
 if(rnk(s)>rnk(t))p=ra(p,UI64,rnk(s));rnk(t)=rnk(s);cp(p,shp(s),UI64,rnk(s));
 if(typ(s)==3){if(siz(s)>siz(t))e=ra(e,D,siz(s));siz(t)=siz(s);
  cp(e,elm(s),D,siz(s));}
 else{if(siz(s)>siz(t))e=ra(e,I64,siz(s));siz(t)=siz(s);
  cp(e,elm(s),I64,siz(s));}
 typ(t)=typ(s);shp(t)=p;elm(t)=e;R 0;}

