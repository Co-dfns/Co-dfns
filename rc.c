S FN{STR nm;I sm;I sd;FN(STR nm,I sm,I sd):nm(nm),sm(sm),sd(sd){}
 FN():nm(""),sm(0),sd(0){}
 virtual array id(dim4 s){err(16);R array();}
 virtual V operator()(A&z,const A&r){err(99);}
 virtual V operator()(A&z,const A&r,D ax){err(99);}
 virtual V operator()(A&z,const A&l,const A&r){err(99);}
 virtual V operator()(A&z,const A&l,const A&r,D ax){err(99);}};
FN MTFN;
S MOP:FN{FN&ll;
 MOP(STR nm,I sm,I sd,FN&ll):FN(nm,sm,sd),ll(ll){}};
S DOP:FN{I fl;I fr;FN&ll;A aa;FN&rr;A ww;
 DOP(STR nm,I sm,I sd,FN&l,FN&r)
  :FN(nm,sm,sd),fl(1),fr(1),ll(l),aa(A()),rr(r),ww(A()){}
 DOP(STR nm,I sm,I sd,A l,FN&r)
  :FN(nm,sm,sd),fl(0),fr(1),ll(MTFN),aa(l),rr(r),ww(A()){}
 DOP(STR nm,I sm,I sd,FN&l,A r)
  :FN(nm,sm,sd),fl(1),fr(0),ll(l),aa(A()),rr(MTFN),ww(r){}};
