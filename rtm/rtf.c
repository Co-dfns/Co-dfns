NM(rtf,"rtf",0,0,DID,MFD,DFD,MAD,DAD)
rtf_f rtf_c;
ID(rtf,0,s32)
MF(rtf_f){z.f=1;z.r=r.r;z.s=r.s;z.v=r.r?flip(r.v,r.r-1):r.v;}
MA(rtf_f){z.f=1;if(1!=cnt(ax))err(5);if(!ax.v.isinteger())err(11);
 I axv=ax.v.as(s32).scalar<I>();if(axv<0||r.r<=axv)err(4);
 z.r=r.r;z.s=r.s;z.v=flip(r.v,r.r-(1+axv));}
DA(rtf_f){rot_c(z,l,r,e,ax);}
DF(rtf_f){if(!r.r){B lc=cnt(l);if(lc!=1&&l.r)err(4);z=r;R;}
 rot_c(z,l,r,e,scl(scl(0)));}
