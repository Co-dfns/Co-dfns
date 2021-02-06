NM(enc,"enc",0,0,DID,MT ,DFD,MT ,MT )
DEFN(enc)
ID(enc,0,s32)
DF(enc_f){B rr=rnk(r),lr=rnk(l),rk=rr+lr;if(rk>4)err(16);
 SHP sp(rk);DOB(rr,sp[i]=r.s[i])DOB(lr,sp[i+rr]=l.s[i])
 if(!cnt(sp)){z.s=sp;z.v=scl(0);R;}
 dim4 lt(1),rt(1);DO((I)rk,lt[i]=rt[i]=sp[i])I k=lr?(I)lr-1:0;
 DO((I)rr,rt[i]=1)DO((I)lr,lt[i+(I)rr]=1)
 arr rv;CVSWITCH(r.v,err(6),rv=v,err(11))
 arr lv;CVSWITCH(l.v,err(6),lv=v,err(11))
 rv=tile(unrav(rv,r.s),rt);z.s=sp;
 arr sv=flip(scan(flip(unrav(lv,l.s),k),k,AF_BINARY_MUL),k);
 lv=tile(arr(sv,rt),lt);IDX x[4];x[k]=0;
 arr dv=sv;dv(x[0],x[1],x[2],x[3])=1;I s[]={0,0,0,0};s[k]=-1;
 dv=shift(dv,s[0],s[1],s[2],s[3]);dv=tile(arr(dv,rt),lt);
 arr ix=where(lv);z.v=arr();arr&zv=std::get<arr>(z.v);
 zv=rv.as(s32);zv(ix)=rem(rv(ix),lv(ix)).as(s32);
 ix=where(dv);zv*=dv!=0;zv(ix)=(zv(ix)/dv(ix)).as(s32);
 zv=flat(zv);}
