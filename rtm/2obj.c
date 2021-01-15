typedef enum{APLNC=0,APLU8,APLTI,APLSI,APLI,APLD,APLP,APLU,APLV,APLW,APLZ,
 APLR,APLF,APLQ}APLTYPE;
typedef long long L;typedef int I;typedef int16_t S16;typedef int8_t S8;
typedef double D;typedef unsigned char U8;typedef unsigned U;
typedef dim_t B;typedef cdouble DZ;typedef void V;typedef std::string STR;
typedef VEC<dim_t> SHP;typedef array arr;typedef const array carr;
typedef af::index IDX;
S{U f=3;U n;U x=0;const wchar_t*v=L"Co-dfns";const wchar_t*e;V*c;}dmx;
S lp{S{L l;B c;U t:4;U r:4;U e:4;U _:13;U _1:16;U _2:16;B s[1];}*p;};
S dwa{B z;S{B z;V*(*ga)(U,U,B*,S lp*);V(*p[16])();V(*er)(V*);}*ws;V*p[4];};
S dwa*dwafns;Z V derr(U n){dmx.n=n;dwafns->ws->er(&dmx);}
EXPORT I DyalogGetInterpreterFunctions(dwa*p){
 if(p)dwafns=p;else R 0;if(dwafns->z<(B)sizeof(S dwa))R 16;R 0;}
Z V err(U n,const wchar_t*e){dmx.e=e;throw n;}Z V err(U n){err(n,L"");}
SHP eshp=SHP(0);std::wstring msg;
std::wstring_convert<std::codecvt_utf8_utf16<wchar_t>> strconv;
S A{I f;SHP s;arr v;VEC<A> nv;
 A(SHP s,arr v):f(1),s(s),v(v){}
 A(SHP s,VEC<A> nv):f(1),s(s),nv(nv){}
 A(B r,arr v):f(1),s(SHP(r,1)),v(v){}
 A(B r,VEC<A> nv):f(1),s(SHP(r,1)),nv(nv){}
 A():f(0){}};
typedef const A CA;S FN;S MOK;S DOK;typedef std::shared_ptr<FN> FNP;
typedef std::shared_ptr<MOK> MOKP;typedef std::shared_ptr<DOK> DOKP;
typedef std::variant<A,FNP,MOKP,DOKP> BX;
typedef VEC<BX> FRM;typedef std::unique_ptr<FRM> FRMP;
typedef VEC<FRMP> ENV;typedef std::stack<BX> STK;
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
