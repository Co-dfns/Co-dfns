#include "h.h"

/* SCALAR PRIMITIVES */
/*  +A */ scalar_monadic(addm,i,d,{*tgt = *rgt;}) 
/* A+B */ scalar_dyadic(addd,d,d,d,i,{*tgt = *lft + *rgt;}) 
/*  ÷A */ scalar_monadic(dividem,d,d,{if(*rgt!=0){*tgt=1.0 / *rgt;}
 else ERR(11,"DOMAIN ERROR: Divide by zero\n");})
/* A÷B */ scalar_dyadic(divided,d,d,d,d,{
 if(*rgt!=0){*tgt=(1.0 * *lft)/(1.0 * *rgt);}
 else ERR(11,"DOMAIN ERROR: Divide by zero\n");})
/* A=B */ scalar_dyadic(equald,i,i,i,i,{*tgt=(*lft==*rgt);})
/* A≥B */ scalar_dyadic(greateqd,i,i,i,i,{*tgt=(*lft>=*rgt);})
/* A>B */ scalar_dyadic(greaterd,i,i,i,i,{*tgt=(*lft>*rgt);})
/* A≤B */ scalar_dyadic(lesseqd,i,i,i,i,{*tgt=(*lft<=*rgt);})
/* A<B */ scalar_dyadic(lessd,i,i,i,i,{*tgt=(*lft<*rgt);})
/*  ⍟A */ scalar_monadic(logm,d,d,{*tgt=log(*rgt);})
/* A⍟B */ scalar_dyadic(logd,d,d,d,d,{*tgt=log(*rgt)/log(*lft);})
/*  |A */ scalar_monadic(residuem,d,i,{
 *tgt=_Generic(*rgt,double:fabs,int64_t:labs)(*rgt);})
#define RESIDUED {D r;r=*rgt/ *lft;r=floor(r);*tgt=*rgt-r * *lft;}
/* A|B */ scalar_dyadic_inner(residued,d,d,d,RESIDUED)
/* A|B */ scalar_dyadic_inner(residued,d,d,i,RESIDUED)
/* A|B */ scalar_dyadic_inner(residued,d,i,d,RESIDUED)
/* A|B */ scalar_dyadic_inner(residued,i,i,i,*tgt=*lft%*rgt;)
/* A|B */ scalar_dyadic_main(residued,d,d,d,i)
/*  ⌈B */ scalar_monadic(maxm,d,i,{*tgt=ceil(*rgt);})
/* A⌈B */ scalar_dyadic(maxd,d,d,d,i,{*tgt=(*lft>=*rgt?*lft:*rgt);})
/*  ⌊A */ scalar_monadic(minm,d,i,{*tgt = floor(*rgt);})
/* A⌊B */ scalar_dyadic(mind,d,d,d,i,{*tgt=(*lft<=*rgt?*lft:*rgt);})
/*  ×A */ scalar_monadic(multiplym,d,i,{if(*rgt==0)*tgt=0;
 else if(*rgt<0)*tgt=-1;else *tgt=1;})
/* A×B */ scalar_dyadic(multiplyd,d,d,d,i,{*tgt=*lft * *rgt;})
/* A≠B */ scalar_dyadic(neqd,i,i,i,i,{*tgt=(*lft!=*rgt);})
/*  ~A */ scalar_monadic(notm,i,i,{if(*rgt==1){*tgt=0;}else if(*rgt==0){*tgt=1;}
 else{ERR(11,"DOMAIN ERROR\n");}})
/*  *A */ scalar_monadic(powerm,d,i,{*tgt=exp(*rgt);})
/* A*B */ scalar_dyadic(powerd,d,d,d,i,{*tgt=pow(*lft,*rgt);})
/*  -A */ scalar_monadic(subtractm,d,i,{*tgt=-1 * *rgt;})
/* A-B */ scalar_dyadic(subtractd,d,d,d,i,{*tgt=*lft-*rgt;})

