NM(iot,"iot",0,0,MT ,MFD,DFD,MT ,MT )
iot_f iot_c;
MF(iot_f){if(r.r>1)err(4);B c=cnt(r);if(c>4)err(10);
 if(c>1)err(16);
 z.r=1;z.s=dim4(r.v.as(s32).scalar<I>());
 z.v=z.s[0]?iota(z.s,dim4(1),s32):scl(0);}
DF(iot_f){z.r=r.r;z.s=r.s;B c=cnt(r);if(!c){z.v=scl(0);R;}
 I lc=(I)cnt(l)+1;if(lc==1){z.v=constant(0,cnt(r),s16);R;};if(l.r>1)err(16);
 array lv,ix,rv;sort(lv,ix,l.v);rv=flat(r.v);z.v=constant(0,cnt(r),s32);
 for(I h;h=lc/2;lc-=h){array t=z.v+h;replace(z.v,lv(t)>rv,t);}
 z.v=array(select(lv(z.v)==rv,ix(z.v).as(s32),(I)cnt(l)),z.s);}
