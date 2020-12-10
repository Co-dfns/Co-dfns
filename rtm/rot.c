NM(rot,"rot",0,0,DID,MFD,DFD,MAD,DAD)
rot_f rot_c;
ID(rot,0,s32)
MF(rot_f){rot_c(z,r,e,scl(scl(rnk(r)-1)));}
MA(rot_f){z.f=1;if(1!=cnt(ax))err(5);if(!isint(ax))err(11);
 I axv=ax.v.as(s32).scalar<I>();B rr=rnk(r);if(axv<0||rr<=axv)err(4);
 z.s=r.s;z.v=flat(flip(axis(r,rr-axv-1),1));}
DA(rot_f){z.f=1;B rr=rnk(r),lr=rnk(l);if(rr>4)err(16);
 if(rnk(ax)>1||cnt(ax)!=1)err(5);if(!isint(ax))err(11);
 I ra=ax.v.as(s32).scalar<I>();if(ra<0)err(11);if(ra>=rr)err(4);
 B lc=cnt(l);I aa=ra;ra=(I)rr-ra-1;if(lc!=1&&lr!=rr-1)err(4);
 if(lc==1){I ix[]={0,0,0,0};z.s=r.s;ix[ra]=-l.v.as(s32).scalar<I>();
  z.v=flat(shift(unrav(r),ix[0],ix[1],ix[2],ix[3]));R;}
 I j=0;DOB(lr,if(i==ra)j++;if(l.s[i]!=r.s[j++])err(5))
 res_c(z,scl(scl(r.s[ra])),l,e);B tc=1;DO(ra,tc*=r.s[i])z.v*=tc;
 cat_c(z,z,e,scl(scl(aa-.5)));I ix[]={1,1,1,1};ix[ra]=(I)r.s[ra];
 z.v=tile(unrav(z),ix[0],ix[1],ix[2],ix[3]);z.s[ra]=r.s[ra];
 dim4 s1(1),s2(1);DO(ra+1,s1[i]=r.s[i])DO((I)rr-ra-1,s2[ra+i+1]=r.s[ra+i+1])
 z.v+=iota(s1,s2);res_c(z,scl(scl(tc*r.s[ra])),z,e);
 z.v=flat(r.v(z.v+(tc*r.s[ra])*iota(s2,s1)));}
DF(rot_f){B rr=rnk(r),lr=rnk(l);if(!rr){B lc=cnt(l);if(lc!=1&&lr)err(4);z=r;R;}
 rot_c(z,l,r,e,scl(scl(rr-1)));}
