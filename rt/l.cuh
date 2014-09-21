#pragma once

/* The inner loop of a monadic scalar function. */
#define scalar_fnm(mk,zt,rt) \
{I c=0;type_##zt*ze;if((c=prep((V**)&ze,res,rgt)))R c;\
 /*cudaMemcpy(gpu(rgt),elm(rgt),sizeof(I64)*siz(rgt),cudaMemcpyHostToDevice);\
 mk##_##rt<<<1,siz(res)>>>(&c,(type_##zt*)gpu(res),(type_##rt*)gpu(rgt),0);if(c)R c;\
 cudaMemcpy(elm(res),gpu(res),sizeof(I64)*siz(res),cudaMemcpyDeviceToHost);*/\
 DO(siz(res),mk##_##rt(&c,ze,(type_##rt*)elm(rgt),i);if(c)R c;);\
 typ(res)=apl_type_##zt;R 0;}

/* The inner loop of a scalar dyadic function for specific types. */
#define scalar_fnd(dk,zt,lt,rt) \
{I c=0;type_##zt*ze;\
 if(same_shape(lft,rgt)){if((c=prep((V**)&ze,res,lft)))R c;\
  type_##lt*le=(type_##lt*)elm(lft);type_##rt*re=(type_##rt*)elm(rgt);\
  DO(siz(res),dk##_##lt##rt(&c,ze,le,re,i,siz(lft),siz(rgt));if(c)R c;)}\
 else if(scalar(lft)){if((c=prep((V**)&ze,res,rgt)))R c;\
  type_##lt le=*((type_##lt*)elm(lft));type_##rt*re=(type_##rt*)elm(rgt);\
  DO(siz(res),dk##_##lt##rt(&c,ze,&le,re,i,1,siz(rgt));if(c)R c;)}\
 else if(scalar(rgt)){if((c=prep((V**)&ze,res,lft)))R c;\
  type_##lt*le=(type_##lt*)elm(lft);type_##rt re=*((type_##rt*)elm(rgt));\
  DO(siz(res),dk##_##lt##rt(&c,ze,le,&re,i,siz(lft),1);if(c)R c;)}\
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

