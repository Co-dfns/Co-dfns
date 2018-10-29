void brk_c(A&z,const A&l,const std::vector<A>&r){I rl=(I)r.size();
 I rk=rl;rk+=rl==0;if(rk!=l.r)err(4);
 I rks[4]={0,0,0,0};DO(rl,rks[i]=r[i].r;rks[i]+=r[i].r==0);
 z.r=0;DO(4,z.r+=rks[i]);if(z.r>4)err(16);
 I x=0;
 DO(rl,I j=i;
  DO(r[j].r,z.s[x+i]=r[j].s[i])z.s[x]+=r[j].r==0;x+=rks[j])
 array vs[4];DO(rl,vs[i]=r[i].v.as(s32))
 switch(rk){
  CS(1,z.v=l.v(vs[0]);if(!r[0].r)z.r=0;)CS(2,z.v=l.v(vs[1],vs[0]))
  CS(3,z.v=l.v(vs[2],vs[1],vs[0]))CS(4,z.v=l.v(vs[3],vs[2],vs[1],vs[0]))}}

OD(brk,"brk",scm(l),scd(l),MFD,DFD)
MF(brk_o){ll(z,r,(r.r?r.r-1:0)-ww.v.as(f64).scalar<D>());}
DF(brk_o){D ax=l.r;if(r.r>l.r)ax=r.r;if(ax)ax--;
 ll(z,l,r,ax-ww.v.as(f64).scalar<D>());}

 