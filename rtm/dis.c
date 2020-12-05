NM(dis,"dis",0,0,MT,MFD,DFD,MT,MT)
dis_f dis_c;
MF(dis_f){z.f=1;z.r=0;z.s=eshp;z.v=r.v(0);}
DF(dis_f){z.f=1;if(l.v.isfloating())err(1);if(l.r>1)err(4);
 B lc=cnt(l);if(!lc){z=r;R;}if(lc!=1||r.r!=1)err(4);
 if(allTrue<char>(cnt(r)<=l.v(0)))err(3);
 z.r=0;z.s=eshp;array i=l.v(0);z.v=r.v(i);}
