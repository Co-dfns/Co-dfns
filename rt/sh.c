#include "s.h"

I same_shape(A*la,A*ra){if(rnk(la)!=rnk(ra))R 0;
 DO(rnk(ra),if(shp(la)[i]!=shp(ra)[i])R 0;)R 1;}
I copy_shape(A*t,A*s){UI32*b=shp(t);if(rnk(s)>rnk(t))b=ra(b,UI32,rnk(s));
 rnk(t)=rnk(s);shp(t)=b;cp(b,shp(s),UI32,rnk(t));R 0;}
I scale_elements(A*a,UI64 s){V*b=elm(a);if(s>siz(a))b=ra(b,I64,s);
 siz(a)=s;elm(a)=b;R 0;}
I prepare_res(V**b,A*r,A*p){if(scale_elements(r,siz(p)))R 99;
 if(copy_shape(r,p))R 99;*b=elm(r);R 0;}
V print_shape(A*a){Ps("Shape: ");DO(rnk(a),P("%"PRIu32" ",shp(a)[i]));}

