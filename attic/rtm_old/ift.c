NM(ift,"ift",1,0,MT ,MFD,MT ,MT ,MT )
DEFN(ift)
MF(ift_f){arr rv;CVSWITCH(r.v,err(6),rv=unrav(v,r.s),err(11))
 z.s=r.s;z.v=idft(rv.type()==c64?rv:rv.as(c64),1,rv.dims());}

