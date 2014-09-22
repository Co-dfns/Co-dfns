#include "h.cuh"

extern "C" {
/* SCALAR PRIMITIVES */
/*  +A */ scalar_monadic(addm,i,d,z[i]=r[i]) 
/* A+B */ scalar_dyadic(addd,d,d,d,i,{z[i]=l[i%sl]+r[i%sr];}) 
/*  ÷A */ scalar_monadic(dividem,d,d,{
 if(r[i]!=0){z[i]=1.0/r[i];}else ERR(11,"DOMAIN ERROR: Divide by zero\n");})
/* A÷B */ scalar_dyadic(divided,d,d,d,d,{
 if(r[i%sr]!=0){z[i]=(1.0*l[i%sl])/(1.0*r[i%sr]);}
 else ERR(11,"DOMAIN ERROR: Divide by zero\n");})
/* A=B */ scalar_dyadic(equald,i,i,i,i,{z[i]=(l[i%sl]==r[i%sr]);})
/* A≥B */ scalar_dyadic(greateqd,i,i,i,i,{z[i]=(l[i%sl]>=r[i%sr]);})
/* A>B */ scalar_dyadic(greaterd,i,i,i,i,{z[i]=(l[i%sl]>r[i%sr]);})
/* A≤B */ scalar_dyadic(lesseqd,i,i,i,i,{z[i]=(l[i%sl]<=r[i%sr]);})
/* A<B */ scalar_dyadic(lessd,i,i,i,i,{z[i]=(l[i%sl]<r[i%sr]);})
/*  ⍟A */ scalar_monadic(logm,d,d,z[i]=log((D)r[i]))
/* A⍟B */ scalar_dyadic(logd,d,d,d,d,{z[i]=log((D)r[i%sr])/log((D)l[i%sl]);})
/*  |A */ smi(residuem,i,i,z[i]=labs(r[i]))
/*  |A */ smi(residuem,d,d,z[i]=fabs(r[i]))
/*  |A */ scalar_monadic_main(residuem,d,i)
#define RESIDUED {z[i]=fmod(r[i%sr],l[i%sl]);}
/* A|B */ sdi(residued,d,d,d,RESIDUED)
/* A|B */ sdi(residued,d,d,i,RESIDUED)
/* A|B */ sdi(residued,d,i,d,RESIDUED)
/* A|B */ sdi(residued,i,i,i,z[i]=l[i%sl]%r[i%sr];)
/* A|B */ scalar_dyadic_main(residued,d,d,d,i)
/*  ⌈B */ scalar_monadic(maxm,d,i,z[i]=ceil((D)r[i]))
/* A⌈B */ scalar_dyadic(maxd,d,d,d,i,{z[i]=(l[i%sl]>=r[i%sr]?l[i%sl]:r[i%sr]);})
/*  ⌊A */ scalar_monadic(minm,d,i,z[i]=floor((D)r[i]))
/* A⌊B */ scalar_dyadic(mind,d,d,d,i,{z[i]=(l[i%sl]<=r[i%sr]?l[i%sl]:r[i%sr]);})
/*  ×A */ scalar_monadic(multiplym,d,i,{
 if(r[i]==0)z[i]=0;else if(r[i]<0)z[i]=-1;else z[i]=1;})
/* A×B */ scalar_dyadic(multiplyd,d,d,d,i,{z[i]=l[i%sl] * r[i%sr];})
/* A≠B */ scalar_dyadic(neqd,i,i,i,i,{z[i]=(l[i%sl]!=r[i%sr]);})
/*  ~A */ scalar_monadic(notm,i,i,{
 if(r[i]==1){z[i]=0;}else if(r[i]==0){z[i]=1;}else{ERR(11,"DOMAIN ERROR\n");}})
/*  *A */ scalar_monadic(powerm,d,i,z[i]=exp((D)r[i]))
/* A*B */ scalar_dyadic(powerd,d,d,d,i,{z[i]=pow(l[i%sl],r[i%sr]);})
/*  -A */ scalar_monadic(subtractm,d,i,z[i]=-1 * r[i])
/* A-B */ scalar_dyadic(subtractd,d,d,d,i,{z[i]=l[i%sl]-r[i%sr];})
}
