NM(dis,"dis",0,0,MT,MFD,DFD,MT,MT)
DEFN(dis)
MF(dis_f){z.s=eshp;z.v=r.v(0);}
DF(dis_f){if(!isint(l))err(11);if(rnk(l)>1)err(4);
 B lc=cnt(l);if(!lc){z=r;R;}if(lc!=1||rnk(r)!=1)err(16);
 I i=l.v.as(s32).scalar<I>();if(i<0||i>=cnt(r))err(3);
 z.s=eshp;z.v=r.v(i);}
