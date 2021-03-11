NM(par,"par",0,0,MT ,MFD,DFD,MAD,MT )
DEFN(par)
MF(par_f){I nv=0;CVSWITCH(r.v,err(6),,nv=1)
 if(!rnk(r)&&!nv){z=r;R;}z=A(0,VEC<A>(1,r));}
MA(par_f){if(rnk(ax)>1)err(4);B axc=cnt(ax);
 if(!axc){map_o f(par_p);f(z,r,e);R;}
 B rr=rnk(r);VEC<I> axm(rr,0);VEC<I> axv(axc);
 CVSWITCH(ax.v,err(6),v.as(s32).host(axv.data()),err(11))
 DOB(axc,I v=axv[i];if(v<0)err(11);if(v>=rr)err(4);if(axm[v])err(11);axm[v]=1)
 B ic=rr-axc;if(!ic){z=A(0,VEC<A>(1,r));R;}
 A nax(SHP(1,ic),arr(ic,s32));arr&naxv=std::get<arr>(nax.v);A x;x.s=SHP(ic);
 B j=0;DOB(rr,if(!axm[i]){naxv((I)j)=i;x.s[ic-j-1]=r.s[rr-i-1];j++;})
 B xc=cnt(x);x.v=VEC<A>(xc);VEC<A>&xv=std::get<VEC<A>>(x.v);
 VEC<I> ixh(ic,0);A ix(SHP(1,ic),arr(ic,s32));arr&ixv=std::get<arr>(ix.v);
 DOB(xc,ixv=arr(ic,ixh.data());sqd_c(xv[i],ix,r,e,nax);
  ixh[ic-1]++;DOB(ic-1,B j=ic-i-1;if(ixh[j]==x.s[i]){ixh[j-1]++;ixh[j]=0;}))
 z=x;}
DF(par_f){err(16);}

