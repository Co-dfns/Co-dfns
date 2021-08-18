NM(eqv,"eqv",0,0,MT ,MFD,DFD,MT ,MT )
DEFN(eqv)
MF(eqv_f){z.s=eshp;z.v=scl(rnk(r)!=0);}
I is_eqv(CA&l,CA&r){B lr=rnk(l),rr=rnk(r);if(lr!=rr)R 0;
 DOB(lr,if(l.s[i]!=r.s[i])R 0)
 I res=1;
 std::visit(visitor{DVSTR(),
   [&](carr&lv,carr&rv){res=allTrue<I>(lv==rv);},
   [&](CVEC<A>&lv,carr&rv){res=0;},
   [&](carr&lv,CVEC<A>&rv){res=0;},
   [&](CVEC<A>&lv,CVEC<A>&rv){B c=cnt(l);
    DOB(c,if(!is_eqv(lv[i],rv[i])){res=0;R;})}},
  l.v,r.v);
 R res;}
DF(eqv_f){z.s=eshp;z.v=scl(is_eqv(l,r));}
