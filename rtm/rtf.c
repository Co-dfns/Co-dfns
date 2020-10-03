NM(rtf,"rtf",0,0,DID,MFD,DFD,MAD,MT )
rtf_f rtf_c;
ID(rtf,0,s32)
MF(rtf_f){z.r=r.r;z.s=r.s;z.v=r.r?flip(r.v,r.r-1):r.v;}
MA(rtf_f){if(1!=cnt(ax))err(5);if(!ax.v.isinteger())err(11);
 I axv=ax.v.as(s32).scalar<I>();if(axv<0||r.r<=axv)err(4);
 z.r=r.r;z.s=r.s;z.v=flip(r.v,r.r-(1+axv));}
DF(rtf_f){I lc=(I)cnt(l);I ra=r.r?r.r-1:0;I ix[]={0,0,0,0};
 if(lc==1){z.r=r.r;z.s=r.s;ix[ra]=-l.v.as(s32).scalar<I>();
  z.v=shift(r.v,ix[0],ix[1],ix[2],ix[3]);R;}
 if(l.r!=r.r-1)err(5);DO(l.r,if(l.s[i]!=r.s[i])err(5))
 std::vector<I> x(lc);l.v.as(s32).host(x.data());
 z.v=array(r.v,lc,r.s[ra]);z.r=r.r;z.s=r.s;
 DO(lc,z.v(i,span)=shift(z.v(i,span),0,-x[i]))
 z.v=array(z.v,z.s);}

