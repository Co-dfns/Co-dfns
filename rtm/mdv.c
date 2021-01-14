NM(mdv,"mdv",1,0,MT ,MFD,DFD,MT ,MT )
DEFN(mdv)
MF(mdv_f){z.f=1;B rr=rnk(r),rc=cnt(r);arr rv=unrav(r);
 if(rr>2)err(4);if(rr==2&&r.s[1]<r.s[0])err(5);if(!rc)err(5);
 if(!rr||rc==1||r.s[0]==r.s[1]){z.s=r.s;z.v=flat(inverse(rv));R;}
 if(rr==1){z.v=flat(matmulNT(inverse(matmulTN(rv,rv)),rv));z.s=r.s;R;}
 z.v=matmulTN(inverse(matmulNT(rv,rv)),rv);z.s=r.s;
 B k=z.s[0];z.s[0]=z.s[1];z.s[1]=k;z.v=flat(transpose(z.v));}
DF(mdv_f){z.f=1;B rr=rnk(r),lr=rnk(l),rc=cnt(r),lc=cnt(l);
 if(rr>2)err(4);if(lr>2)err(4);if(rr==2&&r.s[1]<r.s[0])err(5);
 if(!rc||!lc)err(5);if(rr&&lr&&l.s[lr-1]!=r.s[rr-1])err(5);
 arr rv=unrav(r),lv=unrav(l);
 if(rr==1)rv=transpose(rv);if(lr==1)lv=transpose(lv);
 z.v=flat(transpose(matmul(inverse(matmulNT(rv,rv)),matmulNT(rv,lv))));
 z.s=SHP((lr-(lr>0))+(rr-(rr>0)));
 if(lr>1)z.s[0]=l.s[0];if(rr>1)z.s[lr>1]=r.s[0];}
