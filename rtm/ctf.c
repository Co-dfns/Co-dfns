NM(ctf,"ctf",0,0,MT,MFD,DFD,MT,MT)
ctf_f ctf_c;
MF(ctf_f){dim4 sp=z.s;sp[1]=r.r?r.s[r.r-1]:1;sp[0]=sp[1]?cnt(r)/sp[1]:1;
 sp[2]=sp[3]=1;z.r=2;z.s=sp;z.v=!cnt(z)?scl(0):array(r.v,z.s);}
DF(ctf_f){I x=l.r>r.r?l.r:r.r;if(l.r||r.r){cat_c(z,l,r,x-1);R;}
 A a,b;cat_c(a,l);cat_c(b,r);cat_c(z,a,b,0);}
