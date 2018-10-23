NM(dec,"dec",0,0,MT,MT,DFD,MT,MT⊤)
dec_f dec_c;
DF(dec_f){I ra=r.r?r.r-1:0;I la=l.r?l.r-1:0;z.r=ra+la;z.s=dim4(1);
 if(l.s[0]!=1&&l.s[0]!=r.s[ra]&&r.s[ra]!=1)err(5);
 DO(ra,z.s[i]=r.s[i])DO(la,z.s[i+ra]=l.s[i+1])
 if(!cnt(z)){z.v=scl(0);R;}
 if(!cnt(r)||!cnt(l)){z.v=constant(0,z.s,s32);R;}
 B lc=l.s[0];array x=l.v;if(lc==1){lc=r.s[ra];x=tile(x,(I)lc);}
 x=flip(scan(x,0,AF_BINARY_MUL,false),0);
 x=array(x,lc,x.elements()/lc).as(f64);
 array y=array(r.v,cnt(r)/r.s[ra],r.s[ra]).as(f64);
 z.v=array(matmul(r.s[ra]==1?tile(y,1,(I)l.s[0]):y,x),z.s);}
