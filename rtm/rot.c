NM(rot,"rot",0,0,DID,MFD,DFD,MAD,DAD)
rot_f rot_c;
ID(rot,0,s32)
MF(rot_f){z.f=1;z.r=r.r;z.s=r.s;z.v=flip(r.v,0);}
MA(rot_f){z.f=1;if(1!=cnt(ax))err(5);if(!ax.v.isinteger())err(11);
 I axv=ax.v.as(s32).scalar<I>();if(axv<0||r.r<=axv)err(4);
 z.r=r.r;z.s=r.s;z.v=flip(r.v,r.r-(1+axv));}
DA(rot_f){z.f=1;if(ax.r>1||cnt(ax)!=1)err(5);if(!ax.v.isinteger())err(11);
 I ra=ax.v.as(s32).scalar<I>();if(ra<0)err(11);if(ra>=r.r)err(4);
 B lc=cnt(l);I aa=ra;ra=r.r-ra-1;if(lc!=1&&l.r!=r.r-1)err(4);
 if(lc==1){I ix[]={0,0,0,0};z.r=r.r;z.s=r.s;ix[ra]=-l.v.as(s32).scalar<I>();
  z.v=shift(r.v,ix[0],ix[1],ix[2],ix[3]);R;}
 I j=0;DO(l.r,if(i==ra)j++;if(l.s[i]!=r.s[j++])err(5))
 res_c(z,scl(scl((D)r.s[ra])),l,e);B tc=1;DO(ra,tc*=r.s[i])z.v*=tc;
 cat_c(z,z,e,scl(scl(aa-.5)));I ix[]={1,1,1,1};ix[ra]=(I)r.s[ra];
 z.v=tile(z.v,ix[0],ix[1],ix[2],ix[3]);z.s[ra]=r.s[ra];
 dim4 s1(1),s2(1);DO(ra+1,s1[i]=r.s[i])DO(r.r-ra-1,s2[ra+i+1]=r.s[ra+i+1])
 z.v+=iota(s1,s2);res_c(z,scl(scl((D)tc*r.s[ra])),z,e);
 z.v=r.v(z.v+(tc*r.s[ra])*iota(s2,s1));}
DF(rot_f){if(!r.r){B lc=cnt(l);if(lc!=1&&l.r)err(4);z=r;R;}
 rot_c(z,l,r,e,scl(scl(r.r-1)));}
