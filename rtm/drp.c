NM(drp,"drp",0,0,MT ,MFD,DFD,MAD,DAD)
DEFN(drp)
MF(drp_f){z.f=1;if(rnk(r))err(16);z=r;}
MA(drp_f){err(16);}
DA(drp_f){z.f=1;B c=cnt(l),ac=cnt(ax),rr=rnk(r),lr=rnk(l),axr=rnk(ax);
 if(axr>1||lr>1)err(4);if(ac!=c)err(5);if(c>4)err(16);if(!isint(ax))err(11);
 I m[4]={0,0,0,0},av[4];ax.v.as(s32).host(av);
 DOB(ac,if(av[i]<0)err(11);if(av[i]>=rr)err(4))
 DOB(ac,if(m[av[i]])err(11);m[av[i]]=1)
 if(!c){z=r;R;}if(!isint(l))err(11);I lv[4];l.v.as(s32).host(lv);
 seq it[4],ix[4];z.s=r.s;
 DO((I)c,{B j=rr-av[i]-1;I a=std::abs(lv[i]);z.s[j]=r.s[j]-a;
  if(a>=r.s[j]){z.s[j]=0;ix[j]=seq(0);it[j]=seq(0);}
  else if(lv[i]<0){ix[j]=seq((D)z.s[j]);it[j]=ix[j];}
  else{ix[j]=seq(a,(D)r.s[j]-1);it[j]=ix[j]-(D)a;}})
 if(!cnt(z)){z.v=scl(0);R;}z.v=arr(cnt(z),r.v.type());z.v=0;arr zv=unrav(z);
 zv(it[0],it[1],it[2],it[3])=unrav(r)(ix[0],ix[1],ix[2],ix[3]);
 z.v=flat(zv);}
DF(drp_f){z.f=1;B c=cnt(l);if(c>4)err(16);
 A nr=r;if(!rnk(nr)){nr.s=SHP(c,1);}
 A ax;iot_c(ax,scl(scl(c)),e);drp_c(z,l,nr,e,ax);}
