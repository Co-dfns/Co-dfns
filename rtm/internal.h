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
I isint(D);
I isint(CA&);
I isbool(carr&);
I isbool(CA&);
I is_eqv(CA&,CA&);

V coal(A&);
arr proto(carr&);
VEC<A> proto(CVEC<A>&);
A proto(CA&);
V derr(U);
V err(U,const wchar_t*);
V err(U);

Z arr da16(B,pkt*);
Z arr da8(B,pkt*);
pkt*cpad(lp*,CA&);
V cpda(A&,pkt*);
V cpda(A&,lp*);

V sclfn(A&,CA&,CA&,ENV&,CA&,FN&);

template<class fncls> inline V msclfn(A&z,CA&r,ENV&e,FN&rec_c,fncls fn){
 z.s=r.s;
 CVSWITCH(r.v,err(6),fn(z,v,e)
  ,B cr=cnt(r);z.v=VEC<A>(cr);VEC<A>&zv=std::get<VEC<A>>(z.v);
   DOB(cr,rec_c(zv[i],v[i],e)))}
template<class fncls> inline V sclfn(A&z,CA&l,CA&r,ENV&e,fncls fn){
 B lr=rnk(l),rr=rnk(r);
 if(lr==rr){DOB(rr,if(l.s[i]!=r.s[i])err(5));z.s=l.s;}
 else if(!lr){z.s=r.s;}else if(!rr){z.s=l.s;}else if(lr!=rr)err(4);
 std::visit(visitor{DVSTR(),
   [&](CVEC<A>&lv,carr&rv){err(16);},
   [&](carr&lv,CVEC<A>&rv){err(16);},
   [&](CVEC<A>&lv,CVEC<A>&rv){err(16);},
   [&](carr&lv,carr&rv){
    if(lr==rr){fn(z,lv,rv,e);}
    else if(!lr){fn(z,tile(lv,rv.dims()),rv,e);}
    else if(!rr){fn(z,lv,tile(rv,lv.dims()),e);}}},
  l.v,r.v);}
