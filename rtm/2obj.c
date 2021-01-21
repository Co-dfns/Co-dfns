typedef enum{APLNC=0,APLU8,APLTI,APLSI,APLI,APLD,APLP,APLU,APLV,APLW,APLZ,
 APLR,APLF,APLQ}APLTYPE;
typedef long long L;typedef int I;typedef int16_t S16;typedef int8_t S8;
typedef double D;typedef unsigned char U8;typedef unsigned U;
typedef dim_t B;typedef cdouble DZ;typedef void V;typedef std::string STR;
typedef array arr;typedef const array carr;typedef af::index IDX;
S{U f=3;U n;U x=0;const wchar_t*v=L"Co-dfns";const wchar_t*e;V*c;}dmx;
S pkt{L l;B c;U t:4;U r:4;U e:4;U _:13;U _1:16;U _2:16;B s[1];};
S lp{pkt*p;V*i;};
S dwa{B z;S{B z;pkt*(*ga)(U,U,B*,S lp*);V(*p[16])();V(*er)(V*);}*ws;V*p[4];};
S dwa*dwafns;Z V derr(U n){dmx.n=n;dwafns->ws->er(&dmx);}
EXPORT I DyalogGetInterpreterFunctions(dwa*p){
 if(p)dwafns=p;else R 0;if(dwafns->z<(B)sizeof(S dwa))R 16;R 0;}
Z V err(U n,const wchar_t*e){dmx.e=e;throw n;}Z V err(U n){err(n,L"");}
std::wstring_convert<std::codecvt_utf8_utf16<wchar_t>> strconv;
typedef VEC<dim_t> SHP;S A;
typedef std::variant<std::monostate,arr,VEC<A>> VALS;
S A{SHP s;VALS v;
 A(){}
 A(SHP s,carr v):s(s),v(v){}
 A(SHP s,VEC<A> v):s(s),v(v){}
 A(B r,carr v):s(SHP(r,1)),v(v){}
 A(B r,VEC<A> v):s(SHP(r,1)),v(v){}};
typedef const A CA;S FN;S MOK;S DOK;typedef std::shared_ptr<FN> FNP;
typedef std::shared_ptr<MOK> MOKP;typedef std::shared_ptr<DOK> DOKP;
typedef std::variant<A,FNP,MOKP,DOKP> BX;
typedef VEC<BX> FRM;typedef std::unique_ptr<FRM> FRMP;
typedef VEC<FRMP> ENV;typedef std::stack<BX> STK;
SHP eshp=SHP(0);std::wstring msg;
