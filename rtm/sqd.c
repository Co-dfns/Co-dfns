NM(sqd,"sqd",0,0,MT ,MFD,DFD,MT ,MT )
sqd_f sqd_c;
MF(sqd_f){z=r;}
DF(sqd_f){if(l.r>1)err(4);B s=l.r?l.s[0]:1;if(s>r.r)err(5);if(!s){z=r;R;}
 I sv[4];l.v.as(s32).host(sv);af::index x[4];
 DO((I)s,if(sv[i]<0||sv[i]>=r.s[r.r-(i+1)])err(3));
 DO((I)s,x[r.r-(i+1)]=sv[i]);z.r=r.r-(U)s;z.s=dim4(z.r,r.s.get());
 z.v=r.v(x[0],x[1],x[2],x[3]);}

