typedef enum{APLNC=0,APLU8,APLTI,APLSI,APLI,APLD,APLP,APLU,APLV,APLW,APLZ,
 APLR,APLF,APLQ}APLTYPE;
typedef long long L;typedef int I;typedef int16_t S16;typedef int8_t S8;
typedef double D;typedef unsigned char U8;typedef unsigned U;
typedef dim_t B;typedef cdouble DZ;typedef void V;typedef std::string STR;
S{U f=3;U n;U x=0;const wchar_t*v=L"Co-dfns";const wchar_t*e;V*c;}dmx;
S lp{S{L l;B c;U t:4;U r:4;U e:4;U _:13;U _1:16;U _2:16;B s[1];}*p;};
S dwa{B z;S{B z;V*(*ga)(U,U,B*,S lp*);V(*p[16])();V(*er)(V*);}*ws;V*p[4];};
S dwa*dwafns;Z V derr(U n){dmx.n=n;dwafns->ws->er(&dmx);}
EXPORT I DyalogGetInterpreterFunctions(dwa*p){
 if(p)dwafns=p;else R 0;if(dwafns->z<sizeof(S dwa))R 16;R 0;}
Z V err(U n,wchar_t*e){dmx.e=e;throw n;}Z V err(U n){dmx.e=L"";throw n;}
dim4 eshp=dim4(0,(B*)NULL);
std::wstring_convert<std::codecvt_utf8_utf16<wchar_t>> strconv;
std::wstring msg;S BX;
typedef std::vector<BX> FRM;typedef std::vector<FRM*> ENV;
typedef std::stack<BX> STK;
S A{I r,f;dim4 s;array v;std::vector<A> nv;
 A(I r,dim4 s,array v):r(r),f(1),s(s),v(v){}
 A():r(0),f(0),s(dim4()),v(array()){}};
S FN{STR nm;I sm;I sd;FN(STR nm,I sm,I sd):nm(nm),sm(sm),sd(sd){}
 FN():nm(""),sm(0),sd(0){}
 virtual array id(dim4 s){err(16);R array();}
 virtual V operator()(A&z,const A&r,ENV&e){err(99);}
 virtual V operator()(A&z,const A&r,D ax,ENV&e){err(99);}
 virtual V operator()(A&z,const A&l,const A&r,ENV&e){err(99);}
 virtual V operator()(A&z,const A&l,const A&r,D ax,ENV&e){err(99);}};
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
S MOK{virtual V operator()(FN*&f,FN&l){err(99);}};
S DOK{virtual V operator()(FN*&f,FN&l,FN&r){err(99);}
 virtual V operator()(FN*&f,const A&l,FN&r){err(99);}
 virtual V operator()(FN*&f,FN&l,const A&r){err(99);}};
S BX{A v;union{FN*f;MOK*m;DOK*d;};
 BX(){}BX(FN*f):f(f){}BX(const A&v):v(v){}BX(MOK*m):m(m){}BX(DOK*d):d(d){}};

