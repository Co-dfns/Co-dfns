NM(trn,"trn",0,0,MT ,MFD,DFD,MT ,MT )
trn_f trn_c;
MF(trn_f){B rr=rnk(r);A t(SHP(1,rr),seq((D)rr-1,0,-1));trn_c(z,t,r,e);}
DF(trn_f){z.f=1;B lr=rnk(l),rr=rnk(r);if(lr>1||cnt(l)!=rr)err(5);
 VEC<I> lv(rr);if(!isint(l))err(11);l.v.as(s32).host(lv.data());
 DOB(rr,if(lv[i]<0||lv[i]>=rr)err(4))VEC<U8> f(rr,0);DOB(rr,f[lv[i]]=1)
 U8 t=1;DOB(rr,if(t&&!f[i])t=0;else if(!t&&f[i])err(5))
 if(t&&rr<=4){z.s=SHP(rr);DOB(rr,z.s[rr-lv[i]-1]=r.s[rr-i-1])
  switch(rr){case 0:case 1:z.v=r.v;R;}
  VEC<I> s(rr);DOB(rr,s[rr-lv[i]-1]=(I)(rr-i-1))arr rv=unrav(r);
  switch(rr){CS(2,z.v=flat(reorder(rv,s[0],s[1])))
   CS(3,z.v=flat(reorder(rv,s[0],s[1],s[2])))
   CS(4,z.v=flat(reorder(rv,s[0],s[1],s[2],s[3])))}}
 else{B rk=0;DOB(rr,if(rk<lv[i])rk=lv[i])rk++;z.s=SHP(rk,LLONG_MAX);
  DOB(rr,B j=rk-lv[i]-1;B k=rr-i-1;if(z.s[j]>r.s[k])z.s[j]=r.s[k])
  SHP zs(rk),rs(rr);
  B c=1;DOB(rk,zs[i]=c;c*=z.s[i])c=1;DOB(rr,rs[i]=c;c*=r.s[i])c=cnt(z);
  arr ix=iota(dim4(c),dim4(1),s32),jx=constant(0,dim4(c),s32);
  DOB(rr,B j=rk-lv[i]-1;B k=rr-i-1;jx+=rs[k]*((ix/zs[j])%z.s[j]))
  z.v=r.v(jx);}}
