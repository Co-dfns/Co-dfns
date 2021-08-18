NM(rtf,"rtf",0,0,DID,MFD,DFD,MAD,DAD)
DEFN(rtf)
ID(rtf,0,s32)
MF(rtf_f){if(!rnk(r)){z=r;R;}rot_c(z,r,e,scl(scl(0)));}
MA(rtf_f){rot_c(z,r,e,ax);}
DA(rtf_f){rot_c(z,l,r,e,ax);}
DF(rtf_f){if(!rnk(r)){B lc=cnt(l);if(lc!=1&&rnk(l))err(4);z=r;R;}
 rot_c(z,l,r,e,scl(scl(0)));}
