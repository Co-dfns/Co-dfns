NM(drp,"drp",0,0,MT ,MFD,DFD,MAD,MT )
drp_f drp_c;
MF(drp_f){if(r.r)err(16);z=r;}
MA(drp_f){err(16);}
DF(drp_f){I lv[4];seq it[4];seq ix[4];B c=cnt(l);
 if(l.r>1||(c>r.r&&r.r))err(4);if(!c){z=r;R;}
 U rk=r.r?r.r:(U)l.s[0];z.r=rk;z.s=r.s;l.v.as(s32).host(lv);
 DO((I)c,{U j=rk-(i+1);I a=std::abs(lv[i]);
  if(a>=r.s[j]){z.s[j]=0;ix[j]=seq(0);it[j]=seq(0);}
  else if(lv[i]<0){
   z.s[j]=r.s[j]-a;ix[j]=seq((D)z.s[j]);it[j]=ix[j];}
  else{z.s[j]=r.s[j]-a;ix[j]=seq(a,(D)r.s[j]-1);it[j]=ix[j]-(D)a;}})
 if(!cnt(z)){z.v=scl(0);R;}z.v=array(z.s,r.v.type());z.v=0;
 z.v(it[0],it[1],it[2],it[3])=r.v(ix[0],ix[1],ix[2],ix[3]);}
