std::wstring mkstr(const char*s){R strconv.from_bytes(s);}
I scm(FN&f){R f.sm;}I scm(const A&a){R 1;}
I scd(FN&f){R f.sd;}I scd(const A&a){R 1;}
B rnk(const A&a){R a.s.size();}
B cnt(SHP s){B c=1;DOB(s.size(),c*=s[i]);R c;}
B cnt(const A&a){B c=1;DOB(rnk(a),c*=a.s[i]);R c;}
B cnt(lp*d){B c=1;DO(RANK(d),c*=SHAPE(d)[i]);R c;}
array scl(D x){R constant(x,dim4(1),f64);}
array scl(I x){R constant(x,dim4(1),s32);}
A scl(array v){R A(0,v);}
dtype mxt(dtype at,dtype bt){if(at==c64||bt==c64)R c64;
 if(at==f64||bt==f64)R f64;
 if(at==s32||bt==s32)R s32;if(at==s16||bt==s16)R s16;
 if(at==b8||bt==b8)R b8;err(16);R f64;}
dtype mxt(const array&a,const array&b){R mxt(a.type(),b.type());}
dtype mxt(dtype at,const A&b){R mxt(at,b.v.type());}
Z array da16(B c,lp*d){std::vector<S16>b(c);S8*v=(S8*)DATA(d);
 DOB(c,b[i]=v[i]);R array(c,b.data());}
Z array da8(B c,lp*d){std::vector<char>b(c);U8*v=(U8*)DATA(d);
 DOB(c,b[i]=1&(v[i/8]>>(7-(i%8))))R array(c,b.data());}
V cpad(lp*d,A&a){I t;B c=cnt(a),ar=rnk(a);if(!a.f){d->p=NULL;R;}
 switch(a.v.type()){CS(c64,t=APLZ);
  CS(s32,t=APLI);CS(s16,t=APLSI);CS(b8,t=APLTI);CS(f64,t=APLD);
  default:if(c)err(16);t=APLI;}
 if(ar>15)err(16);B s[15];DOB(ar,s[ar-i-1]=a.s[i]);dwafns->ws->ga(t,(U)ar,s,d);
 if(c)a.v.host(DATA(d));}
V cpda(A&a,lp*d){if(d==NULL)R;if(15!=TYPE(d))err(16);a.f=1;a.v=scl(0);
 a.s=SHP(RANK(d));DO(RANK(d),a.s[RANK(d)-i-1]=SHAPE(d)[i]);B c=cnt(d);
 if(c){
  switch(ETYPE(d)){
   CS(APLZ ,a.v=array(c,(DZ*)DATA(d))) CS(APLI ,a.v=array(c,(I*)DATA(d)))
   CS(APLD ,a.v=array(c,(D*)DATA(d)))  CS(APLSI,a.v=array(c,(S16*)DATA(d)))
   CS(APLTI,a.v=da16(c,d))             CS(APLU8,a.v=da8(c,d))
   default:err(16);}}}
inline I isint(D x){R x!=nearbyint(x);}
inline I isint(A x){R x.v.isinteger()||x.v.isbool()
  ||(x.v.isreal()&&allTrue<I>(x.v==trunc(x.v)));}
inline I isbool(A x){R x.v.isbool()
  ||(x.v.isreal()&&allTrue<I>(x.v==0||x.v==1));}