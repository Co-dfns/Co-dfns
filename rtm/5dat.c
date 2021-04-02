V coal(A&a){
 VSWITCH(a.v,,,
  B c=cnt(a);I can=1;
  DOB(c,A&b=v[i];
   coal(b);if(rnk(b))can=0;CVSWITCH(b.v,can=0,,can=0)
   if(!can)break)
  if(can){dtype tp=mxt(b8,a);arr nv(c,tp);
   const wchar_t*msg=L"Unexpected non-simple array type.";
   DOB(c,CVSWITCH(v[i].v,err(99,msg),nv((I)i)=v(0).as(tp),err(99,msg)))
   a.v=nv;})}
arr proto(carr&);VEC<A> proto(CVEC<A>&);A proto(CA&);
arr proto(carr&a){arr z=a;z=0;R z;}
VEC<A> proto(CVEC<A>&a){VEC<A> z(a.size());DOB(a.size(),z[i]=proto(a[i]));R z;}
A proto(CA&a){A z;z.s=a.s;CVSWITCH(a.v,err(6),z.v=proto(v),z.v=proto(v));R z;}