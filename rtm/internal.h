#pragma once

#define VSWITCH(x,nil,arry,vec) \
 std::visit(\
  visitor{[&](NIL v){nil;},[&](arr&v){arry;},[&](VEC<A>&v){vec;}},\
  (x));
#define CVSWITCH(x,nil,arr,vec) \
 std::visit(\
  visitor{[&](NIL v){nil;},[&](carr&v){arr;},[&](CVEC<A>&v){vec;}},\
  (x));

S DVSTR {
 V operator()(NIL,NIL);
 V operator()(NIL,carr&);
 V operator()(NIL,CVEC<A>&);
 V operator()(carr&,NIL);
 V operator()(CVEC<A>&,NIL);};
S MVSTR {V operator()(NIL);};
template<class... Ts> S visitor : Ts... { using Ts::operator()...; };
template<class... Ts> visitor(Ts...) -> visitor<Ts...>;

std::wstring mkstr(const char*);
I scm(FN&);
I scm(const A&);
I scm(FNP);
I scd(FN&);
I scd(const A&);
I scd(FNP);
B rnk(const SHP&);
B rnk(const A&);
B cnt(SHP);
B cnt(const A&);
B cnt(pkt*);
B cnt(arr&);
I geti(CA&);
arr scl(D);
arr scl(I);
arr scl(B);
A scl(arr);
arr axis(carr&,const SHP&,B);
arr table(carr&,const SHP&,B);
arr unrav(carr&,const SHP&);
V af2cd(A&,const arr&);
dtype mxt(dtype,dtype);
dtype mxt(carr&,carr&);
dtype mxt(dtype,CA&);
dtype mxt(CA&,CA&);
inline I isint(D);
inline I isint(CA&);
inline I isbool(carr&);
inline I isbool(CA&);

V coal(A&);
arr proto(carr&);
VEC<A> proto(CVEC<A>&);
A proto(CA&);

Z arr da16(B,pkt*);
Z arr da8(B,pkt*);
pkt*cpad(lp*,CA&);
V cpda(A&,pkt*);
V cpda(A&,lp*);
