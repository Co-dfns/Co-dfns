NM(tke,"tke",0,0,MT ,MFD,DFD,MAD,DAD)
DEFN(tke)
MF(tke_f){
 CVSWITCH(r.v,err(6),z=r,
  B rc=cnt(r);B rr=rnk(r);
  B mr=0;DOB(rc,B nr=rnk(v[i]);if(nr>mr)mr=nr)
  U8 nv=0;DOB(rc,CVSWITCH(v[i].v,err(6),,nv=1))
  A x(mr+rr);DOB(rr,x.s[mr+rr-i-1]=r.s[rr-i-1])DOB(mr,x.s[i]=0)
  if(!mr){
   if(nv){x.v=VEC<A>(rc);VEC<A>&xv=std::get<VEC<A>>(x.v);
    DOB(rc,CVSWITCH(v[i].v,err(6),xv[i]=scl(v),xv[i]=v[0]))}
   if(!nv){dtype tp=mxt(b8,r);x.v=arr(rc,tp);arr&xv=std::get<arr>(x.v);
    DOB(rc,CVSWITCH(v[i].v,err(6),xv((I)i)=v(0).as(tp),err(99)))}
   z=x;R;}
  err(16);
  DOB(rc,A vi=v[i];B rk=rnk(vi);
   DOB(rk,B j=mr-i-1;B k=rk-i-1;if(x.s[j]<vi.s[k])x.s[j]=vi.s[k])))
}
MA(tke_f){err(16);}
DA(tke_f){B c=cnt(l),ac=cnt(ax),axr=rnk(ax),lr=rnk(l),rr=rnk(r);
 if(axr>1||lr>1)err(4);if(ac!=c)err(5);if(c>4)err(16);if(!isint(ax))err(11);
 VEC<I> av(ac),m(rr,0);
 if(ac)CVSWITCH(ax.v,err(6),v.as(s32).host(av.data()),err(11))
 DOB(ac,if(av[i]<0)err(11);if(av[i]>=rr)err(4))
 DOB(ac,if(m[av[i]])err(11);m[av[i]]=1)
 if(!c){z=r;R;}if(!isint(l))err(11);
 VEC<I> lv(c);CVSWITCH(l.v,err(6),v.as(s32).host(lv.data()),err(11))
 seq it[4],ix[4];z.s=r.s;if(rr>4)err(16);
 DOB(c,{U j=(U)rr-av[i]-1;I a=std::abs(lv[i]);z.s[j]=a;
  if(a>r.s[j])ix[j]=seq((D)r.s[j]);
  else if(lv[i]<0)ix[j]=seq((D)r.s[j]-a,(D)r.s[j]-1);
  else ix[j]=seq(a);
  it[j]=ix[j]+(lv[i]<0)*(a-(D)r.s[j]);})
 B zc=cnt(z);if(!zc){z.v=scl(0);R;}
 CVSWITCH(r.v,err(6)
  ,z.v=arr(zc,v.type());arr&zv=std::get<arr>(z.v);zv=0;
   arr rv=unrav(v,r.s);zv=unrav(zv,z.s);
   zv(it[0],it[1],it[2],it[3])=rv(ix[0],ix[1],ix[2],ix[3]);
   zv=flat(zv)
  ,err(16))}
DF(tke_f){I c=(I)cnt(l);if(c>4)err(16);
 A nr=r;if(!rnk(nr)){nr.s=SHP(c,1);}
 A ax;iot_c(ax,scl(scl(c)),e);tke_c(z,l,nr,e,ax);}
