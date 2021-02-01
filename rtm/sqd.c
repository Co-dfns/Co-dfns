NM(sqd,"sqd",0,0,MT ,MFD,DFD,MT ,DAD)
DEFN(sqd)
MF(sqd_f){z=r;}
DA(sqd_f){if(rnk(ax)>1)err(4);if(!isint(ax))err(11);
 B ac=cnt(ax);VEC<I> av(ac);
 if(ac)CVSWITCH(ax.v,err(6),v.as(s32).host(av.data()),err(11))
 B rr=rnk(r);DOB(ac,if(av[i]<0)err(11))DOB(ac,if(av[i]>=rr)err(4))
 B lc=cnt(l);if(rnk(l)>1)err(4);if(lc!=ac)err(5);if(!lc){z=r;R;}
 VEC<U8> m(rr);DOB(ac,if(m[av[i]])err(11);m[av[i]]=1)if(!isint(l))err(11);
 VEC<I> lv(lc);CVSWITCH(l.v,err(6),v.as(s32).host(lv.data()),err(16))
 DOB(lc,if(lv[i]<0||lv[i]>=r.s[rr-av[i]-1])err(3))
 z.s=SHP(rr-lc);I j=0;DOB(rr,if(!m[rr-i-1])z.s[j++]=r.s[i])
 CVSWITCH(r.v,err(6)
  ,if(rr<5){IDX x[4];DOB(lc,x[rr-av[i]-1]=lv[i]);
    dim4 rs(1);DO((I)rr,rs[i]=r.s[i])
    z.v=flat(moddims(v,rs)(x[0],x[1],x[2],x[3]));R;}
   VEC<seq> x(rr);arr ix=scl(0);
   DOB(rr,x[i]=seq((D)r.s[i]))DOB(lc,x[rr-av[i]-1]=seq(lv[i],lv[i]))
   DOB(rr,B j=rr-i-1;ix=moddims(ix*r.s[j],1,(U)cnt(ix));
    ix=flat(tile(ix,(U)x[j].size,1)+tile(x[j],1,(U)cnt(ix))))
   z.v=v(ix)
  ,err(16))}
DF(sqd_f){A ax;iot_c(ax,scl(scl((I)cnt(l))),e);sqd_c(z,l,r,e,ax);}
