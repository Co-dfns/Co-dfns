NM(lor,"lor",1,1,DID,MT ,DFD,MT ,DAD)
lor_f lor_c;
ID(lor,0,s32)
SF(lor,if(rv.isbool()&&lv.isbool())z.v=lv||rv;
 else if(lv.isbool()&&rv.isinteger())z.v=lv+(!lv)*abs(rv).as(rv.type());
 else if(rv.isbool()&&lv.isinteger())z.v=rv+(!rv)*abs(lv).as(lv.type());
 else if(lv.isinteger()&&rv.isinteger()){B c=cnt(z);
  std::vector<I> a(c);abs(lv).as(s32).host(a.data());
  std::vector<I> b(c);abs(rv).as(s32).host(b.data());
  DOB(c,while(b[i]){I t=b[i];b[i]=a[i]%b[i];a[i]=t;})
  z.v=array(z.s,a.data());}
 else{B c=cnt(z);
  std::vector<D> a(c);abs(lv).as(f64).host(a.data());
  std::vector<D> b(c);abs(rv).as(f64).host(b.data());
  DOB(c,while(b[i]>1e-12){D t=b[i];b[i]=fmod(a[i],b[i]);a[i]=t;})
  z.v=array(z.s,a.data());})

