std::wstring mkstr(const char*s){R strconv.from_bytes(s);}
I scm(FN&f){R f.sm;}I scm(const A&a){R 1;}I scm(FNP f){R (*f).sm;}
I scd(FN&f){R f.sd;}I scd(const A&a){R 1;}I scd(FNP f){R (*f).sd;}
B rnk(const SHP&s){R s.size();}
B rnk(const A&a){R rnk(a.s);}
B cnt(SHP s){B c=1;DOB(s.size(),c*=s[i]);R c;}
B cnt(const A&a){R cnt(a.s);}
B cnt(lp*d){B c=1;DO(RANK(d),c*=SHAPE(d)[i]);R c;}
B cnt(arr&a){R a.elements();}
arr scl(D x){R constant(x,dim4(1),f64);}
arr scl(I x){R constant(x,dim4(1),s32);}
arr scl(B x){R constant(x,dim4(1),u64);}
A scl(arr v){R A(0,v);}
arr axis(carr&a,SHP&s,B ax){B l=1,m=1,r=1;if(ax>=rnk(s))R a;m=s[ax];
 DOB(ax,l*=s[i])DOB(rnk(s)-ax-1,r*=s[ax+i+1])
 R moddims(a,l,m,r);}
arr table(carr&a,SHP&s,B ax){B l=1,r=1;if(ax>=rnk(s))R a;
 DOB(ax,l*=s[i])DOB(rnk(s)-ax,r*=s[ax+i])
 R moddims(a,l,r);}
arr unrav(carr&a,SHP&sp){if(rnk(sp)>4)err(99);dim4 s(1);DO((I)rnk(sp),s[i]=sp[i])
 R moddims(a,s);}
dtype mxt(dtype at,dtype bt){if(at==c64||bt==c64)R c64;
 if(at==f64||bt==f64)R f64;
 if(at==s32||bt==s32)R s32;if(at==s16||bt==s16)R s16;
 if(at==b8||bt==b8)R b8;err(16);R f64;}
dtype mxt(carr&a,carr&b){R mxt(a.type(),b.type());}
dtype mxt(dtype at,const A&b){
 R std::visit(visitor{
   [&](std::monostate _){err(99,L"Unexpected value error.");R s32;},
   [&](carr&v){R mxt(at,v.type());},
   [&](const VEC<A>&v){dtype zt=at;DOB(v.size(),zt=mxt(zt,v[i]));R zt;}},
  b.v);}
Z arr da16(B c,lp*d){VEC<S16>b(c);S8*v=(S8*)DATA(d);
 DOB(c,b[i]=v[i]);R arr(c,b.data());}
Z arr da8(B c,lp*d){VEC<char>b(c);U8*v=(U8*)DATA(d);
 DOB(c,b[i]=1&(v[i/8]>>(7-(i%8))))R arr(c,b.data());}
V cpad(lp*d,A&a){I t;B c=cnt(a),ar=rnk(a);
 std::visit(visitor{
   [&](std::monostate _){d->p=NULL;},
   [&](carr&v){
    switch(v.type()){
     CS(c64,t=APLZ);CS(s32,t=APLI);CS(s16,t=APLSI);
     CS(b8,t=APLTI);CS(f64,t=APLD);
     default:if(c)err(16);t=APLI;}
    if(ar>15)err(16,L"Dyalog APL does not support ranks > 15.");
    B s[15];DOB(ar,s[ar-i-1]=a.s[i]);
    dwafns->ws->ga(t,(U)ar,s,d);if(c)v.host(DATA(d));},
   [&](const VEC<A>&v){err(16);}},
  a.v);}
V cpda(A&a,lp*d){if(d==NULL)R;
 switch(TYPE(d)){
  CS(15,{a.v=scl(0);a.s=SHP(RANK(d));B c=cnt(d);
   DO(RANK(d),a.s[RANK(d)-i-1]=SHAPE(d)[i]);
   if(c){
    switch(ETYPE(d)){
     CS(APLZ ,a.v=arr(c,(DZ*)DATA(d))) CS(APLI ,a.v=arr(c,(I*)DATA(d)))
     CS(APLD ,a.v=arr(c,(D*)DATA(d)))  CS(APLSI,a.v=arr(c,(S16*)DATA(d)))
     CS(APLTI,a.v=da16(c,d))           CS(APLU8,a.v=da8(c,d))
     default:err(16);}}})
  CS(7,{a.v=scl((I)ETYPE(d));a.s=SHP(0);})
  default:err(16);}}
inline I isint(D x){R x==nearbyint(x);}
inline I isint(CA&x){
 R std::visit(visitor{
   [&](std::monostate _){err(99,L"Unexpected value error.");R 0;},
   [&](carr&v)->I{R v.isinteger()||v.isbool()
     ||(v.isreal()&&allTrue<I>(v==0||v==1));},
   [&](const VEC<A>&v){DOB(v.size(),if(!isint(v[i]))R 0);R 1;}},
  x.v);}
inline I isbool(A x){
 R std::visit(visitor{
   [&](std::monostate _){err(99,L"Unexpected value error.");R 0;},
   [&](carr&v)->I{R v.isbool()||(v.isreal()&&allTrue<I>(v==0||v==1));},
   [&](const VEC<A>&v){DOB(v.size(),if(!isbool(v[i]))R 0);R 1;}},
  x.v);}
