NM(mdv,"mdv",1,0,MT ,MFD,DFD,MT ,MT )
mdv_f mdv_c;
MF(mdv_f){z.f=1;if(r.r>2)err(4);if(r.r==2&&r.s[1]<r.s[0])err(5);if(!cnt(r))err(5);
 if(r.s[0]==r.s[1]){z.r=r.r;z.s=r.s;z.v=inverse(r.v);R;}
 if(r.r==1){z.v=matmulNT(inverse(matmulTN(r.v,r.v)),r.v);z.r=r.r;z.s=r.s;R;}
 z.v=matmulTN(inverse(matmulNT(r.v,r.v)),r.v);z.r=r.r;z.s=r.s;
 B k=z.s[0];z.s[0]=z.s[1];z.s[1]=k;z.v=transpose(z.v);}
DF(mdv_f){z.f=1;if(r.r>2)err(4);if(l.r>2)err(4);if(r.r==2&&r.s[1]<r.s[0])err(5);
 if(!cnt(r)||!cnt(l))err(5);if(r.r&&l.r&&l.s[l.r-1]!=r.s[r.r-1])err(5);
 array rv=r.v,lv=l.v;if(r.r==1)rv=transpose(rv);if(l.r==1)lv=transpose(lv);
 z.v=transpose(matmul(inverse(matmulNT(rv,rv)),matmulNT(rv,lv)));
 z.r=(l.r-(l.r>0))+(r.r-(r.r>0));
 if(l.r>1)z.s[0]=l.s[0];if(r.r>1)z.s[l.r>1]=r.s[0];}

