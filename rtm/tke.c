NM(tke,"tke",0,0,MT ,MFD,DFD,MAD,DAD)
tke_f tke_c;
MF(tke_f){z=r;}
MA(tke_f){err(16);}
DA(tke_f){z.f=1;B c=cnt(l),ac=cnt(ax);if(ax.r>1||l.r>1)err(4);
 if(ac!=c)err(5);if(c>4)err(16);if(!isint(ax))err(11);
 I m[4]={0,0,0,0},av[4];ax.v.as(s32).host(av);
 DOB(ac,if(av[i]<0)err(11);if(av[i]>=r.r)err(4))
 DOB(ac,if(m[av[i]])err(11);m[av[i]]=1)
 if(!c){z=r;R;}if(!isint(l))err(11);I lv[4];l.v.as(s32).host(lv);
 seq it[4],ix[4];z.r=r.r;z.s=r.s;
 DOB(c,{U j=z.r-av[i]-1;I a=std::abs(lv[i]);z.s[j]=a;
  if(a>r.s[j])ix[j]=seq((D)r.s[j]);
  else if(lv[i]<0)ix[j]=seq((D)r.s[j]-a,(D)r.s[j]-1);
  else ix[j]=seq(a);
  it[j]=ix[j]+(lv[i]<0)*(a-(D)r.s[j]);})
 if(!cnt(z)){z.v=scl(0);R;}z.v=array(z.s,r.v.type());z.v=0;
 z.v(it[0],it[1],it[2],it[3])=r.v(ix[0],ix[1],ix[2],ix[3]);}
DF(tke_f){I c=(I)cnt(l);if(c>4)err(16);
 A nr=r;if(!nr.r){nr.r=c;nr.s=dim4(1);}
 A ax;iot_c(ax,scl(scl(c)),e);tke_c(z,l,nr,e,ax);}
