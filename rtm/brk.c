void brk_c(A&z,const A&l,const std::vector<A>&r){I rl=(I)r.size();
 if(!rl){if(l.r!=1)err(4);z=l;R;}
 if(rl!=l.r)err(4);z.r=0;DO(rl,z.r+=abs(r[i].r))if(z.r>4)err(16);
 I s=z.r;DO(4,z.s[i]=1)
 DO(rl,I j=i;I k=abs(r[j].r);s-=k;
  DO(k,z.s[s+i]=(k==r[j].r)?r[j].s[i]:l.s[j]))
 af::index x[4];DO(rl,if(r[i].r>=0)x[rl-(i+1)]=r[i].v.as(s32))
 z.v=l.v(x[0],x[1],x[2],x[3]);}

OD(brk,"brk",scm(l),scd(l),MFD,DFD)
MF(brk_o){ll(z,r,(r.r?r.r-1:0)-ww.v.as(f64).scalar<D>());}
DF(brk_o){D ax=l.r;if(r.r>l.r)ax=r.r;if(ax)ax--;
 ll(z,l,r,ax-ww.v.as(f64).scalar<D>());}

 