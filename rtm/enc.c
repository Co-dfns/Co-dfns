NM(enc,"enc",0,0,DID,MT ,DFD,MT ,MT )
enc_f enc_c;
ID(enc,0,s32)
DF(enc_f){I rk=r.r+l.r;if(rk>4)err(16);dim4 sp=r.s;DO(l.r,sp[i+r.r]=l.s[i])
 if(!cnt(sp)){z.r=rk;z.s=sp;z.v=scl(0);R;}dim4 lt=sp,rt=sp;I k=l.r?l.r-1:0;
 DO(r.r,rt[i]=1)DO(l.r,lt[i+r.r]=1)array rv=tile(r.v,rt);z.r=rk;z.s=sp;
 array sv=flip(scan(flip(l.v,k),k,AF_BINARY_MUL),k);
 array lv=tile(array(sv,rt),lt);af::index x[4];x[k]=0;
 array dv=sv;dv(x[0],x[1],x[2],x[3])=1;I s[]={0,0,0,0};s[k]=-1;
 dv=shift(dv,s[0],s[1],s[2],s[3]);dv=tile(array(dv,rt),lt);
 array ix=where(lv);z.v=rv.as(s32);z.v(ix)=rem(rv(ix),lv(ix)).as(s32);
 ix=where(dv);z.v*=dv!=0;z.v(ix)=(z.v(ix)/dv(ix)).as(s32);}
