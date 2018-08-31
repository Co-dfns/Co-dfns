NM(iot,"iot",0,0,MT ,MFD,DFD,MT ,MT )
iot_f iot_c;
MF(iot_f){if(r.r>1)err(4);B c=cnt(r);if(c>4)err(10);
 if(c>1)err(16);
 z.r=1;z.s=dim4(r.v.as(s32).scalar<I>());
 z.v=z.s[0]?iota(z.s,dim4(1),s32):scl(0);}
DF(iot_f){z.r=r.r;z.s=r.s;B c=cnt(r);if(!c){z.v=scl(0);R;}
 B lc=cnt(l)+1;if(lc==1){z.v=scl(0);R;};if(l.r>1)err(16);
 array rf=flat(r.v).T();dtype mt=mxt(l.v,rf);
 z.v=join(0,tile(l.v,1,(U)c).as(mt),rf.as(mt))==tile(rf,(U)lc,1);
 z.v=min((z.v*iota(dim4(lc),dim4(1,c),s32)+((!z.v)*lc).as(s32)),0);
 z.v=array(z.v,z.s);}

