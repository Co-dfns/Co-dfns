NM(sqd,"sqd",0,0,MT ,MFD,DFD,MT ,DAD)
sqd_f sqd_c;
MF(sqd_f){z=r;}
DA(sqd_f){if(ax.r>1)err(4);if(!isint(ax))err(11);I av[4];ax.v.as(s32).host(av);
 B ac=cnt(ax);DOB(ac,if(av[i]<0)err(11))DOB(ac,if(av[i]>=r.r)err(4))
 B lc=cnt(l);if(lc!=ac)err(5);if(!lc){z=r;R;};af::index x[4];
 I m[]={0,0,0,0};DOB(ac,if(m[av[i]])err(11);m[av[i]]=1)
 if(!isint(l))err(11);I lv[4];l.v.as(s32).host(lv);
 DOB(lc,if(lv[i]<0||lv[i]>=r.s[r.r-av[i]-1])err(3))
 DOB(lc,x[r.r-av[i]-1]=lv[i]);z.r=r.r-(I)lc;
 I j=0;DO(r.r,if(!m[r.r-i-1])z.s[j++]=r.s[i];)
 z.v=r.v(x[0],x[1],x[2],x[3]);}
DF(sqd_f){A ax;iot_c(ax,scl(scl((I)cnt(l))),e);sqd_c(z,l,r,e,ax);}
