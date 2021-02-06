NM(drp,"drp",0,0,MT ,MFD,DFD,MAD,DAD)
DEFN(drp)
MF(drp_f){if(rnk(r))err(16);z=r;}
MA(drp_f){err(16);}
DA(drp_f){B c=cnt(l),ac=cnt(ax),rr=rnk(r),lr=rnk(l),axr=rnk(ax);
 if(axr>1||lr>1)err(4);if(ac!=c)err(5);if(c>4)err(16);if(!isint(ax))err(11);
 I m[4]={0,0,0,0},av[4];CVSWITCH(ax.v,err(6),v.as(s32).host(av),err(11))
 DOB(ac,if(av[i]<0)err(11);if(av[i]>=rr)err(4))
 DOB(ac,if(m[av[i]])err(11);m[av[i]]=1)
 if(!c){z=r;R;}if(!isint(l))err(11);
 I lv[4];CVSWITCH(l.v,err(6),v.as(s32).host(lv),err(11))
 seq it[4],ix[4];z.s=r.s;
 DO((I)c,{B j=rr-av[i]-1;I a=std::abs(lv[i]);z.s[j]=r.s[j]-a;
  if(a>=r.s[j]){z.s[j]=0;ix[j]=seq(0);it[j]=seq(0);}
  else if(lv[i]<0){ix[j]=seq((D)z.s[j]);it[j]=ix[j];}
  else{ix[j]=seq(a,(D)r.s[j]-1);it[j]=ix[j]-(D)a;}})
 if(!cnt(z)){z.v=scl(0);R;}
 CVSWITCH(r.v,err(6)
  ,arr tv(cnt(z),v.type());tv=0;tv=unrav(tv,z.s);
   tv(it[0],it[1],it[2],it[3])=unrav(v,r.s)(ix[0],ix[1],ix[2],ix[3]);
   z.v=flat(tv)
  ,err(16))}
DF(drp_f){B c=cnt(l);if(c>4)err(16);
 A nr=r;if(!rnk(nr)){nr.s=SHP(c,1);}
 A ax;iot_c(ax,scl(scl(c)),e);drp_c(z,l,nr,e,ax);}
