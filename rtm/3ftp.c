S FN{STR nm;I sm;I sd;FNP this_p;virtual ~FN() = default;
 FN(STR nm,I sm,I sd):nm(nm),sm(sm),sd(sd){}
 FN():nm(""),sm(0),sd(0){}
 virtual arr id(SHP s){err(16);R arr();}
 virtual V operator()(A&z,CA&r,ENV&e){err(99);}
 virtual V operator()(A&z,CA&r,ENV&e,CA&ax){err(2);}
 virtual V operator()(A&z,CA&l,CA&r,ENV&e){err(99);}
 virtual V operator()(A&z,CA&l,CA&r,ENV&e,CA&ax){err(2);}};
FNP MTFN = std::make_shared<FN>();
S MOP:FN{CA aa;FNP llp=MTFN;FN&ll=*llp;
 MOP(STR nm,I sm,I sd,CA&l):FN(nm,sm,sd),aa(l),llp(MTFN){ll=*llp;}
 MOP(STR nm,I sm,I sd,FNP llp):FN(nm,sm,sd),llp(llp){ll=*llp;}};
S DOP:FN{I fl;I fr;CA aa;CA ww;FNP llp=MTFN;FNP rrp=MTFN;FN&ll=*llp;FN&rr=*rrp;
 DOP(STR nm,I sm,I sd,FNP l,FNP r)
  :FN(nm,sm,sd),fl(1),fr(1),llp(l),rrp(r){ll=*llp;rr=*rrp;}
 DOP(STR nm,I sm,I sd,CA&l,FNP r)
  :FN(nm,sm,sd),fl(0),fr(1),aa(l),rrp(r){rr=*rrp;}
 DOP(STR nm,I sm,I sd,FNP l,CA&r)
  :FN(nm,sm,sd),fl(1),fr(0),ww(r),llp(l){ll=*llp;}
 DOP(STR nm,I sm,I sd,CA&l,CA&r)
  :FN(nm,sm,sd),fl(0),fr(0),aa(l),ww(r){}};
S MOK{virtual ~MOK() = default;
 virtual FNP operator()(FNP l){err(99);R MTFN;}
 virtual FNP operator()(CA&l){err(99);R MTFN;}};
S DOK{virtual ~DOK() = default;
 virtual FNP operator()(FNP l,FNP r){err(99);R MTFN;}
 virtual FNP operator()(CA&l,CA&r){err(99);R MTFN;}
 virtual FNP operator()(FNP l,CA&r){err(99);R MTFN;}
 virtual FNP operator()(CA&l,FNP r){err(99);R MTFN;}};
S DVSTR {
 V operator()(NIL l,NIL r){err(6);}
 V operator()(NIL l,carr&r){err(6);}
 V operator()(NIL l,CVEC<A>&r){err(6);}
 V operator()(carr&l,NIL r){err(6);}
 V operator()(CVEC<A>&l,NIL r){err(6);}};
S MVSTR {V operator()(NIL r){err(6);}};
template<class... Ts> S visitor : Ts... { using Ts::operator()...; };
template<class... Ts> visitor(Ts...) -> visitor<Ts...>;
