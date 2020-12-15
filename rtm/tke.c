NM(tke,"tke",0,0,MT ,MFD,DFD,MAD,DAD)
tke_f tke_c;
MF(tke_f){z=r;}
MA(tke_f){err(16);}
DA(tke_f){z.f=1;B c=cnt(l),ac=cnt(ax),axr=rnk(ax),lr=rnk(l),rr=rnk(r);
 if(axr>1||lr>1)err(4);if(ac!=c)err(5);if(c>4)err(16);if(!isint(ax))err(11);
 VEC<I> av(ac),m(ac,0);if(ac)ax.v.as(s32).host(av.data());
 DOB(ac,if(av[i]<0)err(11);if(av[i]>=rr)err(4))
 DOB(ac,if(m[av[i]])err(11);m[av[i]]=1)
 if(!c){z=r;R;}if(!isint(l))err(11);
 VEC<I> lv(c);l.v.as(s32).host(lv.data());
 seq it[4],ix[4];z.s=r.s;if(rr>4)err(16);
 DOB(c,{U j=(U)rr-av[i]-1;I a=std::abs(lv[i]);z.s[j]=a;
  if(a>r.s[j])ix[j]=seq((D)r.s[j]);
  else if(lv[i]<0)ix[j]=seq((D)r.s[j]-a,(D)r.s[j]-1);
  else ix[j]=seq(a);
  it[j]=ix[j]+(lv[i]<0)*(a-(D)r.s[j]);})
 B zc=cnt(z);if(!zc){z.v=scl(0);R;}z.v=arr(zc,r.v.type());z.v=0;
 arr rv=unrav(r);z.v=unrav(z);
 z.v(it[0],it[1],it[2],it[3])=rv(ix[0],ix[1],ix[2],ix[3]);
 z.v=flat(z.v);}
DF(tke_f){I c=(I)cnt(l);if(c>4)err(16);
 A nr=r;if(!rnk(nr)){nr.s=SHP(c,1);}
 A ax;iot_c(ax,scl(scl(c)),e);tke_c(z,l,nr,e,ax);}
