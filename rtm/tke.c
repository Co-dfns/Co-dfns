NM(tke,"tke",0,0,MT ,MFD,DFD,MAD,MT )
tke_f tke_c;
MF(tke_f){z=r;}
MA(tke_f){err(16);}
DF(tke_f){I lv[4];seq it[4];seq ix[4];B c=cnt(l);
 if(l.r>1||(c>r.r&&r.r))err(4);if(!c){z=r;R;}
 U rk=r.r?r.r:(U)l.s[0];z.r=rk;z.s=r.s;l.v.as(s32).host(lv);
 DO((I)c,{U j=rk-(i+1);I a=std::abs(lv[i]);z.s[j]=a;
  if(a>r.s[j])ix[j]=seq((D)r.s[j]);
  else if(lv[i]<0)ix[j]=seq((D)r.s[j]-a,(D)r.s[j]-1);
  else ix[j]=seq(a);
  it[j]=ix[j]+(lv[i]<0)*(a-(D)r.s[j]);})
 if(!cnt(z)){z.v=scl(0);R;}z.v=array(z.s,r.v.type());z.v=0;
 z.v(it[0],it[1],it[2],it[3])=r.v(ix[0],ix[1],ix[2],ix[3]);}

