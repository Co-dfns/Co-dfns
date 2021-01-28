NM(dis,"dis",0,0,MT,MFD,DFD,MT,MT)
DEFN(dis)
MF(dis_f){CVSWITCH(r.v,err(6),z.s=eshp;z.v=v(0),z=v[0])}
DF(dis_f){if(!isint(l))err(11);if(rnk(l)>1)err(4);
 B lc=cnt(l);if(!lc){z=r;R;}if(lc!=1||rnk(r)!=1)err(16);
 I i;CVSWITCH(l.v,err(6),i=v.as(s32).scalar<I>(),err(16))
 if(i<0||i>=cnt(r))err(3);
 CVSWITCH(r.v,err(6),z.s=eshp;z.v=v(i),z=v[i])}
