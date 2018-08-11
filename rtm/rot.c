NM(rot,"rot",0,0,DID,MFD,DFD,MT ,MT )
ID(rot,0,s32)
MF(rot_f){z.r=r.r;z.s=r.s;z.v=flip(r.v,0);}
DF(rot_f){I lc=(I)cnt(l);if(lc==1){z.r=r.r;z.s=r.s;
  z.v=shift(r.v,-l.v.as(s32).scalar<I>());R;}
 if(l.r!=r.r-1)err(5);DO(l.r,if(l.s[i]!=r.s[i+1])err(5))
 std::vector<I> x(lc);l.v.as(s32).host(x.data());
 z.v=array(r.v,r.s[0],lc);z.r=r.r;z.s=r.s;
 DO(lc,z.v(span,i)=shift(z.v(span,i),-x[i]))z.v=array(z.v,z.s);}

