NM(fft,"fft",1,0,MT ,MFD,MT ,MT ,MT )
DEFN(fft)
MF(fft_f){z.f=1;z.r=r.r;z.s=r.s;z.v=dft(r.v.type()==c64?r.v:r.v.as(c64),1,r.s);}

