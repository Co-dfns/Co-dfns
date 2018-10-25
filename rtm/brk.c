void brk_c(A&z,const A&l,const std::vector<A>&r){I rl=(I)r.size();
 if(l.r!=1||rl!=1)err(16);z.r=r[0].r;z.s=r[0].s;z.v=l.v(r[0].v.as(s32));}

OD(brk,"brk",scm(l),scd(l),MFD,DFD)
MF(brk_o){ll(z,r,(r.r?r.r-1:0)-ww.v.as(f64).scalar<D>());}
DF(brk_o){D ax=l.r;if(r.r>l.r)ax=r.r;if(ax)ax--;
 ll(z,l,r,ax-ww.v.as(f64).scalar<D>());}

 