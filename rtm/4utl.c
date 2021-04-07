std::wstring mkstr(const char*s){R strconv.from_bytes(s);}
I scm(FN&f){R f.sm;}I scm(const A&a){R 1;}I scm(FNP f){R (*f).sm;}
I scd(FN&f){R f.sd;}I scd(const A&a){R 1;}I scd(FNP f){R (*f).sd;}
B rnk(const SHP&s){R s.size();}
B rnk(const A&a){R rnk(a.s);}
B cnt(SHP s){B c=1;DOB(s.size(),c*=s[i]);R c;}
B cnt(const A&a){R cnt(a.s);}
B cnt(pkt*d){B c=1;DO(RANK(d),c*=SHAPE(d)[i]);R c;}
B cnt(arr&a){R a.elements();}
I geti(CA&a){I x;CVSWITCH(a.v,err(6),x=v.as(s32).scalar<I>(),err(11));R x;}
arr scl(D x){R constant(x,dim4(1),f64);}
arr scl(I x){R constant(x,dim4(1),s32);}
arr scl(B x){R constant(x,dim4(1),u64);}
A scl(arr v){R A(0,v);}
arr axis(carr&a,const SHP&s,B ax){B l=1,m=1,r=1;if(ax>=rnk(s))R a;m=s[ax];
 DOB(ax,l*=s[i])DOB(rnk(s)-ax-1,r*=s[ax+i+1])
 R moddims(a,l,m,r);}
arr table(carr&a,const SHP&s,B ax){B l=1,r=1;if(ax>=rnk(s))R a;
 DOB(ax,l*=s[i])DOB(rnk(s)-ax,r*=s[ax+i])
 R moddims(a,l,r);}
arr unrav(carr&a,const SHP&sp){if(rnk(sp)>4)err(99);
 dim4 s(1);DO((I)rnk(sp),s[i]=sp[i])
 R moddims(a,s);}
V af2cd(A&a,const arr&b){dim4 bs=b.dims();a.s=SHP(4,1);DO(4,a.s[i]=bs[i])
 a.v=flat(b);}
dtype mxt(dtype at,dtype bt){if(at==c64||bt==c64)R c64;
 if(at==f64||bt==f64)R f64;
 if(at==s32||bt==s32)R s32;if(at==s16||bt==s16)R s16;
 if(at==b8||bt==b8)R b8;err(16);R f64;}
dtype mxt(carr&a,carr&b){R mxt(a.type(),b.type());}
dtype mxt(dtype at,CA&b){
 R std::visit(visitor{
   [&](NIL _){err(99,L"Unexpected value error.");R s32;},
   [&](carr&v){R mxt(at,v.type());},
   [&](CVEC<A>&v){dtype zt=at;DOB(v.size(),zt=mxt(zt,v[i]));R zt;}},
  b.v);}
dtype mxt(CA&a,CA&b){R mxt(mxt(b8,a),mxt(b8,b));}
inline I isint(D x){R x==nearbyint(x);}
inline I isint(CA&x){I res=1;
 CVSWITCH(x.v
  ,err(99,L"Unexpected value error.")
  ,res=v.isinteger()||v.isbool()||(v.isreal()&&allTrue<I>(v==trunc(v)))
  ,DOB(v.size(),if(!isint(v[i])){res=0;R;}))
 R res;}
inline I isbool(carr&v){R v.isbool()||(v.isreal()&&allTrue<I>(v==0||v==1));}
inline I isbool(CA&x){I res=1;
 CVSWITCH(x.v
  ,err(99,L"Unexpected value error.")
  ,res=isbool(v)
  ,DOB(v.size(),if(!isbool(v[i])){res=0;R;}))
 R res;}
