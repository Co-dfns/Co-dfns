NM(and,"and",1,1,DID,MT,DFD,MT,MT)
ID(and,1,s32)
SF(and_f,if(lv.isbool()&&rv.isbool())z.v=lv&&rv;
 else if(allTrue<I>(lv>=0&&lv<=1&&rv>0&&rv<=1))z.v=lv&&rv;
 else{A a(z.r,z.s,lv);A b(z.r,z.s,rv);
  lorfn(a,a,b);z.v=lv*(rv/((!a.v)+a.v));})
