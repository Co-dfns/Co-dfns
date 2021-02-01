#define DEFN(n) FNP n##_p=std::make_shared<n##_f>();FN&n##_c=*n##_p;
#define NM(n,nm,sm,sd,di,mf,df,ma,da) S n##_f:FN{di;mf;df;ma;da;\
 n##_f():FN(nm,sm,sd){}};
#define OM(n,nm,sm,sd,mf,df,ma,da) S n##_o:MOP{mf;df;ma;da;\
 n##_o(FNP l):MOP(nm,sm,sd,l){}\
 n##_o(CA&l):MOP(nm,sm,sd,l){}};\
 S n##_k:MOK{\
  FNP operator()(FNP l){R std::make_shared<n##_o>(l);}\
  FNP operator()(CA&l){R std::make_shared<n##_o>(l);}};
#define OD(n,nm,sm,sd,mf,df,ma,da) S n##_o:DOP{mf;df;ma;da;\
 n##_o(FNP l,FNP r):DOP(nm,sm,sd,l,r){}\
 n##_o(CA&l,FNP r):DOP(nm,sm,sd,l,r){}\
 n##_o(FNP l,CA&r):DOP(nm,sm,sd,l,r){}\
 n##_o(CA&l,CA&r):DOP(nm,sm,sd,l,r){}};\
 S n##_k:DOK{\
  FNP operator()(FNP l,FNP r){R std::make_shared<n##_o>(l,r);}\
  FNP operator()(CA&l,CA&r){R std::make_shared<n##_o>(l,r);}\
  FNP operator()(FNP l,CA&r){R std::make_shared<n##_o>(l,r);}\
  FNP operator()(CA&l,FNP r){R std::make_shared<n##_o>(l,r);}};
#define DID inline array id(SHP)
#define MFD inline V operator()(A&z,CA&r,ENV&e)
#define MAD inline V operator()(A&z,CA&r,ENV&e,CA&ax)
#define DFD inline V operator()(A&z,CA&l,CA&r,ENV&e)
#define DAD inline V operator()(A&z,CA&l,CA&r,ENV&e,CA&ax)
#define DI(n) inline array n::id(SHP s)
#define ID(n,x,t) DI(n##_f){R constant(x,dim4(cnt(s)),t);}
#define MF(n) inline V n::operator()(A&z,CA&r,ENV&e)
#define MA(n) inline V n::operator()(A&z,CA&r,ENV&e,CA&ax)
#define DF(n) inline V n::operator()(A&z,CA&l,CA&r,ENV&e)
#define DA(n) inline V n::operator()(A&z,CA&l,CA&r,ENV&e,CA&ax)
#define SF(n,lb) \
 DF(n##_f){sclfn(z,l,r,e,[&](A&z,carr&lv,carr&rv,ENV&e){lb;});}\
 DA(n##_f){sclfn(z,l,r,e,ax,n##_c);}
#define SMF(n,lb) \
 MF(n##_f){msclfn(z,r,e,n##_c,[](A&z,carr&rv,ENV&e){lb;});}
#define EF(init,ex,fun) EXPORT V ex##_dwa(lp*z,lp*l,lp*r){try{\
  A cl,cr,za;fn##init##_f fn_c;fn_c(za,cl,cr,e##init);\
  cpda(cr,r);cpda(cl,l);\
  (*std::get<FNP>((*e##init[0])[fun]))(za,cl,cr,e##init);\
  cpad(z,za);}\
 catch(U n){derr(n);}\
 catch(exception&e){msg=mkstr(e.what());dmx.e=msg.c_str();derr(500);}}\
EXPORT V ex##_cdf(A*z,A*l,A*r){{A il,ir,iz;\
 fn##init##_f fn_c;fn_c(iz,il,ir,e##init);}\
 (*std::get<FNP>((*e##init[0])[fun]))(*z,*l,*r,e##init);}
#define EV(init,ex,slt)
#define VSWITCH(x,nil,arry,vec) \
 std::visit(\
  visitor{[&](NIL v){nil;},[&](arr&v){arry;},[&](VEC<A>&v){vec;}},\
  (x));
#define CVSWITCH(x,nil,arr,vec) \
 std::visit(\
  visitor{[&](NIL v){nil;},[&](carr&v){arr;},[&](CVEC<A>&v){vec;}},\
  (x));