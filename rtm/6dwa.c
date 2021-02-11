Z arr da16(B c,pkt*d){VEC<S16>b(c);S8*v=(S8*)DATA(d);
 DOB(c,b[i]=v[i]);R arr(c,b.data());}
Z arr da8(B c,pkt*d){VEC<char>b(c);U8*v=(U8*)DATA(d);
 DOB(c,b[i]=1&(v[i/8]>>(7-(i%8))))R arr(c,b.data());}
pkt*cpad(lp*l,CA&a){I t;B c=cnt(a),ar=rnk(a);pkt*p=NULL;
 if(ar>15)err(16,L"Dyalog APL does not support ranks > 15.");
 B s[15];DOB(ar,s[ar-i-1]=a.s[i]);
 std::visit(visitor{
   [&](NIL _){if(l)l->p=NULL;},
   [&](carr&v){
    switch(v.type()){
     CS(c64,t=APLZ);CS(s32,t=APLI);CS(s16,t=APLSI);
     CS(b8,t=APLTI);CS(f64,t=APLD);
     default:if(c)err(16);t=APLI;}
    p=dwafns->ws->ga(t,(U)ar,s,l);if(c)v.host(DATA(p));},
   [&](CVEC<A>&v){
    p=dwafns->ws->ga(APLP,(U)ar,s,l);pkt**d=(pkt**)DATA(p);
    DOB(c,if(!(d[i]=cpad(NULL,v[i])))err(6))}},
  a.v);
  R p;}
V cpda(A&a,pkt*d){
 B c=cnt(d);a.s=SHP(RANK(d));DO(RANK(d),a.s[RANK(d)-i-1]=SHAPE(d)[i]);
 if(!c){a.v=scl(0);R;}
 switch(TYPE(d)){
  CS(15,
   switch(ETYPE(d)){
    CS(APLZ ,a.v=arr(c,(DZ*)DATA(d))) CS(APLI ,a.v=arr(c,(I*)DATA(d)))
    CS(APLD ,a.v=arr(c,(D*)DATA(d)))  CS(APLSI,a.v=arr(c,(S16*)DATA(d)))
    CS(APLTI,a.v=da16(c,d))           CS(APLU8,a.v=da8(c,d))
    default:err(16);})
  CS(7,{if(APLP!=ETYPE(d))err(16);
   a.v=VEC<A>(c);pkt**dv=(pkt**)DATA(d);
   DOB(c,cpda(std::get<VEC<A>>(a.v)[i],dv[i]))})
  default:err(16);}}
V cpda(A&a,lp*d){if(d==NULL)R;cpda(a,d->p);}
