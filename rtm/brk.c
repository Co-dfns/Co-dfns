NM(brk,"brk",0,0,MT,MT,DFD,MT,MT)
brk_f brk_c;
DF(brk_f){B lr=rnk(l);const std::vector<A>&rv=r.nv;B rl=rv.size();
 if(!rl){if(lr!=1)err(4);z=l;R;}
 if(rl!=lr)err(4);B zr=0;DOB(rl,zr+=rnk(rv[i]))B s=zr;z.s=SHP(zr,1);
 DOB(rl,B j=i;B k=rnk(rv[j]);s-=k;
  DOB(k,z.s[s+i]=(k==rnk(rv[j]))?rv[j].s[i]:l.s[rl-j-1]))
 if(zr<=4){index x[4];DOB(rl,if(rnk(rv[i])>=0)x[rl-i-1]=rv[i].v.as(s32))
  dim4 sp;DO((I)lr,sp[i]=l.s[i])z.v=moddims(l.v,sp)(x[0],x[1],x[2],x[3]);R;}
 err(16);}

OD(brk,"brk",scm(l),scd(l),MFD,DFD,MT ,MT )
MF(brk_o){if(rnk(ww)>1)err(4);ll(z,r,e,ww);}
DF(brk_o){if(rnk(ww)>1)err(4);ll(z,l,r,e,ww);}

