NM(ift,"ift",1,0,MT ,MFD,MT ,MT ,MT )
DEFN(ift)
MF(ift_f){z.r=r.r;z.s=r.s;z.v=idft(r.v.type()==c64?r.v:r.v.as(c64),1,r.s);}

