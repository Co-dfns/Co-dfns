NM(brk,"brk",0,0,MT ,MFD,DFD,MT ,MT )
brk_f brk_c;
MF(brk_f){err(16);}
DF(brk_f){if(l.r!=1)err(16);
 z.r=r.r;z.s=r.s;z.v=l.v(r.v.as(s32));}

OD(brk,"brk",scm(l),scd(l),MFD,DFD)
MF(brk_o){ll(z,r,(r.r?r.r-1:0)-ww.v.as(f64).scalar<D>());}
DF(brk_o){D ax=l.r;if(r.r>l.r)ax=r.r;if(ax)ax--;
 ll(z,l,r,ax-ww.v.as(f64).scalar<D>());}
