#pragma once
#define scalar(x) ((x)->rank == 0)

/* The inner loop of a monadic scalar function. */
#define scalar_fnm(m,zt,rt) \
{I c;type_##zt*ze;type_##rt*re;re=elm(rgt);if((c=prep((V**)&ze,res,rgt)))R c;\
 DO(siz(res),c=m##_##rt(ze++,re++);if(c)R c;);typ(res)=apl_type_##zt;R 0;}

/* The inner loop of a scalar dyadic function for specific types. */
#define scalar_fnd(dy,zt,lt,rt) \
{I c;type_##zt*ze;\
 if(same_shape(lft,rgt)){if((c=prep((V**)&ze,res,lft)))R c;\
  type_##lt*le=elm(lft);type_##rt*re=elm(rgt);\
  DO(siz(res),c=dy##_##lt##rt(ze++,le++,re++);if(c)R c;)}\
 else if(scalar(lft)){if((c=prep((V**)&ze,res,rgt)))R c;\
  type_##lt le=*((type_##lt*)elm(lft));type_##rt*re=elm(rgt);\
  DO(siz(res),c=dy##_##lt##rt(ze++,&le,re++);if(c)R c;)}\
 else if(scalar(rgt)){if((c=prep((V**)&ze,res,lft)))R c;\
  type_##lt*le=elm(lft);type_##rt re=*((type_##rt*)elm(rgt));\
  DO(siz(res),c=dy##_##lt##rt(ze++,le++,&re);if(c)R c;)}\
 typ(res)=apl_type_##zt;R 0;}

/* The body of a top-level scalar monadic function. */
#define smd(fn,dzt,izt) \
if(typ(rgt)==apl_type_d)scalar_fnm(fn,dzt,d)\
else scalar_fnm(fn,izt,i)

/* The body of a top-level scalar dyadic function. */
#define sdd(fn,ddzt,dizt,idzt,iizt) \
if(typ(lft)==apl_type_d){if(typ(rgt)==apl_type_d)scalar_fnd(fn,ddzt,d,d)\
 else scalar_fnd(fn,dizt,d,i)}\
else{if(typ(rgt)==apl_type_d)scalar_fnd(fn,idzt,i,d)\
 else scalar_fnd(fn,iizt,i,i)}

/* Dyadic Kernel */
#define sdi(nm, zt, lt, rt, code) int inline static \
nm##_##lt##rt(type_##zt *tgt, type_##lt *lft, type_##rt *rgt){code;R 0;}

/* Monadic Kernel */
#define smi(nm, zt, rt, code) int inline static \
nm##_##rt(type_##zt *tgt, type_##rt *rgt){code;R 0;}

