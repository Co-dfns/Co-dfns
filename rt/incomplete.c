#include "h.h"

/* Nothing really works here */

I codfns_indexgenm(A*z,A*l,A*r,A**ig){typ(z)=2;I64*c=elm(r);scale(z,1,*c);
 shp(z)[0]=*c;I64*d=elm(z);DO(*c,d[i]=i);R 0;}
I codfns_squadd(A*z,A*l,A*r,A**ig){scale(z,1,shp(r)[1]);typ(z)=typ(r);
 I64*row=elm(l);shp(z)[0]=shp(r)[1];
 if(typ(z)==3){D*e=elm(r);e+=*row*siz(z);cp(elm(z),e,D,siz(z));}
 else{I64*e=elm(r);e+=*row*siz(z);cp(elm(z),e,I64,siz(z));};R 0;}
I codfns_indexd(A*z,A*l,A*r,A**ig){I64*le=elm(l);typ(z)=typ(r);
 if(typ(z)==3){D*ze,*re=elm(r);prep((V**)&ze,z,l);DO(siz(z),ze[i]=re[le[i]]);}
 else{I64*ze,*re=elm(r);prep((V**)&ze,z,l);DO(siz(z),ze[i]=re[le[i]]);};R 0;}
I codfns_reshapem(A*z,A*l,A*r,A**ig){scale(z,1,rnk(r));typ(z)=2;*shp(z)=rnk(r);
 I64*e=elm(z);DO(rnk(r),e[i]=shp(r)[i]);R 0;}
I codfns_reshaped(A*z,A*l,A*r,A**ig){UI64 s=tr(siz(l),elm(l));scale(z,siz(l),s);
 typ(z)=typ(r);I64*le=elm(l);UI64 rs=siz(r);DO(siz(l),shp(z)[i]=le[i]);
 if(typ(z)==3){D*e=elm(z);D*re=elm(r);DO(s,e[i]=re[i%rs]);}
 else{I64*e=elm(z);I64*re=elm(r);DO(s,e[i]=re[i%rs]);};R 0;}
I codfns_catenated(A*z,A*l,A*r,A**ig){UI64 lsz=siz(l);UI64 rsz=siz(r);
 UI64 sz=lsz+rsz;scale(z,1,sz);*shp(z)=sz;typ(z)=typ(l);
 if(typ(z)==3){D*ze=elm(z);D*le=elm(l);D*re=elm(r);
  if(r==z){DO(rsz,ze[lsz+i]=re[i]);DO(lsz,ze[i]=le[i]);}
  else if(l==z){DO(rsz,ze[lsz+i]=re[i]);}
  else{DO(lsz,ze[i]=le[i]);DO(rsz,ze[lsz+i]=re[i]);}}
 else{I64*ze=elm(z);I64*le=elm(l);I64*re=elm(r);
  if(r==z){DO(rsz,ze[lsz+i]=re[i]);DO(lsz,ze[i]=le[i]);}
  else if(l==z){DO(rsz,ze[lsz+i]=re[i]);}
  else{DO(lsz,ze[i]=le[i]);DO(rsz,ze[lsz+i]=re[i]);}}
 R 0;}
I codfns_ptredd(A*z,A*l,A*r,A**ig){D*le=elm(l);D*re=elm(r);D v=0;
 DO(siz(r),v+=le[i]*re[i]);scale(z,0,1);*((D*)elm(z))=v;R 0;}
I codfns_eachm(A*z,A*l,A*r,I(*f)(A*,A*,A*,A**),A**e){D*ze;prep((V**)&ze,z,r);
 A sz={0,0,2,NULL,NULL};A sr={0,1,typ(r),NULL,elm(r)};
 DO(siz(z),elm(&sr)=&((D*)elm(r))[i];f(&sz,NULL,&sr,e);ze[i]=*(D*)elm(&sz));
 typ(z)=typ(&sz);array_free(&sz);R 0;}

