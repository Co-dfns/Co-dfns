#pragma once

/* The inner loop of a monadic scalar function. */
#define scalar_fnm(mk,zt,rt) \
{I c=0;type_##zt*ze;if((c=prep((V**)&ze,res,rgt)))R c;\
 if(gpu){h2g(rgt);UI64 bs=(siz(res)+1024-1)/1024;\
  mk##_##g##rt<<<bs,1024>>>(&c,(type_##zt*)gpu(res),(type_##rt*)gpu(rgt),siz(res));\
  if(c)R c;ong(res)=1;}\
 else{g2h(rgt);DO(siz(res),mk##_##rt(&c,ze,(type_##rt*)elm(rgt),i);\
  if(c)R c;);ong(res)=0;}\
 typ(res)=apl_type_##zt;R 0;}

/* The inner loop of a scalar dyadic function for specific types. */
#define scalar_fnd(dk,zt,lt,rt) \
{I c=0;type_##zt*ze;\
 if(same_shape(lft,rgt)){if((c=prep((V**)&ze,res,lft)))R c;\
  if(gpu){h2g(lft);h2g(rgt);UI64 bs=(siz(res)+1024-1)/1024;\
   type_##lt*le=(type_##lt*)gpu(lft);type_##rt*re=(type_##rt*)gpu(rgt);\
   ze=(type_##zt*)gpu(res);\
   dk##_##g##lt##rt<<<bs,1024>>>(&c,ze,le,re,siz(res),siz(lft),siz(rgt));\
   ong(res)=1;if(c)R c;}\
  else{g2h(lft);g2h(rgt);\
   type_##lt*le=(type_##lt*)elm(lft);type_##rt*re=(type_##rt*)elm(rgt);\
   DO(siz(res),dk##_##lt##rt(&c,ze,le,re,i,siz(lft),siz(rgt));if(c)R c;)\
   ong(res)=0;}}\
 else if(scalar(lft)){if((c=prep((V**)&ze,res,rgt)))R c;\
  if(gpu){h2g(lft);h2g(rgt);UI64 bs=(siz(res)+1024-1)/1024;\
   type_##lt*le=(type_##lt*)gpu(lft);\
   type_##rt*re=(type_##rt*)gpu(rgt);ze=(type_##zt*)gpu(res);\
   dk##_##g##lt##s##rt<<<bs,1024>>>(&c,ze,le,re,siz(res),siz(rgt));\
   ong(res)=1;if(c)R c;}\
  else{g2h(lft);g2h(rgt);\
   type_##lt le=*((type_##lt*)elm(lft));type_##rt*re=(type_##rt*)elm(rgt);\
   DO(siz(res),dk##_##lt##s##rt(&c,ze,le,re,i,siz(rgt));if(c)R c;)\
   ong(res)=0;}}\
 else if(scalar(rgt)){if((c=prep((V**)&ze,res,lft)))R c;\
  if(gpu){h2g(lft);h2g(rgt);UI64 bs=(siz(res)+1024-1)/1024;\
   type_##rt*re=(type_##rt*)gpu(rgt);\
   ze=(type_##zt*)gpu(res);type_##lt*le=(type_##lt*)gpu(lft);\
   dk##_##g##lt##rt##s<<<bs,1024>>>(&c,ze,le,re,siz(res),siz(lft));\
   ong(res)=1;if(c)R c;}\
  else{g2h(lft);g2h(rgt);\
   type_##lt*le=(type_##lt*)elm(lft);type_##rt re=*((type_##rt*)elm(rgt));\
   DO(siz(res),dk##_##lt##rt##s(&c,ze,le,re,i,siz(lft));if(c)R c;)\
   ong(res)=0;}}\
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

