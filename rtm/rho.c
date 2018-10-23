NM(rho,"rho",0,0,MT ,MFD,DFD,MT ,MT )
rho_f rho_c;
MF(rho_f){I sp[4]={1,1,1,1};DO(r.r,sp[r.r-(i+1)]=(I)r.s[i]);
 z.s=dim4(r.r);z.r=1;if(!cnt(z)){z.v=scl(0);R;}z.v=array(z.s,sp);}
DF(rho_f){B cr=cnt(r);B cl=cnt(l);B s[4];if(l.r>1)err(11);if(cl>4)err(16);
 l.v.as(s64).host(s);z.r=(I)cl;DO(4,z.s[i]=i>=z.r?1:s[z.r-(i+1)])B cz=cnt(z);
 if(!cz){z.v=scl(0);R;}z.v=array(cz==cr?r.v:flat(r.v)(iota(cz)%cr),z.s);}

