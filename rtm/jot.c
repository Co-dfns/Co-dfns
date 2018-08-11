OD(jot,"jot",(scm(l)&&scm(r)),(scd(l)&&scd(r)),MFD,DFD)
#define jotop(zz,ll,rr) jot_o zz(ll,rr)

MF(jot_o){if(!fl){rr(z,aa,r);R;}if(!fr){ll(z,r,ww);R;}
 rr(z,r);ll(z,z);}
DF(jot_o){if(!fl||!fr){err(2);}rr(z,r);ll(z,l,z);}

