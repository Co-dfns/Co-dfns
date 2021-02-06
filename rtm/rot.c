NM(rot,"rot",0,0,DID,MFD,DFD,MAD,DAD)
DEFN(rot)
ID(rot,0,s32)
MF(rot_f){if(!rnk(r)){z=r;R;}rot_c(z,r,e,scl(scl(rnk(r)-1)));}
MA(rot_f){if(1!=cnt(ax))err(5);if(!isint(ax))err(11);
 I axv;CVSWITCH(ax.v,err(6),axv=v.as(s32).scalar<I>(),err(11))
 B rr=rnk(r);if(axv<0||rr<=axv)err(4);z.s=r.s;if(!cnt(r)){z.v=r.v;R;}
 CVSWITCH(r.v,err(6)
  ,z.v=flat(flip(axis(v,r.s,rr-axv-1),1))
  ,err(16))}
DA(rot_f){B rr=rnk(r),lr=rnk(l);if(rr>4)err(16);
 if(rnk(ax)>1||cnt(ax)!=1)err(5);if(!isint(ax))err(11);
 I ra;CVSWITCH(ax.v,err(6),ra=v.as(s32).scalar<I>(),err(11))
 if(ra<0)err(11);if(ra>=rr)err(4);B lc=cnt(l);I aa=ra;ra=(I)rr-ra-1;
 if(lc!=1&&lr!=rr-1)err(4);
 if(lc==1){z.s=r.s;I ix[]={0,0,0,0};
  CVSWITCH(l.v,err(6),ix[ra]=-v.as(s32).scalar<I>(),err(11))
  CVSWITCH(r.v,err(6)
   ,z.v=flat(shift(unrav(v,r.s),ix[0],ix[1],ix[2],ix[3]))
   ,err(16))
  R;}
 I j=0;DOB(lr,if(i==ra)j++;if(l.s[i]!=r.s[j++])err(5))
 CVSWITCH(r.v,err(6)
  ,z.s=r.s;z.v=v;arr&zv=std::get<arr>(z.v);zv=zv%r.s[ra];
   B tc=1;DO(ra,tc*=r.s[i])zv*=tc;cat_c(z,z,e,scl(scl(aa-.5)));
   zv=flat(tile(axis(zv,z.s,ra),1,(U)r.s[ra],1));z.s[ra]=r.s[ra];
   dim4 s1(1);dim4 s2(1);
   DO(ra+1,s1[i]=r.s[i])DO((I)rr-ra-1,s2[ra+i+1]=r.s[ra+i+1])
   zv+=flat(iota(s1,s2));zv=zv%(tc*r.s[ra]);
   zv=flat(v(zv+(tc*r.s[ra])*flat(iota(s2,s1))))
  ,err(16))}
DF(rot_f){B rr=rnk(r),lr=rnk(l);if(!rr){B lc=cnt(l);if(lc!=1&&lr)err(4);z=r;R;}
 rot_c(z,l,r,e,scl(scl(rr-1)));}
