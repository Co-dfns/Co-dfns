#include "codfns.h"
#include "internal.h"

MF(pow_o){if(fr){A t;A v=r;I flg;
  do{A u;ll(u,v,e);rr(t,u,v,e);
   if(cnt(t)!=1)err(5);CVSWITCH(t.v,err(6),flg=v.as(s32).scalar<I>(),err(11))
   v=u;}while(!flg);
  z=v;R;}
 if(rnk(ww))err(4);I c;CVSWITCH(ww.v,err(6),c=v.as(s32).scalar<I>(),err(11))
 z=r;DO(c,ll(z,z,e))}
DF(pow_o){if(!fl)err(2);
 if(fr){A t;A v=r;I flg;
  do{A u;ll(u,l,v,e);rr(t,u,v,e);
   if(cnt(t)!=1)err(5);CVSWITCH(t.v,err(6),flg=v.as(s32).scalar<I>(),err(11))
   v=u;}while(!flg);
  z=v;R;}
 if(rnk(ww))err(4);I c;CVSWITCH(ww.v,err(6),c=v.as(s32).scalar<I>(),err(11))
 A t=r;DO(c,ll(t,l,t,e))z=t;}

