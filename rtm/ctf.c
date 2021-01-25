NM(ctf,"ctf",0,0,MT,MFD,DFD,MT,DAD)
DEFN(ctf)
MF(ctf_f){B rr=rnk(r);z.s=SHP(2,1);z.v=r.v;
 if(rr)z.s[1]=r.s[rr-1];if(z.s[1])z.s[0]=cnt(r)/z.s[1];}
DA(ctf_f){cat_c(z,l,r,e,ax);}
DF(ctf_f){if(rnk(l)||rnk(r)){cat_c(z,l,r,e,scl(scl(0)));R;}
 A a,b;cat_c(a,l,e);cat_c(b,r,e);cat_c(z,a,b,e);}
