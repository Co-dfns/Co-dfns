:Namespace codfns
⍝ === VARIABLES ===

AF∆LIB←'cuda'

AF∆PREFIX←'/opt/arrayfire'

DM←3⍴⊂''

EN←0

N∆←' ABCEFGKLMNOPSVZ'

VERSION←4 1 0

VS∆PATH←'\Program Files\Microsoft Visual Studio\2022\Community'

deps←((,'⍉') (,'⍴') (,'⍋') '%s' (,'+')) ((,'⍉') (,'⍴') (,'⍋') '%s' (,'-')) ((,'⍉') (,'⍴') (,'⍋') '%s' (,'×')) ((,'⍉') (,'⍴') (,'⍋') '%s' (,'÷')) ((,'⍉') (,'⍴') (,'⍋') '%s' (,'*')) ((,'⍉') (,'⍴') (,'⍋') '%s' (,'⍟')) ((,'⍉') (,'⍴') (,'⍋') '%s' (,'|')) ((,'⍉') (,'⍴') (,'⍋') '%s' (,'○')) ((,'⍉') (,'⍴') (,'⍋') '%s' (,'⌊')) ((,'⍉') (,'⍴') (,'⍋') '%s' (,'⌈')) ((,'⍉') (,'⍴') (,'⍋') '%s' (,'!')) ((,'⍉') (,'⍴') (,'⍋') '%s' (,'<')) ((,'⍉') (,'⍴') (,'⍋') '%s' (,'≤')) ((,'⍉') (,'⍴') (,'⍋') '%s' (,'=')) ((,'⍉') (,'⍴') (,'⍋') '%s' (,'≥')) ((,'⍉') (,'⍴') (,'⍋') '%s' (,'>')) ((,'⍉') (,'⍴') (,'⍋') '%s' (,'≠')) ((,'⍉') (,'⍴') (,'⍋') '%s' (,'~')) ((,'∨') (,'∧')) ((,'⍉') (,'⍴') (,'⍋') '%s' (,'∨')) ((,'⍉') (,'⍴') (,'⍋') '%s' (,'⍲')) ((,'⍉') (,'⍴') (,'⍋') '%s' (,'⍱')) ((,'⍳') (,'⌷')) (⊂,'[') (⊂,'⍳') (⊂,'⍴') (⊂,',') ((,',') (,'⍪')) ((,'|') (,',') (,'⌽')) (⊂,'⍉') ((,'⌽') (,'⊖')) (⊂,'∊') (⊂,'⊃') (⊂,'≡') ((,'≡') (,'≢')) (⊂,'⊢') (⊂,'⊣') (⊂,'⊤') (⊂,'⊥') ((,'¨') (,'/')) ((,'/') (,'⌿')) ((,'¨') (,'\')) ((,'\') (,'⍀')) ((,'⍉') (,'⍴') (,'⍋') '%s' (,'?')) ((,'⍳') (,'↑')) ((,'⍳') (,'↓')) ((,'⊃') (,',') (,'¨')) (⊂,'⍨') ((,'/') (,'.')) ((,'↑') (,'⌷') (,'⍤')) (⊂,'⍣') (⊂,'∘') (⊂,'∪') (⊂,'∩') ((,'[') (,'⊃') (,',') (,'¨') (,'←')) (⊂,'⍋') (⊂,'⍒') ((,'¨') '∘.') (⊂,'⍷') ((,'¨') (,'⌷') (,'⊂')) (⊂,'⌹') (⊂'⎕FFT') (⊂'⎕IFFT') (⊂'%s') ((,'⊂') (,'⊆')) (⊂,'∇') (⊂,';') (⊂'%u')

f∆←'ptknfsrdx'

_←⍬
_,←'add' 'sub' 'mul' 'div' 'exp' 'log' 'res' 'cir' 'min' 'max' 'fac' 'lth' 'lte' 'eql' 'gte' 'gth' 'neq' 'not' 'and'
_,←'lor' 'nan' 'nor' 'sqd' 'brk' 'iot' 'rho' 'cat' 'ctf' 'rot' 'trn' 'rtf' 'mem' 'dis' 'eqv' 'nqv' 'rgt' 'lft' 'enc'
_,←'dec' 'red' 'rdf' 'scn' 'scf' 'rol' 'tke' 'drp' 'map' 'com' 'dot' 'rnk' 'pow' 'jot' 'unq' 'int' 'get' 'gdu' 'gdd'
_,←'oup' 'fnd' 'par' 'mdv' 'fft' 'ift' 'scl' 'nst' 'this' 'span' ''
nams←_

_←⍬
_,←'#define _SILENCE_CXX17_CODECVT_HEADER_DEPRECATION_WARNING',(⎕ucs 10 10),'#include <time.h>',(⎕ucs 10),'#include <stdint.h>',(⎕ucs 10),'#include <stdio.h>',(⎕ucs 10),'#include <inttypes.h>'
_,←(⎕ucs 10),'#include <limits.h>',(⎕ucs 10),'#include <float.h>',(⎕ucs 10),'#include <locale>',(⎕ucs 10),'#include <codecvt>',(⎕ucs 10),'#include <math.h>',(⎕ucs 10),'#include <memory>',(⎕ucs 10)
_,←'#include <algorithm>',(⎕ucs 10),'#include <stack>',(⎕ucs 10),'#include <string>',(⎕ucs 10),'#include <cstring>',(⎕ucs 10),'#include <variant>',(⎕ucs 10),'#include <vector>',(⎕ucs 10)
_,←'#include <unordered_map>',(⎕ucs 10),'#include <arrayfire.h>',(⎕ucs 10),'using namespace af;',(⎕ucs 10 10),'#if AF_API_VERSION < 36',(⎕ucs 10),'#error "Your ArrayFire version is too old."',(⎕ucs 10)
_,←'#endif',(⎕ucs 10),'#ifdef _WIN32',(⎕ucs 10),' #define EXPORT extern "C" __declspec(dllexport)',(⎕ucs 10),'#elif defined(__GNUC__)',(⎕ucs 10)
_,←' #define EXPORT extern "C" __attribute__ ((visibility ("default")))',(⎕ucs 10),'#else',(⎕ucs 10),' #define EXPORT extern "C"',(⎕ucs 10),'#endif',(⎕ucs 10),'#ifdef _MSC_VER',(⎕ucs 10)
_,←' #define RSTCT __restrict',(⎕ucs 10),'#else',(⎕ucs 10),' #define RSTCT restrict',(⎕ucs 10),'#endif',(⎕ucs 10),'#define S struct',(⎕ucs 10),'#define Z static',(⎕ucs 10),'#define R return',(⎕ucs 10)
_,←'#define this_c (*this)',(⎕ucs 10),'#define VEC std::vector',(⎕ucs 10),'#define CVEC const std::vector',(⎕ucs 10),'#define RANK(pp) ((pp)->r)',(⎕ucs 10),'#define TYPE(pp) ((pp)->t)',(⎕ucs 10)
_,←'#define SHAPE(pp) ((pp)->s)',(⎕ucs 10),'#define ETYPE(pp) ((pp)->e)',(⎕ucs 10),'#define DATA(pp) ((V*)&SHAPE(pp)[RANK(pp)])',(⎕ucs 10),'#define CS(n,x) case n:x;break;',(⎕ucs 10)
_,←'#define DO(n,x) {I _i=(n),i=0;for(;i<_i;++i){x;}}',(⎕ucs 10),'#define DOB(n,x) {B _i=(n),i=0;for(;i<_i;++i){x;}}',(⎕ucs 10),'#define MT',(⎕ucs 10),'#define PUSH(x) s.emplace(x)',(⎕ucs 10)
_,←'#define POP(f,x) x=std::get<f>(s.top());s.pop()',(⎕ucs 10),'#define DEFN(n) FNP n##_p=std::make_shared<n##_f>();FN&n##_c=*n##_p;',(⎕ucs 10)
_,←'#define NM(n,nm,sm,sd,di,mf,df,ma,da) S n##_f:FN{di;mf;df;ma;da;\',(⎕ucs 10),' n##_f():FN(nm,sm,sd){}};',(⎕ucs 10),'#define OM(n,nm,sm,sd,mf,df,ma,da) S n##_o:MOP{mf;df;ma;da;\',(⎕ucs 10)
_,←' n##_o(FNP l):MOP(nm,sm,sd,l){}\',(⎕ucs 10),' n##_o(CA&l):MOP(nm,sm,sd,l){}};\',(⎕ucs 10),' S n##_k:MOK{\',(⎕ucs 10),'  FNP operator()(FNP l){R std::make_shared<n##_o>(l);}\',(⎕ucs 10)
_,←'  FNP operator()(CA&l){R std::make_shared<n##_o>(l);}};',(⎕ucs 10),'#define OD(n,nm,sm,sd,mf,df,ma,da) S n##_o:DOP{mf;df;ma;da;\',(⎕ucs 10),' n##_o(FNP l,FNP r):DOP(nm,sm,sd,l,r){}\',(⎕ucs 10)
_,←' n##_o(CA&l,FNP r):DOP(nm,sm,sd,l,r){}\',(⎕ucs 10),' n##_o(FNP l,CA&r):DOP(nm,sm,sd,l,r){}\',(⎕ucs 10),' n##_o(CA&l,CA&r):DOP(nm,sm,sd,l,r){}};\',(⎕ucs 10),' S n##_k:DOK{\',(⎕ucs 10)
_,←'  FNP operator()(FNP l,FNP r){R std::make_shared<n##_o>(l,r);}\',(⎕ucs 10),'  FNP operator()(CA&l,CA&r){R std::make_shared<n##_o>(l,r);}\',(⎕ucs 10)
_,←'  FNP operator()(FNP l,CA&r){R std::make_shared<n##_o>(l,r);}\',(⎕ucs 10),'  FNP operator()(CA&l,FNP r){R std::make_shared<n##_o>(l,r);}};',(⎕ucs 10),'#define DID inline array id(SHP)',(⎕ucs 10)
_,←'#define MFD inline V operator()(A&z,CA&r,ENV&e)',(⎕ucs 10),'#define MAD inline V operator()(A&z,CA&r,ENV&e,CA&ax)',(⎕ucs 10),'#define DFD inline V operator()(A&z,CA&l,CA&r,ENV&e)',(⎕ucs 10)
_,←'#define DAD inline V operator()(A&z,CA&l,CA&r,ENV&e,CA&ax)',(⎕ucs 10),'#define DI(n) inline array n::id(SHP s)',(⎕ucs 10),'#define ID(n,x,t) DI(n##_f){R constant(x,dim4(cnt(s)),t);}',(⎕ucs 10)
_,←'#define MF(n) inline V n::operator()(A&z,CA&r,ENV&e)',(⎕ucs 10),'#define MA(n) inline V n::operator()(A&z,CA&r,ENV&e,CA&ax)',(⎕ucs 10),'#define DF(n) inline V n::operator()(A&z,CA&l,CA&r,ENV&e)'
_,←(⎕ucs 10),'#define DA(n) inline V n::operator()(A&z,CA&l,CA&r,ENV&e,CA&ax)',(⎕ucs 10),'#define SF(n,lb) \',(⎕ucs 10),' DF(n##_f){sclfn(z,l,r,e,[&](A&z,carr&lv,carr&rv,ENV&e){lb;});}\',(⎕ucs 10)
_,←' DA(n##_f){sclfn(z,l,r,e,ax,n##_c);}',(⎕ucs 10),'#define SMF(n,lb) \',(⎕ucs 10),' MF(n##_f){msclfn(z,r,e,n##_c,[](A&z,carr&rv,ENV&e){lb;});}',(⎕ucs 10)
_,←'#define EF(init,ex,fun) EXPORT V ex##_dwa(lp*z,lp*l,lp*r){try{\',(⎕ucs 10),'  A cl,cr,za;fn##init##_f fn_c;fn_c(za,cl,cr,e##init);\',(⎕ucs 10),'  cpda(cr,r);cpda(cl,l);\',(⎕ucs 10)
_,←'  (*std::get<FNP>((*e##init[0])[fun]))(za,cl,cr,e##init);\',(⎕ucs 10),'  cpad(z,za);}\',(⎕ucs 10),' catch(U n){derr(n);}\',(⎕ucs 10)
_,←' catch(exception&e){msg=mkstr(e.what());dmx.e=msg.c_str();derr(500);}}\',(⎕ucs 10),'EXPORT V ex##_cdf(A*z,A*l,A*r){{A il,ir,iz;\',(⎕ucs 10),' fn##init##_f fn_c;fn_c(iz,il,ir,e##init);}\',(⎕ucs 10)
_,←' (*std::get<FNP>((*e##init[0])[fun]))(*z,*l,*r,e##init);}',(⎕ucs 10),'#define EV(init,ex,slt)',(⎕ucs 10),'#define EO(init,ex,slt)',(⎕ucs 10),'#define VSWITCH(x,nil,arry,vec) \',(⎕ucs 10)
_,←' std::visit(\',(⎕ucs 10),'  visitor{[&](NIL v){nil;},[&](arr&v){arry;},[&](VEC<A>&v){vec;}},\',(⎕ucs 10),'  (x));',(⎕ucs 10),'#define CVSWITCH(x,nil,arr,vec) \',(⎕ucs 10),' std::visit(\',(⎕ucs 10)
_,←'  visitor{[&](NIL v){nil;},[&](carr&v){arr;},[&](CVEC<A>&v){vec;}},\',(⎕ucs 10),'  (x));',(⎕ucs 10),'typedef enum{APLNC=0,APLU8,APLTI,APLSI,APLI,APLD,APLP,APLU,APLV,APLW,APLZ,',(⎕ucs 10)
_,←' APLR,APLF,APLQ}APLTYPE;',(⎕ucs 10),'typedef long long L;typedef int I;typedef int16_t S16;typedef int8_t S8;',(⎕ucs 10),'typedef double D;typedef unsigned char U8;typedef unsigned U;',(⎕ucs 10)
_,←'typedef dim_t B;typedef cdouble DZ;typedef void V;typedef std::string STR;',(⎕ucs 10),'typedef array arr;typedef const array carr;typedef af::index IDX;',(⎕ucs 10),'typedef std::monostate NIL;'
_,←(⎕ucs 10),'S{U f=3;U n;U x=0;const wchar_t*v=L"Co-dfns";const wchar_t*e;V*c;}dmx;',(⎕ucs 10),'S pkt{L l;B c;U t:4;U r:4;U e:4;U _:13;U _1:16;U _2:16;B s[1];};',(⎕ucs 10),'S lp{pkt*p;V*i;};'
_,←(⎕ucs 10),'S dwa{B z;S{B z;pkt*(*ga)(U,U,B*,S lp*);V(*p[16])();V(*er)(V*);}*ws;V*p[4];};',(⎕ucs 10),'S dwa*dwafns;',(⎕ucs 10),'extern "C" int set_dwa(void*);',(⎕ucs 10)
_,←'extern "C" void dwaerror(unsigned int, const wchar_t *);',(⎕ucs 10),'EXPORT I DyalogGetInterpreterFunctions(dwa*p){',(⎕ucs 10)
_,←' if(p){dwafns=p;set_dwa(p);}else R 0;if(dwafns->z<(B)sizeof(S dwa))R 16;R 0;}',(⎕ucs 10),'Z V derr(U n){dwaerror(n,dmx.e);}',(⎕ucs 10),'Z V err(U n,const wchar_t*e){dmx.e=e;throw n;}',(⎕ucs 10)
_,←'Z V err(U n){err(n,L"");}',(⎕ucs 10),'std::wstring_convert<std::codecvt_utf8_utf16<wchar_t>> strconv;',(⎕ucs 10),'typedef VEC<dim_t> SHP;S A;',(⎕ucs 10),'typedef std::variant<NIL,arr,VEC<A>> VALS;'
_,←(⎕ucs 10),'S A{SHP s;VALS v;',(⎕ucs 10),' A(){}',(⎕ucs 10),' A(B r):s(SHP(r,1)){}',(⎕ucs 10),' A(SHP s,VALS v):s(s),v(v){}',(⎕ucs 10),' A(B r,VALS v):s(SHP(r,1)),v(v){}};',(⎕ucs 10)
_,←'typedef const A CA;S FN;S MOK;S DOK;typedef std::shared_ptr<FN> FNP;',(⎕ucs 10),'typedef std::shared_ptr<MOK> MOKP;typedef std::shared_ptr<DOK> DOKP;',(⎕ucs 10)
_,←'typedef std::variant<A,FNP,MOKP,DOKP> BX;',(⎕ucs 10),'typedef VEC<BX> FRM;typedef std::unique_ptr<FRM> FRMP;',(⎕ucs 10),'typedef VEC<FRMP> ENV;typedef std::stack<BX> STK;',(⎕ucs 10)
_,←'SHP eshp=SHP(0);std::wstring msg;',(⎕ucs 10),'S FN{STR nm;I sm;I sd;FNP this_p;virtual ~FN() = default;',(⎕ucs 10),' FN(STR nm,I sm,I sd):nm(nm),sm(sm),sd(sd){}',(⎕ucs 10)
_,←' FN():nm(""),sm(0),sd(0){}',(⎕ucs 10),' virtual arr id(SHP s){err(16);R arr();}',(⎕ucs 10),' virtual V operator()(A&z,CA&r,ENV&e){err(99);}',(⎕ucs 10)
_,←' virtual V operator()(A&z,CA&r,ENV&e,CA&ax){err(2);}',(⎕ucs 10),' virtual V operator()(A&z,CA&l,CA&r,ENV&e){err(99);}',(⎕ucs 10),' virtual V operator()(A&z,CA&l,CA&r,ENV&e,CA&ax){err(2);}};'
_,←(⎕ucs 10),'FNP MTFN = std::make_shared<FN>();',(⎕ucs 10),'S MOP:FN{CA aa;FNP llp=MTFN;FN&ll=*llp;',(⎕ucs 10),' MOP(STR nm,I sm,I sd,CA&l):FN(nm,sm,sd),aa(l),llp(MTFN){ll=*llp;}',(⎕ucs 10)
_,←' MOP(STR nm,I sm,I sd,FNP llp):FN(nm,sm,sd),llp(llp){ll=*llp;}};',(⎕ucs 10),'S DOP:FN{I fl;I fr;CA aa;CA ww;FNP llp=MTFN;FNP rrp=MTFN;FN&ll=*llp;FN&rr=*rrp;',(⎕ucs 10)
_,←' DOP(STR nm,I sm,I sd,FNP l,FNP r)',(⎕ucs 10),'  :FN(nm,sm,sd),fl(1),fr(1),llp(l),rrp(r){ll=*llp;rr=*rrp;}',(⎕ucs 10),' DOP(STR nm,I sm,I sd,CA&l,FNP r)',(⎕ucs 10)
_,←'  :FN(nm,sm,sd),fl(0),fr(1),aa(l),rrp(r){rr=*rrp;}',(⎕ucs 10),' DOP(STR nm,I sm,I sd,FNP l,CA&r)',(⎕ucs 10),'  :FN(nm,sm,sd),fl(1),fr(0),ww(r),llp(l){ll=*llp;}',(⎕ucs 10)
_,←' DOP(STR nm,I sm,I sd,CA&l,CA&r)',(⎕ucs 10),'  :FN(nm,sm,sd),fl(0),fr(0),aa(l),ww(r){}};',(⎕ucs 10),'S MOK{virtual ~MOK() = default;',(⎕ucs 10),' virtual FNP operator()(FNP l){err(99);R MTFN;}'
_,←(⎕ucs 10),' virtual FNP operator()(CA&l){err(99);R MTFN;}};',(⎕ucs 10),'S DOK{virtual ~DOK() = default;',(⎕ucs 10),' virtual FNP operator()(FNP l,FNP r){err(99);R MTFN;}',(⎕ucs 10)
_,←' virtual FNP operator()(CA&l,CA&r){err(99);R MTFN;}',(⎕ucs 10),' virtual FNP operator()(FNP l,CA&r){err(99);R MTFN;}',(⎕ucs 10),' virtual FNP operator()(CA&l,FNP r){err(99);R MTFN;}};',(⎕ucs 10)
_,←'S DVSTR {',(⎕ucs 10),' V operator()(NIL l,NIL r){err(6);}',(⎕ucs 10),' V operator()(NIL l,carr&r){err(6);}',(⎕ucs 10),' V operator()(NIL l,CVEC<A>&r){err(6);}',(⎕ucs 10)
_,←' V operator()(carr&l,NIL r){err(6);}',(⎕ucs 10),' V operator()(CVEC<A>&l,NIL r){err(6);}};',(⎕ucs 10),'S MVSTR {V operator()(NIL r){err(6);}};',(⎕ucs 10)
_,←'template<class... Ts> S visitor : Ts... { using Ts::operator()...; };',(⎕ucs 10),'template<class... Ts> visitor(Ts...) -> visitor<Ts...>;',(⎕ucs 10)
_,←'std::wstring mkstr(const char*s){R strconv.from_bytes(s);}',(⎕ucs 10),'I scm(FN&f){R f.sm;}I scm(const A&a){R 1;}I scm(FNP f){R (*f).sm;}',(⎕ucs 10)
_,←'I scd(FN&f){R f.sd;}I scd(const A&a){R 1;}I scd(FNP f){R (*f).sd;}',(⎕ucs 10),'B rnk(const SHP&s){R s.size();}',(⎕ucs 10),'B rnk(const A&a){R rnk(a.s);}',(⎕ucs 10)
_,←'B cnt(SHP s){B c=1;DOB(s.size(),c*=s[i]);R c;}',(⎕ucs 10),'B cnt(const A&a){R cnt(a.s);}',(⎕ucs 10),'B cnt(pkt*d){B c=1;DO(RANK(d),c*=SHAPE(d)[i]);R c;}',(⎕ucs 10),'B cnt(arr&a){R a.elements();}'
_,←(⎕ucs 10),'I geti(CA&a){I x;CVSWITCH(a.v,err(6),x=v.as(s32).scalar<I>(),err(11));R x;}',(⎕ucs 10),'arr scl(D x){R constant(x,dim4(1),f64);}',(⎕ucs 10),'arr scl(I x){R constant(x,dim4(1),s32);}'
_,←(⎕ucs 10),'arr scl(B x){R constant(x,dim4(1),u64);}',(⎕ucs 10),'A scl(arr v){R A(0,v);}',(⎕ucs 10),'arr axis(carr&a,const SHP&s,B ax){B l=1,m=1,r=1;if(ax>=rnk(s))R a;m=s[ax];',(⎕ucs 10)
_,←' DOB(ax,l*=s[i])DOB(rnk(s)-ax-1,r*=s[ax+i+1])',(⎕ucs 10),' R moddims(a,l,m,r);}',(⎕ucs 10),'arr table(carr&a,const SHP&s,B ax){B l=1,r=1;if(ax>=rnk(s))R a;',(⎕ucs 10)
_,←' DOB(ax,l*=s[i])DOB(rnk(s)-ax,r*=s[ax+i])',(⎕ucs 10),' R moddims(a,l,r);}',(⎕ucs 10),'arr unrav(carr&a,const SHP&sp){if(rnk(sp)>4)err(99);',(⎕ucs 10),' dim4 s(1);DO((I)rnk(sp),s[i]=sp[i])'
_,←(⎕ucs 10),' R moddims(a,s);}',(⎕ucs 10),'V af2cd(A&a,const arr&b){dim4 bs=b.dims();a.s=SHP(4,1);DO(4,a.s[i]=bs[i])',(⎕ucs 10),' a.v=flat(b);}',(⎕ucs 10)
_,←'dtype mxt(dtype at,dtype bt){if(at==c64||bt==c64)R c64;',(⎕ucs 10),' if(at==f64||bt==f64)R f64;',(⎕ucs 10),' if(at==s32||bt==s32)R s32;if(at==s16||bt==s16)R s16;',(⎕ucs 10)
_,←' if(at==b8||bt==b8)R b8;err(16);R f64;}',(⎕ucs 10),'dtype mxt(carr&a,carr&b){R mxt(a.type(),b.type());}',(⎕ucs 10),'dtype mxt(dtype at,CA&b){',(⎕ucs 10),' R std::visit(visitor{',(⎕ucs 10)
_,←'   [&](NIL _){err(99,L"Unexpected value error.");R s32;},',(⎕ucs 10),'   [&](carr&v){R mxt(at,v.type());},',(⎕ucs 10),'   [&](CVEC<A>&v){dtype zt=at;DOB(v.size(),zt=mxt(zt,v[i]));R zt;}},'
_,←(⎕ucs 10),'  b.v);}',(⎕ucs 10),'dtype mxt(CA&a,CA&b){R mxt(mxt(b8,a),mxt(b8,b));}',(⎕ucs 10),'inline I isint(D x){R x==nearbyint(x);}',(⎕ucs 10),'inline I isint(CA&x){I res=1;',(⎕ucs 10)
_,←' CVSWITCH(x.v',(⎕ucs 10),'  ,err(99,L"Unexpected value error.")',(⎕ucs 10),'  ,res=v.isinteger()||v.isbool()||(v.isreal()&&allTrue<I>(v==trunc(v)))',(⎕ucs 10)
_,←'  ,DOB(v.size(),if(!isint(v[i])){res=0;R;}))',(⎕ucs 10),' R res;}',(⎕ucs 10),'inline I isbool(carr&v){R v.isbool()||(v.isreal()&&allTrue<I>(v==0||v==1));}',(⎕ucs 10)
_,←'inline I isbool(CA&x){I res=1;',(⎕ucs 10),' CVSWITCH(x.v',(⎕ucs 10),'  ,err(99,L"Unexpected value error.")',(⎕ucs 10),'  ,res=isbool(v)',(⎕ucs 10),'  ,DOB(v.size(),if(!isbool(v[i])){res=0;R;}))'
_,←(⎕ucs 10),' R res;}',(⎕ucs 10),'V coal(A&a){',(⎕ucs 10),' VSWITCH(a.v,,,',(⎕ucs 10),'  B c=cnt(a);I can=1;',(⎕ucs 10),'  DOB(c,A&b=v[i];',(⎕ucs 10)
_,←'   coal(b);if(rnk(b))can=0;CVSWITCH(b.v,can=0,,can=0)',(⎕ucs 10),'   if(!can)break)',(⎕ucs 10),'  if(can){dtype tp=mxt(b8,a);arr nv(c,tp);',(⎕ucs 10)
_,←'   const wchar_t*msg=L"Unexpected non-simple array type.";',(⎕ucs 10),'   DOB(c,CVSWITCH(v[i].v,err(99,msg),nv((I)i)=v(0).as(tp),err(99,msg)))',(⎕ucs 10),'   a.v=nv;})}',(⎕ucs 10)
_,←'arr proto(carr&);VEC<A> proto(CVEC<A>&);A proto(CA&);',(⎕ucs 10),'arr proto(carr&a){arr z=a;z=0;R z;}',(⎕ucs 10),'VEC<A> proto(CVEC<A>&a){VEC<A> z(a.size());DOB(a.size(),z[i]=proto(a[i]));R z;}'
_,←(⎕ucs 10),'A proto(CA&a){A z;z.s=a.s;CVSWITCH(a.v,err(6),z.v=proto(v),z.v=proto(v));R z;}',(⎕ucs 10),'Z arr da16(B c,pkt*d){VEC<S16>b(c);S8*v=(S8*)DATA(d);',(⎕ucs 10)
_,←' DOB(c,b[i]=v[i]);R arr(c,b.data());}',(⎕ucs 10),'Z arr da8(B c,pkt*d){VEC<char>b(c);U8*v=(U8*)DATA(d);',(⎕ucs 10),' DOB(c,b[i]=1&(v[i/8]>>(7-(i%8))))R arr(c,b.data());}',(⎕ucs 10)
_,←'pkt*cpad(lp*l,CA&a){I t;B c=cnt(a),ar=rnk(a);pkt*p=NULL;',(⎕ucs 10),' if(ar>15)err(16,L"Dyalog APL does not support ranks > 15.");',(⎕ucs 10),' B s[15];DOB(ar,s[ar-i-1]=a.s[i]);',(⎕ucs 10)
_,←' std::visit(visitor{',(⎕ucs 10),'   [&](NIL _){if(l)l->p=NULL;},',(⎕ucs 10),'   [&](carr&v){',(⎕ucs 10),'    switch(v.type()){',(⎕ucs 10),'     CS(c64,t=APLZ);CS(s32,t=APLI);CS(s16,t=APLSI);'
_,←(⎕ucs 10),'     CS(b8,t=APLTI);CS(f64,t=APLD);',(⎕ucs 10),'     default:if(c)err(16);t=APLI;}',(⎕ucs 10),'    p=dwafns->ws->ga(t,(U)ar,s,l);if(c)v.host(DATA(p));},',(⎕ucs 10),'   [&](CVEC<A>&v){'
_,←(⎕ucs 10),'    p=dwafns->ws->ga(APLP,(U)ar,s,l);pkt**d=(pkt**)DATA(p);',(⎕ucs 10),'    DOB(c,if(!(d[i]=cpad(NULL,v[i])))err(6))}},',(⎕ucs 10),'  a.v);',(⎕ucs 10),'  R p;}',(⎕ucs 10)
_,←'V cpda(A&a,pkt*d){',(⎕ucs 10),' B c=cnt(d);a.s=SHP(RANK(d));DO(RANK(d),a.s[RANK(d)-i-1]=SHAPE(d)[i]);',(⎕ucs 10),' switch(TYPE(d)){',(⎕ucs 10),'  CS(15,',(⎕ucs 10),'   if(!c){a.v=scl(0);R;}'
_,←(⎕ucs 10),'   switch(ETYPE(d)){',(⎕ucs 10),'    CS(APLZ ,a.v=arr(c,(DZ*)DATA(d))) CS(APLI ,a.v=arr(c,(I*)DATA(d)))',(⎕ucs 10)
_,←'    CS(APLD ,a.v=arr(c,(D*)DATA(d)))  CS(APLSI,a.v=arr(c,(S16*)DATA(d)))',(⎕ucs 10),'    CS(APLTI,a.v=da16(c,d))           CS(APLU8,a.v=da8(c,d))',(⎕ucs 10),'    default:err(16);})',(⎕ucs 10)
_,←'  CS(7,{if(APLP!=ETYPE(d))err(16);',(⎕ucs 10),'   pkt**dv=(pkt**)DATA(d);',(⎕ucs 10),'   if(!c)c++;a.v=VEC<A>(c);',(⎕ucs 10),'   DOB(c,cpda(std::get<VEC<A>>(a.v)[i],dv[i]))})',(⎕ucs 10)
_,←'  default:err(16);}}',(⎕ucs 10),'V cpda(A&a,lp*d){if(d==NULL)R;cpda(a,d->p);}',(⎕ucs 10),'EXPORT A*mkarray(lp*d){A*z=new A;cpda(*z,d);R z;}',(⎕ucs 10),'EXPORT V frea(A*a){delete a;}',(⎕ucs 10)
_,←'EXPORT V exarray(lp*d,A*a){cpad(d,*a);}',(⎕ucs 10),'EXPORT V afsync(){sync();}',(⎕ucs 10),'EXPORT Window *w_new(char *k){R new Window(k);}',(⎕ucs 10),'EXPORT I w_close(Window*w){R w->close();}'
_,←(⎕ucs 10),'EXPORT V w_del(Window*w){delete w;}',(⎕ucs 10),'EXPORT V w_img(lp*d,Window*w){A a;cpda(a,d);',(⎕ucs 10),' std::visit(visitor{',(⎕ucs 10),'   [&](NIL&_){err(6);},',(⎕ucs 10)
_,←'   [&](VEC<A>&v){err(16,L"Image requires a flat array.");},',(⎕ucs 10),'   [&](carr&v){w->image(v.as(rnk(a)==2?f32:u8));}},',(⎕ucs 10),'  a.v);}',(⎕ucs 10)
_,←'EXPORT V w_plot(lp*d,Window*w){A a;cpda(a,d);',(⎕ucs 10),' std::visit(visitor{',(⎕ucs 10),'   [&](NIL&_){err(6);},',(⎕ucs 10),'   [&](VEC<A>&v){err(16,L"Plot requires a flat array.");},',(⎕ucs 10)
_,←'   [&](carr&v){w->plot(v.as(f32));}},',(⎕ucs 10),'  a.v);}',(⎕ucs 10),'EXPORT V w_hist(lp*d,D l,D h,Window*w){A a;cpda(a,d);',(⎕ucs 10),' std::visit(visitor{',(⎕ucs 10),'   [&](NIL&_){err(6);},'
_,←(⎕ucs 10),'   [&](VEC<A>&v){err(16,L"Hist requires a flat array.");},',(⎕ucs 10),'   [&](carr&v){w->hist(v.as(u32),l,h);}},',(⎕ucs 10),'  a.v);}',(⎕ucs 10)
_,←'EXPORT V loadimg(lp*z,char*p,I c){array a=loadImage(p,c);',(⎕ucs 10),' I rk=a.numdims();dim4 s=a.dims();',(⎕ucs 10),' A b(rk,flat(a).as(s16));DO(rk,b.s[i]=s[i])cpad(z,b);}',(⎕ucs 10)
_,←'EXPORT V saveimg(lp*im,char*p){A a;cpda(a,im);',(⎕ucs 10),' std::visit(visitor{',(⎕ucs 10),'   [&](NIL&_){err(6);},',(⎕ucs 10),'   [&](VEC<A>&v){err(16,L"Save requires a flat array.");},',(⎕ucs 10)
_,←'   [&](carr&v){saveImageNative(p,v.as(v.type()==s32?u16:u8));}},',(⎕ucs 10),'  a.v);}',(⎕ucs 10),'EXPORT V cd_sync(V){sync();}',(⎕ucs 10)
rth←_

_←⍬
_,←,⊂('NM(add,"add",1,1,DID,MFD,DFD,MT,DAD)',(⎕ucs 10),'DEFN(add)',(⎕ucs 10),'ID(add,0,s32)',(⎕ucs 10),'MF(add_f){z=r;}',(⎕ucs 10),'SF(add,z.v=lv+rv)',(⎕ucs 10))
_,←,⊂('NM(sub,"sub",1,1,DID,MFD,DFD,MT ,DAD)',(⎕ucs 10),'DEFN(sub)',(⎕ucs 10),'ID(sub,0,s32)',(⎕ucs 10),'SMF(sub,z.v=-rv)',(⎕ucs 10),'SF(sub,z.v=lv-rv)',(⎕ucs 10 10))
_,←,⊂('NM(mul,"mul",1,1,DID,MFD,DFD,MT ,DAD)',(⎕ucs 10),'DEFN(mul)',(⎕ucs 10),'ID(mul,1,s32)',(⎕ucs 10),'SMF(mul,z.v=(rv>0)-(rv<0))',(⎕ucs 10),'SF(mul,z.v=lv*rv)',(⎕ucs 10 10))
_,←,⊂('NM(div,"div",1,1,DID,MFD,DFD,MT,DAD)',(⎕ucs 10),'DEFN(div)',(⎕ucs 10),'ID(div,1,s32)',(⎕ucs 10),'SMF(div,z.v=1.0/rv.as(f64))',(⎕ucs 10),'SF(div,z.v=lv.as(f64)/rv.as(f64))',(⎕ucs 10))
_,←,⊂('NM(exp,"exp",1,1,DID,MFD,DFD,MT ,DAD)',(⎕ucs 10),'ID(exp,1,s32)',(⎕ucs 10),'DEFN(exp)',(⎕ucs 10),'SMF(exp,z.v=exp(rv.as(f64)))',(⎕ucs 10),'SF(exp,z.v=pow(lv.as(f64),rv.as(f64)))',(⎕ucs 10))
_,←,⊂('NM(log,"log",1,1,MT ,MFD,DFD,MT ,DAD)',(⎕ucs 10),'DEFN(log)',(⎕ucs 10),'SMF(log,z.v=log(rv.as(f64)))',(⎕ucs 10),'SF(log,z.v=log(rv.as(f64))/log(lv.as(f64)))',(⎕ucs 10 10))
_,←,⊂('NM(res,"res",1,1,DID,MFD,DFD,MT ,DAD)',(⎕ucs 10),'DEFN(res)',(⎕ucs 10),'ID(res,0,s32)',(⎕ucs 10),'SMF(res,z.v=abs(rv).as(rv.type()))',(⎕ucs 10),'SF(res,z.v=rv-lv*floor(rv.as(f64)/(lv+(0==lv))))',(⎕ucs 10 10))
_,←,⊂('NM(cir,"cir",1,1,MT,MFD,DFD,MT,DAD)',(⎕ucs 10),'DEFN(cir)',(⎕ucs 10),'SMF(cir,z.v=Pi*rv.as(f64))',(⎕ucs 10),'SF(cir,arr fv=rv.as(f64);B lr=rnk(l);',(⎕ucs 10),' if(!lr){I x=lv.as(s32).scalar<I>();if(abs(x)>10)err(16);',(⎕ucs 10),'  switch(x){CS(0,z.v=sqrt(1-fv*fv))CS(1,z.v=sin(fv))CS(2,z.v=cos(fv))',(⎕ucs 10),'   CS(3,z.v=tan(fv))CS(4,z.v=sqrt(1+fv*fv))CS(5,z.v=sinh(fv))',(⎕ucs 10),'   CS(6,z.v=cosh(fv))CS(7,z.v=tanh(fv))CS(8,z.v=sqrt(fv*fv-1))CS(9,z.v=fv)',(⎕ucs 10),'   CS(10,z.v=abs(fv))CS(-1,z.v=asin(fv))CS(-2,z.v=acos(fv))',(⎕ucs 10),'   CS(-3,z.v=atan(fv))CS(-4,z.v=(fv+1)*sqrt((fv-1)/(fv+1)))',(⎕ucs 10),'   CS(-5,z.v=asinh(fv))CS(-6,z.v=acosh(fv))CS(-7,z.v=atanh(fv))',(⎕ucs 10),'   CS(-8,z.v=-sqrt(fv*fv-1))CS(-9,z.v=fv)CS(-10,z.v=fv)}R;}',(⎕ucs 10),' if(anyTrue<I>(abs(lv)>10))err(16);B c=cnt(z);VEC<D> zv(c);',(⎕ucs 10),' VEC<I> a(c);lv.as(s32).host(a.data());VEC<D> b(c);fv.host(b.data());',(⎕ucs 10),' DOB(c,switch(a[i]){CS(0,zv[i]=sqrt(1-b[i]*b[i]))CS(1,zv[i]=sin(b[i]))',(⎕ucs 10),'  CS(2,zv[i]=cos(b[i]))CS(3,zv[i]=tan(b[i]))CS(4,zv[i]=sqrt(1+b[i]*b[i]))',(⎕ucs 10),'  CS(5,zv[i]=sinh(b[i]))CS(6,zv[i]=cosh(b[i]))CS(7,zv[i]=tanh(b[i]))',(⎕ucs 10),'  CS(8,zv[i]=sqrt(b[i]*b[i]-1))CS(9,zv[i]=b[i])CS(10,zv[i]=abs(b[i]))',(⎕ucs 10),'  CS(-1,zv[i]=asin(b[i]))CS(-2,zv[i]=acos(b[i]))CS(-3,zv[i]=atan(b[i]))',(⎕ucs 10),'  CS(-4,zv[i]=(b[i]==-1)?0:(b[i]+1)*sqrt((b[i]-1)/(b[i]+1)))',(⎕ucs 10),'  CS(-5,zv[i]=asinh(b[i]))CS(-6,zv[i]=acosh(b[i]))CS(-7,zv[i]=atanh(b[i]))',(⎕ucs 10),'  CS(-8,zv[i]=-sqrt(b[i]*b[i]-1))CS(-9,zv[i]=b[i])CS(-10,zv[i]=b[i])})',(⎕ucs 10),' z.v=arr(c,zv.data());)',(⎕ucs 10))
_,←,⊂('NM(min,"min",1,1,DID,MFD,DFD,MT ,DAD)',(⎕ucs 10),'DEFN(min)',(⎕ucs 10),'ID(min,DBL_MAX,f64)',(⎕ucs 10),'SMF(min,z.v=floor(rv).as(rv.type()))',(⎕ucs 10),'SF(min,z.v=min(lv,rv))',(⎕ucs 10 10))
_,←,⊂('NM(max,"max",1,1,DID,MFD,DFD,MT ,DAD)',(⎕ucs 10),'DEFN(max)',(⎕ucs 10),'ID(max,-DBL_MAX,f64)',(⎕ucs 10),'SMF(max,z.v=ceil(rv).as(rv.type()))',(⎕ucs 10),'SF(max,z.v=max(lv,rv))',(⎕ucs 10 10))
_,←,⊂('NM(fac,"fac",1,1,DID,MFD,DFD,MT ,DAD)',(⎕ucs 10),'DEFN(fac)',(⎕ucs 10),'ID(fac,1,s32)',(⎕ucs 10),'SMF(fac,z.v=factorial(rv.as(f64)))',(⎕ucs 10),'SF(fac,arr lvf=lv.as(f64);arr rvf=rv.as(f64);',(⎕ucs 10),' z.v=exp(lgamma(1+rvf)-(lgamma(1+lvf)+lgamma(1+rvf-lvf))))',(⎕ucs 10))
_,←,⊂('NM(lth,"lth",1,1,DID,MT ,DFD,MT ,DAD)',(⎕ucs 10),'DEFN(lth)',(⎕ucs 10),'ID(lth,0,s32)',(⎕ucs 10),'SF(lth,z.v=lv<rv)',(⎕ucs 10 10))
_,←,⊂('NM(lte,"lte",1,1,DID,MT ,DFD,MT ,DAD)',(⎕ucs 10),'DEFN(lte)',(⎕ucs 10),'ID(lte,1,s32)',(⎕ucs 10),'SF(lte,z.v=lv<=rv)',(⎕ucs 10 10))
_,←,⊂('NM(eql,"eql",1,1,DID,MT ,DFD,MT ,DAD)',(⎕ucs 10),'DEFN(eql)',(⎕ucs 10),'ID(eql,1,s32)',(⎕ucs 10),'SF(eql,z.v=lv==rv)',(⎕ucs 10))
_,←,⊂('NM(gte,"gte",1,1,DID,MT ,DFD,MT ,DAD)',(⎕ucs 10),'DEFN(gte)',(⎕ucs 10),'ID(gte,1,s32)',(⎕ucs 10),'SF(gte,z.v=lv>=rv)',(⎕ucs 10 10))
_,←,⊂('NM(gth,"gth",1,1,DID,MT ,DFD,MT ,DAD)',(⎕ucs 10),'DEFN(gth)',(⎕ucs 10),'ID(gth,0,s32)',(⎕ucs 10),'SF(gth,z.v=lv>rv)',(⎕ucs 10 10))
_,←,⊂('NM(neq,"neq",1,1,DID,MT ,DFD,MT ,DAD)',(⎕ucs 10),'DEFN(neq)',(⎕ucs 10),'ID(neq,0,s32)',(⎕ucs 10),'SF(neq,z.v=lv!=rv)',(⎕ucs 10 10))
_,←,⊂('NM(not,"not",1,0,MT ,MFD,DFD,MT ,MT )',(⎕ucs 10),'DEFN(not)',(⎕ucs 10),'SMF(not,z.v=!rv)',(⎕ucs 10),'DF(not_f){err(16);}',(⎕ucs 10 10))
_,←,⊂('NM(and,"and",1,1,DID,MT,DFD,MT,DAD)',(⎕ucs 10),'DEFN(and)',(⎕ucs 10),'ID(and,1,s32)',(⎕ucs 10),'SF(and,if(lv.isbool()&&rv.isbool())z.v=lv&&rv;',(⎕ucs 10),' else if(allTrue<I>(lv>=0&&lv<=1&&rv>0&&rv<=1))z.v=lv&&rv;',(⎕ucs 10),' else{A a(z.s,lv);A b(z.s,rv);',(⎕ucs 10),'  lor_c(a,a,b,e);arr&av=std::get<arr>(a.v);',(⎕ucs 10),'  z.v=lv.as(f64)*(rv/((!av)+av));})',(⎕ucs 10))
_,←,⊂('NM(lor,"lor",1,1,DID,MT ,DFD,MT ,DAD)',(⎕ucs 10),'DEFN(lor)',(⎕ucs 10),'ID(lor,0,s32)',(⎕ucs 10),'SF(lor,if(rv.isbool()&&lv.isbool())z.v=lv||rv;',(⎕ucs 10),' else if(lv.isbool()&&rv.isinteger())z.v=lv+(!lv)*abs(rv).as(rv.type());',(⎕ucs 10),' else if(rv.isbool()&&lv.isinteger())z.v=rv+(!rv)*abs(lv).as(lv.type());',(⎕ucs 10),' else if(lv.isinteger()&&rv.isinteger()){B c=cnt(z);',(⎕ucs 10),'  VEC<I> a(c);abs(lv).as(s32).host(a.data());',(⎕ucs 10),'  VEC<I> b(c);abs(rv).as(s32).host(b.data());',(⎕ucs 10),'  DOB(c,while(b[i]){I t=b[i];b[i]=a[i]%b[i];a[i]=t;})',(⎕ucs 10),'  z.v=arr(c,a.data());}',(⎕ucs 10),' else{B c=cnt(z);',(⎕ucs 10),'  VEC<D> a(c);abs(lv).as(f64).host(a.data());',(⎕ucs 10),'  VEC<D> b(c);abs(rv).as(f64).host(b.data());',(⎕ucs 10),'  DOB(c,while(b[i]>1e-12){D t=b[i];b[i]=fmod(a[i],b[i]);a[i]=t;})',(⎕ucs 10),'  z.v=arr(c,a.data());})',(⎕ucs 10 10))
_,←,⊂('NM(nan,"nan",1,1,MT ,MT ,DFD,MT ,DAD)',(⎕ucs 10),'DEFN(nan)',(⎕ucs 10),'SF(nan,z.v=!(lv&&rv))',(⎕ucs 10 10))
_,←,⊂('NM(nor,"nor",1,1,MT ,MT ,DFD,MT ,DAD)',(⎕ucs 10),'DEFN(nor)',(⎕ucs 10),'SF(nor,z.v=!(lv||rv))',(⎕ucs 10))
_,←,⊂('NM(sqd,"sqd",0,0,MT ,MFD,DFD,MT ,DAD)',(⎕ucs 10),'DEFN(sqd)',(⎕ucs 10),'MF(sqd_f){z=r;}',(⎕ucs 10),'DA(sqd_f){if(rnk(ax)>1)err(4);if(!isint(ax))err(11);',(⎕ucs 10),' B ac=cnt(ax);VEC<I> av(ac);',(⎕ucs 10),' if(ac)CVSWITCH(ax.v,err(6),v.as(s32).host(av.data()),err(11))',(⎕ucs 10),' B rr=rnk(r);DOB(ac,if(av[i]<0)err(11))DOB(ac,if(av[i]>=rr)err(4))',(⎕ucs 10),' B lc=cnt(l);if(rnk(l)>1)err(4);if(lc!=ac)err(5);if(!lc){z=r;R;}',(⎕ucs 10),' VEC<U8> m(rr);DOB(ac,if(m[av[i]])err(11);m[av[i]]=1)if(!isint(l))err(11);',(⎕ucs 10),' VEC<I> lv(lc);CVSWITCH(l.v,err(6),v.as(s32).host(lv.data()),err(16))',(⎕ucs 10),' DOB(lc,if(lv[i]<0||lv[i]>=r.s[rr-av[i]-1])err(3))',(⎕ucs 10),' z.s=SHP(rr-lc);I j=0;DOB(rr,if(!m[rr-i-1])z.s[j++]=r.s[i])',(⎕ucs 10),' CVSWITCH(r.v,err(6)',(⎕ucs 10),'  ,if(rr<5){IDX x[4];DOB(lc,x[rr-av[i]-1]=lv[i]);',(⎕ucs 10),'    dim4 rs(1);DO((I)rr,rs[i]=r.s[i])',(⎕ucs 10),'    z.v=flat(moddims(v,rs)(x[0],x[1],x[2],x[3]));R;}',(⎕ucs 10),'   VEC<seq> x(rr);arr ix=scl(0);',(⎕ucs 10),'   DOB(rr,x[i]=seq((D)r.s[i]))DOB(lc,x[rr-av[i]-1]=seq(lv[i],lv[i]))',(⎕ucs 10),'   DOB(rr,B j=rr-i-1;ix=moddims(ix*r.s[j],1,(U)cnt(ix));',(⎕ucs 10),'    ix=flat(tile(ix,(U)x[j].size,1)+tile(x[j],1,(U)cnt(ix))))',(⎕ucs 10),'   z.v=v(ix)',(⎕ucs 10),'  ,err(16))}',(⎕ucs 10),'DF(sqd_f){A ax;iot_c(ax,scl(scl((I)cnt(l))),e);sqd_c(z,l,r,e,ax);}',(⎕ucs 10))
_,←,⊂('NM(brk,"brk",0,0,MT,MT,DFD,MT,MT)',(⎕ucs 10),'DEFN(brk)',(⎕ucs 10),'DF(brk_f){B lr=rnk(l);B rc=cnt(r);',(⎕ucs 10),' if(!rc){if(lr!=1)err(4);z=l;R;}if(rc!=lr)err(4);',(⎕ucs 10),' CVSWITCH(r.v,err(6),err(99,L"Unexpected bracket index set"),)',(⎕ucs 10),' VEC<B> rm(rc);CVEC<A>&rv=std::get<VEC<A>>(r.v);',(⎕ucs 10),' DOB(rc,CVSWITCH(rv[i].v,rm[i]=1,rm[i]=rnk(rv[i]),err(11)))',(⎕ucs 10),' B zr=0;DOB(rc,zr+=rm[i])z.s=SHP(zr);B s=zr;',(⎕ucs 10),' DOB(rc,B j=i;s-=rm[j];',(⎕ucs 10),'  DOB(rm[j],B&x=z.s[s+i];',(⎕ucs 10),'   CVSWITCH(rv[j].v,x=l.s[rc-j-1],x=rv[j].s[i],err(99))))',(⎕ucs 10),' CVSWITCH(l.v,err(6)',(⎕ucs 10),'  ,if(zr<=4){IDX x[4];',(⎕ucs 10),'    DOB(rc,CVSWITCH(rv[i].v,,x[rc-i-1]=v.as(s32),err(99)))',(⎕ucs 10),'    dim4 sp(1);DO((I)lr,sp[i]=l.s[i])',(⎕ucs 10),'    z.v=flat(moddims(v,sp)(x[0],x[1],x[2],x[3]));}',(⎕ucs 10),'   else err(16);',(⎕ucs 10),'  ,if(lr!=1)err(16);if(rc!=1)err(16);',(⎕ucs 10),'   VEC<A> zv(1);I i=std::get<arr>(rv[0].v).as(s32).scalar<I>();\',(⎕ucs 10),'   CVEC<A> lv=std::get<VEC<A>>(l.v);',(⎕ucs 10),'   zv[0]=lv[i];z.v=zv;)}',(⎕ucs 10 10),'OD(brk,"brk",scm(l),scd(l),MFD,DFD,MT ,MT )',(⎕ucs 10),'MF(brk_o){if(rnk(ww)>1)err(4);ll(z,r,e,ww);}',(⎕ucs 10),'DF(brk_o){if(rnk(ww)>1)err(4);ll(z,l,r,e,ww);}',(⎕ucs 10 10))
_,←,⊂('NM(iot,"iot",0,0,MT ,MFD,DFD,MT ,MT )',(⎕ucs 10),'DEFN(iot)',(⎕ucs 10),'MF(iot_f){if(rnk(r)>1)err(4);B c=cnt(r);if(c>4)err(10);if(c>1)err(16);',(⎕ucs 10),' CVSWITCH(r.v,err(6)',(⎕ucs 10),'  ,I rv=v.as(s32).scalar<I>();',(⎕ucs 10),'   z.s=SHP(1,rv);z.v=z.s[0]?iota(dim4(rv),dim4(1),s32):scl(0);',(⎕ucs 10),'  ,err(11))}',(⎕ucs 10),'DF(iot_f){z.s=r.s;B c=cnt(r);if(!c){z.v=scl(0);R;}',(⎕ucs 10),' I lc=(I)cnt(l)+1;if(lc==1){z.v=constant(0,cnt(r),s16);R;};if(rnk(l)>1)err(16);',(⎕ucs 10),' std::visit(visitor{DVSTR(),',(⎕ucs 10),'   [&](carr&olv,carr&orv){arr lv=olv,rv=orv,ix;sort(lv,ix,lv);',(⎕ucs 10),'    z.v=constant(0,cnt(r),s32);arr&zv=std::get<arr>(z.v);',(⎕ucs 10),'    for(I h;h=lc/2;lc-=h){arr t=zv+h;replace(zv,lv(t)>rv,t);}',(⎕ucs 10),'    zv=arr(select(lv(zv)==rv,ix(zv).as(s32),(I)cnt(l)),c);},',(⎕ucs 10),'   [&](CVEC<A>&lv,carr&rv){err(16);},',(⎕ucs 10),'   [&](carr&lv,CVEC<A>&rv){err(16);},',(⎕ucs 10),'   [&](CVEC<A>&lv,CVEC<A>&rv){err(16);}},',(⎕ucs 10),'  l.v,r.v);}',(⎕ucs 10))
_,←,⊂('NM(rho,"rho",0,0,MT ,MFD,DFD,MT ,MT )',(⎕ucs 10),'DEFN(rho)',(⎕ucs 10),'MF(rho_f){B rr=rnk(r);VEC<I> sp(rr);DOB(rr,sp[rr-i-1]=(I)r.s[i])',(⎕ucs 10),' z.s=SHP(1,rr);if(!cnt(z)){z.v=scl(0);R;}z.v=arr(rr,sp.data());}',(⎕ucs 10),'DF(rho_f){B cr=cnt(r),cl=cnt(l);VEC<I> s(cl);',(⎕ucs 10),' if(rnk(l)>1)err(11);if(!isint(l))err(11);',(⎕ucs 10),' CVSWITCH(l.v,err(6),if(cl)v.as(s32).host(s.data()),if(cl)err(16))',(⎕ucs 10),' DOB(cl,if(s[i]<0)err(11))z.s=SHP(cl);DOB(cl,z.s[i]=(B)s[cl-i-1])',(⎕ucs 10),' B cz=cnt(z);',(⎕ucs 10),' if(!cz){CVSWITCH(r.v,err(6),z.v=proto(v(0)),z.v=VEC<A>(1,proto(v[0])))R;}',(⎕ucs 10),' if(cz==cr){z.v=r.v;R;}',(⎕ucs 10),' CVSWITCH(r.v,err(6),z.v=v(iota(cz)%cr),',(⎕ucs 10),'  z.v=VEC<A>(cz);VEC<A>&zv=std::get<VEC<A>>(z.v);DOB(cz,zv[i]=v[i%cr]))}',(⎕ucs 10))
_,←,⊂('NM(cat,"cat",0,0,MT ,MFD,DFD,MAD,DAD)',(⎕ucs 10),'DEFN(cat)',(⎕ucs 10),'MF(cat_f){z.s=SHP(1,cnt(r));z.v=r.v;}',(⎕ucs 10),'MA(cat_f){B ac=cnt(ax),ar=rnk(ax),rr=rnk(r);if(ac>1&&ar>1)err(4);',(⎕ucs 10),' VEC<D> axv(ac);if(ac)CVSWITCH(ax.v,err(6),v.as(f64).host(axv.data()),err(11))',(⎕ucs 10),' if(ac==1&&(axv[0]<=-1||rr<=axv[0]))err(4);',(⎕ucs 10),' if(ac>1){I c=(I)axv[0];if(c<0)err(11);DO((I)ac,if(axv[i]!=c++)err(11))',(⎕ucs 10),'  if(c>rr)err(4);}',(⎕ucs 10),' I xt=(!ac||(ac==1&&!isint(axv[0])));if(rr==4&&xt)err(16);',(⎕ucs 10),' z=r;B zr=rr;if(!xt&&ac==1)R;DO((I)ac,axv[i]=ceil(rr-axv[i]-1))',(⎕ucs 10),' if(xt){zr++;SHP sp(zr);DOB(rr,sp[i]=r.s[i])B pt=ac?(B)axv[0]:0;',(⎕ucs 10),'  DOB(rr-pt,sp[zr-i-1]=sp[zr-i-2])sp[pt]=1;z.s=sp;R;}',(⎕ucs 10),' B s=(B)axv[ac-1],ei=(B)axv[0];',(⎕ucs 10),' zr=rr-ac+1;z.s=SHP(zr,1);DOB(s,z.s[i]=r.s[i])',(⎕ucs 10),' DOB(ac,z.s[s]*=r.s[s+i])DOB(rr-ei-1,z.s[s+i+1]=r.s[ei+i+1])}',(⎕ucs 10),'DA(cat_f){B ar=rnk(ax),lr=rnk(l),rr=rnk(r);',(⎕ucs 10),' if(lr>4||rr>4)err(16);',(⎕ucs 10),' if(ar>1)err(4);if(cnt(ax)!=1)err(5);',(⎕ucs 10),' D ox;CVSWITCH(ax.v,err(6),ox=v.as(f64).scalar<D>(),err(11))',(⎕ucs 10),' B rk=lr>rr?lr:rr;if(ox<=-1)err(11);if(ox>=rk)err(4);',(⎕ucs 10),' if(lr&&rr&&std::abs((I)lr-rr)>1)err(4);',(⎕ucs 10),' A nl=l,nr=r;D axv=rk-ox-1;I fx=(I)ceil(axv);',(⎕ucs 10),' if(axv!=fx){if(rr>3||lr>3)err(16);if(rr&&lr&&lr!=rr)err(4);',(⎕ucs 10),'  if(lr)cat_c(nl,l,e,ax);if(rr)cat_c(nr,r,e,ax);',(⎕ucs 10),'  if(!lr&&!rr)cat_c(nl,l,e,ax);cat_c(nr,r,e,ax);',(⎕ucs 10),'  cat_c(z,nl,nr,e,scl(scl((I)ceil(ox))));R;}',(⎕ucs 10),' z.s=SHP((lr>=rr)*lr+(rr>lr)*rr+(!rr&&!lr));',(⎕ucs 10),' dim4 ls(1),rs(1);DO((I)lr,ls[i]=l.s[i])DO((I)rr,rs[i]=r.s[i])',(⎕ucs 10),' if(!lr){ls=rs;ls[fx]=1;}if(!rr){rs=ls;rs[fx]=1;}',(⎕ucs 10),' if(rr&&lr>rr){DO(3-fx,rs[3-i]=rs[3-i-1]);rs[fx]=1;}',(⎕ucs 10),' if(lr&&rr>lr){DO(3-fx,ls[3-i]=ls[3-i-1]);ls[fx]=1;}',(⎕ucs 10),' DO(4,if(i!=fx&&rs[i]!=ls[i])err(5));',(⎕ucs 10),' DO((I)rnk(z),z.s[i]=(lr>=rr||i==fx)*ls[i]+(rr>lr||i==fx)*rs[i]);',(⎕ucs 10),' std::visit(visitor{DVSTR(),',(⎕ucs 10),'   [&](CVEC<A>&lv,carr&rv){err(16);},',(⎕ucs 10),'   [&](carr&lv,CVEC<A>&rv){err(16);},',(⎕ucs 10),'   [&](CVEC<A>&lv,CVEC<A>&rv){if(rr>1||lr>1)err(16);B lc=cnt(l),rc=cnt(r);',(⎕ucs 10),'    z.v=VEC<A>(lc+rc,A());VEC<A>&zv=std::get<VEC<A>>(z.v);',(⎕ucs 10),'    DOB(lc,zv[i]=lv[i])DOB(rc,zv[i+lc]=rv[i])},',(⎕ucs 10),'   [&](carr&olv,carr&orv){dtype mt=mxt(orv,olv);',(⎕ucs 10),'    array lv=(lr?moddims(olv,ls):tile(olv,ls)).as(mt);',(⎕ucs 10),'    array rv=(rr?moddims(orv,rs):tile(orv,rs)).as(mt);',(⎕ucs 10),'    if(!cnt(l)){z.v=flat(rv);R;}if(!cnt(r)){z.v=flat(lv);R;}',(⎕ucs 10),'    z.v=flat(join(fx,lv,rv));}},',(⎕ucs 10),'  l.v,r.v);}',(⎕ucs 10),'DF(cat_f){B lr=rnk(l),rr=rnk(r);',(⎕ucs 10),' if(lr||rr){cat_c(z,l,r,e,scl(scl((lr>rr?lr:rr)-1)));R;}',(⎕ucs 10),' A a,b;cat_c(a,l,e);cat_c(b,r,e);cat_c(z,a,b,e);}',(⎕ucs 10))
_,←,⊂('NM(ctf,"ctf",0,0,MT,MFD,DFD,MT,DAD)',(⎕ucs 10),'DEFN(ctf)',(⎕ucs 10),'MF(ctf_f){B rr=rnk(r);z.s=SHP(2,1);z.v=r.v;',(⎕ucs 10),' if(rr)z.s[1]=r.s[rr-1];if(z.s[1])z.s[0]=cnt(r)/z.s[1];}',(⎕ucs 10),'DA(ctf_f){cat_c(z,l,r,e,ax);}',(⎕ucs 10),'DF(ctf_f){if(rnk(l)||rnk(r)){cat_c(z,l,r,e,scl(scl(0)));R;}',(⎕ucs 10),' A a,b;cat_c(a,l,e);cat_c(b,r,e);cat_c(z,a,b,e);}',(⎕ucs 10))
_,←,⊂('NM(rot,"rot",0,0,DID,MFD,DFD,MAD,DAD)',(⎕ucs 10),'DEFN(rot)',(⎕ucs 10),'ID(rot,0,s32)',(⎕ucs 10),'MF(rot_f){if(!rnk(r)){z=r;R;}rot_c(z,r,e,scl(scl(rnk(r)-1)));}',(⎕ucs 10),'MA(rot_f){if(1!=cnt(ax))err(5);if(!isint(ax))err(11);',(⎕ucs 10),' I axv;CVSWITCH(ax.v,err(6),axv=v.as(s32).scalar<I>(),err(11))',(⎕ucs 10),' B rr=rnk(r);if(axv<0||rr<=axv)err(4);z.s=r.s;if(!cnt(r)){z.v=r.v;R;}',(⎕ucs 10),' CVSWITCH(r.v,err(6)',(⎕ucs 10),'  ,z.v=flat(flip(axis(v,r.s,rr-axv-1),1))',(⎕ucs 10),'  ,err(16))}',(⎕ucs 10),'DA(rot_f){B rr=rnk(r),lr=rnk(l);if(rr>4)err(16);',(⎕ucs 10),' if(rnk(ax)>1||cnt(ax)!=1)err(5);if(!isint(ax))err(11);',(⎕ucs 10),' I ra;CVSWITCH(ax.v,err(6),ra=v.as(s32).scalar<I>(),err(11))',(⎕ucs 10),' if(ra<0)err(11);if(ra>=rr)err(4);B lc=cnt(l);I aa=ra;ra=(I)rr-ra-1;',(⎕ucs 10),' if(lc!=1&&lr!=rr-1)err(4);',(⎕ucs 10),' if(lc==1){z.s=r.s;I ix[]={0,0,0,0};',(⎕ucs 10),'  CVSWITCH(l.v,err(6),ix[ra]=-v.as(s32).scalar<I>(),err(11))',(⎕ucs 10),'  CVSWITCH(r.v,err(6)',(⎕ucs 10),'   ,z.v=flat(shift(unrav(v,r.s),ix[0],ix[1],ix[2],ix[3]))',(⎕ucs 10),'   ,err(16))',(⎕ucs 10),'  R;}',(⎕ucs 10),' I j=0;DOB(lr,if(i==ra)j++;if(l.s[i]!=r.s[j++])err(5))',(⎕ucs 10),' res_c(z,scl(scl(r.s[ra])),l,e);arr&zv=std::get<arr>(z.v);',(⎕ucs 10),' B tc=1;DO(ra,tc*=r.s[i])zv*=tc;cat_c(z,z,e,scl(scl(aa-.5)));',(⎕ucs 10),' zv=flat(tile(axis(zv,z.s,ra),1,(U)r.s[ra],1));z.s[ra]=r.s[ra];',(⎕ucs 10),' dim4 s1(1);dim4 s2(1);',(⎕ucs 10),' DO(ra+1,s1[i]=r.s[i])DO((I)rr-ra-1,s2[ra+i+1]=r.s[ra+i+1])',(⎕ucs 10),' zv+=flat(iota(s1,s2));zv=zv%(tc*r.s[ra]);',(⎕ucs 10),' arr rv;CVSWITCH(r.v,err(6),rv=v,err(16))',(⎕ucs 10),' zv=flat(rv(zv+(tc*r.s[ra])*flat(iota(s2,s1))));}',(⎕ucs 10),'DF(rot_f){B rr=rnk(r),lr=rnk(l);if(!rr){B lc=cnt(l);if(lc!=1&&lr)err(4);z=r;R;}',(⎕ucs 10),' rot_c(z,l,r,e,scl(scl(rr-1)));}',(⎕ucs 10))
_,←,⊂('NM(trn,"trn",0,0,MT ,MFD,DFD,MT ,MT )',(⎕ucs 10),'DEFN(trn)',(⎕ucs 10),'MF(trn_f){B rr=rnk(r);if(rr<=1){z=r;R;}',(⎕ucs 10),' A t(SHP(1,rr),seq((D)rr-1,0,-1));trn_c(z,t,r,e);}',(⎕ucs 10),'DF(trn_f){B lr=rnk(l),rr=rnk(r);if(lr>1||cnt(l)!=rr)err(5);if(rr<=1){z=r;R;}',(⎕ucs 10),' VEC<I> lv(rr);if(!isint(l))err(11);',(⎕ucs 10),' CVSWITCH(l.v,err(6),v.as(s32).host(lv.data()),err(11))',(⎕ucs 10),' DOB(rr,if(lv[i]<0||lv[i]>=rr)err(4))VEC<U8> f(rr,0);DOB(rr,f[lv[i]]=1)',(⎕ucs 10),' U8 t=1;DOB(rr,if(t&&!f[i])t=0;else if(!t&&f[i])err(5))',(⎕ucs 10),' if(t&&rr<=4){z.s=SHP(rr);DOB(rr,z.s[rr-lv[i]-1]=r.s[rr-i-1])',(⎕ucs 10),'  switch(rr){case 0:case 1:z.v=r.v;R;}',(⎕ucs 10),'  VEC<I> s(rr);DOB(rr,s[rr-lv[i]-1]=(I)(rr-i-1))',(⎕ucs 10),'  arr rv;CVSWITCH(r.v,err(6),rv=unrav(v,r.s),err(16))',(⎕ucs 10),'  switch(rr){CS(2,z.v=flat(reorder(rv,s[0],s[1])))',(⎕ucs 10),'   CS(3,z.v=flat(reorder(rv,s[0],s[1],s[2])))',(⎕ucs 10),'   CS(4,z.v=flat(reorder(rv,s[0],s[1],s[2],s[3])))}}',(⎕ucs 10),' else{B rk=0;DOB(rr,if(rk<lv[i])rk=lv[i])rk++;z.s=SHP(rk,LLONG_MAX);',(⎕ucs 10),'  DOB(rr,B j=rk-lv[i]-1;B k=rr-i-1;if(z.s[j]>r.s[k])z.s[j]=r.s[k])',(⎕ucs 10),'  SHP zs(rk),rs(rr);',(⎕ucs 10),'  B c=1;DOB(rk,zs[i]=c;c*=z.s[i])c=1;DOB(rr,rs[i]=c;c*=r.s[i])c=cnt(z);',(⎕ucs 10),'  arr ix=iota(dim4(c),dim4(1),s32),jx=constant(0,dim4(c),s32);',(⎕ucs 10),'  DOB(rr,B j=rk-lv[i]-1;B k=rr-i-1;jx+=rs[k]*((ix/zs[j])%z.s[j]))',(⎕ucs 10),'  CVSWITCH(r.v,err(6),z.v=v(jx),err(16))}}',(⎕ucs 10))
_,←,⊂('NM(rtf,"rtf",0,0,DID,MFD,DFD,MAD,DAD)',(⎕ucs 10),'DEFN(rtf)',(⎕ucs 10),'ID(rtf,0,s32)',(⎕ucs 10),'MF(rtf_f){if(!rnk(r)){z=r;R;}rot_c(z,r,e,scl(scl(0)));}',(⎕ucs 10),'MA(rtf_f){rot_c(z,r,e,ax);}',(⎕ucs 10),'DA(rtf_f){rot_c(z,l,r,e,ax);}',(⎕ucs 10),'DF(rtf_f){if(!rnk(r)){B lc=cnt(l);if(lc!=1&&rnk(l))err(4);z=r;R;}',(⎕ucs 10),' rot_c(z,l,r,e,scl(scl(0)));}',(⎕ucs 10))
_,←,⊂('NM(mem,"mem",0,0,MT ,MFD,DFD,MT ,MT )',(⎕ucs 10),'DEFN(mem)',(⎕ucs 10),'MF(mem_f){z.s=SHP(1,cnt(r));z.v=r.v;}',(⎕ucs 10),'DF(mem_f){z.s=l.s;B lc=cnt(z);if(!lc){z.v=scl(0);R;}',(⎕ucs 10),' if(!cnt(r)){arr zv(lc,b8);zv=0;z.v=zv;R;}',(⎕ucs 10),' arr y;CVSWITCH(r.v,err(6),y=setUnique(v),err(16))',(⎕ucs 10),' B rc=y.elements();',(⎕ucs 10),' arr x;CVSWITCH(l.v,err(6),x=arr(v,lc,1),err(16))',(⎕ucs 10),' y=arr(y,1,rc);',(⎕ucs 10),' z.v=arr(anyTrue(tile(x,1,(I)rc)==tile(y,(I)lc,1),1),lc);}',(⎕ucs 10 10))
_,←,⊂('NM(dis,"dis",0,0,MT,MFD,DFD,MT,MT)',(⎕ucs 10),'DEFN(dis)',(⎕ucs 10),'MF(dis_f){CVSWITCH(r.v,err(6),z.s=eshp;z.v=v(0),z=v[0])}',(⎕ucs 10),'DF(dis_f){if(!isint(l))err(11);if(rnk(l)>1)err(4);',(⎕ucs 10),' B lc=cnt(l);if(!lc){z=r;R;}if(lc!=1||rnk(r)!=1)err(16);',(⎕ucs 10),' I i;CVSWITCH(l.v,err(6),i=v.as(s32).scalar<I>(),err(16))',(⎕ucs 10),' if(i<0||i>=cnt(r))err(3);',(⎕ucs 10),' CVSWITCH(r.v,err(6),z.s=eshp;z.v=v(i),z=v[i])}',(⎕ucs 10))
_,←,⊂('NM(eqv,"eqv",0,0,MT ,MFD,DFD,MT ,MT )',(⎕ucs 10),'DEFN(eqv)',(⎕ucs 10),'MF(eqv_f){z.s=eshp;z.v=scl(rnk(r)!=0);}',(⎕ucs 10),'I is_eqv(CA&l,CA&r){B lr=rnk(l),rr=rnk(r);if(lr!=rr)R 0;',(⎕ucs 10),' DOB(lr,if(l.s[i]!=r.s[i])R 0)',(⎕ucs 10),' I res=1;',(⎕ucs 10),' std::visit(visitor{DVSTR(),',(⎕ucs 10),'   [&](carr&lv,carr&rv){res=allTrue<I>(lv==rv);},',(⎕ucs 10),'   [&](CVEC<A>&lv,carr&rv){res=0;},',(⎕ucs 10),'   [&](carr&lv,CVEC<A>&rv){res=0;},',(⎕ucs 10),'   [&](CVEC<A>&lv,CVEC<A>&rv){B c=cnt(l);',(⎕ucs 10),'    DOB(c,if(!is_eqv(lv[i],rv[i])){res=0;R;})}},',(⎕ucs 10),'  l.v,r.v);',(⎕ucs 10),' R res;}',(⎕ucs 10),'DF(eqv_f){z.s=eshp;z.v=scl(is_eqv(l,r));}',(⎕ucs 10))
_,←,⊂('NM(nqv,"nqv",0,0,MT ,MFD,DFD,MT ,MT )',(⎕ucs 10),'DEFN(nqv)',(⎕ucs 10),'MF(nqv_f){B rr=rnk(r);z.v=scl(rr?(I)r.s[rr-1]:1);z.s=eshp;}',(⎕ucs 10),'DF(nqv_f){z.s=eshp;z.v=scl(!is_eqv(l,r));}',(⎕ucs 10))
_,←,⊂('NM(rgt,"rgt",0,0,MT ,MFD,DFD,MT ,MT )',(⎕ucs 10),'DEFN(rgt)',(⎕ucs 10),'MF(rgt_f){z=r;}',(⎕ucs 10),'DF(rgt_f){z=r;}',(⎕ucs 10 10))
_,←,⊂('NM(lft,"lft",0,0,MT ,MFD,DFD,MT ,MT )',(⎕ucs 10),'DEFN(lft)',(⎕ucs 10),'MF(lft_f){z=r;}',(⎕ucs 10),'DF(lft_f){z=l;}',(⎕ucs 10 10))
_,←,⊂('NM(enc,"enc",0,0,DID,MT ,DFD,MT ,MT )',(⎕ucs 10),'DEFN(enc)',(⎕ucs 10),'ID(enc,0,s32)',(⎕ucs 10),'DF(enc_f){B rr=rnk(r),lr=rnk(l),rk=rr+lr;if(rk>4)err(16);',(⎕ucs 10),' SHP sp(rk);DOB(rr,sp[i]=r.s[i])DOB(lr,sp[i+rr]=l.s[i])',(⎕ucs 10),' if(!cnt(sp)){z.s=sp;z.v=scl(0);R;}',(⎕ucs 10),' dim4 lt(1),rt(1);DO((I)rk,lt[i]=rt[i]=sp[i])I k=lr?(I)lr-1:0;',(⎕ucs 10),' DO((I)rr,rt[i]=1)DO((I)lr,lt[i+(I)rr]=1)',(⎕ucs 10),' arr rv;CVSWITCH(r.v,err(6),rv=v,err(11))',(⎕ucs 10),' arr lv;CVSWITCH(l.v,err(6),lv=v,err(11))',(⎕ucs 10),' rv=tile(unrav(rv,r.s),rt);z.s=sp;',(⎕ucs 10),' arr dv=flip(scan(flip(unrav(lv.as(s64),l.s),k),k,AF_BINARY_MUL),k);',(⎕ucs 10),' lv=tile(arr(dv,rt),lt);IDX x[4];x[k]=0;',(⎕ucs 10),' dv(x[0],x[1],x[2],x[3])=1;I s[]={0,0,0,0};s[k]=-1;',(⎕ucs 10),' dv=shift(dv,s[0],s[1],s[2],s[3]);dv=tile(arr(dv,rt),lt);',(⎕ucs 10),' arr ix=where(lv);z.v=arr();arr&zv=std::get<arr>(z.v);',(⎕ucs 10),' zv=rv.as(s32);',(⎕ucs 10),' zv=(rv-lv*floor(rv.as(f64)/(lv+(lv==0)))).as(s32);',(⎕ucs 10),' ix=where(dv);zv*=dv!=0;zv(ix)=floor(zv(ix).as(f64)/dv(ix)).as(s32);',(⎕ucs 10),' zv=flat(zv);}',(⎕ucs 10))
_,←,⊂('NM(dec,"dec",0,0,MT,MT,DFD,MT,MT)',(⎕ucs 10),'DEFN(dec)',(⎕ucs 10),'DF(dec_f){B rr=rnk(r),lr=rnk(l),ra=rr?rr-1:0,la=lr?lr-1:0;z.s=SHP(ra+la);',(⎕ucs 10),' if(rr&&lr)if(l.s[0]!=1&&l.s[0]!=r.s[ra]&&r.s[ra]!=1)err(5);',(⎕ucs 10),' DOB(ra,z.s[i]=r.s[i])DOB(la,z.s[i+ra]=l.s[i+1])',(⎕ucs 10),' if(!cnt(z)){z.v=scl(0);R;}',(⎕ucs 10),' if(!cnt(r)||!cnt(l)){z.v=constant(0,cnt(z),s32);R;}',(⎕ucs 10),' B lc=lr?l.s[0]:1;',(⎕ucs 10),' arr rv;CVSWITCH(r.v,err(6),rv=v,err(11))',(⎕ucs 10),' arr lv;CVSWITCH(l.v,err(6),lv=v,err(11))',(⎕ucs 10),' arr x=unrav(lv,l.s);if(lc==1){lc=r.s[ra];x=tile(x,(I)lc);}',(⎕ucs 10),' x=flip(scan(x,0,AF_BINARY_MUL,false),0);',(⎕ucs 10),' x=arr(x,lc,x.elements()/lc).as(f64);',(⎕ucs 10),' arr y=arr(rv,cnt(r)/r.s[ra],r.s[ra]).as(f64);',(⎕ucs 10),' z.v=flat(matmul(r.s[ra]==1?tile(y,1,(I)lc):y,x));}',(⎕ucs 10))
_,←,⊂('NM(red,"red",0,0,DID,MT ,DFD,MT ,DAD)',(⎕ucs 10),'ID(red,1,s32)',(⎕ucs 10),'DEFN(red)',(⎕ucs 10),'OM(red,"red",0,0,MFD,DFD,MAD,DAD)',(⎕ucs 10),'DA(red_f){B ar=rnk(ax),lr=rnk(l),rr=rnk(r),zr;if(lr>4||rr>4)err(16);',(⎕ucs 10),' if(ar>1||cnt(ax)!=1)err(5);if(!isint(ax))err(11);',(⎕ucs 10),' I axv;CVSWITCH(ax.v,err(6),axv=v.as(s32).scalar<I>(),err(11))',(⎕ucs 10),' if(axv<0)err(11);if(axv>=rr)err(4);',(⎕ucs 10),' dim4 zs(1),ls(1),rs(1);DO((I)lr,ls[i]=l.s[i])DO((I)rr,rs[i]=r.s[i])',(⎕ucs 10),' if(lr>1)err(4);axv=(I)rr-axv-1;B lc=cnt(l),rsx=rs[axv];',(⎕ucs 10),' if(lr!=0&&lc!=1&&rr!=0&&rsx!=1&&lc!=rsx)err(5);',(⎕ucs 10),' arr lv;CVSWITCH(l.v,err(6),lv=moddims(v,ls),err(11))',(⎕ucs 10),' arr x=lc==1?tile(lv,(I)rsx):lv;B zc=sum<B>(abs(x));',(⎕ucs 10),' zr=rr?rr:1;zs=rs;zs[axv]=zc;z.s=SHP(zr);DO((I)zr,z.s[i]=zs[i])',(⎕ucs 10),' if(!cnt(z)){z.v=scl(0);R;}arr w=where(x).as(s32);',(⎕ucs 10),' CVSWITCH(r.v,err(6)',(⎕ucs 10),'  ,arr rv=moddims(v,rs);arr y=rsx==1?tile(rv,(I)lc):rv;IDX ix[4];',(⎕ucs 10),'   z.v=arr();arr&zv=std::get<arr>(z.v);',(⎕ucs 10),'   if(zc==w.elements()){ix[axv]=w;zv=y(ix[0],ix[1],ix[2],ix[3]);',(⎕ucs 10),'    if(zc==sum<B>(x(w)))R;dim4 sp(zs);sp[axv]=1;',(⎕ucs 10),'    zv*=tile(x(w)>0,(I)sp[0],(I)sp[1],(I)sp[2],(I)sp[3]);zv=flat(zv);R;}',(⎕ucs 10),'   arr s=(!sign(x(w))).as(s32);arr i=shift(accum(abs(x(w))),1);',(⎕ucs 10),'   arr d=shift(w,1);arr t=shift(s,1);arr q(zc,s32);arr u(zc,s32);',(⎕ucs 10),'   i(0)=0;d(0)=0;q=0;u=0;t(0)=0;q(i)=w-d;u(i)=s-t;ix[axv]=accum(q);',(⎕ucs 10),'   zv=y(ix[0],ix[1],ix[2],ix[3]);',(⎕ucs 10),'   dim4 s1(1);dim4 s2(zs);s1[axv]=zc;s2[axv]=1;u=arr(accum(u),s1);',(⎕ucs 10),'   zv*=tile(u,(I)s2[0],(I)s2[1],(I)s2[2],(I)s2[3]);zv=flat(zv)',(⎕ucs 10),'  ,err(16))}',(⎕ucs 10),'DF(red_f){A x=r;if(!rnk(r))cat_c(x,r,e);red_c(z,l,x,e,scl(scl(rnk(x)-1)));}',(⎕ucs 10),'MA(red_o){B ar=rnk(ax),rr=rnk(r);if(rr>4)err(16);',(⎕ucs 10),' if(ar>1)err(4);if(cnt(ax)!=1)err(5);if(!isint(ax))err(11);',(⎕ucs 10),' I av;CVSWITCH(ax.v,err(6),av=v.as(s32).scalar<I>(),err(11))',(⎕ucs 10),' if(av<0)err(11);if(av>=rr)err(4);av=(I)rr-av-1;I rc=(I)r.s[av];',(⎕ucs 10),' z.s=SHP(rr-1);I ib=isbool(r);',(⎕ucs 10),' DO(av,z.s[i]=r.s[i])DO((I)rr-av-1,z.s[av+i]=r.s[av+i+1])',(⎕ucs 10),' if(!cnt(z)){z.v=scl(0);R;}',(⎕ucs 10),' if(!rc){z.v=ll.id(z.s);R;}',(⎕ucs 10),' if(1==rc){z.v=r.v;R;}',(⎕ucs 10),' CVSWITCH(r.v,err(6)',(⎕ucs 10),'  ,arr rv=axis(v,r.s,av);',(⎕ucs 10),'   if("rgt"==ll.nm){z.v=flat(rv(span,rc-1,span));R;}',(⎕ucs 10),'   if("lft"==ll.nm){z.v=flat(rv(span,0,span));R;}',(⎕ucs 10),'   if("add"==ll.nm&&ib){z.v=flat(count(rv,1).as(s32));R;}',(⎕ucs 10),'   if("add"==ll.nm){z.v=flat(sum(rv.as(f64),1));R;}',(⎕ucs 10),'   if("mul"==ll.nm){z.v=flat(product(rv.as(f64),1));R;}',(⎕ucs 10),'   if("min"==ll.nm){z.v=flat(min(rv,1));R;}',(⎕ucs 10),'   if("max"==ll.nm){z.v=flat(max(rv,1));R;}',(⎕ucs 10),'   if("and"==ll.nm&&ib){z.v=flat(allTrue(rv,1));R;}',(⎕ucs 10),'   if("lor"==ll.nm&&ib){z.v=flat(anyTrue(rv,1));R;}',(⎕ucs 10),'   if("neq"==ll.nm&&ib){z.v=flat((1&sum(rv,1)).as(b8));R;}',(⎕ucs 10),'   map_o mfn_c(llp);dim4 zs;DO((I)rnk(z),zs[i]=z.s[i])',(⎕ucs 10),'   z.v=flat(rv(span,rc-1,span));',(⎕ucs 10),'   DO(rc-1,mfn_c(z,A(z.s,flat(rv(span,rc-i-2,span))),z,e))',(⎕ucs 10),'  ,B zc=cnt(z);z.v=VEC<A>(cnt(z));VEC<A>&zv=std::get<VEC<A>>(z.v);',(⎕ucs 10),'   B bs=1;DOB(av,bs*=z.s[i])B as=1;DOB(rr-av-1,as*=z.s[av+i])',(⎕ucs 10),'   B ms=bs*rc;B mi=rc*bs-bs;',(⎕ucs 10),'   if("rgt"==ll.nm){DOB(as,B j=i;DOB(bs,zv[j*bs+i]=v[j*ms+mi+i]))R;}',(⎕ucs 10),'   if("lft"==ll.nm){DOB(as,B j=i;DOB(bs,zv[j*bs+i]=v[j*ms+i]))R;}',(⎕ucs 10),'   DOB(as,B k=i;DOB(bs,zv[k*bs+i]=v[k*ms+mi+i]))',(⎕ucs 10),'   DOB(rc-1,B j=(rc-i-2)*bs;',(⎕ucs 10),'    DOB(as,B k=i;DOB(bs,A&zvi=zv[k*bs+i];ll(zvi,v[k*ms+j+i],zvi,e)))))}',(⎕ucs 10),'MF(red_o){A x=r;if(!rnk(r))cat_c(x,r,e);this_c(z,x,e,scl(scl(rnk(x)-1)));}',(⎕ucs 10),'DA(red_o){B ar=rnk(ax),lr=rnk(l),rr=rnk(r);if(lr>4||rr>4)err(16);',(⎕ucs 10),' if(ar>1)err(4);if(cnt(ax)!=1)err(5);if(!isint(ax))err(11);',(⎕ucs 10),' I av;CVSWITCH(ax.v,err(6),av=v.as(s32).scalar<I>(),err(11))',(⎕ucs 10),' if(av<0)err(11);if(av>=rr)err(4);av=(I)rr-av-1;',(⎕ucs 10),' if(lr>1)err(4);if(cnt(l)!=1)err(5);if(!isint(l))err(11);',(⎕ucs 10),' I lv;CVSWITCH(l.v,err(6),lv=v.as(s32).scalar<I>(),err(11))',(⎕ucs 10),' I rc=(I)r.s[av]+1;if(rc<lv)err(5);rc=(I)(rc-abs(lv));',(⎕ucs 10),' A t(r.s,scl(0));t.s[av]=rc;',(⎕ucs 10),' if(!cnt(t)){z=t;R;}if(!lv){t.v=ll.id(t.s);z=t;R;}',(⎕ucs 10),' seq rng(rc);IDX x[4];map_o mfn_c(llp);',(⎕ucs 10),' CVSWITCH(r.v,err(6)',(⎕ucs 10),'  ,arr rv=unrav(v,r.s);',(⎕ucs 10),'   if(lv>=0){x[av]=rng+((D)lv-1);t.v=flat(rv(x[0],x[1],x[2],x[3]));',(⎕ucs 10),'    DO(lv-1,x[av]=rng+(D)(lv-i-2);',(⎕ucs 10),'     mfn_c(t,A(t.s,flat(rv(x[0],x[1],x[2],x[3]))),t,e))',(⎕ucs 10),'   }else{x[av]=rng;t.v=flat(rv(x[0],x[1],x[2],x[3]));',(⎕ucs 10),'    DO(abs(lv)-1,x[av]=rng+(D)(i+1);',(⎕ucs 10),'     mfn_c(t,A(t.s,flat(rv(x[0],x[1],x[2],x[3]))),t,e))}',(⎕ucs 10),'   z=t;',(⎕ucs 10),'  ,err(16))}',(⎕ucs 10),'DF(red_o){if(!rnk(r))err(4);',(⎕ucs 10),' red_o mfn_c(llp);mfn_c(z,l,r,e,scl(scl((I)rnk(r)-1)));}',(⎕ucs 10))
_,←,⊂('NM(rdf,"rdf",0,0,DID,MT ,DFD,MT,DAD)',(⎕ucs 10),'ID(rdf,1,s32)',(⎕ucs 10),'OM(rdf,"rdf",0,0,MFD,DFD,MAD,DAD)',(⎕ucs 10),'DEFN(rdf)',(⎕ucs 10),'DA(rdf_f){red_c(z,l,r,e,ax);}',(⎕ucs 10),'DF(rdf_f){A x=r;if(!rnk(r))cat_c(x,r,e);red_c(z,l,x,e,scl(scl(0)));}',(⎕ucs 10),'MA(rdf_o){red_o mfn_c(llp);mfn_c(z,r,e,ax);}',(⎕ucs 10),'MF(rdf_o){A x=r;if(!rnk(r))cat_c(x,r,e);this_c(z,x,e,scl(scl(0)));}',(⎕ucs 10),'DA(rdf_o){red_o mfn_c(llp);mfn_c(z,l,r,e,ax);}',(⎕ucs 10),'DF(rdf_o){if(!rnk(r))err(4);red_o mfn_c(llp);mfn_c(z,l,r,e,scl(scl(0)));}',(⎕ucs 10))
_,←,⊂('NM(scn,"scn",0,0,DID,MT ,DFD,MT ,DAD)',(⎕ucs 10),'DEFN(scn)',(⎕ucs 10),'ID(scn,1,s32)',(⎕ucs 10),'OM(scn,"scn",1,1,MFD,MT,MAD,MT )',(⎕ucs 10),'DA(scn_f){if(rnk(ax)>1||cnt(ax)!=1)err(5);if(!isint(ax))err(11);',(⎕ucs 10),' B rr=rnk(r),lr=rnk(l);',(⎕ucs 10),' I ra;CVSWITCH(ax.v,err(6),ra=v.as(s32).scalar<I>(),err(11))',(⎕ucs 10),' if(ra<0)err(11);if(ra>=rr)err(4);if(lr>1)err(4);ra=(I)rr-ra-1;',(⎕ucs 10),' arr lv;CVSWITCH(l.v,err(6),lv=v,err(11))',(⎕ucs 10),' if(r.s[ra]!=1&&r.s[ra]!=sum<I>(lv>0))err(5);',(⎕ucs 10),' arr ca=max(1,abs(lv)).as(s32);I c=sum<I>(ca);',(⎕ucs 10),' if(!cnt(l))c=0;z.s=r.s;z.s[ra]=c;B zc=cnt(z);if(!zc){z.v=scl(0);R;}',(⎕ucs 10),' arr pw=0<lv,pa=pw*lv;I pc=sum<I>(pa);if(!pc){z.v=scl(0);R;}',(⎕ucs 10),' pw=where(pw);pa=scan(pa(pw),0,AF_BINARY_ADD,false);',(⎕ucs 10),' arr si(pc,s32);si=0;si(pa)=1;si=accum(si)-1;',(⎕ucs 10),' arr ti(pc,s32);ti=1;ti(pa)=scan(ca,0,AF_BINARY_ADD,false)(pw);',(⎕ucs 10),' ti=scanByKey(si,ti);',(⎕ucs 10),' CVSWITCH(r.v,err(6)',(⎕ucs 10),'  ,arr zv(zc,v.type());zv=0;zv=axis(zv,z.s,ra);',(⎕ucs 10),'   zv(span,ti,span)=axis(v,r.s,ra)(span,si,span);z.v=flat(zv)',(⎕ucs 10),'  ,err(16))}',(⎕ucs 10),'DF(scn_f){A x=r;if(!rnk(r))cat_c(x,r,e);',(⎕ucs 10),' scn_c(z,l,x,e,scl(scl(rnk(x)-1)));}',(⎕ucs 10 10),'MA(scn_o){if(rnk(ax)>1)err(4);if(cnt(ax)!=1)err(5);',(⎕ucs 10),' if(!isint(ax))err(11);',(⎕ucs 10),' I av;CVSWITCH(ax.v,err(6),av=v.as(s32).scalar<I>(),err(11))',(⎕ucs 10),' if(av<0)err(11);B rr=rnk(r);if(av>=rr)err(4);av=(I)rr-av-1;z.s=r.s;',(⎕ucs 10),' I rc=(I)r.s[av];if(rc==1){z.v=r.v;R;}if(!cnt(z)){z.v=scl(0);R;}',(⎕ucs 10),' I ib=isbool(r);arr rv;CVSWITCH(r.v,err(6),rv=axis(v,r.s,av),err(16))',(⎕ucs 10),' if("add"==ll.nm){z.v=flat(scan(rv.as(f64),1,AF_BINARY_ADD));R;}',(⎕ucs 10),' if("mul"==ll.nm){z.v=flat(scan(rv.as(f64),1,AF_BINARY_MUL));R;}',(⎕ucs 10),' if("min"==ll.nm){z.v=flat(scan(rv.as(f64),1,AF_BINARY_MIN));R;}',(⎕ucs 10),' if("max"==ll.nm){z.v=flat(scan(rv.as(f64),1,AF_BINARY_MAX));R;}',(⎕ucs 10),' if("and"==ll.nm&&ib){z.v=flat(scan(rv,1,AF_BINARY_MIN));R;}',(⎕ucs 10),' if("lor"==ll.nm&&ib){z.v=flat(scan(rv,1,AF_BINARY_MAX));R;}',(⎕ucs 10),' map_o mfn_c(llp);B tr=rnk(z)-1;SHP ts(tr,1);',(⎕ucs 10),' DOB(av,ts[i]=r.s[i])DOB(tr-av,ts[av+i]=r.s[av+i+1])',(⎕ucs 10),' rv=rv.as(f64);arr zv(cnt(z),f64);zv=axis(zv,z.s,av);',(⎕ucs 10),' DO(rc,arr rvi=rv(span,i,span);dim4 rvs=rvi.dims();',(⎕ucs 10),'  A t(ts,flat(rv(span,i,span)));I c=i;',(⎕ucs 10),'  DO(c,A y(ts,flat(rv(span,c-i-1,span)));mfn_c(t,y,t,e))',(⎕ucs 10),'  CVSWITCH(t.v,err(6),zv(span,i,span)=moddims(v,rvs),err(16)))',(⎕ucs 10),' z.v=flat(zv);}',(⎕ucs 10),'MF(scn_o){B rr=rnk(r);if(!rr){z=r;R;}',(⎕ucs 10),' scn_o mfn_c(llp);mfn_c(z,r,e,scl(scl(rr-1)));}',(⎕ucs 10))
_,←,⊂('NM(scf,"scf",0,0,DID,MT ,DFD,MT ,DAD)',(⎕ucs 10),'DEFN(scf)',(⎕ucs 10),'ID(scf,1,s32)',(⎕ucs 10),'OM(scf,"scf",1,1,MFD,MT,MAD,MT )',(⎕ucs 10),'DA(scf_f){scn_c(z,l,r,e,ax);}',(⎕ucs 10),'DF(scf_f){A x=r;if(!rnk(x))cat_c(x,r,e);scn_c(z,l,x,e,scl(scl(0)));}',(⎕ucs 10 10),'MA(scf_o){scn_o mfn_c(llp);mfn_c(z,r,e,ax);}',(⎕ucs 10),'MF(scf_o){if(!rnk(r)){z=r;R;}scn_o mfn_c(llp);mfn_c(z,r,e,scl(scl(0)));}',(⎕ucs 10))
_,←,⊂('NM(rol,"rol",1,0,MT ,MFD,DFD,MT ,MT )',(⎕ucs 10),'DEFN(rol)',(⎕ucs 10),'SMF(rol,arr rnd=randu(rv.dims(),f64);z.v=(0==rv)*rnd+trunc(rv*rnd))',(⎕ucs 10),'DF(rol_f){if(cnt(r)!=1||cnt(l)!=1)err(5);',(⎕ucs 10),' D lv;CVSWITCH(l.v,err(6),lv=v.as(f64).scalar<D>(),err(11))',(⎕ucs 10),' D rv;CVSWITCH(r.v,err(6),rv=v.as(f64).scalar<D>(),err(11))',(⎕ucs 10),' if(lv>rv||lv!=floor(lv)||rv!=floor(rv)||lv<0||rv<0)err(11);',(⎕ucs 10),' I s=(I)lv;I t=(I)rv;z.s=SHP(1,s);if(!s){z.v=scl(0);R;}',(⎕ucs 10),' VEC<I> g(t);VEC<I> d(t);',(⎕ucs 10),' ((1+range(t))*randu(t)).as(s32).host(g.data());',(⎕ucs 10),' DO(t,I j=g[i];if(i!=j)d[i]=d[j];d[j]=i)z.v=arr(s,d.data());}',(⎕ucs 10))
_,←,⊂('NM(tke,"tke",0,0,MT ,MFD,DFD,MAD,DAD)',(⎕ucs 10),'DEFN(tke)',(⎕ucs 10),'MF(tke_f){',(⎕ucs 10),' CVSWITCH(r.v,err(6),z=r,',(⎕ucs 10),'  B rc=cnt(r);if(!rc&&!v.size())err(99,L"Missing prototype");',(⎕ucs 10),'  B rr=rnk(r);B mr=rnk(v[0]);U8 speq=1;U8 nv=0;',(⎕ucs 10),'  DOB(v.size(),B nr=rnk(v[i]);if(nr>mr){mr=nr;speq=0;})',(⎕ucs 10),'  DOB(v.size(),CVSWITCH(v[i].v,err(6),,nv=1))',(⎕ucs 10),'  A x(mr+rr);DOB(rr,x.s[mr+rr-i-1]=r.s[rr-i-1])',(⎕ucs 10),'  dtype tp=b8;if(!nv)tp=mxt(b8,r);',(⎕ucs 10),'  if(!mr){',(⎕ucs 10),'   if(nv){x.v=VEC<A>(rc);VEC<A>&xv=std::get<VEC<A>>(x.v);',(⎕ucs 10),'    DOB(rc,CVSWITCH(v[i].v,err(6),xv[i]=scl(v),xv[i]=v[0]))}',(⎕ucs 10),'   if(!nv){x.v=arr(rc,tp);arr&xv=std::get<arr>(x.v);',(⎕ucs 10),'    DOB(rc,CVSWITCH(v[i].v,err(6),xv((I)i)=v(0).as(tp),err(99)))}',(⎕ucs 10),'   z=x;R;}',(⎕ucs 10),'  DOB(mr,x.s[i]=0)B rk=rnk(v[0]);DOB(rk,x.s[mr-i-1]=v[0].s[rk-i-1])',(⎕ucs 10),'  DOB(rc,A vi=v[i];rk=rnk(vi);',(⎕ucs 10),'   DOB(rk,B j=mr-i-1;B k=rk-i-1;if(x.s[j]!=vi.s[k])speq=0;',(⎕ucs 10),'    if(x.s[j]<vi.s[k])x.s[j]=vi.s[k]))',(⎕ucs 10),'  B bc=1;DOB(mr,bc*=x.s[i])seq bx((D)bc);B xc=rc*bc;',(⎕ucs 10),'  if(!speq)err(16);',(⎕ucs 10),'  if(nv)err(16);',(⎕ucs 10),'  if(!nv&&!xc){x.v=scl(0);}',(⎕ucs 10),'  if(!nv&&xc){x.v=arr(xc,tp);arr&xv=std::get<arr>(x.v);',(⎕ucs 10),'   DOB(rc,CVSWITCH(v[i].v,err(6),xv(bx+(D)i*bc)=v.as(tp),err(99)))}',(⎕ucs 10),'  z=x)}',(⎕ucs 10),'MA(tke_f){err(16);}',(⎕ucs 10),'DA(tke_f){B c=cnt(l),ac=cnt(ax),axr=rnk(ax),lr=rnk(l),rr=rnk(r);',(⎕ucs 10),' if(axr>1||lr>1)err(4);if(ac!=c)err(5);if(c>4)err(16);if(!isint(ax))err(11);',(⎕ucs 10),' VEC<I> av(ac),m(rr,0);',(⎕ucs 10),' if(ac)CVSWITCH(ax.v,err(6),v.as(s32).host(av.data()),err(11))',(⎕ucs 10),' DOB(ac,if(av[i]<0)err(11);if(av[i]>=rr)err(4))',(⎕ucs 10),' DOB(ac,if(m[av[i]])err(11);m[av[i]]=1)',(⎕ucs 10),' if(!c){z=r;R;}if(!isint(l))err(11);',(⎕ucs 10),' VEC<I> lv(c);CVSWITCH(l.v,err(6),v.as(s32).host(lv.data()),err(11))',(⎕ucs 10),' seq it[4],ix[4];z.s=r.s;if(rr>4)err(16);',(⎕ucs 10),' DOB(c,{U j=(U)rr-av[i]-1;I a=std::abs(lv[i]);z.s[j]=a;',(⎕ucs 10),'  if(a>r.s[j])ix[j]=seq((D)r.s[j]);',(⎕ucs 10),'  else if(lv[i]<0)ix[j]=seq((D)r.s[j]-a,(D)r.s[j]-1);',(⎕ucs 10),'  else ix[j]=seq(a);',(⎕ucs 10),'  it[j]=ix[j]+(lv[i]<0)*(a-(D)r.s[j]);})',(⎕ucs 10),' B zc=cnt(z);if(!zc){z.v=scl(0);R;}',(⎕ucs 10),' CVSWITCH(r.v,err(6)',(⎕ucs 10),'  ,z.v=arr(zc,v.type());arr&zv=std::get<arr>(z.v);zv=0;',(⎕ucs 10),'   arr rv=unrav(v,r.s);zv=unrav(zv,z.s);',(⎕ucs 10),'   zv(it[0],it[1],it[2],it[3])=rv(ix[0],ix[1],ix[2],ix[3]);',(⎕ucs 10),'   zv=flat(zv)',(⎕ucs 10),'  ,err(16))}',(⎕ucs 10),'DF(tke_f){I c=(I)cnt(l);if(c>4)err(16);',(⎕ucs 10),' A nr=r;if(!rnk(nr)){nr.s=SHP(c,1);}',(⎕ucs 10),' A ax;iot_c(ax,scl(scl(c)),e);tke_c(z,l,nr,e,ax);}',(⎕ucs 10))
_,←,⊂('NM(drp,"drp",0,0,MT ,MFD,DFD,MAD,DAD)',(⎕ucs 10),'DEFN(drp)',(⎕ucs 10),'MF(drp_f){if(rnk(r))err(16);z=r;}',(⎕ucs 10),'MA(drp_f){err(16);}',(⎕ucs 10),'DA(drp_f){B c=cnt(l),ac=cnt(ax),rr=rnk(r),lr=rnk(l),axr=rnk(ax);',(⎕ucs 10),' if(axr>1||lr>1)err(4);if(ac!=c)err(5);if(c>4)err(16);if(!isint(ax))err(11);',(⎕ucs 10),' I m[4]={0,0,0,0},av[4];CVSWITCH(ax.v,err(6),v.as(s32).host(av),err(11))',(⎕ucs 10),' DOB(ac,if(av[i]<0)err(11);if(av[i]>=rr)err(4))',(⎕ucs 10),' DOB(ac,if(m[av[i]])err(11);m[av[i]]=1)',(⎕ucs 10),' if(!c){z=r;R;}if(!isint(l))err(11);',(⎕ucs 10),' I lv[4];CVSWITCH(l.v,err(6),v.as(s32).host(lv),err(11))',(⎕ucs 10),' seq it[4],ix[4];z.s=r.s;',(⎕ucs 10),' DO((I)c,{B j=rr-av[i]-1;I a=std::abs(lv[i]);z.s[j]=r.s[j]-a;',(⎕ucs 10),'  if(a>=r.s[j]){z.s[j]=0;ix[j]=seq(0);it[j]=seq(0);}',(⎕ucs 10),'  else if(lv[i]<0){ix[j]=seq((D)z.s[j]);it[j]=ix[j];}',(⎕ucs 10),'  else{ix[j]=seq(a,(D)r.s[j]-1);it[j]=ix[j]-(D)a;}})',(⎕ucs 10),' if(!cnt(z)){z.v=scl(0);R;}',(⎕ucs 10),' CVSWITCH(r.v,err(6)',(⎕ucs 10),'  ,arr tv(cnt(z),v.type());tv=0;tv=unrav(tv,z.s);',(⎕ucs 10),'   tv(it[0],it[1],it[2],it[3])=unrav(v,r.s)(ix[0],ix[1],ix[2],ix[3]);',(⎕ucs 10),'   z.v=flat(tv)',(⎕ucs 10),'  ,z.v=VEC<A>(cnt(z),scl(scl(0)));VEC<A>&zv=std::get<VEC<A>>(z.v);',(⎕ucs 10),'   if(rr!=1)err(16);B shft=0;if(lv[0]>=0)shft=lv[0];',(⎕ucs 10),'   DOB(z.s[0],zv[i]=v[i+shft]))}',(⎕ucs 10),'DF(drp_f){B c=cnt(l);if(c>4)err(16);',(⎕ucs 10),' A nr=r;if(!rnk(nr)){nr.s=SHP(c,1);}',(⎕ucs 10),' A ax;iot_c(ax,scl(scl(c)),e);drp_c(z,l,nr,e,ax);}',(⎕ucs 10))
_,←,⊂('OM(map,"map",1,1,MFD,DFD,MT ,MT )',(⎕ucs 10),'MF(map_o){if(scm(ll)){ll(z,r,e);R;}',(⎕ucs 10),' if("par"==ll.nm&&std::holds_alternative<arr>(r.v)){z=r;R;}',(⎕ucs 10),' z.s=r.s;I c=(I)cnt(z);if(!c){z.v=scl(0);R;}',(⎕ucs 10),' z.v=VEC<A>(c);VEC<A>&zv=std::get<VEC<A>>(z.v);',(⎕ucs 10),' CVSWITCH(r.v,err(6),DOB(c,ll(zv[i],scl(v((I)i)),e)),DOB(c,ll(zv[i],v[i],e)))',(⎕ucs 10),' coal(z);}',(⎕ucs 10),'DF(map_o){if(scd(ll)){ll(z,l,r,e);R;}B lr=rnk(l),rr=rnk(r);',(⎕ucs 10),' A rv,lv,a,b;cat_c(rv,r,e);cat_c(lv,l,e);',(⎕ucs 10),' if((lr==rr&&l.s==r.s)||!lr){z.s=r.s;}',(⎕ucs 10),' else if(!rr){z.s=l.s;}else if(lr!=rr)err(4);',(⎕ucs 10),' else if(l.s!=r.s)err(5);else err(99);',(⎕ucs 10),' I c=(I)cnt(z);if(!c){z.v=scl(0);R;}',(⎕ucs 10),' z.v=VEC<A>(c);VEC<A>&v=std::get<VEC<A>>(z.v);',(⎕ucs 10),' if(lr==rr){',(⎕ucs 10),'  DOB(c,A ix=scl(scl(i));dis_c(a,ix,lv,e);dis_c(b,ix,rv,e);ll(v[i],a,b,e))}',(⎕ucs 10),' else if(!lr){',(⎕ucs 10),'  dis_c(a,scl(scl(0)),lv,e);DOB(c,dis_c(b,scl(scl(i)),rv,e);ll(v[i],a,b,e))}',(⎕ucs 10),' else if(!rr){',(⎕ucs 10),'  dis_c(b,scl(scl(0)),rv,e);DOB(c,dis_c(a,scl(scl(i)),lv,e);ll(v[i],a,b,e))}',(⎕ucs 10),' coal(z);}',(⎕ucs 10))
_,←,⊂('OM(com,"com",scm(l),scd(l),MFD,DFD,MT ,MT )',(⎕ucs 10),'MF(com_o){ll(z,r,r,e);}DF(com_o){ll(z,r,l,e);}',(⎕ucs 10 10))
_,←,⊂('OD(dot,"dot",0,0,MT,DFD,MT ,MT )',(⎕ucs 10),'DF(dot_o){B lr=rnk(l),rrk=rnk(r),ra=rrk?rrk-1:0,la=lr?lr-1:0;',(⎕ucs 10),' if(rrk&&lr&&l.s[0]!=r.s[ra])err(5);',(⎕ucs 10),' A t(la+ra,scl(0));DOB(ra,t.s[i]=r.s[i])DOB(la,t.s[i+ra]=l.s[i+1])',(⎕ucs 10),' if(!cnt(t)){z=t;R;}if((lr&&!l.s[0])||(rrk&&!r.s[ra])){t.v=ll.id(t.s);z=t;R;}',(⎕ucs 10),' B c=lr?l.s[0]:rrk?r.s[ra]:1;',(⎕ucs 10),' std::visit(visitor{DVSTR(),',(⎕ucs 10),'   [&](carr&lv,carr&rv){',(⎕ucs 10),'    arr x=table(lv,l.s,1),y=table(rv,r.s,ra);',(⎕ucs 10),'    if(!lr||1==l.s[0])x=tile(x,(U)c,1);if(!rrk||1==r.s[ra])y=tile(y,1,(U)c);',(⎕ucs 10),'    if("add"==ll.nm&&"mul"==rr.nm){',(⎕ucs 10),'     t.v=flat(matmul(y.as(f64),x.as(f64)));z=t;R;}',(⎕ucs 10),'    if(isbool(x)&&isbool(y)&&"neq"==ll.nm&&"and"==rr.nm){',(⎕ucs 10),'     t.v=flat((1&matmul(y.as(f32),x.as(f32)).as(s16)).as(b8));z=t;R;}',(⎕ucs 10),'    B rc=1,lc=1;if(rrk)rc=cnt(r)/r.s[ra];if(lr)lc=cnt(l)/l.s[0];',(⎕ucs 10),'    x=tile(arr(x,c,1,lc),1,(U)rc,1);y=tile(y.T(),1,1,(U)lc);',(⎕ucs 10),'    A X(SHP{c,rc,lc},flat(x.as(f64)));A Y(SHP{c,rc,lc},flat(y.as(f64)));',(⎕ucs 10),'    map_o mfn_c(rrp);red_o rfn_c(llp);mfn_c(X,X,Y,e);rfn_c(X,X,e);',(⎕ucs 10),'    t.v=X.v;z=t;},',(⎕ucs 10),'   [&](CVEC<A>&lv,carr&rv){err(16);},',(⎕ucs 10),'   [&](carr&lv,CVEC<A>&rv){err(16);},',(⎕ucs 10),'   [&](CVEC<A>&lv,CVEC<A>&rv){err(16);}},',(⎕ucs 10),'  l.v,r.v);}',(⎕ucs 10))
_,←,⊂('OD(rnk,"rnk",scm(l),0,MFD,DFD,MT ,MT )',(⎕ucs 10),'MF(rnk_o){if(cnt(ww)!=1)err(4);B cr=geti(ww);',(⎕ucs 10),' B rr=rnk(r);if(scm(ll)||cr>=rr){ll(z,r,e);R;}',(⎕ucs 10),' if(cr<=-rr)cr=0;if(cr<0)cr=rr+cr;B dr=rr-cr;',(⎕ucs 10),' A x(cr+1,r.v);DOB(cr,x.s[i]=r.s[i])DOB(dr,x.s[cr]*=r.s[rr-i-1])',(⎕ucs 10),' B dc=x.s[cr];A y(dr,VEC<A>(dc?dc:1));DOB(dr,y.s[dr-i-1]=r.s[rr-i-1])',(⎕ucs 10),' VEC<A>&yv=std::get<VEC<A>>(y.v);',(⎕ucs 10),' if(!dc)tke_c(x,scl(scl(1)),x,e);',(⎕ucs 10),' DOB(dc?dc:1,A t;sqd_c(t,scl(scl(i)),x,e);ll(yv[i],t,e))',(⎕ucs 10),' if(!dc)y=proto(y);tke_c(z,y,e);}',(⎕ucs 10),'DF(rnk_o){I rr=(I)rnk(r),lr=(I)rnk(l),cl,cr,dl,dr;dim4 sl(1),sr(1);',(⎕ucs 10),' arr wwv;CVSWITCH(ww.v,err(6),wwv=v.as(s32),err(11))',(⎕ucs 10),' switch(cnt(ww)){',(⎕ucs 10),'  CS(1,cl=cr=wwv.scalar<I>())',(⎕ucs 10),'  CS(2,cl=wwv.scalar<I>();cr=wwv(1).scalar<I>())',(⎕ucs 10),'  default:err(4);}',(⎕ucs 10),' if(cl>lr)cl=lr;if(cr>rr)cr=rr;if(cl<-lr)cl=0;if(cr<-rr)cr=0;',(⎕ucs 10),' if(cl<0)cl=lr+cl;if(cr<0)cr=rr+cr;if(cr>3||cl>3)err(10);',(⎕ucs 10),' dl=lr-cl;dr=rr-cr;if(dl!=dr&&dl&&dr)err(4);',(⎕ucs 10),' if(dl==dr)DO(dr,if(l.s[i+cl]!=r.s[i+cr])err(5))',(⎕ucs 10),' DO(dl,sl[cl]*=l.s[i+cl])DO(cl,sl[i]=l.s[i])',(⎕ucs 10),' DO(dr,sr[cr]*=r.s[i+cr])DO(cr,sr[i]=r.s[i])',(⎕ucs 10),' B sz=dl>dr?sl[cl]:sr[cr];VEC<A> tv(sz);',(⎕ucs 10),' A a(cl+1,l.v);DO(cl+1,a.s[i]=sl[i])A b(cr+1,r.v);DO(cr+1,b.s[i]=sr[i])',(⎕ucs 10),' DOB(sz,A ta;A tb; A ai=scl(scl((I)(i%sl[cl])));A bi=scl(scl((I)(i%sr[cr])));',(⎕ucs 10),'  sqd_c(ta,ai,a,e);sqd_c(tb,bi,b,e);ll(tv[i],ta,tb,e))',(⎕ucs 10),' if(dr>=dl){z.s=SHP(dr);DOB(dr,z.s[i]=r.s[cr+i])}',(⎕ucs 10),' if(dr<dl){z.s=SHP(dl);DOB(dl,z.s[i]=l.s[cl+i])}',(⎕ucs 10),' z.v=tv;tke_c(z,z,e);}',(⎕ucs 10))
_,←,⊂('OD(pow,"pow",scm(l),scd(l),MFD,DFD,MT ,MT )',(⎕ucs 10),'MF(pow_o){if(fr){A t;A v=r;I flg;',(⎕ucs 10),'  do{A u;ll(u,v,e);rr(t,u,v,e);',(⎕ucs 10),'   if(cnt(t)!=1)err(5);CVSWITCH(t.v,err(6),flg=v.as(s32).scalar<I>(),err(11))',(⎕ucs 10),'   v=u;}while(!flg);',(⎕ucs 10),'  z=v;R;}',(⎕ucs 10),' if(rnk(ww))err(4);I c;CVSWITCH(ww.v,err(6),c=v.as(s32).scalar<I>(),err(11))',(⎕ucs 10),' z=r;DO(c,ll(z,z,e))}',(⎕ucs 10),'DF(pow_o){if(!fl)err(2);',(⎕ucs 10),' if(fr){A t;A v=r;I flg;',(⎕ucs 10),'  do{A u;ll(u,l,v,e);rr(t,u,v,e);',(⎕ucs 10),'   if(cnt(t)!=1)err(5);CVSWITCH(t.v,err(6),flg=v.as(s32).scalar<I>(),err(11))',(⎕ucs 10),'   v=u;}while(!flg);',(⎕ucs 10),'  z=v;R;}',(⎕ucs 10),' if(rnk(ww))err(4);I c;CVSWITCH(ww.v,err(6),c=v.as(s32).scalar<I>(),err(11))',(⎕ucs 10),' A t=r;DO(c,ll(t,l,t,e))z=t;}',(⎕ucs 10 10))
_,←,⊂('OD(jot,"jot",(scm(l)&&scm(r)),(scd(l)&&scd(r)),MFD,DFD,MT ,MT )',(⎕ucs 10),'MF(jot_o){if(!fl){rr(z,aa,r,e);R;}if(!fr){ll(z,r,ww,e);R;}',(⎕ucs 10),' rr(z,r,e);ll(z,z,e);}',(⎕ucs 10),'DF(jot_o){if(!fl||!fr){err(2);}rr(z,r,e);ll(z,l,z,e);}',(⎕ucs 10 10))
_,←,⊂('NM(unq,"unq",0,0,MT ,MFD,DFD,MT ,MT )',(⎕ucs 10),'DEFN(unq)',(⎕ucs 10),'MF(unq_f){if(rnk(r)>1)err(4);if(!cnt(r)){z.s=r.s;z.v=r.v;R;}',(⎕ucs 10),' CVSWITCH(r.v,err(6)',(⎕ucs 10),'  ,arr a;arr b;sort(a,b,v);arr zv=a!=shift(a,1);zv(0)=1;',(⎕ucs 10),'   zv=where(zv);sort(b,zv,b(zv),a(zv));z.s=SHP(1,zv.elements());z.v=zv',(⎕ucs 10),'  ,err(16))}',(⎕ucs 10),'DF(unq_f){if(rnk(r)>1||rnk(l)>1)err(4);',(⎕ucs 10),' B lc=cnt(l),rc=cnt(r);',(⎕ucs 10),' if(!cnt(l)){z.s=SHP(1,rc);z.v=r.v;R;}if(!cnt(r)){z.s=SHP(1,lc);z.v=l.v;R;}',(⎕ucs 10),' arr rv;CVSWITCH(r.v,err(6),rv=v,err(16))',(⎕ucs 10),' arr lv;CVSWITCH(l.v,err(6),lv=v,err(16))',(⎕ucs 10),' dtype mt=mxt(l,r);arr x=setUnique(lv);B c=x.elements();',(⎕ucs 10),' x=!anyTrue(tile(rv,1,(U)c)==tile(arr(x,1,c),(U)rc,1),1);',(⎕ucs 10),' x=join(0,lv.as(mt),rv(where(x)).as(mt));z.s=SHP(1,x.elements());z.v=x;}',(⎕ucs 10))
_,←,⊂('NM(int,"int",0,0,MT ,MT ,DFD,MT ,MT )',(⎕ucs 10),'DEFN(int)',(⎕ucs 10),'DF(int_f){if(rnk(r)>1||rnk(l)>1)err(4);',(⎕ucs 10),' if(!cnt(r)||!cnt(l)){z.v=scl(0);z.s=SHP(1,0);R;}',(⎕ucs 10),' arr rv;CVSWITCH(r.v,err(6),rv=v,err(16))',(⎕ucs 10),' arr lv;CVSWITCH(l.v,err(6),lv=v,err(16))',(⎕ucs 10),' arr pv=setUnique(rv);B pc=pv.elements();arr zv=constant(0,cnt(l),s64);',(⎕ucs 10),' for(B h;h=pc/2;pc-=h){arr t=zv+h;replace(zv,pv(t)>lv,t);}',(⎕ucs 10),' arr ix=where(pv(zv)==lv);z.s=SHP(1,ix.elements());',(⎕ucs 10),' z.v=z.s[0]?lv(ix):scl(0);}',(⎕ucs 10))
_,←,⊂('NM(get,"get",0,0,MT,MT,DFD,MT,MT)',(⎕ucs 10),'DEFN(get)',(⎕ucs 10),'DF(get_f){CVSWITCH(l.v,err(6),err(99,L"Unexpected simple array"),)',(⎕ucs 10),' CVEC<A>&lv=std::get<VEC<A>>(l.v);B ll=lv.size();B zr=rnk(z),rr=rnk(r);',(⎕ucs 10),' if(!ll){if(zr!=1)err(4);if(rr!=1)err(5);if(z.s[0]!=r.s[0])err(5);z=r;R;}',(⎕ucs 10),' if(ll!=zr)err(4);B rk=0;DOB(ll,CVSWITCH(lv[i].v,rk+=1,rk+=rnk(lv[i]),err(11)))',(⎕ucs 10),' if(rr>0&&rk!=rr)err(5);',(⎕ucs 10),' const B*rs=r.s.data();IDX x[4];',(⎕ucs 10),' if(!rr)DOB(ll,A v=lv[ll-i-1];CVSWITCH(v.v,,x[i]=v.as(s32),err(11)))',(⎕ucs 10),' if(rr>0)',(⎕ucs 10),'  DOB(ll,A u=lv[ll-i-1];',(⎕ucs 10),'   CVSWITCH(u.v',(⎕ucs 10),'    ,if(z.s[i]!=*rs++)err(5)',(⎕ucs 10),'    ,DOB(rnk(u),if(u.s[i]!=*rs++)err(5))x[i]=v.as(s32)',(⎕ucs 10),'    ,err(11)))',(⎕ucs 10),' I tp=0;',(⎕ucs 10),' CVSWITCH(r.v,err(6)',(⎕ucs 10),'  ,CVSWITCH(z.v,err(6),tp=1,tp=2)',(⎕ucs 10),'  ,CVSWITCH(z.v,err(6),tp=3,tp=4))',(⎕ucs 10),' switch(tp){',(⎕ucs 10),'  CS(1,{',(⎕ucs 10),'   arr rv=unrav(std::get<arr>(r.v),r.s);arr zv=unrav(std::get<arr>(z.v),z.s);',(⎕ucs 10),'   zv(x[0],x[1],x[2],x[3])=rv;z.v=flat(zv);})',(⎕ucs 10),'  CS(2,err(16))',(⎕ucs 10),'  CS(3,err(16))',(⎕ucs 10),'  CS(4,{I i;VEC<A>&zv=std::get<VEC<A>>(z.v);CVEC<A>&rv=std::get<VEC<A>>(r.v);',(⎕ucs 10),'   if(zr!=1)err(16);',(⎕ucs 10),'   CVSWITCH(lv[0].v,',(⎕ucs 10),'    ,arr x=v.as(s32);if(x.elements()!=1)err(16);i=x.scalar<I>();',(⎕ucs 10),'    ,)',(⎕ucs 10),'   zv[i]=rv[0];})',(⎕ucs 10),'  default:err(99);}}',(⎕ucs 10 10),'OM(get,"get",0,0,MT,DFD,MT,MT)',(⎕ucs 10),'DF(get_o){A t;brk_c(t,z,l,e);map_o mfn_c(llp);mfn_c(t,t,r,e);',(⎕ucs 10),' get_c(z,l,t,e);}',(⎕ucs 10))
_,←,⊂('NM(gdu,"gdu",0,0,MT ,MFD,DFD,MT ,MT )',(⎕ucs 10),'DEFN(gdu)',(⎕ucs 10),'MF(gdu_f){B rr=rnk(r);if(rr<1)err(4);z.s=SHP(1,r.s[rr-1]);',(⎕ucs 10),' if(!cnt(r)){z.v=r.v;R;}B c=1;DOB(rr-1,c*=r.s[i])',(⎕ucs 10),' CVSWITCH(r.v,err(6)',(⎕ucs 10),'  ,arr mt;arr a(v,c,r.s[rr-1]);arr zv=iota(dim4(z.s[0]),dim4(1),s32);',(⎕ucs 10),'   DOB(c,sort(mt,zv,flat(a((I)(c-i-1),zv)),zv,0,true))z.v=zv',(⎕ucs 10),'  ,err(16))}',(⎕ucs 10),'DF(gdu_f){err(16);}',(⎕ucs 10))
_,←,⊂('NM(gdd,"gdd",0,0,MT ,MFD,DFD,MT ,MT )',(⎕ucs 10),'DEFN(gdd)',(⎕ucs 10),'MF(gdd_f){B rr=rnk(r);if(rr<1)err(4);z.s=SHP(1,r.s[rr-1]);',(⎕ucs 10),' if(!cnt(r)){z.v=r.v;R;}I c=1;DOB(rr-1,c*=(I)r.s[i]);',(⎕ucs 10),' arr rv;CVSWITCH(r.v,err(6),rv=v,err(16))',(⎕ucs 10),' arr mt,a(rv,c,r.s[rr-1]);arr zv=iota(dim4(z.s[0]),dim4(1),s32);',(⎕ucs 10),' DO(c,sort(mt,zv,flat(a(c-(i+1),zv)),zv,0,false));z.v=zv;}',(⎕ucs 10),'DF(gdd_f){err(16);}',(⎕ucs 10 10))
_,←,⊂('OM(oup,"oup",0,0,MT,DFD,MT ,MT )',(⎕ucs 10),'DF(oup_o){B lr=rnk(l),rr=rnk(r),lc=cnt(l),rc=cnt(r);',(⎕ucs 10),' SHP sp(lr+rr);DOB(rr,sp[i]=r.s[i])DOB(lr,sp[i+rr]=l.s[i])',(⎕ucs 10),' if(!cnt(sp)){z.s=sp;z.v=scl(0);R;}',(⎕ucs 10),' std::visit(visitor{DVSTR(),',(⎕ucs 10),'   [&](carr&lv,carr&rv){arr x(lv,1,lc),y(rv,rc,1);',(⎕ucs 10),'    x=flat(tile(x,(I)rc,1));y=flat(tile(y,1,(I)lc));',(⎕ucs 10),'    map_o mfn_c(llp);A xa(sp,x),ya(sp,y);mfn_c(z,xa,ya,e);},',(⎕ucs 10),'   [&](CVEC<A>&lv,CVEC<A>&rv){z.s=sp;z.v=VEC<A>(lc*rc);',(⎕ucs 10),'    VEC<A>&zv=std::get<VEC<A>>(z.v);DOB(lc*rc,ll(zv[i],lv[i],rv[i],e))',(⎕ucs 10),'    coal(z);},',(⎕ucs 10),'   [&](CVEC<A>&lv,carr&rv){z.s=sp;z.v=VEC<A>(lc*rc);',(⎕ucs 10),'    VEC<A>&zv=std::get<VEC<A>>(z.v);DOB(lc*rc,ll(zv[i],lv[i],A(0,rv((I)i)),e))',(⎕ucs 10),'    coal(z);},',(⎕ucs 10),'   [&](carr&lv,CVEC<A>&rv){z.s=sp;z.v=VEC<A>(lc*rc);',(⎕ucs 10),'    VEC<A>&zv=std::get<VEC<A>>(z.v);DOB(lc*rc,ll(zv[i],A(0,lv((I)i)),rv[i],e))',(⎕ucs 10),'    coal(z);}},',(⎕ucs 10),'  l.v,r.v);}',(⎕ucs 10))
_,←,⊂('NM(fnd,"fnd",0,0,MT ,MT ,DFD,MT ,MT )',(⎕ucs 10),'DEFN(fnd)',(⎕ucs 10),'DF(fnd_f){B lr=rnk(l),rr=rnk(r),rc=cnt(r),lc=cnt(l);',(⎕ucs 10),' if(!rc){z=r;R;}z=r;arr zv(rc,b8);zv=0;',(⎕ucs 10),' if(lr>rr){z.v=zv;R;}',(⎕ucs 10),' DOB(lr,if(l.s[i]>r.s[i]){z.v=zv;R;})',(⎕ucs 10),' if(!lc){zv=1;z.v=zv;R;}',(⎕ucs 10),' if(lr>4||rr>4)err(16);',(⎕ucs 10),' dim4 rs(1),ls(1);DO((I)lr,ls[i]=l.s[i])DO((I)rr,rs[i]=r.s[i])',(⎕ucs 10),' dim4 sp;DO(4,sp[i]=rs[i]-ls[i]+1)seq x[4];DO(4,x[i]=seq((D)sp[i]))',(⎕ucs 10),' zv=unrav(zv,z.s);zv(x[0],x[1],x[2],x[3])=1;',(⎕ucs 10),' arr lv;CVSWITCH(l.v,err(6),lv=unrav(v,l.s),err(16))',(⎕ucs 10),' arr rv;CVSWITCH(r.v,err(6),rv=unrav(v,r.s),err(16))',(⎕ucs 10),' DO((I)ls[0],I m=i;',(⎕ucs 10),'  DO((I)ls[1],I k=i;',(⎕ucs 10),'   DO((I)ls[2],I j=i;',(⎕ucs 10),'    DO((I)ls[3],zv(x[0],x[1],x[2],x[3])=zv(x[0],x[1],x[2],x[3])',(⎕ucs 10),'     &(tile(lv(m,k,j,i),sp)',(⎕ucs 10),'      ==rv(x[0]+(D)m,x[1]+(D)k,x[2]+(D)j,x[3]+(D)i))))))',(⎕ucs 10),' z.v=zv;}',(⎕ucs 10))
_,←,⊂('NM(par,"par",0,0,MT ,MFD,DFD,MAD,MT )',(⎕ucs 10),'DEFN(par)',(⎕ucs 10),'MF(par_f){I nv=0;CVSWITCH(r.v,err(6),,nv=1)',(⎕ucs 10),' if(!rnk(r)&&!nv){z=r;R;}z=A(0,VEC<A>(1,r));}',(⎕ucs 10),'MA(par_f){if(rnk(ax)>1)err(4);B axc=cnt(ax);',(⎕ucs 10),' if(!axc){map_o f(par_p);f(z,r,e);R;}',(⎕ucs 10),' B rr=rnk(r);VEC<I> axm(rr,0);VEC<I> axv(axc);',(⎕ucs 10),' CVSWITCH(ax.v,err(6),v.as(s32).host(axv.data()),err(11))',(⎕ucs 10),' DOB(axc,I v=axv[i];if(v<0)err(11);if(v>=rr)err(4);if(axm[v])err(11);axm[v]=1)',(⎕ucs 10),' B ic=rr-axc;if(!ic){z=A(0,VEC<A>(1,r));R;}',(⎕ucs 10),' A nax(SHP(1,ic),arr(ic,s32));arr&naxv=std::get<arr>(nax.v);A x;x.s=SHP(ic);',(⎕ucs 10),' B j=0;DOB(rr,if(!axm[i]){naxv((I)j)=i;x.s[ic-j-1]=r.s[rr-i-1];j++;})',(⎕ucs 10),' B xc=cnt(x);x.v=VEC<A>(xc);VEC<A>&xv=std::get<VEC<A>>(x.v);',(⎕ucs 10),' VEC<I> ixh(ic,0);A ix(SHP(1,ic),arr(ic,s32));arr&ixv=std::get<arr>(ix.v);',(⎕ucs 10),' DOB(xc,ixv=arr(ic,ixh.data());sqd_c(xv[i],ix,r,e,nax);',(⎕ucs 10),'  ixh[ic-1]++;DOB(ic-1,B j=ic-i-1;if(ixh[j]==x.s[i]){ixh[j-1]++;ixh[j]=0;}))',(⎕ucs 10),' z=x;}',(⎕ucs 10),'DF(par_f){err(16);}',(⎕ucs 10 10))
_,←,⊂('NM(mdv,"mdv",1,0,MT ,MFD,DFD,MT ,MT )',(⎕ucs 10),'DEFN(mdv)',(⎕ucs 10),'MF(mdv_f){B rr=rnk(r),rc=cnt(r);',(⎕ucs 10),' arr rv;CVSWITCH(r.v,err(6),rv=unrav(v,r.s),err(11))',(⎕ucs 10),' if(rr>2)err(4);if(rr==2&&r.s[1]<r.s[0])err(5);if(!rc)err(5);',(⎕ucs 10),' if(!rr||rc==1||r.s[0]==r.s[1]){z.s=r.s;z.v=flat(inverse(rv));R;}',(⎕ucs 10),' if(rr==1){z.v=flat(matmulNT(inverse(matmulTN(rv,rv)),rv));z.s=r.s;R;}',(⎕ucs 10),' arr zv=matmulTN(inverse(matmulNT(rv,rv)),rv);z.s=r.s;',(⎕ucs 10),' B k=z.s[0];z.s[0]=z.s[1];z.s[1]=k;z.v=flat(transpose(zv));}',(⎕ucs 10),'DF(mdv_f){B rr=rnk(r),lr=rnk(l),rc=cnt(r),lc=cnt(l);',(⎕ucs 10),' if(rr>2)err(4);if(lr>2)err(4);if(rr==2&&r.s[1]<r.s[0])err(5);',(⎕ucs 10),' if(!rc||!lc)err(5);if(rr&&lr&&l.s[lr-1]!=r.s[rr-1])err(5);',(⎕ucs 10),' arr rv;CVSWITCH(r.v,err(6),rv=unrav(v,r.s),err(11))',(⎕ucs 10),' arr lv;CVSWITCH(l.v,err(6),lv=unrav(v,l.s),err(11))',(⎕ucs 10),' if(rr==1)rv=transpose(rv);if(lr==1)lv=transpose(lv);',(⎕ucs 10),' z.v=flat(transpose(matmul(inverse(matmulNT(rv,rv)),matmulNT(rv,lv))));',(⎕ucs 10),' z.s=SHP((lr-(lr>0))+(rr-(rr>0)));',(⎕ucs 10),' if(lr>1)z.s[0]=l.s[0];if(rr>1)z.s[lr>1]=r.s[0];}',(⎕ucs 10))
_,←,⊂('NM(fft,"fft",1,0,MT ,MFD,MT ,MT ,MT )',(⎕ucs 10),'DEFN(fft)',(⎕ucs 10),'MF(fft_f){arr rv;CVSWITCH(r.v,err(6),rv=unrav(v,r.s),err(11))',(⎕ucs 10),' z.s=r.s;z.v=dft(rv.type()==c64?rv:rv.as(c64),1,rv.dims());}',(⎕ucs 10 10))
_,←,⊂('NM(ift,"ift",1,0,MT ,MFD,MT ,MT ,MT )',(⎕ucs 10),'DEFN(ift)',(⎕ucs 10),'MF(ift_f){arr rv;CVSWITCH(r.v,err(6),rv=unrav(v,r.s),err(11))',(⎕ucs 10),' z.s=r.s;z.v=idft(rv.type()==c64?rv:rv.as(c64),1,rv.dims());}',(⎕ucs 10 10))
_,←,⊂('template<class fncls> inline V msclfn(A&z,CA&r,ENV&e,FN&rec_c,fncls fn){',(⎕ucs 10),' z.s=r.s;',(⎕ucs 10),' CVSWITCH(r.v,err(6),fn(z,v,e)',(⎕ucs 10),'  ,B cr=cnt(r);z.v=VEC<A>(cr);VEC<A>&zv=std::get<VEC<A>>(z.v);',(⎕ucs 10),'   DOB(cr,rec_c(zv[i],v[i],e)))}',(⎕ucs 10),'template<class fncls> inline V sclfn(A&z,CA&l,CA&r,ENV&e,fncls fn){',(⎕ucs 10),' B lr=rnk(l),rr=rnk(r);',(⎕ucs 10),' if(lr==rr){DOB(rr,if(l.s[i]!=r.s[i])err(5));z.s=l.s;}',(⎕ucs 10),' else if(!lr){z.s=r.s;}else if(!rr){z.s=l.s;}else if(lr!=rr)err(4);',(⎕ucs 10),' std::visit(visitor{DVSTR(),',(⎕ucs 10),'   [&](CVEC<A>&lv,carr&rv){err(16);},',(⎕ucs 10),'   [&](carr&lv,CVEC<A>&rv){err(16);},',(⎕ucs 10),'   [&](CVEC<A>&lv,CVEC<A>&rv){err(16);},',(⎕ucs 10),'   [&](carr&lv,carr&rv){',(⎕ucs 10),'    if(lr==rr){fn(z,lv,rv,e);}',(⎕ucs 10),'    else if(!lr){fn(z,tile(lv,rv.dims()),rv,e);}',(⎕ucs 10),'    else if(!rr){fn(z,lv,tile(rv,lv.dims()),e);}}},',(⎕ucs 10),'  l.v,r.v);}',(⎕ucs 10),'inline V sclfn(A&z,CA&l,CA&r,ENV&e,CA&ax,FN&me_c){',(⎕ucs 10),' A a=l,b=r;I f=rnk(l)>rnk(r);if(f){a=r;b=l;}',(⎕ucs 10),' B ar=rnk(a),br=rnk(b);B d=br-ar;B rk=cnt(ax);if(rk!=ar)err(5);',(⎕ucs 10),' VEC<D> axd(rk);SHP axv(rk);',(⎕ucs 10),' if(rk)',(⎕ucs 10),'  CVSWITCH(ax.v',(⎕ucs 10),'   ,err(99,L"Unexpected value error.")',(⎕ucs 10),'   ,v.as(f64).host(axd.data())',(⎕ucs 10),'   ,err(99,L"Unexpected nested shape."))',(⎕ucs 10),' DOB(rk,if(axd[i]!=rint(axd[i]))err(11))DOB(rk,axv[i]=(B)axd[i])',(⎕ucs 10),' DOB(rk,if(axv[i]<0||br<=axv[i])err(11))',(⎕ucs 10),' VEC<B> t(br);VEC<U8> tf(br,1);DOB(rk,B j=axv[i];tf[j]=0;t[j]=d+i)',(⎕ucs 10),' B c=0;DOB(br,if(tf[i])t[i]=c++)A ta(SHP(1,br),arr(br,t.data()));',(⎕ucs 10),' trn_c(z,ta,b,e);rho_c(b,z,e);rho_c(a,b,a,e);',(⎕ucs 10),' if(f)me_c(b,z,a,e);else me_c(b,a,z,e);',(⎕ucs 10),' gdu_c(ta,ta,e);trn_c(z,ta,b,e);}',(⎕ucs 10))
_,←,⊂('NM(nst,"nst",0,0,MT ,MFD,MT ,MT ,MT )',(⎕ucs 10),'DEFN(nst)',(⎕ucs 10),'MF(nst_f){CVSWITCH(r.v,err(6),par_c(z,r,e),z=r)}',(⎕ucs 10))
_,←3⍴⊂''
rtn←_

_←⍬
_,←(,'+') (,'-') (,'×') (,'÷') (,'*') (,'⍟') (,'|') (,'○') (,'⌊') (,'⌈') (,'!') (,'<') (,'≤') (,'=') (,'≥') (,'>') (,'≠') (,'~') (,'∧') (,'∨') (,'⍲') (,'⍱') (,'⌷') (,'[') (,'⍳') (,'⍴') (,',') (,'⍪') (,'⌽') (,'⍉') (,'⊖') (,'∊')
_,←(,'⊃') (,'≡') (,'≢') (,'⊢') (,'⊣') (,'⊤') (,'⊥') (,'/') (,'⌿') (,'\') (,'⍀') (,'?') (,'↑') (,'↓') (,'¨') (,'⍨') (,'.') (,'⍤') (,'⍣') (,'∘') (,'∪') (,'∩') (,'←') (,'⍋') (,'⍒') '∘.' (,'⍷') (,'⊂') (,'⌹') '⎕FFT'
_,←'⎕IFFT' '%s' (,'⊆') (,'∇') (,';') '%u'
syms←_

⎕ex '_'

⍝ === End of variables definition ===

(⎕IO ⎕ML ⎕WX)←0 1 3

 CC←{
   vsbat←VS∆PATH,'\VC\Auxiliary\Build\vcvarsall.bat'
   tie←{0::⎕SIGNAL ⎕EN ⋄ 22::⍵ ⎕NCREATE 0 ⋄ 0 ⎕NRESIZE ⍵ ⎕NTIE 0}
   put←{s←(¯128+256|128+'UTF-8'⎕UCS ⍺)⎕NAPPEND(t←tie ⍵)83 ⋄ 1:r←s⊣⎕NUNTIE t}
   opsys←{⍵⊃⍨'Win' 'Lin' 'Mac'⍳⊂3↑⊃'.'⎕WG'APLVersion'}
   soext←{opsys'.dll' '.so' '.dylib'}
   ccf←{' -o ''',⍵,'.',⍺,''' ''',⍵,'.cpp'' -laf',AF∆LIB,' > ',⍵,'.log 2>&1'}
   cci←{'-I''',AF∆PREFIX,'/include'' -L''',AF∆PREFIX,opsys''' ' '/lib64'' ' '/lib'' '}
   cco←'-std=c++17 -Ofast -g -Wall -fPIC -shared -Wno-parentheses '
   cco,←'-Wno-misleading-indentation '
   ucc←{⍵⍵(⎕SH ⍺⍺,' ',cco,cci,ccf)⍵}
   gcc←'g++'ucc'so'
   clang←'clang++'ucc'dylib'
   vsco←{z←'/W3 /wd4102 /wd4275 /O2 /Zc:inline /Zi /FS /Fd"',⍵,'.pdb" '
     z,←'/WX /MD /EHsc /nologo /std:c++latest '
     z,'/I"%AF_PATH%\include" /D "NOMINMAX" /D "AF_DEBUG" '}
   vslo←{z←'/link /DLL /OPT:REF /INCREMENTAL:NO /SUBSYSTEM:WINDOWS '
     z,←'/LIBPATH:"%AF_PATH%\lib" /OPT:ICF /ERRORREPORT:PROMPT /TLBID:1 '
     z,'/DYNAMICBASE "af',AF∆LIB,'.lib" "codfns.lib" '}
   vsc0←{~⎕NEXISTS vsbat:'VISUAL C++?'⎕SIGNAL 99 ⋄ '""',vsbat,'" amd64'}
   vsc1←{' && cd "',(⊃⎕CMD'echo %CD%'),'" && cl ',(vsco ⍵),' "',⍵,'.cpp" '}
   vsc2←{(vslo ⍵),'/OUT:"',⍵,'.dll" > "',⍵,'.log""'}
   vsc←{⎕CMD('%comspec% /C ',vsc0,vsc1,vsc2)⍵}
   _←(⍎opsys'vsc' 'gcc' 'clang')⍺⊣⍵ put ⍺,'.cpp'⊣1 ⎕NDELETE f←⍺,soext ⍬
   ⎕←⍪⊃⎕NGET(⍺,'.log')1
   ⎕NEXISTS f:f ⋄ 'COMPILE ERROR'⎕SIGNAL 22}

 D2P←{0=≢⍵:⍬ ⋄ p⊣2{p[⍵]←⍺[⍺⍸⍵]}⌿⊢∘⊂⌸⍵⊣p←⍳≢⍵}

 Fix←{n NS{⍵⊣⍞←'L'}⍺ CC{⍵⊣⍞←'B'}GC{⍵⊣⍞←'G'}TT{⍵⊣⍞←'C'}a n s src←PS ⍵⊣⍞←'P'}

 GC←{p t k n fr sl rf fd xn sym←⍵ ⋄ A B C E F G K L M N O P S V Z←1+⍳15
     ⍝ Parameters
     ⍝  deps  Dependencies for each symbol in syms
     ⍝  nams  Name codes for each symbol in syms
     ⍝  P2D   Converter Parent vector to depth vector
     ⍝  rth   Runtime header for all modules
     ⍝  rtn   Runtime code for each symbol in syms
     ⍝  syms  Core instruction set of generated code
   gck←(A 1)(A 6)
   gcv←'Aa' 'As'
   gck,←(B 1)(B 2)(B 3)(B 4)
   gcv,←'Bv' 'Bf' 'Bo' 'Bo'
   gck,←(E ¯2)(E ¯1)(E 0)(E 1)(E 2)(E 4)(E 6)
   gcv,←'Ec' 'Ek' 'Er' 'Em' 'Ed' 'Eb' 'Ei'
   gck,←(F 0)(F 2)(F 3)(F 4)
   gcv,←'Fz' 'Fn' 'Fn' 'Fn'
   gck,←(G 0)(N 1)
   gcv,←'Gd' 'Na'
   gck,←(O 1)(O 2)(O 4)(O 5)(O 7)(O 8)
   gcv,←'Ov' 'Of' 'Ovv' 'Ofv' 'Ovf' 'Off'
   gck,←(P 0)(P 1)(P 2)(P 3)(P 4)
   gcv,←'Pv' 'Pv' 'Pf' 'Po' 'Po'
   gck,←(V 0)(V 1)(V 2)(V 3)(V 4)
   gcv,←'Va' 'Va' 'Vf' 'Vo' 'Vo'
   gcv,←⊂'{''/* Unhandled '',(⍕⍺),'' */'',NL}'
   NL←⎕UCS 13 10
     
   xi←⍸(t=B)∧k[rf]=0 ⋄ d i←P2D p
   I←{(⊂⍵)⌷⍺} ⋄ com←{⊃{⍺,',',⍵}/⍵} ⋄ ks←{⍵⊂[0]⍨(⊃⍵)=⍵[;0]}
   nam←{'∆'⎕R'__'∘⍕¨sym[|⍵]} ⋄ slt←{'(*e[',(⍕6⊃⍵),'])[',(⍕7⊃⍵),']'}
   ast←(⍉↑d p t k n(⍳≢p)fr sl fd)[i;]
   Aa←{0=≢ns←dis¨⍵:'PUSH(A(SHP(1,0),scl(0)));',NL
     1=≢ns:'PUSH(scl(scl(',(⊃ns),')));',NL
     c←⍕≢⍵ ⋄ v←'VEC<',('DI'⊃⍨∧.=∘⌊⍨⍎¨ns),'>{',(com ns),'}.data()'
     'PUSH(A(SHP(1,',c,'),arr(',c,',',v,')));',NL}
   As←{c←⍕4⊃⍺ ⋄ z←'{A z(SHP(1,',c,'),VEC<A>(',c,'));',NL
     z,←'  VEC<A>&zv=std::get<VEC<A>>(z.v);',NL
     z,'  DOB(',c,',POP(A,zv[i]))coal(z);PUSH(z);}',NL}
   Bf←{'(*e[fd])[',(⍕4⊃⍺),']=s.top();',NL}
   Bv←{'(*e[fd])[',(⍕4⊃⍺),']=s.top();',NL}
   Bo←{'(*e[fd])[',(⍕4⊃⍺),']=s.top();',NL}
   Eb←{z←'{A x,y;FNP f;POP(A,x);POP(FNP,f);POP(A,y);'
     z,'(*f)(std::get<A>(',(slt ⍺),'),x,y,e);PUSH(y);}',NL}
   Ed←{z←'{A z,x,y;FNP f;POP(A,x);POP(FNP,f);POP(A,y);'
     z,'(*f)(z,x,y,e);PUSH(z);}',NL}
   Ei←{c←⍕4⊃⍺ ⋄ z←'{A x(SHP(1,',c,'),VEC<A>(',c,'));'
     z,'VEC<A>&v=std::get<VEC<A>>(x.v);DOB(',c,',POP(A,v[i]));PUSH(x);}',NL}
   Ek←{'s.pop();',NL}
   Em←{'{A z,x;FNP f;POP(FNP,f);POP(A,x);(*f)(z,x,e);PUSH(z);}',NL}
   Er←{'POP(A,z);e[fd]=std::move(of);R;',NL}
   Fn←{z←NL,'DF(',('fn',⍕5⊃⍺),'_','fffoo'[3⊃⍺],'){U fd=',(⍕8⊃⍺),';STK s;',NL
     z,←' if(e.size()<=fd)e.resize(fd+1);',NL
     z,←' FRMP of=std::move(e[fd]);e[fd]=std::make_unique<FRM>(',(⍕4⊃⍺),');',NL
     z,←' try{',NL
     do←{'(*e[fd])[',(⍕n[⍵]),']=(*e[',(⍕fr[⍵]),'])[',(⍕sl[⍵]),'];',NL}
     z,←⊃,⌿(do¨⍸(p=5⊃⍺)∧(t=B)∧fr≠¯1),' ',¨dis¨⍵
     z,←' }catch(U x){e[fd]=std::move(of);throw x;}',NL
     z,←' catch(exception&x){e[fd]=std::move(of);throw x;}',NL
     z,' e[fd]=std::move(of);}',NL}
   Fz←{z←NL,'ENV e',(⍕5⊃⍺),'(1);I is',(⍕5⊃⍺),'=0;',NL
     z,←'DF(',('fn',⍕5⊃⍺),'_f){if(is0)R;','' 'I fd=0;'⊃⍨×≢⍵
     z,←'STK s;e[0]=std::make_unique<FRM>(',(⍕4⊃⍺),');',NL
     z,(⊃,⌿' ',¨dis¨⍵),' is0=1;}',NL,NL}
   Gd←{z←'{A x;POP(A,x);if(cnt(x)!=1)err(5);',NL
     z,←' if(!(isint(x)||isbool(x)))err(11);',NL
     z,←' I t;CVSWITCH(x.v,err(6),t=v.as(s32).scalar<I>(),err(11))',NL
     z,←' if(t!=0&&t!=1)err(11);',NL
     z,' if(t){',NL,(⊃,/' ',¨dis¨⍵),' }}',NL}
   Na←{'¯'⎕R'-'⍕sym⌷⍨|4⊃⍺}
   Ov←{z←'{A x;MOKP o;POP(A,x);POP(MOKP,o);'
     z,'FNP f=(*o)(x);f->this_p=f;PUSH(f);}',NL}
   Of←{z←'{FNP f,g;MOKP o;POP(FNP,g);POP(MOKP,o);'
     z,'f=(*o)(g);f->this_p=f;PUSH(f);}',NL}
   Ovv←{z←'{A x,y;DOKP o;POP(A,x);POP(DOKP,o);POP(A,y);'
     z,'FNP f=(*o)(x,y);f->this_p=f;PUSH(f);}',NL}
   Ovf←{z←'{A x;FNP f,g;DOKP o;POP(A,x);POP(DOKP,o);POP(FNP,g);'
     z,'f=(*o)(x,g);f->this_p=f;PUSH(f);}',NL}
   Ofv←{z←'{A x;FNP f,g;DOKP o;POP(FNP,g);POP(DOKP,o);POP(A,x);'
     z,'f=(*o)(g,x);f->this_p=f;PUSH(f);}',NL}
   Off←{z←'{FNP f,g,h;DOKP o;POP(FNP,g);POP(DOKP,o);POP(FNP,h);'
     z,'f=(*o)(g,h);f->this_p=f;PUSH(f);}',NL}
   Pf←{(x←4⊃⍺)∊-1+⍳4:'PUSH(',(,'r' 'l' 'llp' 'rrp'⊃⍨¯1+|x),');',NL
     'PUSH(',(nams⊃⍨syms⍳sym⌷⍨|4⊃⍺),'_p);',NL}
   Po←{'PUSH(std::make_shared<',(nams⊃⍨syms⍳sym⌷⍨|4⊃⍺),'_k>());',NL}
   Pv←{'PUSH(A());',NL}
   Va←{(x←4⊃⍺)∊-1+⍳4:'PUSH(',(,'r' 'l' 'aa' 'ww'⊃⍨¯1+|x),');',NL
     'PUSH(',(slt ⍺),');',NL}
   Vf←{0>x←4⊃⍺:'PUSH(',(slt ⍺),');',NL
     'fn',(⍕x),'_p->this_p=fn',(⍕x),'_p;PUSH(fn',(⍕x),'_p);',NL}
   Vo←{0>x←4⊃⍺:'PUSH(',(slt ⍺),');',NL
     'PUSH(std::make_shared<fn',(⍕x),'_k>());',NL}
   Zf←{z←'NM(',⍵,',"',⍵,'",0,0,MT,MFD,DFD,MT,MT)',NL
     z,'DEFN(',⍵,')',NL,'MF(',⍵,'_f){this_c(z,A(),r,e);}',NL}
   Zm←{z←'OM(',⍵,',"',⍵,'",0,0,MFD,DFD,MT,MT)',NL
     z,'MF(',⍵,'_o){this_c(z,A(),r,e);}',NL}
   Zd←{z←'OD(',⍵,',"',⍵,'",0,0,MFD,DFD,MT,MT)',NL
     z,'MF(',⍵,'_o){this_c(z,A(),r,e);}',NL}
   Zp←{n←'fn',⍕⍵ ⋄ k[⍵]∊0 2:Zf n ⋄ k[⍵]=3:Zm n ⋄ k[⍵]=4:Zd n
     NOTFOUND t[⍵],k[⍵]}
   NOTFOUND←{('[GC] UNSUPPORTED NODE TYPE ',N∆[⊃⍵],⍕⊃⌽⍵)⎕SIGNAL 16}
   dis←{0=2⊃h←,1↑⍵:'' ⋄ (≢gck)=i←gck⍳⊂h[2 3]:NOTFOUND h[2 3] ⋄ h(⍎i⊃gcv)ks 1↓⍵}
   z←'#include "codfns.h"',NL,,/Zp¨⍸t=F
   z←(⊂rth),(rtn[syms⍳{∪⊃,/(deps,⊂⍬)[syms⍳⍵]}⍣≡sym]),,/Zp¨⍸t=F
   z,←dis¨ks ast
   z,←'E',¨('?VFOO'[k[xi]]),¨'(',¨(⍕¨rf[xi]),¨',',¨(nam xn),¨',',¨(⍕¨n[xi]),¨')',¨⊂NL
   ⊃,⌿z}

∇ Z←Help _
 Z←'Usage: <object> <target> [-af={cpu,opencl,cuda}]'
∇

∇ r←List
 r←⎕NS¨1⍴⊂⍬ ⋄ r.Name←,¨⊂'Compile' ⋄ r.Group←⊂'CODFNS'
 r[0].Desc←'Compile an object using Co-dfns'
 r.Parse←⊂'2S -af=cpu opencl cuda '
∇

 NS←{
   MKA←{mka⊂⍵} ⋄ EXA←{exa ⍬ ⍵}
   Display←{⍺←'Co-dfns' ⋄ W←w_new⊂⍺ ⋄ 777::w_del W
     w_del W⊣W ⍺⍺{w_close ⍺:⍎'⎕SIGNAL 777' ⋄ ⍺ ⍺⍺ ⍵}⍣⍵⍵⊢⍵}
   LoadImage←{⍺←1 ⋄ ~⎕NEXISTS ⍵:⎕SIGNAL 22 ⋄ loadimg ⍬ ⍵ ⍺}
   SaveImage←{⍺←'image.png' ⋄ saveimg ⍵ ⍺}
   Image←{~2 3∨.=≢⍴⍵:⎕SIGNAL 4 ⋄ (3≠⊃⍴⍵)∧3=≢⍴⍵:⎕SIGNAL 5 ⋄ ⍵⊣w_img ⍵ ⍺}
   Plot←{2≠≢⍴⍵:⎕SIGNAL 4 ⋄ ~2 3∨.=1⊃⍴⍵:⎕SIGNAL 5 ⋄ ⍵⊣w_plot(⍉⍵)⍺}
   Histogram←{⍵⊣w_hist ⍵,⍺}
   Rtm∆Init←{
     _←'w_new'⎕NA'P ',⍵,'|w_new   <C[]'
     _←'w_close'⎕NA'I ',⍵,'|w_close P'
     _←'w_del'⎕NA ⍵,'|w_del   P'
     _←'w_img'⎕NA ⍵,'|w_img   <PP P'
     _←'w_plot'⎕NA ⍵,'|w_plot  <PP P'
     _←'w_hist'⎕NA ⍵,'|w_hist  <PP F8   F8 P'
     _←'loadimg'⎕NA ⍵,'|loadimg >PP <C[] I'
     _←'saveimg'⎕NA ⍵,'|saveimg <PP <C[]'
     _←'exa'⎕NA ⍵,'|exarray >PP P'
     _←'mka'⎕NA'P ',⍵,'|mkarray <PP'
     _←'FREA'⎕NA ⍵,'|frea    P'
     _←'Sync'⎕NA ⍵,'|cd_sync'
     0 0⍴⍬}
   mkna←{⍺,'|',('∆'⎕R'__'⊢⍵),'_cdf P P P'}
   mkf←{fn←⍺,'|',('∆'⎕R'__'⊢⍵),'_dwa ' ⋄ mon dya←⍵∘,¨'_mon' '_dya'
     z←('Z←{A}',⍵,' W')(':If 0=⎕NC''⍙.',mon,'''')
     z,←(mon dya{'''',⍺,'''⍙.⎕NA''',fn,⍵,' <PP'''}¨'>PP P' '>PP <PP'),⊂':EndIf'
     z,':If 0=⎕NC''A'''('Z←⍙.',mon,' 0 0 W')':Else'('Z←⍙.',dya,' 0 A W')':EndIf'}
   ns←#.⎕NS ⍬ ⋄ _←'∆⍙'ns.⎕NS¨⊂⍬ ⋄ ∆ ⍙←ns.(∆ ⍙) ⋄ ∆.names←(0⍴⊂''),(2=1⊃⍺)⌿0⊃⍺
   fns←'Rtm∆Init' 'MKA' 'EXA' 'Display' 'LoadImage' 'SaveImage' 'Image' 'Plot'
   fns,←'Histogram' 'soext' 'opsys' 'mkna'
   _←∆.⎕FX∘⎕CR¨fns ⋄ ∆.(decls←⍵∘mkna¨names) ⋄ _←ns.⎕FX¨(⊂''),⍵∘mkf¨∆.names
   _←∆.⎕FX'Z←Init'('Z←Rtm∆Init ''',⍵,'''')'→0⌿⍨0=≢names' 'names ##.⍙.⎕NA¨decls'
   ns}

 P2D←{z←⍪⍳≢⍵ ⋄ d←⍵≠,z ⋄ _←{p⊣d+←⍵≠p←⍺[z,←⍵]}⍣≡⍨⍵ ⋄ d(⍋(-1+d)↑⍤0 1⊢⌽z)}

 PS←{IN←⍵ ⋄ A B C E F G K L M N O P S V Z←1+⍳15
   I←{(⊂⍵)⌷⍺} ⋄ U←{0=⎕NC'⍺':⍵⍵⍣¯1 ⍺⍺ ⍵⍵ ⍵ ⋄ ⍵⍵⍣¯1⊢(⍵⍵ ⍺)⍺⍺ ⍵⍵ ⍵}
   assert←{⍺←'assertion failure' ⋄ 0∊⍵:⍎'⍺ ⎕SIGNAL 8' ⋄ shy←0}
     
   1<≢⍴IN:'PARSER REQUIRES A SCALAR/VECTOR INPUT'⎕SIGNAL 11
   2<|≡IN:'PARSER REQUIRES A SIMPLE OR VECTOR OF VECTOR INPUT'⎕SIGNAL 11
   IN←∊(⊆IN),¨⎕UCS 10
   0≠10|⎕DR IN:'PARSER REQUIRES A CHARACTER ARRAY'⎕SIGNAL 11
     
     ⍝ Line and error reporting utilities
   CR LF←⎕UCS 13 10
   linestarts←(⍸1⍪2>⌿IN∊CR LF)⍪≢IN
   mkdm←{⍺←2 ⋄ line←linestarts⍸⍵ ⋄ no←'[',(⍕1+line),'] '
     i←(~IN[i]∊CR LF)⌿i←beg+⍳linestarts[line+1]-beg←linestarts[line]
     (⎕EM ⍺)(no,IN[i])(' ^'[i∊⍵],⍨' '⍴⍨≢no)}
   quotelines←{
     lines←∪linestarts⍸⍵
     nos←(1 0⍴⍨2×≢lines)⍀'[',(⍕⍪1+lines),⍤1⊢'] '
     beg←linestarts[lines] ⋄ end←linestarts[lines+1]
     m←∊∘⍵¨i←beg+⍳¨end-beg
     ¯1↓∊nos,(~∘CR LF¨⍪,(IN∘I¨i),⍪' ▔'∘I¨m),CR}
   SIGNAL←{⍺←2 '' ⋄ en msg←⍺ ⋄ EN∘←en ⋄ DM∘←en mkdm⊃⍵
     dmx←('EN'en)('Category' 'Compiler')('Vendor' 'Co-dfns')
     dmx,←⊂'Message'(msg,CR,quotelines ⍵)
     ⎕SIGNAL⊂dmx}
     
     ⍝ Group input into lines as a nested vector
   pos←(⍳≢IN)⊆⍨~IN∊CR LF
     
     ⍝ Mask strings
   0≠≢lin←⍸⊃∘⌽¨msk←≠⍀¨''''=IN∘I¨pos:{
     EM←'SYNTAX ERROR: UNBALANCED STRING',('S'⌿⍨2≤≢lin),CR
     EM,←quotelines∊(msk⌿¨pos)[lin]
     EM ⎕SIGNAL 2}⍬
     
     ⍝ Remove comments
   pos msk⌿¨⍨←⊂∧⍀¨(~msk←msk∨¯1⌽¨msk)⍲'⍝'=IN∘I¨pos
     
     ⍝ Remove leading and trailing whitespace
   WS←⎕UCS 9 32 ⋄ pos msk⌿¨⍨←⊂~(∧⍀∨∧⍀U⌽)∘(WS∊⍨IN∘I)¨pos
     
     ⍝ Flatten and separate lines and ⋄ with Z type
   t←⊃0⍴⊂pos ⋄ t pos msk(∊,∘⍪⍨)←Z(⊃¨pos)0 ⋄ t[⍸'⋄'=IN[pos]]←Z
     
     ⍝ Tokenize Strings
   end←1+pos ⋄ t[i←⍸2<⌿0⍪msk]←C ⋄ end[i]←end[⍸2>⌿msk⍪0]
   t pos end⌿⍨←⊂(t≠0)∨~msk
     
     ⍝ Verify that all open characters are part of the valid character set
   alp←'ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz'
   alp,←'ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝßàáâãäåæçèéêëìíîïðñòóôõöøùúûüþ'
   alp,←'∆⍙ⒶⒷⒸⒹⒺⒻⒼⒽⒾⒿⓀⓁⓂⓃⓄⓅⓆⓇⓈⓉⓊⓋⓌⓍⓎⓏ'
   num←⎕D
   synb←'¯[]{}()'':⍺⍵⋄;'
   syna←'⍬⎕⍞#'
   prmfs←'+-×÷|⌈⌊*⍟○!?~∧∨⍲⍱<≤=>≥≠≡≢⍴,⍪⌽⊖⍉↑↓⊂⊆⊃∊⍷∩∪⍳⍸⌷⍋⍒⍎⍕⊥⊤⊣⊢⌹∇←→'
   prmdo←'∘.⍣⍠⌺⍤⍥@' ⋄ prmmo←'¨⍨&⌶⌸' ⋄ prmfo←'/⌿\⍀'
   prms←prmfs,prmdo,prmmo,prmfo
   x←' '@{t≠0}IN[pos] ⍝ The spaces produce nice invariants
   ∨⌿msk←~x∊alp,num,syna,synb,prms,WS:{
     EM←'SYNTAX ERROR: INVALID CHARACTER(S) IN SOURCE',CR
     EM,←quotelines⍸msk
     EM ⎕SIGNAL 2}⍬
     
     ⍝ Tokenize numbers
   _←{dm[⍵]←∧⍀dm[⍵]}¨(dm∨x∊alp)⊆⍳≢dm←x∊num
   dm∨←('.'=x)∧(¯1⌽dm)∨1⌽dm
   dm∨←('¯'=x)∧1⌽dm
   dm∨←(x∊'EeJj')∧(¯1⌽dm)∧1⌽dm
   ∨⌿msk←(dm=0)∧x='¯':2 'ORPHANED ¯'SIGNAL pos⌿⍨msk
   ∨⌿{1<+⌿⍵='j'}¨dp←⎕C¨dm⊆x:'MULTIPLE J IN NUMBER'⎕SIGNAL 2
   ∨⌿{1<+⌿⍵='e'}¨dp←⊃⍪/{⍵⊆⍨⍵≠'j'}¨dp:'MULTIPLE E IN NUMBER'⎕SIGNAL 2
   ∨⌿'e'=⊃¨dp:'MISSING MANTISSA'⎕SIGNAL 2
   ∨⌿'e'=⊃∘⌽¨dp:'MISSING EXPONENT'⎕SIGNAL 2
   mn ex←↓⍉↑{2↑(⍵⊆⍨⍵≠'e'),⊂''}¨dp
   ∨⌿{1<+⌿'.'=⍵}¨mn,ex:'MULTIPLE . IN NUMBER'⎕SIGNAL 2
   ∨⌿'.'∊¨ex:'REAL NUMBER IN EXPONENT'⎕SIGNAL 2
   ∨⌿{∨⌿1↓⍵∊'¯'}¨mn,ex:'MISPLACED ¯'⎕SIGNAL 2
   t[i←⍸2<⌿0⍪dm]←N ⋄ end[i]←end⌿⍨2>⌿dm⍪0
     
     ⍝ Tokenize Variables
   t[i←⍸2<⌿0⍪vm←(~dm)∧x∊alp,num]←V ⋄ end[i]←end⌿⍨2>⌿vm⍪0
     
     ⍝ Tokenize ⍺, ⍵ formals
   fm←{mm←⌽⊃(>∘⊃,⊢)⌿⌽m←⍺=' ',⍵ ⋄ 1↓¨(mm∧~m1)(mm∧m1←1⌽m)}
   am aam←'⍺'fm x ⋄ wm wwm←'⍵'fm x
   ((am∨wm)⌿t)←A ⋄ ((aam∨wwm)⌿t)←P ⋄ ((aam∨wwm)⌿end)←end⌿⍨¯1⌽aam∨wwm
     
     ⍝ Tokenize Primitives, Atoms
   t[⍸(~dm)∧x∊prms]←P ⋄ t[⍸x∊syna]←A
     
     ⍝ Compute dfns regions and type, include } as a child
   t[⍸'{'=x]←F ⋄ 0≠⊃d←¯1⌽+⍀1 ¯1 0['{}'⍳x]:'UNBALANCED DFNS'⎕SIGNAL 2
     
     ⍝ Check for out of context dfns formals
   ∨⌿(d=0)∧(t=P)∧IN[pos]∊'⍺⍵':'DFN FORMAL REFERENCED OUTSIDE DFNS'⎕SIGNAL 2
     
     ⍝ Compute trad-fns regions
   ∨⌿Z≠t⌿⍨1⌽msk←(d=0)∧'∇'=x:'TRAD-FNS START/END LINES MUST BEGIN WITH ∇'⎕SIGNAL 2
   0≠⊃tm←¯1⌽≠⍀(d=0)∧'∇'=x:'UNBALANCED TRAD-FNS'⎕SIGNAL 2
   ∨⌿Z≠t⌿⍨⊃1 ¯1∨.⌽⊂(2>⌿tm)⍪0:'TRAD-FNS END LINE MUST CONTAIN ∇ ALONE'⎕SIGNAL 2
     
     ⍝ Identify Label colons versus others
   t[⍸tm∧(d=0)∧∊((~⊃)∧(<⍀∨⍀))¨':'=(t=Z)⊂IN[pos]]←L
     
     ⍝ Tokenize Keywords
   ki←⍸(t=0)∧(d=0)∧(':'=IN[pos])∧1⌽t=V
   t[ki]←K ⋄ end[ki]←end[ki+1] ⋄ t[ki+1]←0
   ERR←'EMPTY COLON IN NON-DFNS CONTEXT, EXPECTED LABEL OR KEYWORD'
   ∨⌿(t=0)∧(d=0)∧':'=IN[pos]:ERR ⎕SIGNAL 2
     
     ⍝ Tokenize System Variables
   si←⍸('⎕'=IN[pos])∧1⌽t=V
   t[si]←S ⋄ end[si]←end[si+1] ⋄ t[si+1]←0
     
     ⍝ Delete all characters we no longer need from the tree
   d tm t pos end(⌿⍨)←⊂(t≠0)∨x∊'()[]{}:;'
     
     ⍝ Tokenize Labels
   ERR←'LABEL MUST CONSIST OF A SINGLE NAME'
   ∨⌿(Z≠t[li-1])∨(V≠t[li←⍸1⌽msk←t=L]):ERR ⎕SIGNAL 2
   t[li]←L ⋄ end[li]←end[li+1]
   d tm t pos end(⌿⍨)←⊂~msk
     
     ⍝ Now that all compound data is tokenized, reify n field before tree-building
   n←{1↓⍎¨'0',⍵}@{t=N}(⊂'')@{t∊Z F}1 ⎕C@{t∊K S}IN∘I¨pos+⍳¨end-pos
     
     ⍝ Verify that keywords are defined and scoped correctly
   KW←'NAMESPACE' 'ENDNAMESPACE' 'END' 'IF' 'ELSEIF' 'ANDIF' 'ORIF' 'ENDIF'
   KW,←'WHILE' 'ENDWHILE' 'UNTIL' 'REPEAT' 'ENDREPEAT' 'LEAVE' 'FOR' 'ENDFOR'
   KW,←'IN' 'INEACH' 'SELECT' 'ENDSELECT' 'CASE' 'CASELIST' 'ELSE' 'WITH'
   KW,←'ENDWITH' 'HOLD' 'ENDHOLD' 'TRAP' 'ENDTRAP' 'GOTO' 'RETURN' 'CONTINUE'
   KW,←'SECTION' 'ENDSECTION' 'DISPOSABLE' 'ENDDISPOSABLE'
   KW,¨⍨←':'
   msk←~KW∊⍨kws←n⌿⍨km←t=K
   ∨⌿msk:('UNRECOGNIZED KEYWORD ',kws⊃⍨⊃⍸msk)⎕SIGNAL 2
   msk←kws∊':NAMESPACE' ':ENDNAMESPACE'
   ∨⌿msk∧km⌿tm:'NAMESPACE SCRIPTS MUST APPEAR AT THE TOP LEVEL'⎕SIGNAL 2
   msk←kws∊KW~':NAMESPACE' ':ENDNAMESPACE' ':SECTION' ':ENDSECTION'
   ∨⌿msk←msk∧~km⌿tm:{msg←2 'STRUCTURED STATEMENTS MUST APPEAR WITHIN TRAD-FNS'
     msg SIGNAL∊{x+⍳end[⍵]-x←pos[⍵]}¨⍸km⍀msk}⍬
     
     ⍝ Verify system variables are valid
   SYSV←,¨'Á' 'A' 'AI' 'AN' 'AV' 'AVU' 'BASE' 'CT' 'D' 'DCT' 'DIV' 'DM'
   SYSV,←,¨'DMX' 'EXCEPTION' 'FAVAIL' 'FNAMES' 'FNUMS' 'FR' 'IO' 'LC' 'LX'
   SYSV,←,¨'ML' 'NNAMES' 'NNUMS' 'NSI' 'NULL' 'PATH' 'PP' 'PW' 'RL' 'RSI'
   SYSV,←,¨'RTL' 'SD' 'SE' 'SI' 'SM' 'STACK' 'TC' 'THIS' 'TID' 'TNAME' 'TNUMS'
   SYSV,←,¨'TPOOL' 'TRACE' 'TRAP' 'TS' 'USING' 'WA' 'WSID' 'WX' 'XSI'
   SYSF←,¨'ARBIN' 'ARBOUT' 'AT' 'C' 'CLASS' 'CLEAR' 'CMD' 'CR' 'CS' 'CSV'
   SYSF,←,¨'CY' 'DF' 'DL' 'DQ' 'DR' 'DT' 'ED' 'EM' 'EN' 'EX' 'EXPORT'
   SYSF,←,¨'FAPPEND' 'FCHK' 'FCOPY' 'FCREATE' 'FDROP' 'FERASE' 'FFT' 'IFFT'
   SYSF,←,¨'FHIST' 'FHOLD' 'FIX' 'FLIB' 'FMT' 'FPROPS' 'FRDAC' 'FRDCI' 'FREAD'
   SYSF,←,¨'FRENAME' 'FREPLACE' 'FRESIZE' 'FSIZE' 'FSTAC' 'FSTIE' 'FTIE'
   SYSF,←,¨'FUNTIE' 'FX' 'INSTANCES' 'JSON' 'KL' 'LOAD' 'LOCK' 'MAP' 'MKDIR'
   SYSF,←,¨'MONITOR' 'NA' 'NAPPEND' 'NC' 'NCOPY' 'NCREATE' 'NDELETE' 'NERASE'
   SYSF,←,¨'NEW' 'NEXISTS' 'NGET' 'NINFO' 'NL' 'NLOCK' 'NMOVE' 'NPARTS'
   SYSF,←,¨'NPUT' 'NQ' 'NR' 'NREAD' 'NRENAME' 'NREPLACE' 'NRESIZE' 'NS'
   SYSF,←,¨'NSIZE' 'NTIE' 'NUNTIE' 'NXLATE' 'OFF' 'OR' 'PFKEY' 'PROFILE'
   SYSF,←,¨'REFS' 'SAVE' 'SH' 'SHADOW' 'SIGNAL' 'SIZE' 'SR' 'SRC' 'STATE'
   SYSF,←,¨'STOP' 'SVC' 'SVO' 'SVQ' 'SVR' 'SVS' 'TCNUMS' 'TGET' 'TKILL' 'TPUT'
   SYSF,←,¨'TREQ' 'TSYNC' 'UCS' 'VR' 'VFI' 'WC' 'WG' 'WN' 'WS' 'XML' 'XT'
   SYSD←,¨'OPT' 'R' 'S'
   ∨⌿msk←(t=S)∧~n∊'⎕',¨SYSV,SYSF,SYSD:{
     ERR←2 'INVALID SYSTEM VARIABLE, FUNCTION, OR OPERATOR'
     ERR SIGNAL∊pos[⍵]{⍺+⍳⍵-⍺}¨end[⍵]
   }⍸msk
     
     ⍝ Compute parent vector from d
   p←D2P d
     
     ⍝ Compute nameclass of dfns
   k←2×t∊F ⋄ k[∪p⌿⍨(t=P)∧n∊⊂'⍺⍺']←3 ⋄ k[∪p⌿⍨(t=P)∧n∊⊂'⍵⍵']←4
     
     ⍝ We will often wrap a set of nodes as children under a Z node
   gz←{z←⍵↑⍨-0≠≢⍵ ⋄ ks←¯1↓⍵
     t[z]←Z ⋄ p[ks]←⊃z ⋄ pos[z]←pos[⊃⍵] ⋄ end[z]←end[⊃⌽z,ks] ⋄ z}
     
     ⍝ Nest top-level root lines as Z nodes
   _←(gz 1⌽⊢)¨(t[i]=Z)⊂i←⍸d=0
   'Non-Z top-level node'assert t[⍸p=⍳≢p]=Z:
     
     ⍝ Nest all dfns expression bodies as Z nodes
   _←p[i]{end[⍺]←end[⊃⌽⍵] ⋄ gz¨⍵⊂⍨1,¯1↓t[⍵]=Z}⌸i←⍸t[p]=F
   'Non-Z dfns body node'assert t[⍸t[p]=F]=Z:
     
     ⍝ Drop/eliminate any Z nodes that are empty or blank
   _←p[i]{msk[⍺,⍵]←~∧⌿IN[pos[⍵]]∊WS}⌸i←⍸(t[p]=Z)∧p≠⍳≢p⊣msk←t≠Z
   tm n t k pos end(⌿⍨)←⊂msk ⋄ p←(⍸~msk)(⊢-1+⍸)msk⌿p
     
     ⍝ Parse Keyword structures
   nss←n∊⊂':NAMESPACE' ⋄ nse←n∊⊂':ENDNAMESPACE'
   ERR←':NAMESPACE KEYWORD MAY ONLY APPEAR AT BEGINNING OF A LINE'
   Z∨.≠t⌿⍨1⌽nss:ERR ⎕SIGNAL 2
   ERR←'NAMESPACE DECLARATION MAY HAVE ONLY A NAME OR BE EMPTY'
   ∨⌿(Z≠t⌿⍨¯1⌽nss)∧(V≠t⌿⍨¯1⌽nss)∨Z≠t⌿⍨¯2⌽nss:ERR ⎕SIGNAL 2
   ERR←':ENDNAMESPACE KEYWORD MUST APPEAR ALONE ON A LINE'
   ∨⌿Z≠t⌿⍨⊃1 ¯1∨.⌽⊂nse:ERR ⎕SIGNAL 2
   t[nsi←⍸1⌽nss]←M ⋄ t[nei←⍸1⌽nse]←-M
   n[i]←n[1+i←⍸(t=M)∧V=1⌽t] ⋄ end[nsi]←end[nei]
   x←⍸p=⍳≢p ⋄ d←+⍀(t[x]=M)+-t[x]=-M
   0≠⊃⌽d:':NAMESPACE KEYWORD MISSING :ENDNAMESPACE PAIR'⎕SIGNAL 2
   p[x]←x[D2P ¯1⌽d]
     
     ⍝ Delete unnecessary namespace nodes from the tree, leave only M's
   msk←~nss∨((¯1⌽nss)∧t=V)∨nse∨1⌽nse
   t k n pos end⌿⍨←⊂msk ⋄ p←(⍸~msk)(⊢-1+⍸)msk⌿p
     
     ⍝ PARSE LABELS ∘∘∘
     
     ⍝ Map guard statements to (G (Z ...) (Z ...))
   _←p[i]{
     0=+⌿m←':'=IN[pos[⍵]]:⍬
     ⊃m:'EMPTY GUARD TEST EXPRESSION'⎕SIGNAL 2
     1<+⌿m:'TOO MANY GUARDS'⎕SIGNAL 2
     t[⍺]←G ⋄ p[ti←gz⊃tx cq←2↑(⊂⍬)⍪⍨⍵⊂⍨1,¯1↓m]←⍺ ⋄ k[ti]←1
     ci←≢p ⋄ p,←⍺ ⋄ t k pos end⍪←0 ⋄ n,←⊂'' ⋄ k[gz cq,ci]←1
     0}⌸i←⍸t[p[p]]=F
     
     ⍝ Parse brackets and parentheses into ¯1 and Z nodes
   _←p[i]{
     x←IN[pos[⍵]] ⋄ bd←+⍀bm←(bo←'['=x)+-bc←']'=x ⋄ pd←+⍀pm←(po←'('=x)+-pc←')'=x
     0≠⊃⌽bd:2 'UNBALANCED BRACKETS'SIGNAL pos[⍵]{x+⍳(⌈⌿⍵)-x←⌊⌿⍺}⍥{⍵⌿⍨0≠bd}end[⍵]
     0≠⊃⌽pd:2 'UNBALANCED PARENTHESES'SIGNAL pos[⍵]{x+⍳(⌈⌿⍵)-x←⌊⌿⍺}⍥{⍵⌿⍨0≠pd}end[⍵]
     (po⌿bd)∨.≠⌽pc⌿bd:'OVERLAPPING BRACKETS AND PARENTHESES'⎕SIGNAL 2
     p[⍵]←(⍺,⍵)[1+¯1@{⍵=⍳≢⍵}D2P+⍀¯1⌽bm+pm] ⋄ t[bo⌿⍵]←¯1 ⋄ t[po⌿⍵]←Z
     end[po⌿⍵]←end[⌽pc⌿⍵] ⋄ end[bo⌿⍵]←end[⌽bc⌿⍵]
     0}⌸i←⍸(t[p]=Z)∧p≠⍳≢p
   t k n pos end⌿⍨←⊂msk←~IN[pos]∊')' ⋄ p←(⍸~msk)(⊢-1+⍸)msk⌿p
     
     ⍝ Convert semi-colon indexing into Z nodes in the ¯1 nodes
   _←p[i]{k[z←⊃⍪⌿gz¨g←⍵⊂⍨¯1⌽IN[pos[⍵]]∊';]']←1 ⋄ t[z]←Z P[1=≢¨g]}⌸i←⍸t[p]=¯1
     
     ⍝ Mark bindable nodes
   bm←(t=V)∨(t=A)∧n∊,¨'⎕⍞'
   bm←{bm⊣p[i]{bm[⍺]←(V ¯1≡t[⍵])∨∧⌿bm[⍵]}⌸i←⍸(~bm[p])∧t[p]=Z}⍣≡bm
     
     ⍝ Binding nodes
   _←p[i]{
     t[⍵⌿⍨(n[⍵]∊⊂,'←')∧0,¯1↓bm[⍵]]←B
     b v←{(⊃¨x)(1↓¨x←⍵⌿⍨{t[⊃⍵]=B}¨⍵)}¯1⌽¨⍵⊂⍨1,¯1↓t[⍵]∊P B
     ∨⌿~bm[∊v]:'CANNOT BIND ASSIGNMENT VALUE'⎕SIGNAL 2
     p[⍵]←(⍺,b)[0,¯1↓+⍀t[⍵]=B]
     n[b]←n[∊v] ⋄ t[∊v]←¯7 ⋄ pos[b]←pos[∊v] ⋄ end[b]←end[⊃⌽⍵]
     0}⌸i←⍸(t[p]=Z)∧p≠⍳≢p
   t k n pos end⌿⍨←⊂msk←t≠¯7 ⋄ p←(⍸~msk)(⊢-1+⍸)msk⌿p
     
     ⍝ Mark unambiguous primitive kinds
   k[⍸(t=S)∧n∊'⎕',¨SYSV]←1 ⋄ k[⍸(t=S)∧n∊'⎕',¨SYSF]←2 ⋄ k[⍸(t=S)∧n∊'⎕',¨SYSD]←4
   t[⍸t=S]←P
   k[⍸t∊A C N]←1 ⋄ k[⍸n∊,¨prmfs]←2 ⋄ k[⍸n∊,¨prmmo]←3 ⋄ k[⍸n∊,¨prmdo]←4
   k[⍸n∊,¨prmfo]←5
   k[i←⍸msk←(n∊⊂,'∘')∧1⌽n∊⊂,'.']←3 ⋄ end[i]←end[i+1] ⋄ n[i]←⊂,'∘.'
   t k n pos end⌿⍨←⊂msk←~¯1⌽msk ⋄ p←(⍸~msk)(⊢-1+⍸)msk⌿p
     
     ⍝ Anchor variables to earliest binding in matching frame
   rf←¯1@{~t[⍵]∊F G M}p[rz←I@{~(t[⍵]=Z)∧(t[p[⍵]]∊F G M)∨p[⍵]=⍵}⍣≡⍨p]
   rf[i]←p[i←⍸t=G] ⋄ rz[i]←i ⋄ rf←rf I@{rz∊p[i]⊢∘⊃⌸i←⍸t[p]=G}rf
   mk←{⍺[⍵],⍪n[⍵]}
   fr←rf mk⊢fb←fb[⍳⍨rf mk⊢fb←fb I∘(⍳⍨)U⊖rz mk⊢fb←⍸t=B] ⋄ fb,←¯1
   vb←fb[fr⍳rf mk i]@(i←⍸t=V)⊢¯1⍴⍨≢p
   vb[i⌿⍨(rz[i]<rz[b])∨(rz[i]=rz[b])∧i≥b←vb[i←i⌿⍨vb[i]≠¯1]]←¯1
   _←{z/⍨¯1=vb[1⌷z]←fb[fr⍳⍉n I@1⊢z←rf I@0⊢⍵]}⍣≡⍉{rf[⍵],⍪⍵}⍸(t=V)∧vb=¯1
   ∨⌿msk←(t=V)∧vb=¯1:{
     6 'ALL VARIABLES MUST REFERENCE A BINDING'SIGNAL∊pos[⍵]{⍺+⍳⍵-⍺}¨end[⍵]
   }⍸msk
     
     ⍝ ⍺/⍵ → V ; M → F0 ; ⍺⍺/⍵⍵ → P2
   t←V@(i←⍸(t=A)∧n∊,¨'⍺⍵')⊢F@{t=M}t ⋄ vb[i]←i ⋄ k[⍸(t=P)∧n∊'⍺⍺' '⍵⍵']←2
     
     ⍝ Infer types of bindings, groups, and variables
   z x←↓⍉p[i]{⍺ ⍵}⌸i←⍸(t[p]∊B Z)∧p≠⍳≢p
   x←{⍵⌿⍨~∧⍀t[⍵]=¯1}U⌽¨x
   0∨.=≢¨x:'BRACKET SYNTAX REQUIRES FUNCTION OR ARRAY TO ITS LEFT'⎕SIGNAL 2
   _←{
     k[msk⌿z]←k[x⌿⍨msk←(k[⊃¨x]≠0)∧1=≢¨x] ⋄ z x⌿⍨←⊂~msk
     k[z⌿⍨msk←k[⊃¨x]=4]←3 ⋄ z x⌿⍨←⊂~msk
     k[z⌿⍨msk←{(2 3 5∊⍨k[⊃⍵])∨4=(⍵,≢k)[0⍳⍨∧⍀k[⍵]=1]⌷k,0}∘⌽¨x]←2 ⋄ z x⌿⍨←⊂~msk
     k[z⌿⍨msk←k[⊃∘⌽¨x]=1]←1 ⋄ z x⌿⍨←⊂~msk
     k[i]←k[vb[i←⍸t=V]]
     ≢z}⍣(=∨0=⊣)≢z
   'FAILED TO INFER ALL BINDING TYPES'assert 0=≢z:
     
     ⍝ Strand arrays into atoms
   i←|i⊣km←0<i←i[⍋|(i,⍨←-∪p[i]),p[i←⍸t[p]∊B Z]]
   msk←(t[i]∊C N)∨msk∧⊃1 ¯1∨.⌽⊂msk←km∧(t[i]∊A C N V Z)∧k[i]=1
   np←(≢p)+⍳≢ai←i⌿⍨am←2>⌿msk⍪0 ⋄ p←(np@ai⍳≢p)[p] ⋄ p,←ai ⋄ km←2<⌿0⍪msk
   t k n pos end(⊣,I)←⊂ai ⋄ k[ai]←1 6[∨⌿¨msk⊆t[i]≠N]
   t n pos(⊣@ai⍨)←A(⊂'')(pos[km⌿i]) ⋄ p[msk⌿i]←ai[(msk←msk∧~am)⌿¯1++⍀km]
   i←⍸(t[p]=A)∧(k[p]=6)∧t=N
   p,←i ⋄ t k n pos end(⊣,I)←⊂i ⋄ t k n(⊣@i⍨)←A 1(⊂'')
     
     ⍝ PARSE B←D...
     ⍝ PARSE B←...D
     
     ⍝ Rationalize F[X]
   _←p[i]{
     ⊃m←t[⍵]=¯1:'SYNTAX ERROR:NOTHING TO INDEX'⎕SIGNAL 2
     k[⍵⌿⍨m∧¯1⌽(k[⍵]∊2 3 5)∨¯1⌽k[⍵]=4]←4
     0}⌸i←⍸(t[p]∊B Z)∧(p≠⍳≢p)∧k[p]∊1 2
   i←⍸(t=¯1)∧k=4 ⋄ j←⍸(t[p]=¯1)∧k[p]=4
   (≢i)≠≢j:{
     2 'AXIS REQUIRES SINGLE AXIS EXPRESSION'SIGNAL∊pos[⍵]+⍳¨end[⍵]-pos[⍵]
   }⊃⍪⌿{⊂⍺⌿⍨1<≢⍵}⌸p[j]
   ∨⌿msk←t[j]≠Z:{
     2 'AXIS REQUIRES NON-EMPTY AXIS EXPRESSION'SIGNAL∊pos[⍵]+⍳¨end[⍵]-pos[⍵]
   }msk⌿p[j]
   p[j]←p[i] ⋄ t[i]←P ⋄ end[i]←1+pos[i]
     
     ⍝ Group function and value expressions
   i km←⍪⌿p[i]{(⍺⍪⍵)(0,1∨⍵)}⌸i←⍸(t[p]∊B Z)∧(p≠⍳≢p)∧k[p]∊1 2
     
     ⍝ Mask and verify dyadic operator right operands
   (dm←¯1⌽(k[i]=4)∧t[i]∊F P V Z)∨.∧(~km)∨k[i]∊0 3 4:{
     'MISSING RIGHT OPERAND'⎕SIGNAL 2
   }⍬
     
     ⍝ Refine schizophrenic types
   k[i⌿⍨(k[i]=5)∧dm∨¯1⌽(~km)∨(~dm)∧k[i]∊1 6]←2 ⋄ k[i⌿⍨k[i]=5]←3
     
     ⍝ Rationalize ∘.
   jm←(t[i]=P)∧n[i]∊⊂,'∘.'
   jm∨.∧1⌽(~km)∨k[i]∊3 4:'MISSING OPERAND TO ∘.'⎕SIGNAL 2
   p←((ji←jm⌿i)@(jj←i⌿⍨¯1⌽jm)⍳≢p)[p] ⋄ t[ji,jj]←t[jj,ji] ⋄ k[ji,jj]←k[jj,ji]
   n[ji,jj]←n[jj,ji] ⋄ pos[ji,jj]←pos[ji,ji] ⋄ end[ji,jj]←end[jj,jj]
     
     ⍝ Mask and verify monadic and dyadic operator left operands
   ∨⌿msk←(dm∧¯2⌽~km)∨(¯1⌽~km)∧mm←(k[i]=3)∧t[i]∊F P V Z:{
     2 'MISSING LEFT OPERAND'SIGNAL∊pos[⍵]+⍳¨end[⍵]-pos[⍵]
   }i⌿⍨msk
   msk←dm∨mm
     
     ⍝ Parse function expressions
   np←(≢p)+⍳xc←≢oi←msk⌿i ⋄ p←(np@oi⍳≢p)[p] ⋄ p,←oi ⋄ t k n pos end(⊣,I)←⊂oi
   p[g⌿i]←oi[(g←(~msk)∧(1⌽msk)∨2⌽dm)⌿xc-⌽+⍀⌽msk]
   p[g⌿oi]←(g←msk⌿(1⌽mm)∨2⌽dm)⌿1⌽oi ⋄ t[oi]←O ⋄ n[oi]←⊂''
   pos[oi]←pos[g⌿i][msk⌿¯1++⍀g←(~msk)∧(1⌽mm)∨2⌽dm]
   ol←1+(k[i⌿⍨(2⌽mm)∨3⌽dm]=4)∨k[i⌿⍨(1⌽mm)∨2⌽dm]∊2 3
   or←(msk⌿dm)⍀1+k[dm⌿i]=2
   k[oi]←3 3⊥↑or ol
     
     ⍝ Wrap all assignment values as Z nodes
   i km←⍪⌿p[i]{(⍺⍪⍵)(0,1∨⍵)}⌸i←⍸(t[p]∊B Z)∧(p≠⍳≢p)∧k[p]∊1
   j←i⌿⍨msk←(t[i]=P)∧n[i]∊⊂,'←' ⋄ nz←(≢p)+⍳zc←+⌿msk
   p,←nz ⋄ t k n,←zc⍴¨Z 1(⊂'') ⋄ pos,←1+pos[j] ⋄ end,←end[p[j]]
   zm←¯1⌽msk ⋄ p[km⌿i]←(zpm⌿(i×~km)+zm⍀nz)[km⌿¯1++⍀zpm←zm∨~km]
     
     ⍝ This is the definition of a function value at this point
   isfn←{(t[⍵]∊O F)∨(t[⍵]∊B P V Z)∧k[⍵]=2}
     
     ⍝ Parse modified assignment to E4(V, F, Z)
   j←i⌿⍨m←msk∧(¯1⌽isfn i)∧¯2⌽(t[i]=V)∧k[i]=1 ⋄ p[zi←nz⌿⍨msk⌿m]←j
   p[i⌿⍨(1⌽m)∨2⌽m]←2⌿j ⋄ t k(⊣@j⍨)←E 4 ⋄ pos end n{⍺[⍵]@j⊢⍺}←vi zi,⊂vi←i⌿⍨2⌽m
     
     ⍝ Parse bracket modified assignment to E4(E6, O2(F, P3(←)), Z)
   j←i⌿⍨m←msk∧(¯1⌽isfn i)∧(¯2⌽t[i]=¯1)∧¯3⌽(t[i]=V)∧k[i]=1
   p[zi←nz⌿⍨msk⌿m]←ei←i⌿⍨3⌽m ⋄ t k end(⊣@ei⍨)←E 4(end[zi])
   p t k n(⊣@(i⌿⍨2⌽m)⍨)←ei E 6(⊂'')
   p,←j ⋄ t,←P⍴⍨≢j ⋄ k,←3⍴⍨≢j ⋄ n,←(≢j)⍴⊂,'←' ⋄ pos,←pos[j] ⋄ end,←end[j]
   p t k n pos(⊣@j⍨)←ei O 2(⊂'')(pos[fi←i⌿⍨1⌽m]) ⋄ p[fi]←j
     
     ⍝ Parse bracket assignment to E4(E6, P2(←), Z)
   j←i⌿⍨m←msk∧(¯1⌽t[i]=¯1)∧¯2⌽(t[i]=V)∧k[i]=1 ⋄ p[zi←nz⌿⍨msk⌿m]←ei←i⌿⍨2⌽m
   t k end(⊣@ei⍨)←E 4(end[zi]) ⋄ p t k n(⊣@(i⌿⍨1⌽m)⍨)←ei E 6(⊂'')
   p t k(⊣@j⍨)←ei P 2
     
     ⍝ Parse modified strand assignment
     ⍝ Parse strand assignment
     
     ⍝ SELECTIVE MODIFIED ASSIGNMENT
     ⍝ SELECTIVE ASSIGNMENT
     
     ⍝ Enclose V[X;...] for expression parsing
   i←i[⍋p[i←⍸(t[p]∊B Z)∧(k[p]=1)∧p≠⍳≢p]] ⋄ j←i⌿⍨jm←t[i]=¯1
   t[j]←A ⋄ k[j]←¯1 ⋄ p[i⌿⍨1⌽jm]←j
     
     ⍝ TRAINS
     
     ⍝ Parse expression sequences
   i km←⍪⌿p[i]{(⍺⍪⍵)(0,(2≤≢⍵)∧1∨⍵)}⌸i←⍸(t[p]∊B Z)∧(k[p]=1)∧p≠⍳≢p
   msk←m2∨fm∧~¯1⌽m2←km∧(1⌽km)∧~fm←(t[i]=O)∨(t[i]≠A)∧k[i]=2
   t,←E⍴⍨xc←+⌿msk ⋄ k,←msk⌿msk+m2 ⋄ n,←xc⍴⊂''
   pos,←pos[msk⌿i] ⋄ end,←end[p[msk⌿i]]
   p,←msk⌿¯1⌽(i×~km)+km×x←¯1+(≢p)++⍀msk ⋄ p[km⌿i]←km⌿x
     
     ⍝ Rationalize V[X;...]
   i←i[⍋p[i←⍸(t[p]=A)∧k[p]=¯1]] ⋄ msk←~2≠⌿¯1,ip←p[i] ⋄ ip←∪ip ⋄ nc←2×≢ip
   t[ip]←E ⋄ k[ip]←2 ⋄ n[ip]←⊂'' ⋄ p[msk⌿i]←msk⌿(≢p)+1+2×¯1++⍀~msk
   p,←2⌿ip ⋄ t,←nc⍴P E ⋄ k,←nc⍴2 6 ⋄ n,←nc⍴,¨'[' ''
   pos,←2⌿pos[ip] ⋄ end,←∊(1+pos[ip]),⍪end[ip] ⋄ pos[ip]←pos[i⌿⍨~msk]
     
     ⍝ Sanity check
   ERR←'INVARIANT ERROR: Z node with multiple children'
   ERR assert(+⌿(t[p]=Z)∧p≠⍳≢p)=+⌿t=Z:
     
     ⍝ Count parentheses in source information
   ip←p[i←⍸(t[p]=Z)∧n[p]∊⊂,'('] ⋄ pos[i]←pos[ip] ⋄ end[i]←end[ip]
     
     ⍝ VERIFY Z/B NODE TYPES MATCH ACTUAL TYPE
     
     ⍝ Eliminate Z nodes from the tree
   zi←p I@{t[p[⍵]]=Z}⍣≡ki←⍸msk←(t[p]=Z)∧t≠Z
   p←(zi@ki⍳≢p)[p] ⋄ t k n pos end(⊣@zi⍨)←t k n pos end I¨⊂ki
   t k n pos end⌿⍨←⊂msk←~msk∨t=Z ⋄ p←(⍸~msk)(⊢-1+⍸)msk⌿p
     
     ⍝ Compute Exports
   msk←(t=B)∧k[I@{t[⍵]≠F}⍣≡⍨p]=0
   xn←(0⍴⊂''),msk⌿n ⋄ xt←msk⌿k
     
   d i←P2D p ⋄ d n t k pos end I∘⊢←⊂i ⋄ sym←∪('')(,'⍵')(,'⍺')'⍺⍺' '⍵⍵',n
   (d t k(-sym⍳n)pos end)(xn xt)sym IN}

∇ Run(C I);Convert;in;out
     ⍝ Parameters
     ⍝  AF∆LIB  ArrayFire backend to use
 Convert←{⍺(⎕SE.SALT.Load'[SALT]/lib/NStoScript -noname').ntgennscode ⍵}
 in out←I.Arguments ⋄ AF∆LIB←I.af''⊃⍨I.af≡0
 S←(⊂':Namespace ',out),2↓0 0 0 out Convert ##.THIS.⍎in
 →0⌿⍨'Compile'≢C
 {##.THIS.⍎out,'←⍵'}out Fix S⊣⎕EX'##.THIS.',out
∇

 TT←{((d t k n ss se)exp sym src)←⍵ ⋄ I←{(⊂⍵)⌷⍺}
   A B C E F G K L M N O P S V Z←1+⍳15
     
     ⍝ Compute parent vector and reference scope
   r←I@{t[⍵]≠F}⍣≡⍨p⊣2{p[⍵]←⍺[⍺⍸⍵]}⌿⊢∘⊂⌸d⊣p←⍳≢d
     
     ⍝ Lift Functions to top-level
   p,←n[i]←(≢p)+⍳≢i←⍸(t=F)∧p≠⍳≢p ⋄ t k n r(⊣,I)←⊂i ⋄ p r I⍨←⊂n[i]@i⊢⍳≢p
   t[i]←V
     
     ⍝ Wrap expressions as binding or return statements
   i←(⍸(~t∊F G)∧t[p]=F),{⍵⌿⍨2|⍳≢⍵}⍸t[p]=G ⋄ p t k n r⌿⍨←⊂m←2@i⊢1⍴⍨≢p
   p r i I⍨←⊂j←(+⍀m)-1 ⋄ n←j I@(0≤⊢)n ⋄ p[i]←j←i-1
   k[j]←-(k[r[j]]=0)∨0@({⊃⌽⍵}⌸p[j])⊢(t[j]=B)∨(t[j]=E)∧k[j]=4 ⋄ t[j]←E
     
     ⍝ Lift guard tests
   p[i]←p[x←¯1+i←{⍵⌿⍨~2|⍳≢⍵}⍸t[p]=G] ⋄ t[i,x]←t[x,i] ⋄ k[i,x]←k[x,i]
   n[x]←n[i] ⋄ p←((x,i)@(i,x)⊢⍳≢p)[p]
     
     ⍝ Count strand and indexing children
   n[⍸(t∊A E)∧k=6]←0 ⋄ n[p⌿⍨(t[p]∊A E)∧k[p]=6]+←1
     
     ⍝ Lift and flatten expressions
   p[i]←p[x←p I@{~t[p[⍵]]∊F G}⍣≡i←⍸t∊G A B E O P V] ⋄ j←(⌽i)[⍋⌽x]
   p t k n r{⍺[⍵]@i⊢⍺}←⊂j ⋄ p←(i@j⊢⍳≢p)[p]
     
     ⍝ Compute slots for each frame
   s←¯1,⍨∊⍳¨n[∪x]←⊢∘≢⌸x←0⌷⍉e←∪I∘⍋⍨rn←r[b],⍪n[b←⍸t=B]
     
     ⍝ Compute frame depths
   d←(≢p)↑d ⋄ d[i←⍸t=F]←0 ⋄ _←{z⊣d[i]+←⍵≠z←r[⍵]}⍣≡i ⋄ f←d[0⌷⍉e],¯1
     
     ⍝ Record exported top-level bindings
   xn←n⌿⍨(t=B)∧k[r]=0
     
     ⍝ Anchor variables to appropriate frame depth and slot
   v←⍸(n<¯4)∧(t=V)∨(t=E)∧k=4 ⋄ x←n[y←v,b] ⋄ n[b]←s[e⍳rn] ⋄ i←(≢x)⍴c←≢e
   _←{z/⍨c=i[1⌷z]←e⍳⍉x I@1⊢z←r I@0⊢⍵}⍣≡(v,r[b])⍪⍉⍪⍳≢x
   f s←(f s I¨⊂i)⊣@y¨⊂¯1⍴⍨≢r
     
   p t k n f s r d xn sym}

 Xml←{⍺←0 ⋄ ast←⍺{d i←P2D⊃⍵ ⋄ i∘{⍵[⍺]}¨(⊂d),1↓⍺↓⍵}⍣(0≠⍺)⊢⍵ ⋄ d t k n←4↑ast
   cls←N∆[t],¨('-..'[1+×k]),¨⍕¨|k ⋄ fld←{((≢⍵)↑3↓f∆),⍪⍵}¨↓⍉↑3↓ast
   ⎕XML⍉↑d cls(⊂'')fld}

 dwh←{⍵('┬'dlk 1)' │├┌└─'(0⌷⍉)dct,⊃⍪/((≢¨⍺),¨⊂⌈/≢∘⍉¨⍺)↑¨⍺}

 dwv←{⍵('├'dlk 0)' ─┬┌┐│'(0⌷⊢)dct(⊣⍪1↓⊢)⊃{⍺,' ',⍵}/(1+⌈/≢¨⍺){⍺↑⍵⍪⍨'│'↑⍨≢⍉⍵}¨⍺}

 lb3←{⍺←⍳≢⊃⍵
   '(',¨')',¨⍨{⍺,';',⍵}⌿⍕¨(N∆{⍺[⍵]}@2⊢(2⊃⍵){⍺[|⍵]}@{0>⍵}@4↑⊃⍵)[⍺;]}

 dct←{⍺[(2×2≠/n,0)+(1↑⍨≢m)+m+n←⌽∨\⌽m←' '≠⍺⍺ ⍵]⍵⍵ ⍵}


 dlk←{((x⌷⍴⍵)↑[x←2|1+⍵⍵]⍺),[⍵⍵]⍺⍺@(⊂0 0)⍣('┌'=⊃⍵)⊢⍵}


 pp3←{⍺←'○' ⋄ d←(⍳≢⍵)≠⍵ ⋄ _←{z⊣d+←⍵≠z←⍺[⍵]}⍣≡⍨⍵ ⋄ lbl←⍺⍴⍨≢⍵
   lyr←{i←⍸⍺=d ⋄ k v←↓⍉⍵⍵[i],∘⊂⌸i ⋄ (⍵∘{⍺[⍵]}¨v)⍺⍺¨@k⊢⍵}⍵
   (⍵=⍳≢⍵)⌿⊃⍺⍺ lyr⌿(1+⍳⌈/d),⊂⍉∘⍪∘⍕¨lbl}


:Namespace FNS
(⎕IO ⎕ML ⎕WX)←0 1 3

 Xml←{⍺←0 ⋄ ast←⍺{d i←P2D⊃⍵ ⋄ i∘{⍵[⍺]}¨(⊂d),1↓⍺↓⍵}⍣(0≠⍺)⊢⍵ ⋄ d t k n←4↑ast
   cls←N∆[t],¨('-..'[1+×k]),¨⍕¨|k ⋄ fld←{((≢⍵)↑3↓f∆),⍪⍵}¨↓⍉↑3↓ast
   ⎕XML⍉↑d cls(⊂'')fld}

 lb3←{⍺←⍳≢⊃⍵
   '(',¨')',¨⍨{⍺,';',⍵}⌿⍕¨(N∆{⍺[⍵]}@2⊢(2⊃⍵){⍺[|⍵]}@{0>⍵}@4↑⊃⍵)[⍺;]}

 pp3←{⍺←'○' ⋄ d←(⍳≢⍵)≠⍵ ⋄ _←{z⊣d+←⍵≠z←⍺[⍵]}⍣≡⍨⍵ ⋄ lbl←⍺⍴⍨≢⍵
   lyr←{i←⍸⍺=d ⋄ k v←↓⍉⍵⍵[i],∘⊂⌸i ⋄ (⍵∘{⍺[⍵]}¨v)⍺⍺¨@k⊢⍵}⍵
   (⍵=⍳≢⍵)⌿⊃⍺⍺ lyr⌿(1+⍳⌈/d),⊂⍉∘⍪∘⍕¨lbl}


:EndNamespace 
:Namespace GLOBAL
(⎕IO ⎕ML ⎕WX)←0 1 3

:EndNamespace 
:Namespace OP
⍝ === VARIABLES ===

N∆←' ABCEFGKLMNOPSVZ'

f∆←'ptknfsrdx'


⍝ === End of variables definition ===

(⎕IO ⎕ML ⎕WX)←0 1 3

 Afx←{
   Z←⍺(Mop _o JotDot _o Fop _o Vop _o Bop)⍵
     
   Z}

 Alp←{
   Z←⍺(_yes _as('⍺'⍨))⍵
     
   Z}

 App←{
   Z←⍺(Afx _s(IAx _opt)_as({⍺((≢⍵)E)⌽⍵}))⍵
     
   Z}

 Asgn←{
   Z←⍺(gets _s(Bget _o Mget))⍵
     
   Z}

 Atom←{
   Z←⍺(Unit _some _as(MkAtom))⍵
     
   Z}

 Bfn←{
   Z←⍺(rbrc Blrp lbrc _as(¯1 F))⍵
     
   Z}

 Bget←{
   Z←⍺(2 Gets _s Brk _s(1 Name)_as(4 E∘(1∘↓)Atn∘⌽))⍵
     
   Z}

 Bop←{
   Z←⍺(rbrk _s Ex _s lbrk _s(4 Lbrk)_s Afx _as(5 O∘⌽))⍵
     
   Z}

 Brk←{
   Z←⍺(rbrk _s(Semx _s(semi _s Semx _any))_s lbrk _as(6 E∘⌽))⍵
     
   Z}

 ClrEnv←{
   Z←⍺((Alp _env(¯1))_s(Alp _s Alp _env(¯1))_s(Omg _env(¯1))_s(Omg _s Omg _env(¯1))_ign)⍵
     
   Z}

 Dop1←{
   Z←⍺(Pdop1 _s Afx _as(8 O∘⌽))⍵
     
   Z}

 Dop3←{
   Z←⍺(Pdop3 _s Atom _as(7 O∘⌽))⍵
     
   Z}

 Ex←{
   Z←⍺(IAx _s ExHd _as(MkAST))⍵
     
   Z}

 ExHd←{
   Z←⍺(Asgn _o(1 Bind)_o App _s ∇ _opt)⍵
     
   Z}

 Fa←{
   Z←⍺(ClrEnv _s(FaFn _o FaMop _o FaDop)_noenv)⍵
     
   Z}

 FaDop←{
   Z←⍺(FaDopV _s(FaDopF _opt)_o FaDopF)⍵
     
   Z}

 FaDopF←{
   Z←⍺(Omg _s Omg _env(2)_ign _s FaMop _noenv)⍵
     
   Z}

 FaDopV←{
   Z←⍺(Omg _s Omg _env(1)_ign _s FaMop _noenv)⍵
     
   Z}

 FaFn←{
   Z←⍺(FaFnW _o FaFnA)⍵
     
   Z}

 FaFnA←{
   Z←⍺(Omg _env(1)_s(Alp _env(1))_ign _s Fax _noenv)⍵
     
   Z}

 FaFnW←{
   Z←⍺(Omg _env(1)_ign _s Fax _noenv)⍵
     
   Z}

 FaMop←{
   Z←⍺(FaMopV _s(FaMopF _opt)_o FaMopF)⍵
     
   Z}

 FaMopF←{
   Z←⍺(Alp _s Alp _env(2)_ign _s FaFn _noenv)⍵
     
   Z}

 FaMopV←{
   Z←⍺(Alp _s Alp _env(1)_ign _s FaFn _noenv)⍵
     
   Z}

 Fax←{
   Z←⍺(lbrc _s(Gex _o Ex _o Fex Stmts rbrc)_then Fn _as((FnType ⍺)F))⍵
     
   Z}

 Fex←{
   Z←⍺(Afx _s(Trn _opt)_s(2 Bind _any)_as(MkAST))⍵
     
   Z}

 Fn←{a(i d)←⍵ ⋄ 0=≢a:0 ⍬ ⍺(i d)
   0=≢ss←(4⊃z)⌿⍨m←(((N∆⍳'F')=1⊃⊢)∧¯1=2⊃⊢)⊢z←⍪⌿↑a:0(,⊂z)⍺(i d)
   0<c←r⊃⍨0,pi←⊃⍒⊃r←↓⍉↑ps←⍺∘Fa¨ss,¨⊂⊂d:pi⊃ps
   0(,⊂(⊂¨¨z)((⊃⍪⌿)⊣@{m})¨⍨↓(m⌿0⊃z)+@0⍉↑⊃¨1⊃r)⍺(i d)}

 FnType←{⌈⌿2,3 4×¯1≠(¯1,⍨1⊃⍵)['⍺⍺' '⍵⍵'⍳⍨⊃⍵]}

 Fnp←{
   Z←⍺(Prim _o Sfn _o(2 Var)_o Bfn _o Pfe)⍵
     
   Z}

 Fop←{
   Z←⍺(Fnp _s(Dop1 _o Dop3 _opt)_as(MkAST))⍵
     
   Z}

 G←{⍪/(0 6 0 0,1+⍺),1+@0⍉↑(⊂6⍴⊂⍬),⍵}

 Gex←{
   Z←⍺(Ex _s grd _s Ex _as(G∘⌽))⍵
     
   Z}

 IAx←{
   Z←⍺(Idx _o Atom _s(dop2 _not))⍵
     
   Z}

 Idx←{
   Z←⍺(Brk _s(2 Lbrk)_s Atom _as(2 E∘⌽))⍵
     
   Z}

 JotDP←{
   Z←⍺(dot _s jot _as(3 P∘⌽))⍵
     
   Z}

 JotDot←{
   Z←⍺(Fnp _s JotDP _as(2 O))⍵
     
   Z}

 L←{⍪/(0 8 0 0,1+⍺),1+@0⍉↑(⊂6⍴⊂⍬),⍵}

 M←{⍪/(0 9 0 0,1+⍺),1+@0⍉↑(⊂6⍴⊂⍬),⍵}

 Mbrk←{
   Z←⍺(Ogets _s Brk _s(1 Name)_as(4 E∘(1∘↓)Atn∘⌽))⍵
     
   Z}

 Mget←{
   Z←⍺(Mname _o Mbrk)⍵
     
   Z}

 MkAST←{⍪/(⍳≢⍵)+@0⍉↑⌽⍵}

 MkAtom←{∧⌿m←(N∆⍳'N')=⊃¨1⊃¨⍵:⍺(1 A)⌽⍵ ⋄ 1=≢⍵:0⊃⍵ ⋄ ⍺(6 A)⌽({⊃¨⍵[4 5]}1 A⊂)¨@{m}⍵}

 MkMget←{⍪/(0,1+2<≢⊃z)+@0⊢z←⍉↑⌽⍵}

 Mname←{
   Z←⍺(Afx _s(1 Name)_as(4 E Atn∘⌽))⍵
     
   Z}

 Mop←{
   Z←⍺(Pmop _s Afx _as(2 O∘⌽))⍵
     
   Z}

 N←{0(N∆⍳'N')1(⍎⍵),1+⍺}

 Nlrp←{
   Z←⍺(sep _o rbrc _peek Slrp(lbrc Blrp rbrc))⍵
     
   Z}

 Ns←{
   Z←⍺(nss _s(Ex _o Fex Stmts nse)_s eot _then Fn _as((¯1+⊣)0 F⊢))⍵
     
   Z}

 Num←{
   Z←⍺(float _o int _as(N∘⌽))⍵
     
   Z}

 Ogets←{
   Z←⍺(Afx _s(3 Gets)_as(2 O))⍵
     
   Z}

 Omg←{
   Z←⍺(_yes _as('⍵'⍨))⍵
     
   Z}

 PEG←{⍺←⎕THIS
   A←,¨'`([^`]*)`' '"([^"]*)"' '\[\]' '\[([^]]+)\]' '\|' ','
   B←'(''\1''_set)' '(''\1''_tk)' '_noenv' '_env(\1)' '_o' '_s'
   A,←,¨'→' '!' '&' '∊' '\?' '\*' '\+' '⍥' '↓' '↑' '⌽'
   B,←'_then' '_not' '_t' '_yes' '_opt' '_any' '_some' '_eat' '_ign' '_peek' '_bkwd'
   A,←⊂,'⍬'
   B,←⊂,'_eot'
   noq←' '@(∊{⍺+⍳⍵}⌿¨'`[^`]*`' '"[^"]*"'⎕S 0 1⊢x)⊢x←' ',⍵
   nm peg as←1↓¨3↑x⊂⍨1@(0,⊃∘⍸¨('←'=noq)(':'=noq))⊢0⍴⍨≢x
   peg←A ⎕R(' ',¨B,¨' ')⊢peg ⋄ as←{' _as (',⍵,')'}⍣(∨⌿as≠' ')⊢as
   ⍺.⎕FX(nm,'←{')('Z←⍺(',peg,as,')⍵')(''⊣'⎕←''',nm,': '',⍕(0)(3 0)⊃¨⊂Z')('Z}')}

 Pdop1←{
   Z←⍺(dop1 _as(3 P))⍵
     
   Z}

 Pdop2←{
   Z←⍺(dop2 _as(3 P))⍵
     
   Z}

 Pdop3←{
   Z←⍺(dop3 _as(3 P))⍵
     
   Z}

 Pex←{
   Z←⍺(rpar _s Ex _s lpar)⍵
     
   Z}

 Pfe←{
   Z←⍺(rpar _s Fex _s lpar)⍵
     
   Z}

 Pmop←{
   Z←⍺(mop _as(3 P))⍵
     
   Z}

 Prim←{
   Z←⍺(prim _as(2 P))⍵
     
   Z}

 Semi←{
   Z←⍺(_yes _as(⊣1 P{,';'}))⍵
     
   Z}

 Semx←{
   Z←⍺(Ex _o Semi)⍵
     
   Z}

 Sfn←{
   Z←⍺(sfn _as(2 P∘⌽∘∊))⍵
     
   Z}

 Symbol←{
   Z←⍺(name _as(⊢∘⌽))⍵
     
   Z}

 Trn←{
   Z←⍺(Afx _s(Afx _o Idx _o Atom _s(∇ _opt)_opt)_as(5 F∘⌽))⍵
     
   Z}

 Unit←{
   Z←⍺((1 Var)_o Num _o Zil _o Pex)⍵
     
   Z}

 Vop←{
   Z←⍺(Atom _s Pdop2 _s Afx _as(5 O∘⌽))⍵
     
   Z}

Vt←('⊢' '⍳⍨' (0 '⊃' '⊣')) '⊃' (¯1 ',⍨' (1 '⊃' '⊣'))

 Z←{0(N∆⍳'Z')0(⊂⍵),1+⍺}

 Zil←{
   Z←⍺(zil _as(1 A))⍵
     
   Z}

 _eat←{i d←⍵ ⋄ i≥≢d:2 ⍬ ⍺ ⍵ ⋄ 0(i⌷d)⍺((i _step 1)d)}

 _eot←{i d←⍵ ⋄ (i<0)∨i≥≢d:0 ⍬ ⍺((≢d)d) ⋄ 2 ⍬ ⍺ ⍵}

 _gob←{_step∘←- ⋄ _less∘←> ⋄ _←0}

 _gof←{_step∘←+ ⋄ _less∘←< ⋄ _←0}

_less←<

 _report←{c a e(i d)←⍵ ⋄ 0=c:⍵⊣⎕←'Parsing successful.'⊣##.EN←0⊣##.DM←'' '' ''
   0>c:('Unhandled return code: ',(⍕c))⎕SIGNAL 16
   li←⍸lm←¯1⌽lm∨(CR=d)∧~1⌽lm←LF=d←d,LF⊣CR LF←⎕UCS 13 10
   ##.EN←c
   ##.DM[0]←⊂⎕EM c
   ##.DM[1]←⊂(lnm←'[',(⍕1+ln),'] '),' '@{⍵∊CR LF}⊢l←(ln←0⌈li⍸i)⊃lm⊂d
   ##.DM[2]←⊂(' '⍴⍨≢lnm),'^'@(0⌈i-ln⌷li)⊢' '⍴⍨≢l
   msg←∊CR,'─'⍪⍨'─'⍪↑##.DM[1 2]
   ⎕SIGNAL⊂('EN'c)('Category' 'Compiler')('Vendor' 'Co-dfns')('Message'msg)}

_step←+

 _yes←{0 ⍬ ⍺ ⍵}

 aaww←{
   Z←⍺(aws _s(('⍺⍺'_tk)_o('⍵⍵'_tk))_s aws)⍵
     
   Z}

 alpha←{
   Z←⍺(('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz∆_'_set))⍵
     
   Z}

 aw←{
   Z←⍺(aws _s(('⍵'_tk)_o('⍺'_tk))_s aws)⍵
     
   Z}

 aws←{
   Z←⍺(ws _any _ign)⍵
     
   Z}

 awslf←{
   Z←⍺(crlf _o ws _any _ign)⍵
     
   Z}

crlf←((⎕ucs 10 13)) (,⊂' _set←{i d←⍵ ⋄ 3::2 ⍬ ⍺ ⍵ ⋄ (i⌷d)∊⍺⍺:0(,i⌷d)⍺((i _step 1)d) ⋄ 2 ⍬ ⍺ ⍵}')

 digit←{
   Z←⍺(('0123456789'_set))⍵
     
   Z}

 dop1←{
   Z←⍺(aws _s('.⍣∘'_set)_s aws)⍵
     
   Z}

 dop2←{
   Z←⍺(aws _s('⍤⍣∘'_set)_s aws)⍵
     
   Z}

 dop3←{
   Z←⍺(aws _s('∘'_set)_s aws)⍵
     
   Z}

 dot←{
   Z←⍺(aws _s('.'_set)_s aws)⍵
     
   Z}

 egrd←{
   Z←⍺(aws _s('::'_tk)_s aws _ign)⍵
     
   Z}

 eot←{
   Z←⍺(aws _s _eot _ign)⍵
     
   Z}

 float←{
   Z←⍺(aws _s(digit _any _s('.'_set)_s int _o(digit _some _s('.'_set)_s ndlm))_s aws)⍵
     
   Z}

 gets←{
   Z←⍺(aws _s('←'_tk)_s aws _ign)⍵
     
   Z}

 grd←{
   Z←⍺(aws _s(':'_tk)_s aws _ign)⍵
     
   Z}

 int←{
   Z←⍺(aws _s(digit _some)_s ndlm _s aws)⍵
     
   Z}

 jot←{
   Z←⍺(aws _s('∘'_set)_s aws)⍵
     
   Z}

 lbrc←{
   Z←⍺(aws _s('{'_set)_s aws _ign)⍵
     
   Z}

 lbrk←{
   Z←⍺(aws _s('['_tk)_s aws _ign)⍵
     
   Z}

 lpar←{
   Z←⍺(aws _s('('_tk)_s aws _ign)⍵
     
   Z}

 mop←{
   Z←⍺(aws _s('¨/⌿\⍀⍨'_set)_s aws)⍵
     
   Z}

 name←{
   Z←⍺(aws _s(alpha _o(digit _some _s alpha)_some)_s(('⎕'_set)_not)_s aws)⍵
     
   Z}

 ndlm←{
   Z←⍺(('¯'_set)_o(alpha _not _peek))⍵
     
   Z}

 nse←{
   Z←⍺(awslf _s(':EndNamespace'_tk)_s awslf _ign)⍵
     
   Z}

 nss←{
   Z←⍺(awslf _s(':Namespace'_tk)_s aws _s(alpha _s(alpha _o digit _any)_opt)_s awslf _ign)⍵
     
   Z}

 prim←{
   Z←⍺(aws _s('+-÷×|*⍟⌈⌊!<≤=≠≥>∧∨⍲⍱⌷?⍴,⍪⌽⊖⍉∊⍷⊂⊆⊃⍳○~≡≢⊢⊣/⌿\⍀⊤⊥↑↓∪∩⍋⍒∇⌹'_set)_s aws)⍵
     
   Z}

 ps←{⍺←⍬ ⍬ ⋄ src←∊{⍵/⍨∧\'⍝'≠⍵}¨⍵,¨⎕UCS 10
   0≠⊃c a e(i d)←p←⍺ Ns 0,⊂src:_report p
   (↓s(-⍳)@3↑⊃a)e(s←∪0(,'⍵')(,'⍺')'⍺⍺' '⍵⍵',3⊃⊃a)src}

 rbrc←{
   Z←⍺(aws _s('}'_set)_s aws _ign)⍵
     
   Z}

 rbrk←{
   Z←⍺(aws _s(']'_tk)_s aws _ign)⍵
     
   Z}

 rpar←{
   Z←⍺(aws _s(')'_tk)_s aws _ign)⍵
     
   Z}

 semi←{
   Z←⍺(aws _s(';'_tk)_s aws _ign)⍵
     
   Z}

 sep←{
   Z←⍺(aws _s(('⋄'_set)_o crlf _ign)_s aws)⍵
     
   Z}

 sfn←{
   Z←⍺(aws _s(('TFFI⎕'_tk)_o('TFF⎕'_tk))_s aws)⍵
     
   Z}

ws←(⎕ucs 32 9) (,⊂' _set←{i d←⍵ ⋄ 3::2 ⍬ ⍺ ⍵ ⋄ (i⌷d)∊⍺⍺:0(,i⌷d)⍺((i _step 1)d) ⋄ 2 ⍬ ⍺ ⍵}')

 zil←{
   Z←⍺(aws _s('⍬'_tk)_s aws _ign)⍵
     
   Z}

 A←{⍪/(0 1 ⍺⍺ 0,1+⍺),1+@0⍉↑(⊂6⍴⊂⍬),⍵}


 Args←{
   Z←⍺(aaww _o aw _t(⍺⍺=Vt)_as(⍺⍺ V∘,∘⊃))⍵

   Z}


 Atn←{(0 3⊃⍵)@(⊂3 0)⊢⍺ ⍺⍺ ⍵}


 B←{0(N∆⍳'B')⍺⍺(0⌷⍵),1+⍺}


 Bind←{
   Z←⍺(gets _s Symbol _env(⍺⍺)_as(⍺⍺ B))⍵

   Z}


 Blrp←{
   Z←⍺(⍺⍺ _s(⍵⍵ Slrp ∇)_ign)⍵

   Z}


 E←{⍪/(0 4 ⍺⍺ 0,1+⍺),1+@0⍉↑(⊂6⍴⊂⍬),⍵}


 F←{⍪/(0 5 ⍺⍺ 0,1+⍺),1+@0⍉↑(⊂6⍴⊂⍬),⍵}


 Gets←{
   Z←⍺(_yes _as(⊣⍺⍺ P{,'←'}))⍵

   Z}


 Lbrk←{
   Z←⍺(_yes _as(⊣⍺⍺ P{,'['}))⍵

   Z}


 Name←{
   Z←⍺(Symbol _t(⍺⍺=Vt)_as(⍺⍺ V∘,∘⊃))⍵

   Z}


 O←{⍪/(0 11 ⍺⍺ 0,1+⍺),1+@0⍉↑(⊂6⍴⊂⍬),⍵}


 P←{0(N∆⍳'P')⍺⍺(⊂⍵),1+⍺}


 Slrp←{
   Z←⍺(⍺⍺ _o(⍵⍵ _s ∇)_o(_eat _s ∇)_ign)⍵

   Z}


 Stmt←{
   Z←⍺(sep _o(⍺⍺ _s(sep _o lbrc)_bkwd Nlrp))⍵

   Z}


 Stmts←{
   Z←⍺(⍵⍵ _o(⍺⍺ Stmt _s ∇))⍵

   Z}


 V←{0(N∆⍳'V')⍺⍺(⊂⍵),1+⍺}


 Var←{
   Z←⍺(⍺⍺ Args _o(⍺⍺ Name))⍵

   Z}


 _any←{⍺(⍺⍺ _s ∇ _o _yes)⍵}


 _as←{0<⊃c a e d←⍺ ⍺⍺ ⍵:c a e d ⋄ c(,⊂((⌊/,⌈/)⊃¨⍵ d)⍵⍵ a)e d}


 _bkwd←{c a e d1←⍺ ⍵⍵ ⍵ ⋄ _gob ⍬: ⋄ c a e d2←⍺ ⍺⍺-∘1@0⊢d1 ⋄ _gof ⍬:
   0<c:c a e((⌈⌿⊃¨⍵ d2),1↓⍵) ⋄ c a e d1}


 _env←{0<⊃c a e d←p←⍺ ⍺⍺ ⍵:p ⋄ c a((⊆a)⍵⍵⍪¨e)d}


 _ign←{c a e d←⍺ ⍺⍺ ⍵ ⋄ c ⍬ e d}


 _noenv←{0<⊃c a e d←p←⍺ ⍺⍺ ⍵:p ⋄ c a ⍺ d}


 _not←{0<⊃c a e d←⍺ ⍺⍺ ⍵:0 a ⍺ ⍵ ⋄ 2 a ⍺ ⍵}


 _o←{0≥⊃c1 a e(i1 d1)←A←⍺ ⍺⍺ ⍵:A ⋄ 0≥⊃c2 a e(i2 d2)←B←⍺ ⍵⍵ ⍵:B
   (i1=i2∧c1<c2)∨i1 _less i2:B ⋄ A}


 _opt←{⍺(⍺⍺ _o _yes)⍵}


 _peek←{0<p←⊃⍺ ⍺⍺ ⍵:p ⋄ 0 ⍬ ⍺ ⍵}


 _s←{0<⊃c a e d←p←⍺ ⍺⍺ ⍵:p ⋄ 0<⊃c2 a2 e d←p←e ⍵⍵ d:p ⋄ (c⌈c2)(a⍪a2)e d}


 _set←{i d←⍵ ⋄ 3::2 ⍬ ⍺ ⍵ ⋄ (i⌷d)∊⍺⍺:0(,i⌷d)⍺((i _step 1)d) ⋄ 2 ⍬ ⍺ ⍵}


 _some←{⍺(⍺⍺ _s(⍺⍺ _any))⍵}


 _t←{0<⊃c a e(i d)←p←⍺ ⍺⍺ ⍵:p ⋄ e ⍵⍵ a:p ⋄ i>⊃⍵:6 ⍬ ⍺ ⍵ ⋄ 6 ⍬ ⍺(i d)}


 _then←{0<⊃c a e d←p←⍺ ⍺⍺ ⍵:p ⋄ 0<⊃c a e _←p←e ⍵⍵ a d:p ⋄ c a e d}


 _tk←{i d←⍵ ⋄ m←(,⍺⍺)=⍥⎕C c↑d⌷⍨⊂x⌿⍨(0≤x)∧(≢d)>x←i _step⍳c←≢,⍺⍺
   x←(i _step+⌿∧⍀m)d ⋄ ∧⌿m:0(⊂,⍺⍺)⍺ x ⋄ 2 ⍬ ⍺ x}


:EndNamespace 
:Namespace RTM
⍝ === VARIABLES ===

deps←((,'⍉') (,'⍴') (,'⍋') '%s' (,'+')) ((,'⍉') (,'⍴') (,'⍋') '%s' (,'-')) ((,'⍉') (,'⍴') (,'⍋') '%s' (,'×')) ((,'⍉') (,'⍴') (,'⍋') '%s' (,'÷')) ((,'⍉') (,'⍴') (,'⍋') '%s' (,'*')) ((,'⍉') (,'⍴') (,'⍋') '%s' (,'⍟')) ((,'⍉') (,'⍴') (,'⍋') '%s' (,'|')) ((,'⍉') (,'⍴') (,'⍋') '%s' (,'○')) ((,'⍉') (,'⍴') (,'⍋') '%s' (,'⌊')) ((,'⍉') (,'⍴') (,'⍋') '%s' (,'⌈')) ((,'⍉') (,'⍴') (,'⍋') '%s' (,'!')) ((,'⍉') (,'⍴') (,'⍋') '%s' (,'<')) ((,'⍉') (,'⍴') (,'⍋') '%s' (,'≤')) ((,'⍉') (,'⍴') (,'⍋') '%s' (,'=')) ((,'⍉') (,'⍴') (,'⍋') '%s' (,'≥')) ((,'⍉') (,'⍴') (,'⍋') '%s' (,'>')) ((,'⍉') (,'⍴') (,'⍋') '%s' (,'≠')) ((,'⍉') (,'⍴') (,'⍋') '%s' (,'~')) ((,'∨') (,'∧')) ((,'⍉') (,'⍴') (,'⍋') '%s' (,'∨')) ((,'⍉') (,'⍴') (,'⍋') '%s' (,'⍲')) ((,'⍉') (,'⍴') (,'⍋') '%s' (,'⍱')) ((,'⍳') (,'⌷')) (⊂,'[') (⊂,'⍳') (⊂,'⍴') (⊂,',') ((,',') (,'⍪')) ((,'|') (,',') (,'⌽')) (⊂,'⍉') ((,'⌽') (,'⊖')) (⊂,'∊') (⊂,'⊃') (⊂,'≡') ((,'≡') (,'≢')) (⊂,'⊢') (⊂,'⊣') (⊂,'⊤') (⊂,'⊥') ((,'¨') (,'/')) ((,'/') (,'⌿')) ((,'¨') (,'\')) ((,'\') (,'⍀')) ((,'⍉') (,'⍴') (,'⍋') '%s' (,'?')) ((,'⍳') (,'↑')) ((,'⍳') (,'↓')) ((,'⊃') (,',') (,'¨')) (⊂,'⍨') ((,'/') (,'.')) ((,'↑') (,'⌷') (,'⍤')) (⊂,'⍣') (⊂,'∘') (⊂,'∪') (⊂,'∩') ((,'[') (,'⊃') (,',') (,'¨') (,'←')) (⊂,'⍋') (⊂,'⍒') ((,'¨') '∘.') (⊂,'⍷') ((,'¨') (,'⌷') (,'⊂')) (⊂,'⌹') (⊂'⎕FFT') (⊂'⎕IFFT') (⊂'%s') ((,'⊂') (,'⊆')) (⊂,'∇') (⊂,';') (⊂'%u')

initsrc←'0inc' '1mac' '2obj' '3ftp' '4utl' '5dat' '6dwa' '7api'

_←⍬
_,←'add' 'sub' 'mul' 'div' 'exp' 'log' 'res' 'cir' 'min' 'max' 'fac' 'lth' 'lte' 'eql' 'gte' 'gth' 'neq' 'not' 'and'
_,←'lor' 'nan' 'nor' 'sqd' 'brk' 'iot' 'rho' 'cat' 'ctf' 'rot' 'trn' 'rtf' 'mem' 'dis' 'eqv' 'nqv' 'rgt' 'lft' 'enc'
_,←'dec' 'red' 'rdf' 'scn' 'scf' 'rol' 'tke' 'drp' 'map' 'com' 'dot' 'rnk' 'pow' 'jot' 'unq' 'int' 'get' 'gdu' 'gdd'
_,←'oup' 'fnd' 'par' 'mdv' 'fft' 'ift' 'scl' 'nst' 'this' 'span' ''
nams←_

_←⍬
_,←'#define _SILENCE_CXX17_CODECVT_HEADER_DEPRECATION_WARNING',(⎕ucs 10 10),'#include <time.h>',(⎕ucs 10),'#include <stdint.h>',(⎕ucs 10),'#include <stdio.h>',(⎕ucs 10),'#include <inttypes.h>'
_,←(⎕ucs 10),'#include <limits.h>',(⎕ucs 10),'#include <float.h>',(⎕ucs 10),'#include <locale>',(⎕ucs 10),'#include <codecvt>',(⎕ucs 10),'#include <math.h>',(⎕ucs 10),'#include <memory>',(⎕ucs 10)
_,←'#include <algorithm>',(⎕ucs 10),'#include <stack>',(⎕ucs 10),'#include <string>',(⎕ucs 10),'#include <cstring>',(⎕ucs 10),'#include <variant>',(⎕ucs 10),'#include <vector>',(⎕ucs 10)
_,←'#include <unordered_map>',(⎕ucs 10),'#include <arrayfire.h>',(⎕ucs 10),'using namespace af;',(⎕ucs 10 10),'#if AF_API_VERSION < 36',(⎕ucs 10),'#error "Your ArrayFire version is too old."',(⎕ucs 10)
_,←'#endif',(⎕ucs 10),'#ifdef _WIN32',(⎕ucs 10),' #define EXPORT extern "C" __declspec(dllexport)',(⎕ucs 10),'#elif defined(__GNUC__)',(⎕ucs 10)
_,←' #define EXPORT extern "C" __attribute__ ((visibility ("default")))',(⎕ucs 10),'#else',(⎕ucs 10),' #define EXPORT extern "C"',(⎕ucs 10),'#endif',(⎕ucs 10),'#ifdef _MSC_VER',(⎕ucs 10)
_,←' #define RSTCT __restrict',(⎕ucs 10),'#else',(⎕ucs 10),' #define RSTCT restrict',(⎕ucs 10),'#endif',(⎕ucs 10),'#define S struct',(⎕ucs 10),'#define Z static',(⎕ucs 10),'#define R return',(⎕ucs 10)
_,←'#define this_c (*this)',(⎕ucs 10),'#define VEC std::vector',(⎕ucs 10),'#define CVEC const std::vector',(⎕ucs 10),'#define RANK(pp) ((pp)->r)',(⎕ucs 10),'#define TYPE(pp) ((pp)->t)',(⎕ucs 10)
_,←'#define SHAPE(pp) ((pp)->s)',(⎕ucs 10),'#define ETYPE(pp) ((pp)->e)',(⎕ucs 10),'#define DATA(pp) ((V*)&SHAPE(pp)[RANK(pp)])',(⎕ucs 10),'#define CS(n,x) case n:x;break;',(⎕ucs 10)
_,←'#define DO(n,x) {I _i=(n),i=0;for(;i<_i;++i){x;}}',(⎕ucs 10),'#define DOB(n,x) {B _i=(n),i=0;for(;i<_i;++i){x;}}',(⎕ucs 10),'#define MT',(⎕ucs 10),'#define PUSH(x) s.emplace(x)',(⎕ucs 10)
_,←'#define POP(f,x) x=std::get<f>(s.top());s.pop()',(⎕ucs 10),'#define DEFN(n) FNP n##_p=std::make_shared<n##_f>();FN&n##_c=*n##_p;',(⎕ucs 10)
_,←'#define NM(n,nm,sm,sd,di,mf,df,ma,da) S n##_f:FN{di;mf;df;ma;da;\',(⎕ucs 10),' n##_f():FN(nm,sm,sd){}};',(⎕ucs 10),'#define OM(n,nm,sm,sd,mf,df,ma,da) S n##_o:MOP{mf;df;ma;da;\',(⎕ucs 10)
_,←' n##_o(FNP l):MOP(nm,sm,sd,l){}\',(⎕ucs 10),' n##_o(CA&l):MOP(nm,sm,sd,l){}};\',(⎕ucs 10),' S n##_k:MOK{\',(⎕ucs 10),'  FNP operator()(FNP l){R std::make_shared<n##_o>(l);}\',(⎕ucs 10)
_,←'  FNP operator()(CA&l){R std::make_shared<n##_o>(l);}};',(⎕ucs 10),'#define OD(n,nm,sm,sd,mf,df,ma,da) S n##_o:DOP{mf;df;ma;da;\',(⎕ucs 10),' n##_o(FNP l,FNP r):DOP(nm,sm,sd,l,r){}\',(⎕ucs 10)
_,←' n##_o(CA&l,FNP r):DOP(nm,sm,sd,l,r){}\',(⎕ucs 10),' n##_o(FNP l,CA&r):DOP(nm,sm,sd,l,r){}\',(⎕ucs 10),' n##_o(CA&l,CA&r):DOP(nm,sm,sd,l,r){}};\',(⎕ucs 10),' S n##_k:DOK{\',(⎕ucs 10)
_,←'  FNP operator()(FNP l,FNP r){R std::make_shared<n##_o>(l,r);}\',(⎕ucs 10),'  FNP operator()(CA&l,CA&r){R std::make_shared<n##_o>(l,r);}\',(⎕ucs 10)
_,←'  FNP operator()(FNP l,CA&r){R std::make_shared<n##_o>(l,r);}\',(⎕ucs 10),'  FNP operator()(CA&l,FNP r){R std::make_shared<n##_o>(l,r);}};',(⎕ucs 10),'#define DID inline array id(SHP)',(⎕ucs 10)
_,←'#define MFD inline V operator()(A&z,CA&r,ENV&e)',(⎕ucs 10),'#define MAD inline V operator()(A&z,CA&r,ENV&e,CA&ax)',(⎕ucs 10),'#define DFD inline V operator()(A&z,CA&l,CA&r,ENV&e)',(⎕ucs 10)
_,←'#define DAD inline V operator()(A&z,CA&l,CA&r,ENV&e,CA&ax)',(⎕ucs 10),'#define DI(n) inline array n::id(SHP s)',(⎕ucs 10),'#define ID(n,x,t) DI(n##_f){R constant(x,dim4(cnt(s)),t);}',(⎕ucs 10)
_,←'#define MF(n) inline V n::operator()(A&z,CA&r,ENV&e)',(⎕ucs 10),'#define MA(n) inline V n::operator()(A&z,CA&r,ENV&e,CA&ax)',(⎕ucs 10),'#define DF(n) inline V n::operator()(A&z,CA&l,CA&r,ENV&e)'
_,←(⎕ucs 10),'#define DA(n) inline V n::operator()(A&z,CA&l,CA&r,ENV&e,CA&ax)',(⎕ucs 10),'#define SF(n,lb) \',(⎕ucs 10),' DF(n##_f){sclfn(z,l,r,e,[&](A&z,carr&lv,carr&rv,ENV&e){lb;});}\',(⎕ucs 10)
_,←' DA(n##_f){sclfn(z,l,r,e,ax,n##_c);}',(⎕ucs 10),'#define SMF(n,lb) \',(⎕ucs 10),' MF(n##_f){msclfn(z,r,e,n##_c,[](A&z,carr&rv,ENV&e){lb;});}',(⎕ucs 10)
_,←'#define EF(init,ex,fun) EXPORT V ex##_dwa(lp*z,lp*l,lp*r){try{\',(⎕ucs 10),'  A cl,cr,za;fn##init##_f fn_c;fn_c(za,cl,cr,e##init);\',(⎕ucs 10),'  cpda(cr,r);cpda(cl,l);\',(⎕ucs 10)
_,←'  (*std::get<FNP>((*e##init[0])[fun]))(za,cl,cr,e##init);\',(⎕ucs 10),'  cpad(z,za);}\',(⎕ucs 10),' catch(U n){derr(n);}\',(⎕ucs 10)
_,←' catch(exception&e){msg=mkstr(e.what());dmx.e=msg.c_str();derr(500);}}\',(⎕ucs 10),'EXPORT V ex##_cdf(A*z,A*l,A*r){{A il,ir,iz;\',(⎕ucs 10),' fn##init##_f fn_c;fn_c(iz,il,ir,e##init);}\',(⎕ucs 10)
_,←' (*std::get<FNP>((*e##init[0])[fun]))(*z,*l,*r,e##init);}',(⎕ucs 10),'#define EV(init,ex,slt)',(⎕ucs 10),'#define EO(init,ex,slt)',(⎕ucs 10),'#define VSWITCH(x,nil,arry,vec) \',(⎕ucs 10)
_,←' std::visit(\',(⎕ucs 10),'  visitor{[&](NIL v){nil;},[&](arr&v){arry;},[&](VEC<A>&v){vec;}},\',(⎕ucs 10),'  (x));',(⎕ucs 10),'#define CVSWITCH(x,nil,arr,vec) \',(⎕ucs 10),' std::visit(\',(⎕ucs 10)
_,←'  visitor{[&](NIL v){nil;},[&](carr&v){arr;},[&](CVEC<A>&v){vec;}},\',(⎕ucs 10),'  (x));',(⎕ucs 10),'typedef enum{APLNC=0,APLU8,APLTI,APLSI,APLI,APLD,APLP,APLU,APLV,APLW,APLZ,',(⎕ucs 10)
_,←' APLR,APLF,APLQ}APLTYPE;',(⎕ucs 10),'typedef long long L;typedef int I;typedef int16_t S16;typedef int8_t S8;',(⎕ucs 10),'typedef double D;typedef unsigned char U8;typedef unsigned U;',(⎕ucs 10)
_,←'typedef dim_t B;typedef cdouble DZ;typedef void V;typedef std::string STR;',(⎕ucs 10),'typedef array arr;typedef const array carr;typedef af::index IDX;',(⎕ucs 10),'typedef std::monostate NIL;'
_,←(⎕ucs 10),'S{U f=3;U n;U x=0;const wchar_t*v=L"Co-dfns";const wchar_t*e;V*c;}dmx;',(⎕ucs 10),'S pkt{L l;B c;U t:4;U r:4;U e:4;U _:13;U _1:16;U _2:16;B s[1];};',(⎕ucs 10),'S lp{pkt*p;V*i;};'
_,←(⎕ucs 10),'S dwa{B z;S{B z;pkt*(*ga)(U,U,B*,S lp*);V(*p[16])();V(*er)(V*);}*ws;V*p[4];};',(⎕ucs 10),'S dwa*dwafns;',(⎕ucs 10),'extern "C" int set_dwa(void*);',(⎕ucs 10)
_,←'extern "C" void dwaerror(unsigned int, const wchar_t *);',(⎕ucs 10),'EXPORT I DyalogGetInterpreterFunctions(dwa*p){',(⎕ucs 10)
_,←' if(p){dwafns=p;set_dwa(p);}else R 0;if(dwafns->z<(B)sizeof(S dwa))R 16;R 0;}',(⎕ucs 10),'Z V derr(U n){dwaerror(n,dmx.e);}',(⎕ucs 10),'Z V err(U n,const wchar_t*e){dmx.e=e;throw n;}',(⎕ucs 10)
_,←'Z V err(U n){err(n,L"");}',(⎕ucs 10),'std::wstring_convert<std::codecvt_utf8_utf16<wchar_t>> strconv;',(⎕ucs 10),'typedef VEC<dim_t> SHP;S A;',(⎕ucs 10),'typedef std::variant<NIL,arr,VEC<A>> VALS;'
_,←(⎕ucs 10),'S A{SHP s;VALS v;',(⎕ucs 10),' A(){}',(⎕ucs 10),' A(B r):s(SHP(r,1)){}',(⎕ucs 10),' A(SHP s,VALS v):s(s),v(v){}',(⎕ucs 10),' A(B r,VALS v):s(SHP(r,1)),v(v){}};',(⎕ucs 10)
_,←'typedef const A CA;S FN;S MOK;S DOK;typedef std::shared_ptr<FN> FNP;',(⎕ucs 10),'typedef std::shared_ptr<MOK> MOKP;typedef std::shared_ptr<DOK> DOKP;',(⎕ucs 10)
_,←'typedef std::variant<A,FNP,MOKP,DOKP> BX;',(⎕ucs 10),'typedef VEC<BX> FRM;typedef std::unique_ptr<FRM> FRMP;',(⎕ucs 10),'typedef VEC<FRMP> ENV;typedef std::stack<BX> STK;',(⎕ucs 10)
_,←'SHP eshp=SHP(0);std::wstring msg;',(⎕ucs 10),'S FN{STR nm;I sm;I sd;FNP this_p;virtual ~FN() = default;',(⎕ucs 10),' FN(STR nm,I sm,I sd):nm(nm),sm(sm),sd(sd){}',(⎕ucs 10)
_,←' FN():nm(""),sm(0),sd(0){}',(⎕ucs 10),' virtual arr id(SHP s){err(16);R arr();}',(⎕ucs 10),' virtual V operator()(A&z,CA&r,ENV&e){err(99);}',(⎕ucs 10)
_,←' virtual V operator()(A&z,CA&r,ENV&e,CA&ax){err(2);}',(⎕ucs 10),' virtual V operator()(A&z,CA&l,CA&r,ENV&e){err(99);}',(⎕ucs 10),' virtual V operator()(A&z,CA&l,CA&r,ENV&e,CA&ax){err(2);}};'
_,←(⎕ucs 10),'FNP MTFN = std::make_shared<FN>();',(⎕ucs 10),'S MOP:FN{CA aa;FNP llp=MTFN;FN&ll=*llp;',(⎕ucs 10),' MOP(STR nm,I sm,I sd,CA&l):FN(nm,sm,sd),aa(l),llp(MTFN){ll=*llp;}',(⎕ucs 10)
_,←' MOP(STR nm,I sm,I sd,FNP llp):FN(nm,sm,sd),llp(llp){ll=*llp;}};',(⎕ucs 10),'S DOP:FN{I fl;I fr;CA aa;CA ww;FNP llp=MTFN;FNP rrp=MTFN;FN&ll=*llp;FN&rr=*rrp;',(⎕ucs 10)
_,←' DOP(STR nm,I sm,I sd,FNP l,FNP r)',(⎕ucs 10),'  :FN(nm,sm,sd),fl(1),fr(1),llp(l),rrp(r){ll=*llp;rr=*rrp;}',(⎕ucs 10),' DOP(STR nm,I sm,I sd,CA&l,FNP r)',(⎕ucs 10)
_,←'  :FN(nm,sm,sd),fl(0),fr(1),aa(l),rrp(r){rr=*rrp;}',(⎕ucs 10),' DOP(STR nm,I sm,I sd,FNP l,CA&r)',(⎕ucs 10),'  :FN(nm,sm,sd),fl(1),fr(0),ww(r),llp(l){ll=*llp;}',(⎕ucs 10)
_,←' DOP(STR nm,I sm,I sd,CA&l,CA&r)',(⎕ucs 10),'  :FN(nm,sm,sd),fl(0),fr(0),aa(l),ww(r){}};',(⎕ucs 10),'S MOK{virtual ~MOK() = default;',(⎕ucs 10),' virtual FNP operator()(FNP l){err(99);R MTFN;}'
_,←(⎕ucs 10),' virtual FNP operator()(CA&l){err(99);R MTFN;}};',(⎕ucs 10),'S DOK{virtual ~DOK() = default;',(⎕ucs 10),' virtual FNP operator()(FNP l,FNP r){err(99);R MTFN;}',(⎕ucs 10)
_,←' virtual FNP operator()(CA&l,CA&r){err(99);R MTFN;}',(⎕ucs 10),' virtual FNP operator()(FNP l,CA&r){err(99);R MTFN;}',(⎕ucs 10),' virtual FNP operator()(CA&l,FNP r){err(99);R MTFN;}};',(⎕ucs 10)
_,←'S DVSTR {',(⎕ucs 10),' V operator()(NIL l,NIL r){err(6);}',(⎕ucs 10),' V operator()(NIL l,carr&r){err(6);}',(⎕ucs 10),' V operator()(NIL l,CVEC<A>&r){err(6);}',(⎕ucs 10)
_,←' V operator()(carr&l,NIL r){err(6);}',(⎕ucs 10),' V operator()(CVEC<A>&l,NIL r){err(6);}};',(⎕ucs 10),'S MVSTR {V operator()(NIL r){err(6);}};',(⎕ucs 10)
_,←'template<class... Ts> S visitor : Ts... { using Ts::operator()...; };',(⎕ucs 10),'template<class... Ts> visitor(Ts...) -> visitor<Ts...>;',(⎕ucs 10)
_,←'std::wstring mkstr(const char*s){R strconv.from_bytes(s);}',(⎕ucs 10),'I scm(FN&f){R f.sm;}I scm(const A&a){R 1;}I scm(FNP f){R (*f).sm;}',(⎕ucs 10)
_,←'I scd(FN&f){R f.sd;}I scd(const A&a){R 1;}I scd(FNP f){R (*f).sd;}',(⎕ucs 10),'B rnk(const SHP&s){R s.size();}',(⎕ucs 10),'B rnk(const A&a){R rnk(a.s);}',(⎕ucs 10)
_,←'B cnt(SHP s){B c=1;DOB(s.size(),c*=s[i]);R c;}',(⎕ucs 10),'B cnt(const A&a){R cnt(a.s);}',(⎕ucs 10),'B cnt(pkt*d){B c=1;DO(RANK(d),c*=SHAPE(d)[i]);R c;}',(⎕ucs 10),'B cnt(arr&a){R a.elements();}'
_,←(⎕ucs 10),'I geti(CA&a){I x;CVSWITCH(a.v,err(6),x=v.as(s32).scalar<I>(),err(11));R x;}',(⎕ucs 10),'arr scl(D x){R constant(x,dim4(1),f64);}',(⎕ucs 10),'arr scl(I x){R constant(x,dim4(1),s32);}'
_,←(⎕ucs 10),'arr scl(B x){R constant(x,dim4(1),u64);}',(⎕ucs 10),'A scl(arr v){R A(0,v);}',(⎕ucs 10),'arr axis(carr&a,const SHP&s,B ax){B l=1,m=1,r=1;if(ax>=rnk(s))R a;m=s[ax];',(⎕ucs 10)
_,←' DOB(ax,l*=s[i])DOB(rnk(s)-ax-1,r*=s[ax+i+1])',(⎕ucs 10),' R moddims(a,l,m,r);}',(⎕ucs 10),'arr table(carr&a,const SHP&s,B ax){B l=1,r=1;if(ax>=rnk(s))R a;',(⎕ucs 10)
_,←' DOB(ax,l*=s[i])DOB(rnk(s)-ax,r*=s[ax+i])',(⎕ucs 10),' R moddims(a,l,r);}',(⎕ucs 10),'arr unrav(carr&a,const SHP&sp){if(rnk(sp)>4)err(99);',(⎕ucs 10),' dim4 s(1);DO((I)rnk(sp),s[i]=sp[i])'
_,←(⎕ucs 10),' R moddims(a,s);}',(⎕ucs 10),'V af2cd(A&a,const arr&b){dim4 bs=b.dims();a.s=SHP(4,1);DO(4,a.s[i]=bs[i])',(⎕ucs 10),' a.v=flat(b);}',(⎕ucs 10)
_,←'dtype mxt(dtype at,dtype bt){if(at==c64||bt==c64)R c64;',(⎕ucs 10),' if(at==f64||bt==f64)R f64;',(⎕ucs 10),' if(at==s32||bt==s32)R s32;if(at==s16||bt==s16)R s16;',(⎕ucs 10)
_,←' if(at==b8||bt==b8)R b8;err(16);R f64;}',(⎕ucs 10),'dtype mxt(carr&a,carr&b){R mxt(a.type(),b.type());}',(⎕ucs 10),'dtype mxt(dtype at,CA&b){',(⎕ucs 10),' R std::visit(visitor{',(⎕ucs 10)
_,←'   [&](NIL _){err(99,L"Unexpected value error.");R s32;},',(⎕ucs 10),'   [&](carr&v){R mxt(at,v.type());},',(⎕ucs 10),'   [&](CVEC<A>&v){dtype zt=at;DOB(v.size(),zt=mxt(zt,v[i]));R zt;}},'
_,←(⎕ucs 10),'  b.v);}',(⎕ucs 10),'dtype mxt(CA&a,CA&b){R mxt(mxt(b8,a),mxt(b8,b));}',(⎕ucs 10),'inline I isint(D x){R x==nearbyint(x);}',(⎕ucs 10),'inline I isint(CA&x){I res=1;',(⎕ucs 10)
_,←' CVSWITCH(x.v',(⎕ucs 10),'  ,err(99,L"Unexpected value error.")',(⎕ucs 10),'  ,res=v.isinteger()||v.isbool()||(v.isreal()&&allTrue<I>(v==trunc(v)))',(⎕ucs 10)
_,←'  ,DOB(v.size(),if(!isint(v[i])){res=0;R;}))',(⎕ucs 10),' R res;}',(⎕ucs 10),'inline I isbool(carr&v){R v.isbool()||(v.isreal()&&allTrue<I>(v==0||v==1));}',(⎕ucs 10)
_,←'inline I isbool(CA&x){I res=1;',(⎕ucs 10),' CVSWITCH(x.v',(⎕ucs 10),'  ,err(99,L"Unexpected value error.")',(⎕ucs 10),'  ,res=isbool(v)',(⎕ucs 10),'  ,DOB(v.size(),if(!isbool(v[i])){res=0;R;}))'
_,←(⎕ucs 10),' R res;}',(⎕ucs 10),'V coal(A&a){',(⎕ucs 10),' VSWITCH(a.v,,,',(⎕ucs 10),'  B c=cnt(a);I can=1;',(⎕ucs 10),'  DOB(c,A&b=v[i];',(⎕ucs 10)
_,←'   coal(b);if(rnk(b))can=0;CVSWITCH(b.v,can=0,,can=0)',(⎕ucs 10),'   if(!can)break)',(⎕ucs 10),'  if(can){dtype tp=mxt(b8,a);arr nv(c,tp);',(⎕ucs 10)
_,←'   const wchar_t*msg=L"Unexpected non-simple array type.";',(⎕ucs 10),'   DOB(c,CVSWITCH(v[i].v,err(99,msg),nv((I)i)=v(0).as(tp),err(99,msg)))',(⎕ucs 10),'   a.v=nv;})}',(⎕ucs 10)
_,←'arr proto(carr&);VEC<A> proto(CVEC<A>&);A proto(CA&);',(⎕ucs 10),'arr proto(carr&a){arr z=a;z=0;R z;}',(⎕ucs 10),'VEC<A> proto(CVEC<A>&a){VEC<A> z(a.size());DOB(a.size(),z[i]=proto(a[i]));R z;}'
_,←(⎕ucs 10),'A proto(CA&a){A z;z.s=a.s;CVSWITCH(a.v,err(6),z.v=proto(v),z.v=proto(v));R z;}',(⎕ucs 10),'Z arr da16(B c,pkt*d){VEC<S16>b(c);S8*v=(S8*)DATA(d);',(⎕ucs 10)
_,←' DOB(c,b[i]=v[i]);R arr(c,b.data());}',(⎕ucs 10),'Z arr da8(B c,pkt*d){VEC<char>b(c);U8*v=(U8*)DATA(d);',(⎕ucs 10),' DOB(c,b[i]=1&(v[i/8]>>(7-(i%8))))R arr(c,b.data());}',(⎕ucs 10)
_,←'pkt*cpad(lp*l,CA&a){I t;B c=cnt(a),ar=rnk(a);pkt*p=NULL;',(⎕ucs 10),' if(ar>15)err(16,L"Dyalog APL does not support ranks > 15.");',(⎕ucs 10),' B s[15];DOB(ar,s[ar-i-1]=a.s[i]);',(⎕ucs 10)
_,←' std::visit(visitor{',(⎕ucs 10),'   [&](NIL _){if(l)l->p=NULL;},',(⎕ucs 10),'   [&](carr&v){',(⎕ucs 10),'    switch(v.type()){',(⎕ucs 10),'     CS(c64,t=APLZ);CS(s32,t=APLI);CS(s16,t=APLSI);'
_,←(⎕ucs 10),'     CS(b8,t=APLTI);CS(f64,t=APLD);',(⎕ucs 10),'     default:if(c)err(16);t=APLI;}',(⎕ucs 10),'    p=dwafns->ws->ga(t,(U)ar,s,l);if(c)v.host(DATA(p));},',(⎕ucs 10),'   [&](CVEC<A>&v){'
_,←(⎕ucs 10),'    p=dwafns->ws->ga(APLP,(U)ar,s,l);pkt**d=(pkt**)DATA(p);',(⎕ucs 10),'    DOB(c,if(!(d[i]=cpad(NULL,v[i])))err(6))}},',(⎕ucs 10),'  a.v);',(⎕ucs 10),'  R p;}',(⎕ucs 10)
_,←'V cpda(A&a,pkt*d){',(⎕ucs 10),' B c=cnt(d);a.s=SHP(RANK(d));DO(RANK(d),a.s[RANK(d)-i-1]=SHAPE(d)[i]);',(⎕ucs 10),' switch(TYPE(d)){',(⎕ucs 10),'  CS(15,',(⎕ucs 10),'   if(!c){a.v=scl(0);R;}'
_,←(⎕ucs 10),'   switch(ETYPE(d)){',(⎕ucs 10),'    CS(APLZ ,a.v=arr(c,(DZ*)DATA(d))) CS(APLI ,a.v=arr(c,(I*)DATA(d)))',(⎕ucs 10)
_,←'    CS(APLD ,a.v=arr(c,(D*)DATA(d)))  CS(APLSI,a.v=arr(c,(S16*)DATA(d)))',(⎕ucs 10),'    CS(APLTI,a.v=da16(c,d))           CS(APLU8,a.v=da8(c,d))',(⎕ucs 10),'    default:err(16);})',(⎕ucs 10)
_,←'  CS(7,{if(APLP!=ETYPE(d))err(16);',(⎕ucs 10),'   pkt**dv=(pkt**)DATA(d);',(⎕ucs 10),'   if(!c)c++;a.v=VEC<A>(c);',(⎕ucs 10),'   DOB(c,cpda(std::get<VEC<A>>(a.v)[i],dv[i]))})',(⎕ucs 10)
_,←'  default:err(16);}}',(⎕ucs 10),'V cpda(A&a,lp*d){if(d==NULL)R;cpda(a,d->p);}',(⎕ucs 10),'EXPORT A*mkarray(lp*d){A*z=new A;cpda(*z,d);R z;}',(⎕ucs 10),'EXPORT V frea(A*a){delete a;}',(⎕ucs 10)
_,←'EXPORT V exarray(lp*d,A*a){cpad(d,*a);}',(⎕ucs 10),'EXPORT V afsync(){sync();}',(⎕ucs 10),'EXPORT Window *w_new(char *k){R new Window(k);}',(⎕ucs 10),'EXPORT I w_close(Window*w){R w->close();}'
_,←(⎕ucs 10),'EXPORT V w_del(Window*w){delete w;}',(⎕ucs 10),'EXPORT V w_img(lp*d,Window*w){A a;cpda(a,d);',(⎕ucs 10),' std::visit(visitor{',(⎕ucs 10),'   [&](NIL&_){err(6);},',(⎕ucs 10)
_,←'   [&](VEC<A>&v){err(16,L"Image requires a flat array.");},',(⎕ucs 10),'   [&](carr&v){w->image(v.as(rnk(a)==2?f32:u8));}},',(⎕ucs 10),'  a.v);}',(⎕ucs 10)
_,←'EXPORT V w_plot(lp*d,Window*w){A a;cpda(a,d);',(⎕ucs 10),' std::visit(visitor{',(⎕ucs 10),'   [&](NIL&_){err(6);},',(⎕ucs 10),'   [&](VEC<A>&v){err(16,L"Plot requires a flat array.");},',(⎕ucs 10)
_,←'   [&](carr&v){w->plot(v.as(f32));}},',(⎕ucs 10),'  a.v);}',(⎕ucs 10),'EXPORT V w_hist(lp*d,D l,D h,Window*w){A a;cpda(a,d);',(⎕ucs 10),' std::visit(visitor{',(⎕ucs 10),'   [&](NIL&_){err(6);},'
_,←(⎕ucs 10),'   [&](VEC<A>&v){err(16,L"Hist requires a flat array.");},',(⎕ucs 10),'   [&](carr&v){w->hist(v.as(u32),l,h);}},',(⎕ucs 10),'  a.v);}',(⎕ucs 10)
_,←'EXPORT V loadimg(lp*z,char*p,I c){array a=loadImage(p,c);',(⎕ucs 10),' I rk=a.numdims();dim4 s=a.dims();',(⎕ucs 10),' A b(rk,flat(a).as(s16));DO(rk,b.s[i]=s[i])cpad(z,b);}',(⎕ucs 10)
_,←'EXPORT V saveimg(lp*im,char*p){A a;cpda(a,im);',(⎕ucs 10),' std::visit(visitor{',(⎕ucs 10),'   [&](NIL&_){err(6);},',(⎕ucs 10),'   [&](VEC<A>&v){err(16,L"Save requires a flat array.");},',(⎕ucs 10)
_,←'   [&](carr&v){saveImageNative(p,v.as(v.type()==s32?u16:u8));}},',(⎕ucs 10),'  a.v);}',(⎕ucs 10),'EXPORT V cd_sync(V){sync();}',(⎕ucs 10)
rth←_

rtm←'C:\Users\arcfi\OneDrive\Documents\Co-dfns\Source\rtm/'

_←⍬
_,←,⊂('NM(add,"add",1,1,DID,MFD,DFD,MT,DAD)',(⎕ucs 10),'DEFN(add)',(⎕ucs 10),'ID(add,0,s32)',(⎕ucs 10),'MF(add_f){z=r;}',(⎕ucs 10),'SF(add,z.v=lv+rv)',(⎕ucs 10))
_,←,⊂('NM(sub,"sub",1,1,DID,MFD,DFD,MT ,DAD)',(⎕ucs 10),'DEFN(sub)',(⎕ucs 10),'ID(sub,0,s32)',(⎕ucs 10),'SMF(sub,z.v=-rv)',(⎕ucs 10),'SF(sub,z.v=lv-rv)',(⎕ucs 10 10))
_,←,⊂('NM(mul,"mul",1,1,DID,MFD,DFD,MT ,DAD)',(⎕ucs 10),'DEFN(mul)',(⎕ucs 10),'ID(mul,1,s32)',(⎕ucs 10),'SMF(mul,z.v=(rv>0)-(rv<0))',(⎕ucs 10),'SF(mul,z.v=lv*rv)',(⎕ucs 10 10))
_,←,⊂('NM(div,"div",1,1,DID,MFD,DFD,MT,DAD)',(⎕ucs 10),'DEFN(div)',(⎕ucs 10),'ID(div,1,s32)',(⎕ucs 10),'SMF(div,z.v=1.0/rv.as(f64))',(⎕ucs 10),'SF(div,z.v=lv.as(f64)/rv.as(f64))',(⎕ucs 10))
_,←,⊂('NM(exp,"exp",1,1,DID,MFD,DFD,MT ,DAD)',(⎕ucs 10),'ID(exp,1,s32)',(⎕ucs 10),'DEFN(exp)',(⎕ucs 10),'SMF(exp,z.v=exp(rv.as(f64)))',(⎕ucs 10),'SF(exp,z.v=pow(lv.as(f64),rv.as(f64)))',(⎕ucs 10))
_,←,⊂('NM(log,"log",1,1,MT ,MFD,DFD,MT ,DAD)',(⎕ucs 10),'DEFN(log)',(⎕ucs 10),'SMF(log,z.v=log(rv.as(f64)))',(⎕ucs 10),'SF(log,z.v=log(rv.as(f64))/log(lv.as(f64)))',(⎕ucs 10 10))
_,←,⊂('NM(res,"res",1,1,DID,MFD,DFD,MT ,DAD)',(⎕ucs 10),'DEFN(res)',(⎕ucs 10),'ID(res,0,s32)',(⎕ucs 10),'SMF(res,z.v=abs(rv).as(rv.type()))',(⎕ucs 10),'SF(res,z.v=rv-lv*floor(rv.as(f64)/(lv+(0==lv))))',(⎕ucs 10 10))
_,←,⊂('NM(cir,"cir",1,1,MT,MFD,DFD,MT,DAD)',(⎕ucs 10),'DEFN(cir)',(⎕ucs 10),'SMF(cir,z.v=Pi*rv.as(f64))',(⎕ucs 10),'SF(cir,arr fv=rv.as(f64);B lr=rnk(l);',(⎕ucs 10),' if(!lr){I x=lv.as(s32).scalar<I>();if(abs(x)>10)err(16);',(⎕ucs 10),'  switch(x){CS(0,z.v=sqrt(1-fv*fv))CS(1,z.v=sin(fv))CS(2,z.v=cos(fv))',(⎕ucs 10),'   CS(3,z.v=tan(fv))CS(4,z.v=sqrt(1+fv*fv))CS(5,z.v=sinh(fv))',(⎕ucs 10),'   CS(6,z.v=cosh(fv))CS(7,z.v=tanh(fv))CS(8,z.v=sqrt(fv*fv-1))CS(9,z.v=fv)',(⎕ucs 10),'   CS(10,z.v=abs(fv))CS(-1,z.v=asin(fv))CS(-2,z.v=acos(fv))',(⎕ucs 10),'   CS(-3,z.v=atan(fv))CS(-4,z.v=(fv+1)*sqrt((fv-1)/(fv+1)))',(⎕ucs 10),'   CS(-5,z.v=asinh(fv))CS(-6,z.v=acosh(fv))CS(-7,z.v=atanh(fv))',(⎕ucs 10),'   CS(-8,z.v=-sqrt(fv*fv-1))CS(-9,z.v=fv)CS(-10,z.v=fv)}R;}',(⎕ucs 10),' if(anyTrue<I>(abs(lv)>10))err(16);B c=cnt(z);VEC<D> zv(c);',(⎕ucs 10),' VEC<I> a(c);lv.as(s32).host(a.data());VEC<D> b(c);fv.host(b.data());',(⎕ucs 10),' DOB(c,switch(a[i]){CS(0,zv[i]=sqrt(1-b[i]*b[i]))CS(1,zv[i]=sin(b[i]))',(⎕ucs 10),'  CS(2,zv[i]=cos(b[i]))CS(3,zv[i]=tan(b[i]))CS(4,zv[i]=sqrt(1+b[i]*b[i]))',(⎕ucs 10),'  CS(5,zv[i]=sinh(b[i]))CS(6,zv[i]=cosh(b[i]))CS(7,zv[i]=tanh(b[i]))',(⎕ucs 10),'  CS(8,zv[i]=sqrt(b[i]*b[i]-1))CS(9,zv[i]=b[i])CS(10,zv[i]=abs(b[i]))',(⎕ucs 10),'  CS(-1,zv[i]=asin(b[i]))CS(-2,zv[i]=acos(b[i]))CS(-3,zv[i]=atan(b[i]))',(⎕ucs 10),'  CS(-4,zv[i]=(b[i]==-1)?0:(b[i]+1)*sqrt((b[i]-1)/(b[i]+1)))',(⎕ucs 10),'  CS(-5,zv[i]=asinh(b[i]))CS(-6,zv[i]=acosh(b[i]))CS(-7,zv[i]=atanh(b[i]))',(⎕ucs 10),'  CS(-8,zv[i]=-sqrt(b[i]*b[i]-1))CS(-9,zv[i]=b[i])CS(-10,zv[i]=b[i])})',(⎕ucs 10),' z.v=arr(c,zv.data());)',(⎕ucs 10))
_,←,⊂('NM(min,"min",1,1,DID,MFD,DFD,MT ,DAD)',(⎕ucs 10),'DEFN(min)',(⎕ucs 10),'ID(min,DBL_MAX,f64)',(⎕ucs 10),'SMF(min,z.v=floor(rv).as(rv.type()))',(⎕ucs 10),'SF(min,z.v=min(lv,rv))',(⎕ucs 10 10))
_,←,⊂('NM(max,"max",1,1,DID,MFD,DFD,MT ,DAD)',(⎕ucs 10),'DEFN(max)',(⎕ucs 10),'ID(max,-DBL_MAX,f64)',(⎕ucs 10),'SMF(max,z.v=ceil(rv).as(rv.type()))',(⎕ucs 10),'SF(max,z.v=max(lv,rv))',(⎕ucs 10 10))
_,←,⊂('NM(fac,"fac",1,1,DID,MFD,DFD,MT ,DAD)',(⎕ucs 10),'DEFN(fac)',(⎕ucs 10),'ID(fac,1,s32)',(⎕ucs 10),'SMF(fac,z.v=factorial(rv.as(f64)))',(⎕ucs 10),'SF(fac,arr lvf=lv.as(f64);arr rvf=rv.as(f64);',(⎕ucs 10),' z.v=exp(lgamma(1+rvf)-(lgamma(1+lvf)+lgamma(1+rvf-lvf))))',(⎕ucs 10))
_,←,⊂('NM(lth,"lth",1,1,DID,MT ,DFD,MT ,DAD)',(⎕ucs 10),'DEFN(lth)',(⎕ucs 10),'ID(lth,0,s32)',(⎕ucs 10),'SF(lth,z.v=lv<rv)',(⎕ucs 10 10))
_,←,⊂('NM(lte,"lte",1,1,DID,MT ,DFD,MT ,DAD)',(⎕ucs 10),'DEFN(lte)',(⎕ucs 10),'ID(lte,1,s32)',(⎕ucs 10),'SF(lte,z.v=lv<=rv)',(⎕ucs 10 10))
_,←,⊂('NM(eql,"eql",1,1,DID,MT ,DFD,MT ,DAD)',(⎕ucs 10),'DEFN(eql)',(⎕ucs 10),'ID(eql,1,s32)',(⎕ucs 10),'SF(eql,z.v=lv==rv)',(⎕ucs 10))
_,←,⊂('NM(gte,"gte",1,1,DID,MT ,DFD,MT ,DAD)',(⎕ucs 10),'DEFN(gte)',(⎕ucs 10),'ID(gte,1,s32)',(⎕ucs 10),'SF(gte,z.v=lv>=rv)',(⎕ucs 10 10))
_,←,⊂('NM(gth,"gth",1,1,DID,MT ,DFD,MT ,DAD)',(⎕ucs 10),'DEFN(gth)',(⎕ucs 10),'ID(gth,0,s32)',(⎕ucs 10),'SF(gth,z.v=lv>rv)',(⎕ucs 10 10))
_,←,⊂('NM(neq,"neq",1,1,DID,MT ,DFD,MT ,DAD)',(⎕ucs 10),'DEFN(neq)',(⎕ucs 10),'ID(neq,0,s32)',(⎕ucs 10),'SF(neq,z.v=lv!=rv)',(⎕ucs 10 10))
_,←,⊂('NM(not,"not",1,0,MT ,MFD,DFD,MT ,MT )',(⎕ucs 10),'DEFN(not)',(⎕ucs 10),'SMF(not,z.v=!rv)',(⎕ucs 10),'DF(not_f){err(16);}',(⎕ucs 10 10))
_,←,⊂('NM(and,"and",1,1,DID,MT,DFD,MT,DAD)',(⎕ucs 10),'DEFN(and)',(⎕ucs 10),'ID(and,1,s32)',(⎕ucs 10),'SF(and,if(lv.isbool()&&rv.isbool())z.v=lv&&rv;',(⎕ucs 10),' else if(allTrue<I>(lv>=0&&lv<=1&&rv>0&&rv<=1))z.v=lv&&rv;',(⎕ucs 10),' else{A a(z.s,lv);A b(z.s,rv);',(⎕ucs 10),'  lor_c(a,a,b,e);arr&av=std::get<arr>(a.v);',(⎕ucs 10),'  z.v=lv.as(f64)*(rv/((!av)+av));})',(⎕ucs 10))
_,←,⊂('NM(lor,"lor",1,1,DID,MT ,DFD,MT ,DAD)',(⎕ucs 10),'DEFN(lor)',(⎕ucs 10),'ID(lor,0,s32)',(⎕ucs 10),'SF(lor,if(rv.isbool()&&lv.isbool())z.v=lv||rv;',(⎕ucs 10),' else if(lv.isbool()&&rv.isinteger())z.v=lv+(!lv)*abs(rv).as(rv.type());',(⎕ucs 10),' else if(rv.isbool()&&lv.isinteger())z.v=rv+(!rv)*abs(lv).as(lv.type());',(⎕ucs 10),' else if(lv.isinteger()&&rv.isinteger()){B c=cnt(z);',(⎕ucs 10),'  VEC<I> a(c);abs(lv).as(s32).host(a.data());',(⎕ucs 10),'  VEC<I> b(c);abs(rv).as(s32).host(b.data());',(⎕ucs 10),'  DOB(c,while(b[i]){I t=b[i];b[i]=a[i]%b[i];a[i]=t;})',(⎕ucs 10),'  z.v=arr(c,a.data());}',(⎕ucs 10),' else{B c=cnt(z);',(⎕ucs 10),'  VEC<D> a(c);abs(lv).as(f64).host(a.data());',(⎕ucs 10),'  VEC<D> b(c);abs(rv).as(f64).host(b.data());',(⎕ucs 10),'  DOB(c,while(b[i]>1e-12){D t=b[i];b[i]=fmod(a[i],b[i]);a[i]=t;})',(⎕ucs 10),'  z.v=arr(c,a.data());})',(⎕ucs 10 10))
_,←,⊂('NM(nan,"nan",1,1,MT ,MT ,DFD,MT ,DAD)',(⎕ucs 10),'DEFN(nan)',(⎕ucs 10),'SF(nan,z.v=!(lv&&rv))',(⎕ucs 10 10))
_,←,⊂('NM(nor,"nor",1,1,MT ,MT ,DFD,MT ,DAD)',(⎕ucs 10),'DEFN(nor)',(⎕ucs 10),'SF(nor,z.v=!(lv||rv))',(⎕ucs 10))
_,←,⊂('NM(sqd,"sqd",0,0,MT ,MFD,DFD,MT ,DAD)',(⎕ucs 10),'DEFN(sqd)',(⎕ucs 10),'MF(sqd_f){z=r;}',(⎕ucs 10),'DA(sqd_f){if(rnk(ax)>1)err(4);if(!isint(ax))err(11);',(⎕ucs 10),' B ac=cnt(ax);VEC<I> av(ac);',(⎕ucs 10),' if(ac)CVSWITCH(ax.v,err(6),v.as(s32).host(av.data()),err(11))',(⎕ucs 10),' B rr=rnk(r);DOB(ac,if(av[i]<0)err(11))DOB(ac,if(av[i]>=rr)err(4))',(⎕ucs 10),' B lc=cnt(l);if(rnk(l)>1)err(4);if(lc!=ac)err(5);if(!lc){z=r;R;}',(⎕ucs 10),' VEC<U8> m(rr);DOB(ac,if(m[av[i]])err(11);m[av[i]]=1)if(!isint(l))err(11);',(⎕ucs 10),' VEC<I> lv(lc);CVSWITCH(l.v,err(6),v.as(s32).host(lv.data()),err(16))',(⎕ucs 10),' DOB(lc,if(lv[i]<0||lv[i]>=r.s[rr-av[i]-1])err(3))',(⎕ucs 10),' z.s=SHP(rr-lc);I j=0;DOB(rr,if(!m[rr-i-1])z.s[j++]=r.s[i])',(⎕ucs 10),' CVSWITCH(r.v,err(6)',(⎕ucs 10),'  ,if(rr<5){IDX x[4];DOB(lc,x[rr-av[i]-1]=lv[i]);',(⎕ucs 10),'    dim4 rs(1);DO((I)rr,rs[i]=r.s[i])',(⎕ucs 10),'    z.v=flat(moddims(v,rs)(x[0],x[1],x[2],x[3]));R;}',(⎕ucs 10),'   VEC<seq> x(rr);arr ix=scl(0);',(⎕ucs 10),'   DOB(rr,x[i]=seq((D)r.s[i]))DOB(lc,x[rr-av[i]-1]=seq(lv[i],lv[i]))',(⎕ucs 10),'   DOB(rr,B j=rr-i-1;ix=moddims(ix*r.s[j],1,(U)cnt(ix));',(⎕ucs 10),'    ix=flat(tile(ix,(U)x[j].size,1)+tile(x[j],1,(U)cnt(ix))))',(⎕ucs 10),'   z.v=v(ix)',(⎕ucs 10),'  ,err(16))}',(⎕ucs 10),'DF(sqd_f){A ax;iot_c(ax,scl(scl((I)cnt(l))),e);sqd_c(z,l,r,e,ax);}',(⎕ucs 10))
_,←,⊂('NM(brk,"brk",0,0,MT,MT,DFD,MT,MT)',(⎕ucs 10),'DEFN(brk)',(⎕ucs 10),'DF(brk_f){B lr=rnk(l);B rc=cnt(r);',(⎕ucs 10),' if(!rc){if(lr!=1)err(4);z=l;R;}if(rc!=lr)err(4);',(⎕ucs 10),' CVSWITCH(r.v,err(6),err(99,L"Unexpected bracket index set"),)',(⎕ucs 10),' VEC<B> rm(rc);CVEC<A>&rv=std::get<VEC<A>>(r.v);',(⎕ucs 10),' DOB(rc,CVSWITCH(rv[i].v,rm[i]=1,rm[i]=rnk(rv[i]),err(11)))',(⎕ucs 10),' B zr=0;DOB(rc,zr+=rm[i])z.s=SHP(zr);B s=zr;',(⎕ucs 10),' DOB(rc,B j=i;s-=rm[j];',(⎕ucs 10),'  DOB(rm[j],B&x=z.s[s+i];',(⎕ucs 10),'   CVSWITCH(rv[j].v,x=l.s[rc-j-1],x=rv[j].s[i],err(99))))',(⎕ucs 10),' CVSWITCH(l.v,err(6)',(⎕ucs 10),'  ,if(zr<=4){IDX x[4];',(⎕ucs 10),'    DOB(rc,CVSWITCH(rv[i].v,,x[rc-i-1]=v.as(s32),err(99)))',(⎕ucs 10),'    dim4 sp(1);DO((I)lr,sp[i]=l.s[i])',(⎕ucs 10),'    z.v=flat(moddims(v,sp)(x[0],x[1],x[2],x[3]));}',(⎕ucs 10),'   else err(16);',(⎕ucs 10),'  ,if(lr!=1)err(16);if(rc!=1)err(16);',(⎕ucs 10),'   VEC<A> zv(1);I i=std::get<arr>(rv[0].v).as(s32).scalar<I>();\',(⎕ucs 10),'   CVEC<A> lv=std::get<VEC<A>>(l.v);',(⎕ucs 10),'   zv[0]=lv[i];z.v=zv;)}',(⎕ucs 10 10),'OD(brk,"brk",scm(l),scd(l),MFD,DFD,MT ,MT )',(⎕ucs 10),'MF(brk_o){if(rnk(ww)>1)err(4);ll(z,r,e,ww);}',(⎕ucs 10),'DF(brk_o){if(rnk(ww)>1)err(4);ll(z,l,r,e,ww);}',(⎕ucs 10 10))
_,←,⊂('NM(iot,"iot",0,0,MT ,MFD,DFD,MT ,MT )',(⎕ucs 10),'DEFN(iot)',(⎕ucs 10),'MF(iot_f){if(rnk(r)>1)err(4);B c=cnt(r);if(c>4)err(10);if(c>1)err(16);',(⎕ucs 10),' CVSWITCH(r.v,err(6)',(⎕ucs 10),'  ,I rv=v.as(s32).scalar<I>();',(⎕ucs 10),'   z.s=SHP(1,rv);z.v=z.s[0]?iota(dim4(rv),dim4(1),s32):scl(0);',(⎕ucs 10),'  ,err(11))}',(⎕ucs 10),'DF(iot_f){z.s=r.s;B c=cnt(r);if(!c){z.v=scl(0);R;}',(⎕ucs 10),' I lc=(I)cnt(l)+1;if(lc==1){z.v=constant(0,cnt(r),s16);R;};if(rnk(l)>1)err(16);',(⎕ucs 10),' std::visit(visitor{DVSTR(),',(⎕ucs 10),'   [&](carr&olv,carr&orv){arr lv=olv,rv=orv,ix;sort(lv,ix,lv);',(⎕ucs 10),'    z.v=constant(0,cnt(r),s32);arr&zv=std::get<arr>(z.v);',(⎕ucs 10),'    for(I h;h=lc/2;lc-=h){arr t=zv+h;replace(zv,lv(t)>rv,t);}',(⎕ucs 10),'    zv=arr(select(lv(zv)==rv,ix(zv).as(s32),(I)cnt(l)),c);},',(⎕ucs 10),'   [&](CVEC<A>&lv,carr&rv){err(16);},',(⎕ucs 10),'   [&](carr&lv,CVEC<A>&rv){err(16);},',(⎕ucs 10),'   [&](CVEC<A>&lv,CVEC<A>&rv){err(16);}},',(⎕ucs 10),'  l.v,r.v);}',(⎕ucs 10))
_,←,⊂('NM(rho,"rho",0,0,MT ,MFD,DFD,MT ,MT )',(⎕ucs 10),'DEFN(rho)',(⎕ucs 10),'MF(rho_f){B rr=rnk(r);VEC<I> sp(rr);DOB(rr,sp[rr-i-1]=(I)r.s[i])',(⎕ucs 10),' z.s=SHP(1,rr);if(!cnt(z)){z.v=scl(0);R;}z.v=arr(rr,sp.data());}',(⎕ucs 10),'DF(rho_f){B cr=cnt(r),cl=cnt(l);VEC<I> s(cl);',(⎕ucs 10),' if(rnk(l)>1)err(11);if(!isint(l))err(11);',(⎕ucs 10),' CVSWITCH(l.v,err(6),if(cl)v.as(s32).host(s.data()),if(cl)err(16))',(⎕ucs 10),' DOB(cl,if(s[i]<0)err(11))z.s=SHP(cl);DOB(cl,z.s[i]=(B)s[cl-i-1])',(⎕ucs 10),' B cz=cnt(z);',(⎕ucs 10),' if(!cz){CVSWITCH(r.v,err(6),z.v=proto(v(0)),z.v=VEC<A>(1,proto(v[0])))R;}',(⎕ucs 10),' if(cz==cr){z.v=r.v;R;}',(⎕ucs 10),' CVSWITCH(r.v,err(6),z.v=v(iota(cz)%cr),',(⎕ucs 10),'  z.v=VEC<A>(cz);VEC<A>&zv=std::get<VEC<A>>(z.v);DOB(cz,zv[i]=v[i%cr]))}',(⎕ucs 10))
_,←,⊂('NM(cat,"cat",0,0,MT ,MFD,DFD,MAD,DAD)',(⎕ucs 10),'DEFN(cat)',(⎕ucs 10),'MF(cat_f){z.s=SHP(1,cnt(r));z.v=r.v;}',(⎕ucs 10),'MA(cat_f){B ac=cnt(ax),ar=rnk(ax),rr=rnk(r);if(ac>1&&ar>1)err(4);',(⎕ucs 10),' VEC<D> axv(ac);if(ac)CVSWITCH(ax.v,err(6),v.as(f64).host(axv.data()),err(11))',(⎕ucs 10),' if(ac==1&&(axv[0]<=-1||rr<=axv[0]))err(4);',(⎕ucs 10),' if(ac>1){I c=(I)axv[0];if(c<0)err(11);DO((I)ac,if(axv[i]!=c++)err(11))',(⎕ucs 10),'  if(c>rr)err(4);}',(⎕ucs 10),' I xt=(!ac||(ac==1&&!isint(axv[0])));if(rr==4&&xt)err(16);',(⎕ucs 10),' z=r;B zr=rr;if(!xt&&ac==1)R;DO((I)ac,axv[i]=ceil(rr-axv[i]-1))',(⎕ucs 10),' if(xt){zr++;SHP sp(zr);DOB(rr,sp[i]=r.s[i])B pt=ac?(B)axv[0]:0;',(⎕ucs 10),'  DOB(rr-pt,sp[zr-i-1]=sp[zr-i-2])sp[pt]=1;z.s=sp;R;}',(⎕ucs 10),' B s=(B)axv[ac-1],ei=(B)axv[0];',(⎕ucs 10),' zr=rr-ac+1;z.s=SHP(zr,1);DOB(s,z.s[i]=r.s[i])',(⎕ucs 10),' DOB(ac,z.s[s]*=r.s[s+i])DOB(rr-ei-1,z.s[s+i+1]=r.s[ei+i+1])}',(⎕ucs 10),'DA(cat_f){B ar=rnk(ax),lr=rnk(l),rr=rnk(r);',(⎕ucs 10),' if(lr>4||rr>4)err(16);',(⎕ucs 10),' if(ar>1)err(4);if(cnt(ax)!=1)err(5);',(⎕ucs 10),' D ox;CVSWITCH(ax.v,err(6),ox=v.as(f64).scalar<D>(),err(11))',(⎕ucs 10),' B rk=lr>rr?lr:rr;if(ox<=-1)err(11);if(ox>=rk)err(4);',(⎕ucs 10),' if(lr&&rr&&std::abs((I)lr-rr)>1)err(4);',(⎕ucs 10),' A nl=l,nr=r;D axv=rk-ox-1;I fx=(I)ceil(axv);',(⎕ucs 10),' if(axv!=fx){if(rr>3||lr>3)err(16);if(rr&&lr&&lr!=rr)err(4);',(⎕ucs 10),'  if(lr)cat_c(nl,l,e,ax);if(rr)cat_c(nr,r,e,ax);',(⎕ucs 10),'  if(!lr&&!rr)cat_c(nl,l,e,ax);cat_c(nr,r,e,ax);',(⎕ucs 10),'  cat_c(z,nl,nr,e,scl(scl((I)ceil(ox))));R;}',(⎕ucs 10),' z.s=SHP((lr>=rr)*lr+(rr>lr)*rr+(!rr&&!lr));',(⎕ucs 10),' dim4 ls(1),rs(1);DO((I)lr,ls[i]=l.s[i])DO((I)rr,rs[i]=r.s[i])',(⎕ucs 10),' if(!lr){ls=rs;ls[fx]=1;}if(!rr){rs=ls;rs[fx]=1;}',(⎕ucs 10),' if(rr&&lr>rr){DO(3-fx,rs[3-i]=rs[3-i-1]);rs[fx]=1;}',(⎕ucs 10),' if(lr&&rr>lr){DO(3-fx,ls[3-i]=ls[3-i-1]);ls[fx]=1;}',(⎕ucs 10),' DO(4,if(i!=fx&&rs[i]!=ls[i])err(5));',(⎕ucs 10),' DO((I)rnk(z),z.s[i]=(lr>=rr||i==fx)*ls[i]+(rr>lr||i==fx)*rs[i]);',(⎕ucs 10),' std::visit(visitor{DVSTR(),',(⎕ucs 10),'   [&](CVEC<A>&lv,carr&rv){err(16);},',(⎕ucs 10),'   [&](carr&lv,CVEC<A>&rv){err(16);},',(⎕ucs 10),'   [&](CVEC<A>&lv,CVEC<A>&rv){if(rr>1||lr>1)err(16);B lc=cnt(l),rc=cnt(r);',(⎕ucs 10),'    z.v=VEC<A>(lc+rc,A());VEC<A>&zv=std::get<VEC<A>>(z.v);',(⎕ucs 10),'    DOB(lc,zv[i]=lv[i])DOB(rc,zv[i+lc]=rv[i])},',(⎕ucs 10),'   [&](carr&olv,carr&orv){dtype mt=mxt(orv,olv);',(⎕ucs 10),'    array lv=(lr?moddims(olv,ls):tile(olv,ls)).as(mt);',(⎕ucs 10),'    array rv=(rr?moddims(orv,rs):tile(orv,rs)).as(mt);',(⎕ucs 10),'    if(!cnt(l)){z.v=flat(rv);R;}if(!cnt(r)){z.v=flat(lv);R;}',(⎕ucs 10),'    z.v=flat(join(fx,lv,rv));}},',(⎕ucs 10),'  l.v,r.v);}',(⎕ucs 10),'DF(cat_f){B lr=rnk(l),rr=rnk(r);',(⎕ucs 10),' if(lr||rr){cat_c(z,l,r,e,scl(scl((lr>rr?lr:rr)-1)));R;}',(⎕ucs 10),' A a,b;cat_c(a,l,e);cat_c(b,r,e);cat_c(z,a,b,e);}',(⎕ucs 10))
_,←,⊂('NM(ctf,"ctf",0,0,MT,MFD,DFD,MT,DAD)',(⎕ucs 10),'DEFN(ctf)',(⎕ucs 10),'MF(ctf_f){B rr=rnk(r);z.s=SHP(2,1);z.v=r.v;',(⎕ucs 10),' if(rr)z.s[1]=r.s[rr-1];if(z.s[1])z.s[0]=cnt(r)/z.s[1];}',(⎕ucs 10),'DA(ctf_f){cat_c(z,l,r,e,ax);}',(⎕ucs 10),'DF(ctf_f){if(rnk(l)||rnk(r)){cat_c(z,l,r,e,scl(scl(0)));R;}',(⎕ucs 10),' A a,b;cat_c(a,l,e);cat_c(b,r,e);cat_c(z,a,b,e);}',(⎕ucs 10))
_,←,⊂('NM(rot,"rot",0,0,DID,MFD,DFD,MAD,DAD)',(⎕ucs 10),'DEFN(rot)',(⎕ucs 10),'ID(rot,0,s32)',(⎕ucs 10),'MF(rot_f){if(!rnk(r)){z=r;R;}rot_c(z,r,e,scl(scl(rnk(r)-1)));}',(⎕ucs 10),'MA(rot_f){if(1!=cnt(ax))err(5);if(!isint(ax))err(11);',(⎕ucs 10),' I axv;CVSWITCH(ax.v,err(6),axv=v.as(s32).scalar<I>(),err(11))',(⎕ucs 10),' B rr=rnk(r);if(axv<0||rr<=axv)err(4);z.s=r.s;if(!cnt(r)){z.v=r.v;R;}',(⎕ucs 10),' CVSWITCH(r.v,err(6)',(⎕ucs 10),'  ,z.v=flat(flip(axis(v,r.s,rr-axv-1),1))',(⎕ucs 10),'  ,err(16))}',(⎕ucs 10),'DA(rot_f){B rr=rnk(r),lr=rnk(l);if(rr>4)err(16);',(⎕ucs 10),' if(rnk(ax)>1||cnt(ax)!=1)err(5);if(!isint(ax))err(11);',(⎕ucs 10),' I ra;CVSWITCH(ax.v,err(6),ra=v.as(s32).scalar<I>(),err(11))',(⎕ucs 10),' if(ra<0)err(11);if(ra>=rr)err(4);B lc=cnt(l);I aa=ra;ra=(I)rr-ra-1;',(⎕ucs 10),' if(lc!=1&&lr!=rr-1)err(4);',(⎕ucs 10),' if(lc==1){z.s=r.s;I ix[]={0,0,0,0};',(⎕ucs 10),'  CVSWITCH(l.v,err(6),ix[ra]=-v.as(s32).scalar<I>(),err(11))',(⎕ucs 10),'  CVSWITCH(r.v,err(6)',(⎕ucs 10),'   ,z.v=flat(shift(unrav(v,r.s),ix[0],ix[1],ix[2],ix[3]))',(⎕ucs 10),'   ,err(16))',(⎕ucs 10),'  R;}',(⎕ucs 10),' I j=0;DOB(lr,if(i==ra)j++;if(l.s[i]!=r.s[j++])err(5))',(⎕ucs 10),' res_c(z,scl(scl(r.s[ra])),l,e);arr&zv=std::get<arr>(z.v);',(⎕ucs 10),' B tc=1;DO(ra,tc*=r.s[i])zv*=tc;cat_c(z,z,e,scl(scl(aa-.5)));',(⎕ucs 10),' zv=flat(tile(axis(zv,z.s,ra),1,(U)r.s[ra],1));z.s[ra]=r.s[ra];',(⎕ucs 10),' dim4 s1(1);dim4 s2(1);',(⎕ucs 10),' DO(ra+1,s1[i]=r.s[i])DO((I)rr-ra-1,s2[ra+i+1]=r.s[ra+i+1])',(⎕ucs 10),' zv+=flat(iota(s1,s2));zv=zv%(tc*r.s[ra]);',(⎕ucs 10),' arr rv;CVSWITCH(r.v,err(6),rv=v,err(16))',(⎕ucs 10),' zv=flat(rv(zv+(tc*r.s[ra])*flat(iota(s2,s1))));}',(⎕ucs 10),'DF(rot_f){B rr=rnk(r),lr=rnk(l);if(!rr){B lc=cnt(l);if(lc!=1&&lr)err(4);z=r;R;}',(⎕ucs 10),' rot_c(z,l,r,e,scl(scl(rr-1)));}',(⎕ucs 10))
_,←,⊂('NM(trn,"trn",0,0,MT ,MFD,DFD,MT ,MT )',(⎕ucs 10),'DEFN(trn)',(⎕ucs 10),'MF(trn_f){B rr=rnk(r);if(rr<=1){z=r;R;}',(⎕ucs 10),' A t(SHP(1,rr),seq((D)rr-1,0,-1));trn_c(z,t,r,e);}',(⎕ucs 10),'DF(trn_f){B lr=rnk(l),rr=rnk(r);if(lr>1||cnt(l)!=rr)err(5);if(rr<=1){z=r;R;}',(⎕ucs 10),' VEC<I> lv(rr);if(!isint(l))err(11);',(⎕ucs 10),' CVSWITCH(l.v,err(6),v.as(s32).host(lv.data()),err(11))',(⎕ucs 10),' DOB(rr,if(lv[i]<0||lv[i]>=rr)err(4))VEC<U8> f(rr,0);DOB(rr,f[lv[i]]=1)',(⎕ucs 10),' U8 t=1;DOB(rr,if(t&&!f[i])t=0;else if(!t&&f[i])err(5))',(⎕ucs 10),' if(t&&rr<=4){z.s=SHP(rr);DOB(rr,z.s[rr-lv[i]-1]=r.s[rr-i-1])',(⎕ucs 10),'  switch(rr){case 0:case 1:z.v=r.v;R;}',(⎕ucs 10),'  VEC<I> s(rr);DOB(rr,s[rr-lv[i]-1]=(I)(rr-i-1))',(⎕ucs 10),'  arr rv;CVSWITCH(r.v,err(6),rv=unrav(v,r.s),err(16))',(⎕ucs 10),'  switch(rr){CS(2,z.v=flat(reorder(rv,s[0],s[1])))',(⎕ucs 10),'   CS(3,z.v=flat(reorder(rv,s[0],s[1],s[2])))',(⎕ucs 10),'   CS(4,z.v=flat(reorder(rv,s[0],s[1],s[2],s[3])))}}',(⎕ucs 10),' else{B rk=0;DOB(rr,if(rk<lv[i])rk=lv[i])rk++;z.s=SHP(rk,LLONG_MAX);',(⎕ucs 10),'  DOB(rr,B j=rk-lv[i]-1;B k=rr-i-1;if(z.s[j]>r.s[k])z.s[j]=r.s[k])',(⎕ucs 10),'  SHP zs(rk),rs(rr);',(⎕ucs 10),'  B c=1;DOB(rk,zs[i]=c;c*=z.s[i])c=1;DOB(rr,rs[i]=c;c*=r.s[i])c=cnt(z);',(⎕ucs 10),'  arr ix=iota(dim4(c),dim4(1),s32),jx=constant(0,dim4(c),s32);',(⎕ucs 10),'  DOB(rr,B j=rk-lv[i]-1;B k=rr-i-1;jx+=rs[k]*((ix/zs[j])%z.s[j]))',(⎕ucs 10),'  CVSWITCH(r.v,err(6),z.v=v(jx),err(16))}}',(⎕ucs 10))
_,←,⊂('NM(rtf,"rtf",0,0,DID,MFD,DFD,MAD,DAD)',(⎕ucs 10),'DEFN(rtf)',(⎕ucs 10),'ID(rtf,0,s32)',(⎕ucs 10),'MF(rtf_f){if(!rnk(r)){z=r;R;}rot_c(z,r,e,scl(scl(0)));}',(⎕ucs 10),'MA(rtf_f){rot_c(z,r,e,ax);}',(⎕ucs 10),'DA(rtf_f){rot_c(z,l,r,e,ax);}',(⎕ucs 10),'DF(rtf_f){if(!rnk(r)){B lc=cnt(l);if(lc!=1&&rnk(l))err(4);z=r;R;}',(⎕ucs 10),' rot_c(z,l,r,e,scl(scl(0)));}',(⎕ucs 10))
_,←,⊂('NM(mem,"mem",0,0,MT ,MFD,DFD,MT ,MT )',(⎕ucs 10),'DEFN(mem)',(⎕ucs 10),'MF(mem_f){z.s=SHP(1,cnt(r));z.v=r.v;}',(⎕ucs 10),'DF(mem_f){z.s=l.s;B lc=cnt(z);if(!lc){z.v=scl(0);R;}',(⎕ucs 10),' if(!cnt(r)){arr zv(lc,b8);zv=0;z.v=zv;R;}',(⎕ucs 10),' arr y;CVSWITCH(r.v,err(6),y=setUnique(v),err(16))',(⎕ucs 10),' B rc=y.elements();',(⎕ucs 10),' arr x;CVSWITCH(l.v,err(6),x=arr(v,lc,1),err(16))',(⎕ucs 10),' y=arr(y,1,rc);',(⎕ucs 10),' z.v=arr(anyTrue(tile(x,1,(I)rc)==tile(y,(I)lc,1),1),lc);}',(⎕ucs 10 10))
_,←,⊂('NM(dis,"dis",0,0,MT,MFD,DFD,MT,MT)',(⎕ucs 10),'DEFN(dis)',(⎕ucs 10),'MF(dis_f){CVSWITCH(r.v,err(6),z.s=eshp;z.v=v(0),z=v[0])}',(⎕ucs 10),'DF(dis_f){if(!isint(l))err(11);if(rnk(l)>1)err(4);',(⎕ucs 10),' B lc=cnt(l);if(!lc){z=r;R;}if(lc!=1||rnk(r)!=1)err(16);',(⎕ucs 10),' I i;CVSWITCH(l.v,err(6),i=v.as(s32).scalar<I>(),err(16))',(⎕ucs 10),' if(i<0||i>=cnt(r))err(3);',(⎕ucs 10),' CVSWITCH(r.v,err(6),z.s=eshp;z.v=v(i),z=v[i])}',(⎕ucs 10))
_,←,⊂('NM(eqv,"eqv",0,0,MT ,MFD,DFD,MT ,MT )',(⎕ucs 10),'DEFN(eqv)',(⎕ucs 10),'MF(eqv_f){z.s=eshp;z.v=scl(rnk(r)!=0);}',(⎕ucs 10),'I is_eqv(CA&l,CA&r){B lr=rnk(l),rr=rnk(r);if(lr!=rr)R 0;',(⎕ucs 10),' DOB(lr,if(l.s[i]!=r.s[i])R 0)',(⎕ucs 10),' I res=1;',(⎕ucs 10),' std::visit(visitor{DVSTR(),',(⎕ucs 10),'   [&](carr&lv,carr&rv){res=allTrue<I>(lv==rv);},',(⎕ucs 10),'   [&](CVEC<A>&lv,carr&rv){res=0;},',(⎕ucs 10),'   [&](carr&lv,CVEC<A>&rv){res=0;},',(⎕ucs 10),'   [&](CVEC<A>&lv,CVEC<A>&rv){B c=cnt(l);',(⎕ucs 10),'    DOB(c,if(!is_eqv(lv[i],rv[i])){res=0;R;})}},',(⎕ucs 10),'  l.v,r.v);',(⎕ucs 10),' R res;}',(⎕ucs 10),'DF(eqv_f){z.s=eshp;z.v=scl(is_eqv(l,r));}',(⎕ucs 10))
_,←,⊂('NM(nqv,"nqv",0,0,MT ,MFD,DFD,MT ,MT )',(⎕ucs 10),'DEFN(nqv)',(⎕ucs 10),'MF(nqv_f){B rr=rnk(r);z.v=scl(rr?(I)r.s[rr-1]:1);z.s=eshp;}',(⎕ucs 10),'DF(nqv_f){z.s=eshp;z.v=scl(!is_eqv(l,r));}',(⎕ucs 10))
_,←,⊂('NM(rgt,"rgt",0,0,MT ,MFD,DFD,MT ,MT )',(⎕ucs 10),'DEFN(rgt)',(⎕ucs 10),'MF(rgt_f){z=r;}',(⎕ucs 10),'DF(rgt_f){z=r;}',(⎕ucs 10 10))
_,←,⊂('NM(lft,"lft",0,0,MT ,MFD,DFD,MT ,MT )',(⎕ucs 10),'DEFN(lft)',(⎕ucs 10),'MF(lft_f){z=r;}',(⎕ucs 10),'DF(lft_f){z=l;}',(⎕ucs 10 10))
_,←,⊂('NM(enc,"enc",0,0,DID,MT ,DFD,MT ,MT )',(⎕ucs 10),'DEFN(enc)',(⎕ucs 10),'ID(enc,0,s32)',(⎕ucs 10),'DF(enc_f){B rr=rnk(r),lr=rnk(l),rk=rr+lr;if(rk>4)err(16);',(⎕ucs 10),' SHP sp(rk);DOB(rr,sp[i]=r.s[i])DOB(lr,sp[i+rr]=l.s[i])',(⎕ucs 10),' if(!cnt(sp)){z.s=sp;z.v=scl(0);R;}',(⎕ucs 10),' dim4 lt(1),rt(1);DO((I)rk,lt[i]=rt[i]=sp[i])I k=lr?(I)lr-1:0;',(⎕ucs 10),' DO((I)rr,rt[i]=1)DO((I)lr,lt[i+(I)rr]=1)',(⎕ucs 10),' arr rv;CVSWITCH(r.v,err(6),rv=v,err(11))',(⎕ucs 10),' arr lv;CVSWITCH(l.v,err(6),lv=v,err(11))',(⎕ucs 10),' rv=tile(unrav(rv,r.s),rt);z.s=sp;',(⎕ucs 10),' arr dv=flip(scan(flip(unrav(lv.as(s64),l.s),k),k,AF_BINARY_MUL),k);',(⎕ucs 10),' lv=tile(arr(dv,rt),lt);IDX x[4];x[k]=0;',(⎕ucs 10),' dv(x[0],x[1],x[2],x[3])=1;I s[]={0,0,0,0};s[k]=-1;',(⎕ucs 10),' dv=shift(dv,s[0],s[1],s[2],s[3]);dv=tile(arr(dv,rt),lt);',(⎕ucs 10),' arr ix=where(lv);z.v=arr();arr&zv=std::get<arr>(z.v);',(⎕ucs 10),' zv=rv.as(s32);',(⎕ucs 10),' zv=(rv-lv*floor(rv.as(f64)/(lv+(lv==0)))).as(s32);',(⎕ucs 10),' ix=where(dv);zv*=dv!=0;zv(ix)=floor(zv(ix).as(f64)/dv(ix)).as(s32);',(⎕ucs 10),' zv=flat(zv);}',(⎕ucs 10))
_,←,⊂('NM(dec,"dec",0,0,MT,MT,DFD,MT,MT)',(⎕ucs 10),'DEFN(dec)',(⎕ucs 10),'DF(dec_f){B rr=rnk(r),lr=rnk(l),ra=rr?rr-1:0,la=lr?lr-1:0;z.s=SHP(ra+la);',(⎕ucs 10),' if(rr&&lr)if(l.s[0]!=1&&l.s[0]!=r.s[ra]&&r.s[ra]!=1)err(5);',(⎕ucs 10),' DOB(ra,z.s[i]=r.s[i])DOB(la,z.s[i+ra]=l.s[i+1])',(⎕ucs 10),' if(!cnt(z)){z.v=scl(0);R;}',(⎕ucs 10),' if(!cnt(r)||!cnt(l)){z.v=constant(0,cnt(z),s32);R;}',(⎕ucs 10),' B lc=lr?l.s[0]:1;',(⎕ucs 10),' arr rv;CVSWITCH(r.v,err(6),rv=v,err(11))',(⎕ucs 10),' arr lv;CVSWITCH(l.v,err(6),lv=v,err(11))',(⎕ucs 10),' arr x=unrav(lv,l.s);if(lc==1){lc=r.s[ra];x=tile(x,(I)lc);}',(⎕ucs 10),' x=flip(scan(x,0,AF_BINARY_MUL,false),0);',(⎕ucs 10),' x=arr(x,lc,x.elements()/lc).as(f64);',(⎕ucs 10),' arr y=arr(rv,cnt(r)/r.s[ra],r.s[ra]).as(f64);',(⎕ucs 10),' z.v=flat(matmul(r.s[ra]==1?tile(y,1,(I)lc):y,x));}',(⎕ucs 10))
_,←,⊂('NM(red,"red",0,0,DID,MT ,DFD,MT ,DAD)',(⎕ucs 10),'ID(red,1,s32)',(⎕ucs 10),'DEFN(red)',(⎕ucs 10),'OM(red,"red",0,0,MFD,DFD,MAD,DAD)',(⎕ucs 10),'DA(red_f){B ar=rnk(ax),lr=rnk(l),rr=rnk(r),zr;if(lr>4||rr>4)err(16);',(⎕ucs 10),' if(ar>1||cnt(ax)!=1)err(5);if(!isint(ax))err(11);',(⎕ucs 10),' I axv;CVSWITCH(ax.v,err(6),axv=v.as(s32).scalar<I>(),err(11))',(⎕ucs 10),' if(axv<0)err(11);if(axv>=rr)err(4);',(⎕ucs 10),' dim4 zs(1),ls(1),rs(1);DO((I)lr,ls[i]=l.s[i])DO((I)rr,rs[i]=r.s[i])',(⎕ucs 10),' if(lr>1)err(4);axv=(I)rr-axv-1;B lc=cnt(l),rsx=rs[axv];',(⎕ucs 10),' if(lr!=0&&lc!=1&&rr!=0&&rsx!=1&&lc!=rsx)err(5);',(⎕ucs 10),' arr lv;CVSWITCH(l.v,err(6),lv=moddims(v,ls),err(11))',(⎕ucs 10),' arr x=lc==1?tile(lv,(I)rsx):lv;B zc=sum<B>(abs(x));',(⎕ucs 10),' zr=rr?rr:1;zs=rs;zs[axv]=zc;z.s=SHP(zr);DO((I)zr,z.s[i]=zs[i])',(⎕ucs 10),' if(!cnt(z)){z.v=scl(0);R;}arr w=where(x).as(s32);',(⎕ucs 10),' CVSWITCH(r.v,err(6)',(⎕ucs 10),'  ,arr rv=moddims(v,rs);arr y=rsx==1?tile(rv,(I)lc):rv;IDX ix[4];',(⎕ucs 10),'   z.v=arr();arr&zv=std::get<arr>(z.v);',(⎕ucs 10),'   if(zc==w.elements()){ix[axv]=w;zv=y(ix[0],ix[1],ix[2],ix[3]);',(⎕ucs 10),'    if(zc==sum<B>(x(w)))R;dim4 sp(zs);sp[axv]=1;',(⎕ucs 10),'    zv*=tile(x(w)>0,(I)sp[0],(I)sp[1],(I)sp[2],(I)sp[3]);zv=flat(zv);R;}',(⎕ucs 10),'   arr s=(!sign(x(w))).as(s32);arr i=shift(accum(abs(x(w))),1);',(⎕ucs 10),'   arr d=shift(w,1);arr t=shift(s,1);arr q(zc,s32);arr u(zc,s32);',(⎕ucs 10),'   i(0)=0;d(0)=0;q=0;u=0;t(0)=0;q(i)=w-d;u(i)=s-t;ix[axv]=accum(q);',(⎕ucs 10),'   zv=y(ix[0],ix[1],ix[2],ix[3]);',(⎕ucs 10),'   dim4 s1(1);dim4 s2(zs);s1[axv]=zc;s2[axv]=1;u=arr(accum(u),s1);',(⎕ucs 10),'   zv*=tile(u,(I)s2[0],(I)s2[1],(I)s2[2],(I)s2[3]);zv=flat(zv)',(⎕ucs 10),'  ,err(16))}',(⎕ucs 10),'DF(red_f){A x=r;if(!rnk(r))cat_c(x,r,e);red_c(z,l,x,e,scl(scl(rnk(x)-1)));}',(⎕ucs 10),'MA(red_o){B ar=rnk(ax),rr=rnk(r);if(rr>4)err(16);',(⎕ucs 10),' if(ar>1)err(4);if(cnt(ax)!=1)err(5);if(!isint(ax))err(11);',(⎕ucs 10),' I av;CVSWITCH(ax.v,err(6),av=v.as(s32).scalar<I>(),err(11))',(⎕ucs 10),' if(av<0)err(11);if(av>=rr)err(4);av=(I)rr-av-1;I rc=(I)r.s[av];',(⎕ucs 10),' z.s=SHP(rr-1);I ib=isbool(r);',(⎕ucs 10),' DO(av,z.s[i]=r.s[i])DO((I)rr-av-1,z.s[av+i]=r.s[av+i+1])',(⎕ucs 10),' if(!cnt(z)){z.v=scl(0);R;}',(⎕ucs 10),' if(!rc){z.v=ll.id(z.s);R;}',(⎕ucs 10),' if(1==rc){z.v=r.v;R;}',(⎕ucs 10),' CVSWITCH(r.v,err(6)',(⎕ucs 10),'  ,arr rv=axis(v,r.s,av);',(⎕ucs 10),'   if("rgt"==ll.nm){z.v=flat(rv(span,rc-1,span));R;}',(⎕ucs 10),'   if("lft"==ll.nm){z.v=flat(rv(span,0,span));R;}',(⎕ucs 10),'   if("add"==ll.nm&&ib){z.v=flat(count(rv,1).as(s32));R;}',(⎕ucs 10),'   if("add"==ll.nm){z.v=flat(sum(rv.as(f64),1));R;}',(⎕ucs 10),'   if("mul"==ll.nm){z.v=flat(product(rv.as(f64),1));R;}',(⎕ucs 10),'   if("min"==ll.nm){z.v=flat(min(rv,1));R;}',(⎕ucs 10),'   if("max"==ll.nm){z.v=flat(max(rv,1));R;}',(⎕ucs 10),'   if("and"==ll.nm&&ib){z.v=flat(allTrue(rv,1));R;}',(⎕ucs 10),'   if("lor"==ll.nm&&ib){z.v=flat(anyTrue(rv,1));R;}',(⎕ucs 10),'   if("neq"==ll.nm&&ib){z.v=flat((1&sum(rv,1)).as(b8));R;}',(⎕ucs 10),'   map_o mfn_c(llp);dim4 zs;DO((I)rnk(z),zs[i]=z.s[i])',(⎕ucs 10),'   z.v=flat(rv(span,rc-1,span));',(⎕ucs 10),'   DO(rc-1,mfn_c(z,A(z.s,flat(rv(span,rc-i-2,span))),z,e))',(⎕ucs 10),'  ,B zc=cnt(z);z.v=VEC<A>(cnt(z));VEC<A>&zv=std::get<VEC<A>>(z.v);',(⎕ucs 10),'   B bs=1;DOB(av,bs*=z.s[i])B as=1;DOB(rr-av-1,as*=z.s[av+i])',(⎕ucs 10),'   B ms=bs*rc;B mi=rc*bs-bs;',(⎕ucs 10),'   if("rgt"==ll.nm){DOB(as,B j=i;DOB(bs,zv[j*bs+i]=v[j*ms+mi+i]))R;}',(⎕ucs 10),'   if("lft"==ll.nm){DOB(as,B j=i;DOB(bs,zv[j*bs+i]=v[j*ms+i]))R;}',(⎕ucs 10),'   DOB(as,B k=i;DOB(bs,zv[k*bs+i]=v[k*ms+mi+i]))',(⎕ucs 10),'   DOB(rc-1,B j=(rc-i-2)*bs;',(⎕ucs 10),'    DOB(as,B k=i;DOB(bs,A&zvi=zv[k*bs+i];ll(zvi,v[k*ms+j+i],zvi,e)))))}',(⎕ucs 10),'MF(red_o){A x=r;if(!rnk(r))cat_c(x,r,e);this_c(z,x,e,scl(scl(rnk(x)-1)));}',(⎕ucs 10),'DA(red_o){B ar=rnk(ax),lr=rnk(l),rr=rnk(r);if(lr>4||rr>4)err(16);',(⎕ucs 10),' if(ar>1)err(4);if(cnt(ax)!=1)err(5);if(!isint(ax))err(11);',(⎕ucs 10),' I av;CVSWITCH(ax.v,err(6),av=v.as(s32).scalar<I>(),err(11))',(⎕ucs 10),' if(av<0)err(11);if(av>=rr)err(4);av=(I)rr-av-1;',(⎕ucs 10),' if(lr>1)err(4);if(cnt(l)!=1)err(5);if(!isint(l))err(11);',(⎕ucs 10),' I lv;CVSWITCH(l.v,err(6),lv=v.as(s32).scalar<I>(),err(11))',(⎕ucs 10),' I rc=(I)r.s[av]+1;if(rc<lv)err(5);rc=(I)(rc-abs(lv));',(⎕ucs 10),' A t(r.s,scl(0));t.s[av]=rc;',(⎕ucs 10),' if(!cnt(t)){z=t;R;}if(!lv){t.v=ll.id(t.s);z=t;R;}',(⎕ucs 10),' seq rng(rc);IDX x[4];map_o mfn_c(llp);',(⎕ucs 10),' CVSWITCH(r.v,err(6)',(⎕ucs 10),'  ,arr rv=unrav(v,r.s);',(⎕ucs 10),'   if(lv>=0){x[av]=rng+((D)lv-1);t.v=flat(rv(x[0],x[1],x[2],x[3]));',(⎕ucs 10),'    DO(lv-1,x[av]=rng+(D)(lv-i-2);',(⎕ucs 10),'     mfn_c(t,A(t.s,flat(rv(x[0],x[1],x[2],x[3]))),t,e))',(⎕ucs 10),'   }else{x[av]=rng;t.v=flat(rv(x[0],x[1],x[2],x[3]));',(⎕ucs 10),'    DO(abs(lv)-1,x[av]=rng+(D)(i+1);',(⎕ucs 10),'     mfn_c(t,A(t.s,flat(rv(x[0],x[1],x[2],x[3]))),t,e))}',(⎕ucs 10),'   z=t;',(⎕ucs 10),'  ,err(16))}',(⎕ucs 10),'DF(red_o){if(!rnk(r))err(4);',(⎕ucs 10),' red_o mfn_c(llp);mfn_c(z,l,r,e,scl(scl((I)rnk(r)-1)));}',(⎕ucs 10))
_,←,⊂('NM(rdf,"rdf",0,0,DID,MT ,DFD,MT,DAD)',(⎕ucs 10),'ID(rdf,1,s32)',(⎕ucs 10),'OM(rdf,"rdf",0,0,MFD,DFD,MAD,DAD)',(⎕ucs 10),'DEFN(rdf)',(⎕ucs 10),'DA(rdf_f){red_c(z,l,r,e,ax);}',(⎕ucs 10),'DF(rdf_f){A x=r;if(!rnk(r))cat_c(x,r,e);red_c(z,l,x,e,scl(scl(0)));}',(⎕ucs 10),'MA(rdf_o){red_o mfn_c(llp);mfn_c(z,r,e,ax);}',(⎕ucs 10),'MF(rdf_o){A x=r;if(!rnk(r))cat_c(x,r,e);this_c(z,x,e,scl(scl(0)));}',(⎕ucs 10),'DA(rdf_o){red_o mfn_c(llp);mfn_c(z,l,r,e,ax);}',(⎕ucs 10),'DF(rdf_o){if(!rnk(r))err(4);red_o mfn_c(llp);mfn_c(z,l,r,e,scl(scl(0)));}',(⎕ucs 10))
_,←,⊂('NM(scn,"scn",0,0,DID,MT ,DFD,MT ,DAD)',(⎕ucs 10),'DEFN(scn)',(⎕ucs 10),'ID(scn,1,s32)',(⎕ucs 10),'OM(scn,"scn",1,1,MFD,MT,MAD,MT )',(⎕ucs 10),'DA(scn_f){if(rnk(ax)>1||cnt(ax)!=1)err(5);if(!isint(ax))err(11);',(⎕ucs 10),' B rr=rnk(r),lr=rnk(l);',(⎕ucs 10),' I ra;CVSWITCH(ax.v,err(6),ra=v.as(s32).scalar<I>(),err(11))',(⎕ucs 10),' if(ra<0)err(11);if(ra>=rr)err(4);if(lr>1)err(4);ra=(I)rr-ra-1;',(⎕ucs 10),' arr lv;CVSWITCH(l.v,err(6),lv=v,err(11))',(⎕ucs 10),' if(r.s[ra]!=1&&r.s[ra]!=sum<I>(lv>0))err(5);',(⎕ucs 10),' arr ca=max(1,abs(lv)).as(s32);I c=sum<I>(ca);',(⎕ucs 10),' if(!cnt(l))c=0;z.s=r.s;z.s[ra]=c;B zc=cnt(z);if(!zc){z.v=scl(0);R;}',(⎕ucs 10),' arr pw=0<lv,pa=pw*lv;I pc=sum<I>(pa);if(!pc){z.v=scl(0);R;}',(⎕ucs 10),' pw=where(pw);pa=scan(pa(pw),0,AF_BINARY_ADD,false);',(⎕ucs 10),' arr si(pc,s32);si=0;si(pa)=1;si=accum(si)-1;',(⎕ucs 10),' arr ti(pc,s32);ti=1;ti(pa)=scan(ca,0,AF_BINARY_ADD,false)(pw);',(⎕ucs 10),' ti=scanByKey(si,ti);',(⎕ucs 10),' CVSWITCH(r.v,err(6)',(⎕ucs 10),'  ,arr zv(zc,v.type());zv=0;zv=axis(zv,z.s,ra);',(⎕ucs 10),'   zv(span,ti,span)=axis(v,r.s,ra)(span,si,span);z.v=flat(zv)',(⎕ucs 10),'  ,err(16))}',(⎕ucs 10),'DF(scn_f){A x=r;if(!rnk(r))cat_c(x,r,e);',(⎕ucs 10),' scn_c(z,l,x,e,scl(scl(rnk(x)-1)));}',(⎕ucs 10 10),'MA(scn_o){if(rnk(ax)>1)err(4);if(cnt(ax)!=1)err(5);',(⎕ucs 10),' if(!isint(ax))err(11);',(⎕ucs 10),' I av;CVSWITCH(ax.v,err(6),av=v.as(s32).scalar<I>(),err(11))',(⎕ucs 10),' if(av<0)err(11);B rr=rnk(r);if(av>=rr)err(4);av=(I)rr-av-1;z.s=r.s;',(⎕ucs 10),' I rc=(I)r.s[av];if(rc==1){z.v=r.v;R;}if(!cnt(z)){z.v=scl(0);R;}',(⎕ucs 10),' I ib=isbool(r);arr rv;CVSWITCH(r.v,err(6),rv=axis(v,r.s,av),err(16))',(⎕ucs 10),' if("add"==ll.nm){z.v=flat(scan(rv.as(f64),1,AF_BINARY_ADD));R;}',(⎕ucs 10),' if("mul"==ll.nm){z.v=flat(scan(rv.as(f64),1,AF_BINARY_MUL));R;}',(⎕ucs 10),' if("min"==ll.nm){z.v=flat(scan(rv.as(f64),1,AF_BINARY_MIN));R;}',(⎕ucs 10),' if("max"==ll.nm){z.v=flat(scan(rv.as(f64),1,AF_BINARY_MAX));R;}',(⎕ucs 10),' if("and"==ll.nm&&ib){z.v=flat(scan(rv,1,AF_BINARY_MIN));R;}',(⎕ucs 10),' if("lor"==ll.nm&&ib){z.v=flat(scan(rv,1,AF_BINARY_MAX));R;}',(⎕ucs 10),' map_o mfn_c(llp);B tr=rnk(z)-1;SHP ts(tr,1);',(⎕ucs 10),' DOB(av,ts[i]=r.s[i])DOB(tr-av,ts[av+i]=r.s[av+i+1])',(⎕ucs 10),' rv=rv.as(f64);arr zv(cnt(z),f64);zv=axis(zv,z.s,av);',(⎕ucs 10),' DO(rc,arr rvi=rv(span,i,span);dim4 rvs=rvi.dims();',(⎕ucs 10),'  A t(ts,flat(rv(span,i,span)));I c=i;',(⎕ucs 10),'  DO(c,A y(ts,flat(rv(span,c-i-1,span)));mfn_c(t,y,t,e))',(⎕ucs 10),'  CVSWITCH(t.v,err(6),zv(span,i,span)=moddims(v,rvs),err(16)))',(⎕ucs 10),' z.v=flat(zv);}',(⎕ucs 10),'MF(scn_o){B rr=rnk(r);if(!rr){z=r;R;}',(⎕ucs 10),' scn_o mfn_c(llp);mfn_c(z,r,e,scl(scl(rr-1)));}',(⎕ucs 10))
_,←,⊂('NM(scf,"scf",0,0,DID,MT ,DFD,MT ,DAD)',(⎕ucs 10),'DEFN(scf)',(⎕ucs 10),'ID(scf,1,s32)',(⎕ucs 10),'OM(scf,"scf",1,1,MFD,MT,MAD,MT )',(⎕ucs 10),'DA(scf_f){scn_c(z,l,r,e,ax);}',(⎕ucs 10),'DF(scf_f){A x=r;if(!rnk(x))cat_c(x,r,e);scn_c(z,l,x,e,scl(scl(0)));}',(⎕ucs 10 10),'MA(scf_o){scn_o mfn_c(llp);mfn_c(z,r,e,ax);}',(⎕ucs 10),'MF(scf_o){if(!rnk(r)){z=r;R;}scn_o mfn_c(llp);mfn_c(z,r,e,scl(scl(0)));}',(⎕ucs 10))
_,←,⊂('NM(rol,"rol",1,0,MT ,MFD,DFD,MT ,MT )',(⎕ucs 10),'DEFN(rol)',(⎕ucs 10),'SMF(rol,arr rnd=randu(rv.dims(),f64);z.v=(0==rv)*rnd+trunc(rv*rnd))',(⎕ucs 10),'DF(rol_f){if(cnt(r)!=1||cnt(l)!=1)err(5);',(⎕ucs 10),' D lv;CVSWITCH(l.v,err(6),lv=v.as(f64).scalar<D>(),err(11))',(⎕ucs 10),' D rv;CVSWITCH(r.v,err(6),rv=v.as(f64).scalar<D>(),err(11))',(⎕ucs 10),' if(lv>rv||lv!=floor(lv)||rv!=floor(rv)||lv<0||rv<0)err(11);',(⎕ucs 10),' I s=(I)lv;I t=(I)rv;z.s=SHP(1,s);if(!s){z.v=scl(0);R;}',(⎕ucs 10),' VEC<I> g(t);VEC<I> d(t);',(⎕ucs 10),' ((1+range(t))*randu(t)).as(s32).host(g.data());',(⎕ucs 10),' DO(t,I j=g[i];if(i!=j)d[i]=d[j];d[j]=i)z.v=arr(s,d.data());}',(⎕ucs 10))
_,←,⊂('NM(tke,"tke",0,0,MT ,MFD,DFD,MAD,DAD)',(⎕ucs 10),'DEFN(tke)',(⎕ucs 10),'MF(tke_f){',(⎕ucs 10),' CVSWITCH(r.v,err(6),z=r,',(⎕ucs 10),'  B rc=cnt(r);if(!rc&&!v.size())err(99,L"Missing prototype");',(⎕ucs 10),'  B rr=rnk(r);B mr=rnk(v[0]);U8 speq=1;U8 nv=0;',(⎕ucs 10),'  DOB(v.size(),B nr=rnk(v[i]);if(nr>mr){mr=nr;speq=0;})',(⎕ucs 10),'  DOB(v.size(),CVSWITCH(v[i].v,err(6),,nv=1))',(⎕ucs 10),'  A x(mr+rr);DOB(rr,x.s[mr+rr-i-1]=r.s[rr-i-1])',(⎕ucs 10),'  dtype tp=b8;if(!nv)tp=mxt(b8,r);',(⎕ucs 10),'  if(!mr){',(⎕ucs 10),'   if(nv){x.v=VEC<A>(rc);VEC<A>&xv=std::get<VEC<A>>(x.v);',(⎕ucs 10),'    DOB(rc,CVSWITCH(v[i].v,err(6),xv[i]=scl(v),xv[i]=v[0]))}',(⎕ucs 10),'   if(!nv){x.v=arr(rc,tp);arr&xv=std::get<arr>(x.v);',(⎕ucs 10),'    DOB(rc,CVSWITCH(v[i].v,err(6),xv((I)i)=v(0).as(tp),err(99)))}',(⎕ucs 10),'   z=x;R;}',(⎕ucs 10),'  DOB(mr,x.s[i]=0)B rk=rnk(v[0]);DOB(rk,x.s[mr-i-1]=v[0].s[rk-i-1])',(⎕ucs 10),'  DOB(rc,A vi=v[i];rk=rnk(vi);',(⎕ucs 10),'   DOB(rk,B j=mr-i-1;B k=rk-i-1;if(x.s[j]!=vi.s[k])speq=0;',(⎕ucs 10),'    if(x.s[j]<vi.s[k])x.s[j]=vi.s[k]))',(⎕ucs 10),'  B bc=1;DOB(mr,bc*=x.s[i])seq bx((D)bc);B xc=rc*bc;',(⎕ucs 10),'  if(!speq)err(16);',(⎕ucs 10),'  if(nv)err(16);',(⎕ucs 10),'  if(!nv&&!xc){x.v=scl(0);}',(⎕ucs 10),'  if(!nv&&xc){x.v=arr(xc,tp);arr&xv=std::get<arr>(x.v);',(⎕ucs 10),'   DOB(rc,CVSWITCH(v[i].v,err(6),xv(bx+(D)i*bc)=v.as(tp),err(99)))}',(⎕ucs 10),'  z=x)}',(⎕ucs 10),'MA(tke_f){err(16);}',(⎕ucs 10),'DA(tke_f){B c=cnt(l),ac=cnt(ax),axr=rnk(ax),lr=rnk(l),rr=rnk(r);',(⎕ucs 10),' if(axr>1||lr>1)err(4);if(ac!=c)err(5);if(c>4)err(16);if(!isint(ax))err(11);',(⎕ucs 10),' VEC<I> av(ac),m(rr,0);',(⎕ucs 10),' if(ac)CVSWITCH(ax.v,err(6),v.as(s32).host(av.data()),err(11))',(⎕ucs 10),' DOB(ac,if(av[i]<0)err(11);if(av[i]>=rr)err(4))',(⎕ucs 10),' DOB(ac,if(m[av[i]])err(11);m[av[i]]=1)',(⎕ucs 10),' if(!c){z=r;R;}if(!isint(l))err(11);',(⎕ucs 10),' VEC<I> lv(c);CVSWITCH(l.v,err(6),v.as(s32).host(lv.data()),err(11))',(⎕ucs 10),' seq it[4],ix[4];z.s=r.s;if(rr>4)err(16);',(⎕ucs 10),' DOB(c,{U j=(U)rr-av[i]-1;I a=std::abs(lv[i]);z.s[j]=a;',(⎕ucs 10),'  if(a>r.s[j])ix[j]=seq((D)r.s[j]);',(⎕ucs 10),'  else if(lv[i]<0)ix[j]=seq((D)r.s[j]-a,(D)r.s[j]-1);',(⎕ucs 10),'  else ix[j]=seq(a);',(⎕ucs 10),'  it[j]=ix[j]+(lv[i]<0)*(a-(D)r.s[j]);})',(⎕ucs 10),' B zc=cnt(z);if(!zc){z.v=scl(0);R;}',(⎕ucs 10),' CVSWITCH(r.v,err(6)',(⎕ucs 10),'  ,z.v=arr(zc,v.type());arr&zv=std::get<arr>(z.v);zv=0;',(⎕ucs 10),'   arr rv=unrav(v,r.s);zv=unrav(zv,z.s);',(⎕ucs 10),'   zv(it[0],it[1],it[2],it[3])=rv(ix[0],ix[1],ix[2],ix[3]);',(⎕ucs 10),'   zv=flat(zv)',(⎕ucs 10),'  ,err(16))}',(⎕ucs 10),'DF(tke_f){I c=(I)cnt(l);if(c>4)err(16);',(⎕ucs 10),' A nr=r;if(!rnk(nr)){nr.s=SHP(c,1);}',(⎕ucs 10),' A ax;iot_c(ax,scl(scl(c)),e);tke_c(z,l,nr,e,ax);}',(⎕ucs 10))
_,←,⊂('NM(drp,"drp",0,0,MT ,MFD,DFD,MAD,DAD)',(⎕ucs 10),'DEFN(drp)',(⎕ucs 10),'MF(drp_f){if(rnk(r))err(16);z=r;}',(⎕ucs 10),'MA(drp_f){err(16);}',(⎕ucs 10),'DA(drp_f){B c=cnt(l),ac=cnt(ax),rr=rnk(r),lr=rnk(l),axr=rnk(ax);',(⎕ucs 10),' if(axr>1||lr>1)err(4);if(ac!=c)err(5);if(c>4)err(16);if(!isint(ax))err(11);',(⎕ucs 10),' I m[4]={0,0,0,0},av[4];CVSWITCH(ax.v,err(6),v.as(s32).host(av),err(11))',(⎕ucs 10),' DOB(ac,if(av[i]<0)err(11);if(av[i]>=rr)err(4))',(⎕ucs 10),' DOB(ac,if(m[av[i]])err(11);m[av[i]]=1)',(⎕ucs 10),' if(!c){z=r;R;}if(!isint(l))err(11);',(⎕ucs 10),' I lv[4];CVSWITCH(l.v,err(6),v.as(s32).host(lv),err(11))',(⎕ucs 10),' seq it[4],ix[4];z.s=r.s;',(⎕ucs 10),' DO((I)c,{B j=rr-av[i]-1;I a=std::abs(lv[i]);z.s[j]=r.s[j]-a;',(⎕ucs 10),'  if(a>=r.s[j]){z.s[j]=0;ix[j]=seq(0);it[j]=seq(0);}',(⎕ucs 10),'  else if(lv[i]<0){ix[j]=seq((D)z.s[j]);it[j]=ix[j];}',(⎕ucs 10),'  else{ix[j]=seq(a,(D)r.s[j]-1);it[j]=ix[j]-(D)a;}})',(⎕ucs 10),' if(!cnt(z)){z.v=scl(0);R;}',(⎕ucs 10),' CVSWITCH(r.v,err(6)',(⎕ucs 10),'  ,arr tv(cnt(z),v.type());tv=0;tv=unrav(tv,z.s);',(⎕ucs 10),'   tv(it[0],it[1],it[2],it[3])=unrav(v,r.s)(ix[0],ix[1],ix[2],ix[3]);',(⎕ucs 10),'   z.v=flat(tv)',(⎕ucs 10),'  ,z.v=VEC<A>(cnt(z),scl(scl(0)));VEC<A>&zv=std::get<VEC<A>>(z.v);',(⎕ucs 10),'   if(rr!=1)err(16);B shft=0;if(lv[0]>=0)shft=lv[0];',(⎕ucs 10),'   DOB(z.s[0],zv[i]=v[i+shft]))}',(⎕ucs 10),'DF(drp_f){B c=cnt(l);if(c>4)err(16);',(⎕ucs 10),' A nr=r;if(!rnk(nr)){nr.s=SHP(c,1);}',(⎕ucs 10),' A ax;iot_c(ax,scl(scl(c)),e);drp_c(z,l,nr,e,ax);}',(⎕ucs 10))
_,←,⊂('OM(map,"map",1,1,MFD,DFD,MT ,MT )',(⎕ucs 10),'MF(map_o){if(scm(ll)){ll(z,r,e);R;}',(⎕ucs 10),' if("par"==ll.nm&&std::holds_alternative<arr>(r.v)){z=r;R;}',(⎕ucs 10),' z.s=r.s;I c=(I)cnt(z);if(!c){z.v=scl(0);R;}',(⎕ucs 10),' z.v=VEC<A>(c);VEC<A>&zv=std::get<VEC<A>>(z.v);',(⎕ucs 10),' CVSWITCH(r.v,err(6),DOB(c,ll(zv[i],scl(v((I)i)),e)),DOB(c,ll(zv[i],v[i],e)))',(⎕ucs 10),' coal(z);}',(⎕ucs 10),'DF(map_o){if(scd(ll)){ll(z,l,r,e);R;}B lr=rnk(l),rr=rnk(r);',(⎕ucs 10),' A rv,lv,a,b;cat_c(rv,r,e);cat_c(lv,l,e);',(⎕ucs 10),' if((lr==rr&&l.s==r.s)||!lr){z.s=r.s;}',(⎕ucs 10),' else if(!rr){z.s=l.s;}else if(lr!=rr)err(4);',(⎕ucs 10),' else if(l.s!=r.s)err(5);else err(99);',(⎕ucs 10),' I c=(I)cnt(z);if(!c){z.v=scl(0);R;}',(⎕ucs 10),' z.v=VEC<A>(c);VEC<A>&v=std::get<VEC<A>>(z.v);',(⎕ucs 10),' if(lr==rr){',(⎕ucs 10),'  DOB(c,A ix=scl(scl(i));dis_c(a,ix,lv,e);dis_c(b,ix,rv,e);ll(v[i],a,b,e))}',(⎕ucs 10),' else if(!lr){',(⎕ucs 10),'  dis_c(a,scl(scl(0)),lv,e);DOB(c,dis_c(b,scl(scl(i)),rv,e);ll(v[i],a,b,e))}',(⎕ucs 10),' else if(!rr){',(⎕ucs 10),'  dis_c(b,scl(scl(0)),rv,e);DOB(c,dis_c(a,scl(scl(i)),lv,e);ll(v[i],a,b,e))}',(⎕ucs 10),' coal(z);}',(⎕ucs 10))
_,←,⊂('OM(com,"com",scm(l),scd(l),MFD,DFD,MT ,MT )',(⎕ucs 10),'MF(com_o){ll(z,r,r,e);}DF(com_o){ll(z,r,l,e);}',(⎕ucs 10 10))
_,←,⊂('OD(dot,"dot",0,0,MT,DFD,MT ,MT )',(⎕ucs 10),'DF(dot_o){B lr=rnk(l),rrk=rnk(r),ra=rrk?rrk-1:0,la=lr?lr-1:0;',(⎕ucs 10),' if(rrk&&lr&&l.s[0]!=r.s[ra])err(5);',(⎕ucs 10),' A t(la+ra,scl(0));DOB(ra,t.s[i]=r.s[i])DOB(la,t.s[i+ra]=l.s[i+1])',(⎕ucs 10),' if(!cnt(t)){z=t;R;}if((lr&&!l.s[0])||(rrk&&!r.s[ra])){t.v=ll.id(t.s);z=t;R;}',(⎕ucs 10),' B c=lr?l.s[0]:rrk?r.s[ra]:1;',(⎕ucs 10),' std::visit(visitor{DVSTR(),',(⎕ucs 10),'   [&](carr&lv,carr&rv){',(⎕ucs 10),'    arr x=table(lv,l.s,1),y=table(rv,r.s,ra);',(⎕ucs 10),'    if(!lr||1==l.s[0])x=tile(x,(U)c,1);if(!rrk||1==r.s[ra])y=tile(y,1,(U)c);',(⎕ucs 10),'    if("add"==ll.nm&&"mul"==rr.nm){',(⎕ucs 10),'     t.v=flat(matmul(y.as(f64),x.as(f64)));z=t;R;}',(⎕ucs 10),'    if(isbool(x)&&isbool(y)&&"neq"==ll.nm&&"and"==rr.nm){',(⎕ucs 10),'     t.v=flat((1&matmul(y.as(f32),x.as(f32)).as(s16)).as(b8));z=t;R;}',(⎕ucs 10),'    B rc=1,lc=1;if(rrk)rc=cnt(r)/r.s[ra];if(lr)lc=cnt(l)/l.s[0];',(⎕ucs 10),'    x=tile(arr(x,c,1,lc),1,(U)rc,1);y=tile(y.T(),1,1,(U)lc);',(⎕ucs 10),'    A X(SHP{c,rc,lc},flat(x.as(f64)));A Y(SHP{c,rc,lc},flat(y.as(f64)));',(⎕ucs 10),'    map_o mfn_c(rrp);red_o rfn_c(llp);mfn_c(X,X,Y,e);rfn_c(X,X,e);',(⎕ucs 10),'    t.v=X.v;z=t;},',(⎕ucs 10),'   [&](CVEC<A>&lv,carr&rv){err(16);},',(⎕ucs 10),'   [&](carr&lv,CVEC<A>&rv){err(16);},',(⎕ucs 10),'   [&](CVEC<A>&lv,CVEC<A>&rv){err(16);}},',(⎕ucs 10),'  l.v,r.v);}',(⎕ucs 10))
_,←,⊂('OD(rnk,"rnk",scm(l),0,MFD,DFD,MT ,MT )',(⎕ucs 10),'MF(rnk_o){if(cnt(ww)!=1)err(4);B cr=geti(ww);',(⎕ucs 10),' B rr=rnk(r);if(scm(ll)||cr>=rr){ll(z,r,e);R;}',(⎕ucs 10),' if(cr<=-rr)cr=0;if(cr<0)cr=rr+cr;B dr=rr-cr;',(⎕ucs 10),' A x(cr+1,r.v);DOB(cr,x.s[i]=r.s[i])DOB(dr,x.s[cr]*=r.s[rr-i-1])',(⎕ucs 10),' B dc=x.s[cr];A y(dr,VEC<A>(dc?dc:1));DOB(dr,y.s[dr-i-1]=r.s[rr-i-1])',(⎕ucs 10),' VEC<A>&yv=std::get<VEC<A>>(y.v);',(⎕ucs 10),' if(!dc)tke_c(x,scl(scl(1)),x,e);',(⎕ucs 10),' DOB(dc?dc:1,A t;sqd_c(t,scl(scl(i)),x,e);ll(yv[i],t,e))',(⎕ucs 10),' if(!dc)y=proto(y);tke_c(z,y,e);}',(⎕ucs 10),'DF(rnk_o){I rr=(I)rnk(r),lr=(I)rnk(l),cl,cr,dl,dr;dim4 sl(1),sr(1);',(⎕ucs 10),' arr wwv;CVSWITCH(ww.v,err(6),wwv=v.as(s32),err(11))',(⎕ucs 10),' switch(cnt(ww)){',(⎕ucs 10),'  CS(1,cl=cr=wwv.scalar<I>())',(⎕ucs 10),'  CS(2,cl=wwv.scalar<I>();cr=wwv(1).scalar<I>())',(⎕ucs 10),'  default:err(4);}',(⎕ucs 10),' if(cl>lr)cl=lr;if(cr>rr)cr=rr;if(cl<-lr)cl=0;if(cr<-rr)cr=0;',(⎕ucs 10),' if(cl<0)cl=lr+cl;if(cr<0)cr=rr+cr;if(cr>3||cl>3)err(10);',(⎕ucs 10),' dl=lr-cl;dr=rr-cr;if(dl!=dr&&dl&&dr)err(4);',(⎕ucs 10),' if(dl==dr)DO(dr,if(l.s[i+cl]!=r.s[i+cr])err(5))',(⎕ucs 10),' DO(dl,sl[cl]*=l.s[i+cl])DO(cl,sl[i]=l.s[i])',(⎕ucs 10),' DO(dr,sr[cr]*=r.s[i+cr])DO(cr,sr[i]=r.s[i])',(⎕ucs 10),' B sz=dl>dr?sl[cl]:sr[cr];VEC<A> tv(sz);',(⎕ucs 10),' A a(cl+1,l.v);DO(cl+1,a.s[i]=sl[i])A b(cr+1,r.v);DO(cr+1,b.s[i]=sr[i])',(⎕ucs 10),' DOB(sz,A ta;A tb; A ai=scl(scl((I)(i%sl[cl])));A bi=scl(scl((I)(i%sr[cr])));',(⎕ucs 10),'  sqd_c(ta,ai,a,e);sqd_c(tb,bi,b,e);ll(tv[i],ta,tb,e))',(⎕ucs 10),' if(dr>=dl){z.s=SHP(dr);DOB(dr,z.s[i]=r.s[cr+i])}',(⎕ucs 10),' if(dr<dl){z.s=SHP(dl);DOB(dl,z.s[i]=l.s[cl+i])}',(⎕ucs 10),' z.v=tv;tke_c(z,z,e);}',(⎕ucs 10))
_,←,⊂('OD(pow,"pow",scm(l),scd(l),MFD,DFD,MT ,MT )',(⎕ucs 10),'MF(pow_o){if(fr){A t;A v=r;I flg;',(⎕ucs 10),'  do{A u;ll(u,v,e);rr(t,u,v,e);',(⎕ucs 10),'   if(cnt(t)!=1)err(5);CVSWITCH(t.v,err(6),flg=v.as(s32).scalar<I>(),err(11))',(⎕ucs 10),'   v=u;}while(!flg);',(⎕ucs 10),'  z=v;R;}',(⎕ucs 10),' if(rnk(ww))err(4);I c;CVSWITCH(ww.v,err(6),c=v.as(s32).scalar<I>(),err(11))',(⎕ucs 10),' z=r;DO(c,ll(z,z,e))}',(⎕ucs 10),'DF(pow_o){if(!fl)err(2);',(⎕ucs 10),' if(fr){A t;A v=r;I flg;',(⎕ucs 10),'  do{A u;ll(u,l,v,e);rr(t,u,v,e);',(⎕ucs 10),'   if(cnt(t)!=1)err(5);CVSWITCH(t.v,err(6),flg=v.as(s32).scalar<I>(),err(11))',(⎕ucs 10),'   v=u;}while(!flg);',(⎕ucs 10),'  z=v;R;}',(⎕ucs 10),' if(rnk(ww))err(4);I c;CVSWITCH(ww.v,err(6),c=v.as(s32).scalar<I>(),err(11))',(⎕ucs 10),' A t=r;DO(c,ll(t,l,t,e))z=t;}',(⎕ucs 10 10))
_,←,⊂('OD(jot,"jot",(scm(l)&&scm(r)),(scd(l)&&scd(r)),MFD,DFD,MT ,MT )',(⎕ucs 10),'MF(jot_o){if(!fl){rr(z,aa,r,e);R;}if(!fr){ll(z,r,ww,e);R;}',(⎕ucs 10),' rr(z,r,e);ll(z,z,e);}',(⎕ucs 10),'DF(jot_o){if(!fl||!fr){err(2);}rr(z,r,e);ll(z,l,z,e);}',(⎕ucs 10 10))
_,←,⊂('NM(unq,"unq",0,0,MT ,MFD,DFD,MT ,MT )',(⎕ucs 10),'DEFN(unq)',(⎕ucs 10),'MF(unq_f){if(rnk(r)>1)err(4);if(!cnt(r)){z.s=r.s;z.v=r.v;R;}',(⎕ucs 10),' CVSWITCH(r.v,err(6)',(⎕ucs 10),'  ,arr a;arr b;sort(a,b,v);arr zv=a!=shift(a,1);zv(0)=1;',(⎕ucs 10),'   zv=where(zv);sort(b,zv,b(zv),a(zv));z.s=SHP(1,zv.elements());z.v=zv',(⎕ucs 10),'  ,err(16))}',(⎕ucs 10),'DF(unq_f){if(rnk(r)>1||rnk(l)>1)err(4);',(⎕ucs 10),' B lc=cnt(l),rc=cnt(r);',(⎕ucs 10),' if(!cnt(l)){z.s=SHP(1,rc);z.v=r.v;R;}if(!cnt(r)){z.s=SHP(1,lc);z.v=l.v;R;}',(⎕ucs 10),' arr rv;CVSWITCH(r.v,err(6),rv=v,err(16))',(⎕ucs 10),' arr lv;CVSWITCH(l.v,err(6),lv=v,err(16))',(⎕ucs 10),' dtype mt=mxt(l,r);arr x=setUnique(lv);B c=x.elements();',(⎕ucs 10),' x=!anyTrue(tile(rv,1,(U)c)==tile(arr(x,1,c),(U)rc,1),1);',(⎕ucs 10),' x=join(0,lv.as(mt),rv(where(x)).as(mt));z.s=SHP(1,x.elements());z.v=x;}',(⎕ucs 10))
_,←,⊂('NM(int,"int",0,0,MT ,MT ,DFD,MT ,MT )',(⎕ucs 10),'DEFN(int)',(⎕ucs 10),'DF(int_f){if(rnk(r)>1||rnk(l)>1)err(4);',(⎕ucs 10),' if(!cnt(r)||!cnt(l)){z.v=scl(0);z.s=SHP(1,0);R;}',(⎕ucs 10),' arr rv;CVSWITCH(r.v,err(6),rv=v,err(16))',(⎕ucs 10),' arr lv;CVSWITCH(l.v,err(6),lv=v,err(16))',(⎕ucs 10),' arr pv=setUnique(rv);B pc=pv.elements();arr zv=constant(0,cnt(l),s64);',(⎕ucs 10),' for(B h;h=pc/2;pc-=h){arr t=zv+h;replace(zv,pv(t)>lv,t);}',(⎕ucs 10),' arr ix=where(pv(zv)==lv);z.s=SHP(1,ix.elements());',(⎕ucs 10),' z.v=z.s[0]?lv(ix):scl(0);}',(⎕ucs 10))
_,←,⊂('NM(get,"get",0,0,MT,MT,DFD,MT,MT)',(⎕ucs 10),'DEFN(get)',(⎕ucs 10),'DF(get_f){CVSWITCH(l.v,err(6),err(99,L"Unexpected simple array"),)',(⎕ucs 10),' CVEC<A>&lv=std::get<VEC<A>>(l.v);B ll=lv.size();B zr=rnk(z),rr=rnk(r);',(⎕ucs 10),' if(!ll){if(zr!=1)err(4);if(rr!=1)err(5);if(z.s[0]!=r.s[0])err(5);z=r;R;}',(⎕ucs 10),' if(ll!=zr)err(4);B rk=0;DOB(ll,CVSWITCH(lv[i].v,rk+=1,rk+=rnk(lv[i]),err(11)))',(⎕ucs 10),' if(rr>0&&rk!=rr)err(5);',(⎕ucs 10),' const B*rs=r.s.data();IDX x[4];',(⎕ucs 10),' if(!rr)DOB(ll,A v=lv[ll-i-1];CVSWITCH(v.v,,x[i]=v.as(s32),err(11)))',(⎕ucs 10),' if(rr>0)',(⎕ucs 10),'  DOB(ll,A u=lv[ll-i-1];',(⎕ucs 10),'   CVSWITCH(u.v',(⎕ucs 10),'    ,if(z.s[i]!=*rs++)err(5)',(⎕ucs 10),'    ,DOB(rnk(u),if(u.s[i]!=*rs++)err(5))x[i]=v.as(s32)',(⎕ucs 10),'    ,err(11)))',(⎕ucs 10),' I tp=0;',(⎕ucs 10),' CVSWITCH(r.v,err(6)',(⎕ucs 10),'  ,CVSWITCH(z.v,err(6),tp=1,tp=2)',(⎕ucs 10),'  ,CVSWITCH(z.v,err(6),tp=3,tp=4))',(⎕ucs 10),' switch(tp){',(⎕ucs 10),'  CS(1,{',(⎕ucs 10),'   arr rv=unrav(std::get<arr>(r.v),r.s);arr zv=unrav(std::get<arr>(z.v),z.s);',(⎕ucs 10),'   zv(x[0],x[1],x[2],x[3])=rv;z.v=flat(zv);})',(⎕ucs 10),'  CS(2,err(16))',(⎕ucs 10),'  CS(3,err(16))',(⎕ucs 10),'  CS(4,{I i;VEC<A>&zv=std::get<VEC<A>>(z.v);CVEC<A>&rv=std::get<VEC<A>>(r.v);',(⎕ucs 10),'   if(zr!=1)err(16);',(⎕ucs 10),'   CVSWITCH(lv[0].v,',(⎕ucs 10),'    ,arr x=v.as(s32);if(x.elements()!=1)err(16);i=x.scalar<I>();',(⎕ucs 10),'    ,)',(⎕ucs 10),'   zv[i]=rv[0];})',(⎕ucs 10),'  default:err(99);}}',(⎕ucs 10 10),'OM(get,"get",0,0,MT,DFD,MT,MT)',(⎕ucs 10),'DF(get_o){A t;brk_c(t,z,l,e);map_o mfn_c(llp);mfn_c(t,t,r,e);',(⎕ucs 10),' get_c(z,l,t,e);}',(⎕ucs 10))
_,←,⊂('NM(gdu,"gdu",0,0,MT ,MFD,DFD,MT ,MT )',(⎕ucs 10),'DEFN(gdu)',(⎕ucs 10),'MF(gdu_f){B rr=rnk(r);if(rr<1)err(4);z.s=SHP(1,r.s[rr-1]);',(⎕ucs 10),' if(!cnt(r)){z.v=r.v;R;}B c=1;DOB(rr-1,c*=r.s[i])',(⎕ucs 10),' CVSWITCH(r.v,err(6)',(⎕ucs 10),'  ,arr mt;arr a(v,c,r.s[rr-1]);arr zv=iota(dim4(z.s[0]),dim4(1),s32);',(⎕ucs 10),'   DOB(c,sort(mt,zv,flat(a((I)(c-i-1),zv)),zv,0,true))z.v=zv',(⎕ucs 10),'  ,err(16))}',(⎕ucs 10),'DF(gdu_f){err(16);}',(⎕ucs 10))
_,←,⊂('NM(gdd,"gdd",0,0,MT ,MFD,DFD,MT ,MT )',(⎕ucs 10),'DEFN(gdd)',(⎕ucs 10),'MF(gdd_f){B rr=rnk(r);if(rr<1)err(4);z.s=SHP(1,r.s[rr-1]);',(⎕ucs 10),' if(!cnt(r)){z.v=r.v;R;}I c=1;DOB(rr-1,c*=(I)r.s[i]);',(⎕ucs 10),' arr rv;CVSWITCH(r.v,err(6),rv=v,err(16))',(⎕ucs 10),' arr mt,a(rv,c,r.s[rr-1]);arr zv=iota(dim4(z.s[0]),dim4(1),s32);',(⎕ucs 10),' DO(c,sort(mt,zv,flat(a(c-(i+1),zv)),zv,0,false));z.v=zv;}',(⎕ucs 10),'DF(gdd_f){err(16);}',(⎕ucs 10 10))
_,←,⊂('OM(oup,"oup",0,0,MT,DFD,MT ,MT )',(⎕ucs 10),'DF(oup_o){B lr=rnk(l),rr=rnk(r),lc=cnt(l),rc=cnt(r);',(⎕ucs 10),' SHP sp(lr+rr);DOB(rr,sp[i]=r.s[i])DOB(lr,sp[i+rr]=l.s[i])',(⎕ucs 10),' if(!cnt(sp)){z.s=sp;z.v=scl(0);R;}',(⎕ucs 10),' std::visit(visitor{DVSTR(),',(⎕ucs 10),'   [&](carr&lv,carr&rv){arr x(lv,1,lc),y(rv,rc,1);',(⎕ucs 10),'    x=flat(tile(x,(I)rc,1));y=flat(tile(y,1,(I)lc));',(⎕ucs 10),'    map_o mfn_c(llp);A xa(sp,x),ya(sp,y);mfn_c(z,xa,ya,e);},',(⎕ucs 10),'   [&](CVEC<A>&lv,CVEC<A>&rv){z.s=sp;z.v=VEC<A>(lc*rc);',(⎕ucs 10),'    VEC<A>&zv=std::get<VEC<A>>(z.v);DOB(lc*rc,ll(zv[i],lv[i],rv[i],e))',(⎕ucs 10),'    coal(z);},',(⎕ucs 10),'   [&](CVEC<A>&lv,carr&rv){z.s=sp;z.v=VEC<A>(lc*rc);',(⎕ucs 10),'    VEC<A>&zv=std::get<VEC<A>>(z.v);DOB(lc*rc,ll(zv[i],lv[i],A(0,rv((I)i)),e))',(⎕ucs 10),'    coal(z);},',(⎕ucs 10),'   [&](carr&lv,CVEC<A>&rv){z.s=sp;z.v=VEC<A>(lc*rc);',(⎕ucs 10),'    VEC<A>&zv=std::get<VEC<A>>(z.v);DOB(lc*rc,ll(zv[i],A(0,lv((I)i)),rv[i],e))',(⎕ucs 10),'    coal(z);}},',(⎕ucs 10),'  l.v,r.v);}',(⎕ucs 10))
_,←,⊂('NM(fnd,"fnd",0,0,MT ,MT ,DFD,MT ,MT )',(⎕ucs 10),'DEFN(fnd)',(⎕ucs 10),'DF(fnd_f){B lr=rnk(l),rr=rnk(r),rc=cnt(r),lc=cnt(l);',(⎕ucs 10),' if(!rc){z=r;R;}z=r;arr zv(rc,b8);zv=0;',(⎕ucs 10),' if(lr>rr){z.v=zv;R;}',(⎕ucs 10),' DOB(lr,if(l.s[i]>r.s[i]){z.v=zv;R;})',(⎕ucs 10),' if(!lc){zv=1;z.v=zv;R;}',(⎕ucs 10),' if(lr>4||rr>4)err(16);',(⎕ucs 10),' dim4 rs(1),ls(1);DO((I)lr,ls[i]=l.s[i])DO((I)rr,rs[i]=r.s[i])',(⎕ucs 10),' dim4 sp;DO(4,sp[i]=rs[i]-ls[i]+1)seq x[4];DO(4,x[i]=seq((D)sp[i]))',(⎕ucs 10),' zv=unrav(zv,z.s);zv(x[0],x[1],x[2],x[3])=1;',(⎕ucs 10),' arr lv;CVSWITCH(l.v,err(6),lv=unrav(v,l.s),err(16))',(⎕ucs 10),' arr rv;CVSWITCH(r.v,err(6),rv=unrav(v,r.s),err(16))',(⎕ucs 10),' DO((I)ls[0],I m=i;',(⎕ucs 10),'  DO((I)ls[1],I k=i;',(⎕ucs 10),'   DO((I)ls[2],I j=i;',(⎕ucs 10),'    DO((I)ls[3],zv(x[0],x[1],x[2],x[3])=zv(x[0],x[1],x[2],x[3])',(⎕ucs 10),'     &(tile(lv(m,k,j,i),sp)',(⎕ucs 10),'      ==rv(x[0]+(D)m,x[1]+(D)k,x[2]+(D)j,x[3]+(D)i))))))',(⎕ucs 10),' z.v=zv;}',(⎕ucs 10))
_,←,⊂('NM(par,"par",0,0,MT ,MFD,DFD,MAD,MT )',(⎕ucs 10),'DEFN(par)',(⎕ucs 10),'MF(par_f){I nv=0;CVSWITCH(r.v,err(6),,nv=1)',(⎕ucs 10),' if(!rnk(r)&&!nv){z=r;R;}z=A(0,VEC<A>(1,r));}',(⎕ucs 10),'MA(par_f){if(rnk(ax)>1)err(4);B axc=cnt(ax);',(⎕ucs 10),' if(!axc){map_o f(par_p);f(z,r,e);R;}',(⎕ucs 10),' B rr=rnk(r);VEC<I> axm(rr,0);VEC<I> axv(axc);',(⎕ucs 10),' CVSWITCH(ax.v,err(6),v.as(s32).host(axv.data()),err(11))',(⎕ucs 10),' DOB(axc,I v=axv[i];if(v<0)err(11);if(v>=rr)err(4);if(axm[v])err(11);axm[v]=1)',(⎕ucs 10),' B ic=rr-axc;if(!ic){z=A(0,VEC<A>(1,r));R;}',(⎕ucs 10),' A nax(SHP(1,ic),arr(ic,s32));arr&naxv=std::get<arr>(nax.v);A x;x.s=SHP(ic);',(⎕ucs 10),' B j=0;DOB(rr,if(!axm[i]){naxv((I)j)=i;x.s[ic-j-1]=r.s[rr-i-1];j++;})',(⎕ucs 10),' B xc=cnt(x);x.v=VEC<A>(xc);VEC<A>&xv=std::get<VEC<A>>(x.v);',(⎕ucs 10),' VEC<I> ixh(ic,0);A ix(SHP(1,ic),arr(ic,s32));arr&ixv=std::get<arr>(ix.v);',(⎕ucs 10),' DOB(xc,ixv=arr(ic,ixh.data());sqd_c(xv[i],ix,r,e,nax);',(⎕ucs 10),'  ixh[ic-1]++;DOB(ic-1,B j=ic-i-1;if(ixh[j]==x.s[i]){ixh[j-1]++;ixh[j]=0;}))',(⎕ucs 10),' z=x;}',(⎕ucs 10),'DF(par_f){err(16);}',(⎕ucs 10 10))
_,←,⊂('NM(mdv,"mdv",1,0,MT ,MFD,DFD,MT ,MT )',(⎕ucs 10),'DEFN(mdv)',(⎕ucs 10),'MF(mdv_f){B rr=rnk(r),rc=cnt(r);',(⎕ucs 10),' arr rv;CVSWITCH(r.v,err(6),rv=unrav(v,r.s),err(11))',(⎕ucs 10),' if(rr>2)err(4);if(rr==2&&r.s[1]<r.s[0])err(5);if(!rc)err(5);',(⎕ucs 10),' if(!rr||rc==1||r.s[0]==r.s[1]){z.s=r.s;z.v=flat(inverse(rv));R;}',(⎕ucs 10),' if(rr==1){z.v=flat(matmulNT(inverse(matmulTN(rv,rv)),rv));z.s=r.s;R;}',(⎕ucs 10),' arr zv=matmulTN(inverse(matmulNT(rv,rv)),rv);z.s=r.s;',(⎕ucs 10),' B k=z.s[0];z.s[0]=z.s[1];z.s[1]=k;z.v=flat(transpose(zv));}',(⎕ucs 10),'DF(mdv_f){B rr=rnk(r),lr=rnk(l),rc=cnt(r),lc=cnt(l);',(⎕ucs 10),' if(rr>2)err(4);if(lr>2)err(4);if(rr==2&&r.s[1]<r.s[0])err(5);',(⎕ucs 10),' if(!rc||!lc)err(5);if(rr&&lr&&l.s[lr-1]!=r.s[rr-1])err(5);',(⎕ucs 10),' arr rv;CVSWITCH(r.v,err(6),rv=unrav(v,r.s),err(11))',(⎕ucs 10),' arr lv;CVSWITCH(l.v,err(6),lv=unrav(v,l.s),err(11))',(⎕ucs 10),' if(rr==1)rv=transpose(rv);if(lr==1)lv=transpose(lv);',(⎕ucs 10),' z.v=flat(transpose(matmul(inverse(matmulNT(rv,rv)),matmulNT(rv,lv))));',(⎕ucs 10),' z.s=SHP((lr-(lr>0))+(rr-(rr>0)));',(⎕ucs 10),' if(lr>1)z.s[0]=l.s[0];if(rr>1)z.s[lr>1]=r.s[0];}',(⎕ucs 10))
_,←,⊂('NM(fft,"fft",1,0,MT ,MFD,MT ,MT ,MT )',(⎕ucs 10),'DEFN(fft)',(⎕ucs 10),'MF(fft_f){arr rv;CVSWITCH(r.v,err(6),rv=unrav(v,r.s),err(11))',(⎕ucs 10),' z.s=r.s;z.v=dft(rv.type()==c64?rv:rv.as(c64),1,rv.dims());}',(⎕ucs 10 10))
_,←,⊂('NM(ift,"ift",1,0,MT ,MFD,MT ,MT ,MT )',(⎕ucs 10),'DEFN(ift)',(⎕ucs 10),'MF(ift_f){arr rv;CVSWITCH(r.v,err(6),rv=unrav(v,r.s),err(11))',(⎕ucs 10),' z.s=r.s;z.v=idft(rv.type()==c64?rv:rv.as(c64),1,rv.dims());}',(⎕ucs 10 10))
_,←,⊂('template<class fncls> inline V msclfn(A&z,CA&r,ENV&e,FN&rec_c,fncls fn){',(⎕ucs 10),' z.s=r.s;',(⎕ucs 10),' CVSWITCH(r.v,err(6),fn(z,v,e)',(⎕ucs 10),'  ,B cr=cnt(r);z.v=VEC<A>(cr);VEC<A>&zv=std::get<VEC<A>>(z.v);',(⎕ucs 10),'   DOB(cr,rec_c(zv[i],v[i],e)))}',(⎕ucs 10),'template<class fncls> inline V sclfn(A&z,CA&l,CA&r,ENV&e,fncls fn){',(⎕ucs 10),' B lr=rnk(l),rr=rnk(r);',(⎕ucs 10),' if(lr==rr){DOB(rr,if(l.s[i]!=r.s[i])err(5));z.s=l.s;}',(⎕ucs 10),' else if(!lr){z.s=r.s;}else if(!rr){z.s=l.s;}else if(lr!=rr)err(4);',(⎕ucs 10),' std::visit(visitor{DVSTR(),',(⎕ucs 10),'   [&](CVEC<A>&lv,carr&rv){err(16);},',(⎕ucs 10),'   [&](carr&lv,CVEC<A>&rv){err(16);},',(⎕ucs 10),'   [&](CVEC<A>&lv,CVEC<A>&rv){err(16);},',(⎕ucs 10),'   [&](carr&lv,carr&rv){',(⎕ucs 10),'    if(lr==rr){fn(z,lv,rv,e);}',(⎕ucs 10),'    else if(!lr){fn(z,tile(lv,rv.dims()),rv,e);}',(⎕ucs 10),'    else if(!rr){fn(z,lv,tile(rv,lv.dims()),e);}}},',(⎕ucs 10),'  l.v,r.v);}',(⎕ucs 10),'inline V sclfn(A&z,CA&l,CA&r,ENV&e,CA&ax,FN&me_c){',(⎕ucs 10),' A a=l,b=r;I f=rnk(l)>rnk(r);if(f){a=r;b=l;}',(⎕ucs 10),' B ar=rnk(a),br=rnk(b);B d=br-ar;B rk=cnt(ax);if(rk!=ar)err(5);',(⎕ucs 10),' VEC<D> axd(rk);SHP axv(rk);',(⎕ucs 10),' if(rk)',(⎕ucs 10),'  CVSWITCH(ax.v',(⎕ucs 10),'   ,err(99,L"Unexpected value error.")',(⎕ucs 10),'   ,v.as(f64).host(axd.data())',(⎕ucs 10),'   ,err(99,L"Unexpected nested shape."))',(⎕ucs 10),' DOB(rk,if(axd[i]!=rint(axd[i]))err(11))DOB(rk,axv[i]=(B)axd[i])',(⎕ucs 10),' DOB(rk,if(axv[i]<0||br<=axv[i])err(11))',(⎕ucs 10),' VEC<B> t(br);VEC<U8> tf(br,1);DOB(rk,B j=axv[i];tf[j]=0;t[j]=d+i)',(⎕ucs 10),' B c=0;DOB(br,if(tf[i])t[i]=c++)A ta(SHP(1,br),arr(br,t.data()));',(⎕ucs 10),' trn_c(z,ta,b,e);rho_c(b,z,e);rho_c(a,b,a,e);',(⎕ucs 10),' if(f)me_c(b,z,a,e);else me_c(b,a,z,e);',(⎕ucs 10),' gdu_c(ta,ta,e);trn_c(z,ta,b,e);}',(⎕ucs 10))
_,←,⊂('NM(nst,"nst",0,0,MT ,MFD,MT ,MT ,MT )',(⎕ucs 10),'DEFN(nst)',(⎕ucs 10),'MF(nst_f){CVSWITCH(r.v,err(6),par_c(z,r,e),z=r)}',(⎕ucs 10))
_,←3⍴⊂''
rtn←_

sclsyms←'+-×÷*⍟|○⌊⌈!<≤=≠≥>∨⍱⍲~?'

_←⍬
_,←(,'+') (,'-') (,'×') (,'÷') (,'*') (,'⍟') (,'|') (,'○') (,'⌊') (,'⌈') (,'!') (,'<') (,'≤') (,'=') (,'≥') (,'>') (,'≠') (,'~') (,'∧') (,'∨') (,'⍲') (,'⍱') (,'⌷') (,'[') (,'⍳') (,'⍴') (,',') (,'⍪') (,'⌽') (,'⍉') (,'⊖') (,'∊')
_,←(,'⊃') (,'≡') (,'≢') (,'⊢') (,'⊣') (,'⊤') (,'⊥') (,'/') (,'⌿') (,'\') (,'⍀') (,'?') (,'↑') (,'↓') (,'¨') (,'⍨') (,'.') (,'⍤') (,'⍣') (,'∘') (,'∪') (,'∩') (,'←') (,'⍋') (,'⍒') '∘.' (,'⍷') (,'⊂') (,'⌹') '⎕FFT'
_,←'⎕IFFT' '%s' (,'⊆') (,'∇') (,';') '%u'
syms←_

⎕ex '_'

⍝ === End of variables definition ===

(⎕IO ⎕ML ⎕WX)←0 1 3

:EndNamespace 
:EndNamespace 
