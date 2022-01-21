#include "codfns.h"
#include "internal.h"

NM(scn,"scn",0,0,DID,MT ,DFD,MT ,DAD)
DEFN(scn)
ID(scn,1,s32)
DA(scn_f){if(rnk(ax)>1||cnt(ax)!=1)err(5);if(!isint(ax))err(11);
 B rr=rnk(r),lr=rnk(l);
 I ra;CVSWITCH(ax.v,err(6),ra=v.as(s32).scalar<I>(),err(11))
 if(ra<0)err(11);if(ra>=rr)err(4);if(lr>1)err(4);ra=(I)rr-ra-1;
 arr lv;CVSWITCH(l.v,err(6),lv=v,err(11))
 if(r.s[ra]!=1&&r.s[ra]!=sum<I>(lv>0))err(5);
 arr ca=max(1,abs(lv)).as(s32);I c=sum<I>(ca);
 if(!cnt(l))c=0;z.s=r.s;z.s[ra]=c;B zc=cnt(z);if(!zc){z.v=scl(0);R;}
 arr pw=0<lv,pa=pw*lv;I pc=sum<I>(pa);if(!pc){z.v=scl(0);R;}
 pw=where(pw);pa=scan(pa(pw),0,AF_BINARY_ADD,false);
 arr si(pc,s32);si=0;si(pa)=1;si=accum(si)-1;
 arr ti(pc,s32);ti=1;ti(pa)=scan(ca,0,AF_BINARY_ADD,false)(pw);
 ti=scanByKey(si,ti);
 CVSWITCH(r.v,err(6)
  ,arr zv(zc,v.type());zv=0;zv=axis(zv,z.s,ra);
   zv(span,ti,span)=axis(v,r.s,ra)(span,si,span);z.v=flat(zv)
  ,err(16))}
DF(scn_f){A x=r;if(!rnk(r))cat_c(x,r,e);
 scn_c(z,l,x,e,scl(scl(rnk(x)-1)));}

MA(scn_o){if(rnk(ax)>1)err(4);if(cnt(ax)!=1)err(5);
 if(!isint(ax))err(11);
 I av;CVSWITCH(ax.v,err(6),av=v.as(s32).scalar<I>(),err(11))
 if(av<0)err(11);B rr=rnk(r);if(av>=rr)err(4);av=(I)rr-av-1;z.s=r.s;
 I rc=(I)r.s[av];if(rc==1){z.v=r.v;R;}if(!cnt(z)){z.v=scl(0);R;}
 I ib=isbool(r);arr rv;CVSWITCH(r.v,err(6),rv=axis(v,r.s,av),err(16))
 if("add"==ll.nm){z.v=flat(scan(rv.as(f64),1,AF_BINARY_ADD));R;}
 if("mul"==ll.nm){z.v=flat(scan(rv.as(f64),1,AF_BINARY_MUL));R;}
 if("min"==ll.nm){z.v=flat(scan(rv.as(f64),1,AF_BINARY_MIN));R;}
 if("max"==ll.nm){z.v=flat(scan(rv.as(f64),1,AF_BINARY_MAX));R;}
 if("and"==ll.nm&&ib){z.v=flat(scan(rv,1,AF_BINARY_MIN));R;}
 if("lor"==ll.nm&&ib){z.v=flat(scan(rv,1,AF_BINARY_MAX));R;}
 map_o mfn_c(llp);B tr=rnk(z)-1;SHP ts(tr,1);
 DOB(av,ts[i]=r.s[i])DOB(tr-av,ts[av+i]=r.s[av+i+1])
 rv=rv.as(f64);arr zv(cnt(z),f64);zv=axis(zv,z.s,av);
 DO(rc,arr rvi=rv(span,i,span);dim4 rvs=rvi.dims();
  A t(ts,flat(rv(span,i,span)));I c=i;
  DO(c,A y(ts,flat(rv(span,c-i-1,span)));mfn_c(t,y,t,e))
  CVSWITCH(t.v,err(6),zv(span,i,span)=moddims(v,rvs),err(16)))
 z.v=flat(zv);}
MF(scn_o){B rr=rnk(r);if(!rr){z=r;R;}
 scn_o mfn_c(llp);mfn_c(z,r,e,scl(scl(rr-1)));}
