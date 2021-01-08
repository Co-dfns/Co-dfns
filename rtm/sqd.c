NM(sqd,"sqd",0,0,MT ,MFD,DFD,MT ,DAD)
sqd_f sqd_c;
MF(sqd_f){z=r;}
DA(sqd_f){z.f=1;if(rnk(ax)>1)err(4);if(!isint(ax))err(11);
 VEC<I> av(4);ax.v.as(s32).host(av.data());
 B ac=cnt(ax),rr=rnk(r);DOB(ac,if(av[i]<0)err(11))DOB(ac,if(av[i]>=rr)err(4))
 B lc=cnt(l);if(rnk(l)>1)err(4);if(lc!=ac)err(5);if(!lc){z=r;R;}
 VEC<U8> m(rr);DOB(ac,if(m[av[i]])err(11);m[av[i]]=1)
 if(!isint(l))err(11);VEC<I> lv(lc);l.v.as(s32).host(lv.data());
 DOB(lc,if(lv[i]<0||lv[i]>=r.s[rr-av[i]-1])err(3))                 //+1106R~
 z.s=SHP(rr-lc);I j=0;DOB(rr,if(!m[rr-i-1])z.s[j++]=r.s[i])
 if(rr<5){IDX x[4];DOB(lc,x[rr-av[i]-1]=lv[i]);                    //+1106R~
  dim4 rs(1);DO((I)rr,rs[i]=r.s[i])
  z.v=flat(moddims(r.v,rs)(x[0],x[1],x[2],x[3]));R;}
 VEC<seq> x(rr);arr ix=scl(0);
 DOB(rr,x[i]=seq((D)r.s[i]))DOB(lc,x[rr-av[i]-1]=seq(lv[i],lv[i]))
 DOB(rr,B j=rr-i-1;ix=moddims(ix*r.s[j],1,(U)cnt(ix));
  ix=flat(tile(ix,(U)x[j].size,1)+tile(x[j],1,(U)cnt(ix))))
 z.v=r.v(ix);}
DF(sqd_f){A ax;iot_c(ax,scl(scl((I)cnt(l))),e);sqd_c(z,l,r,e,ax);}
