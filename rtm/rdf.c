NM(rdf,"rdf",0,0,DID,MT ,DFD,MT ,MT )
ID(rdf,1,s32)
OM(rdf,"rdf",0,0,MFD,DFD)
DF(rdf_f){if(l.r>1)err(4);I ra=r.r?r.r-1:0;z.r=ra+1;z.s=r.s;
 if(l.r!=0&&l.s[0]!=1&&r.r!=0&&r.s[ra]!=1&&l.s[0]!=r.s[ra])err(5);
 array x=l.v;array y=r.v;if(cnt(l)==1)x=tile(x,(I)r.s[ra]);
 if(r.s[ra]==1){dim4 s(1);s[ra]=cnt(l);y=tile(y,s);}
 z.s[ra]=sum<B>(abs(x));if(!cnt(z)){z.v=scl(0);R;}
 array w=where(x).as(s32);af::index ix[4];if(z.s[ra]==w.elements()){
  ix[ra]=w;z.v=y(ix[0],ix[1],ix[2],ix[3]);R;}
 array i=shift(accum(abs(x(w))),1),d=shift(w,1);i(0)=0;d(0)=0;
 array v=array(z.s[ra],s32),u=array(z.s[ra],s32);v=0;u=0;
 array s=(!sign(x(w))).as(s32);array t=shift(s,1);t(0)=0;
 v(i)=w-d;u(i)=s-t;ix[ra]=accum(v);z.v=y(ix[0],ix[1],ix[2],ix[3]);
 dim4 s1(1),s2(z.s);s1[ra]=z.s[ra];s2[ra]=1;u=array(accum(u),s1);
 z.v*=tile(u,(I)s2[0],(I)s2[1],(I)s2[2],(I)s2[3]);}

#define rdfop(zz,rr) rdf_o zz(rr)

MF(rdf_o){A t(r.r?r.r-1:0,dim4(1),r.v(0));DO(t.r,t.s[i]=r.s[i])
 I rc=(I)r.s[t.r];I zc=(I)cnt(t);mapop(mfn,ll);
 if(!zc){t.v=scl(0);z=t;R;}if(!rc){t.v=ll.id(t.s);z=t;R;}
 if(1==rc){t.v=array(r.v,t.s);z=t;R;}
 if("add"==ll.nm){if(r.v.isbool())t.v=count(r.v,t.r).as(s32);
  else t.v=sum(r.v.as(f64),t.r);z=t;R;}
 if("mul"==ll.nm){t.v=product(r.v.as(f64),t.r);z=t;R;}
 if("min"==ll.nm){t.v=min(r.v,t.r);z=t;R;}
 if("max"==ll.nm){t.v=max(r.v,t.r);z=t;R;}
 if("and"==ll.nm){t.v=allTrue(r.v,t.r);z=t;R;}
 if("lor"==ll.nm){t.v=anyTrue(r.v,t.r);z=t;R;}
 af::index x[4];x[t.r]=rc-1;t.v=r.v(x[0],x[1],x[2],x[3]);
 DO(rc-1,x[t.r]=rc-(i+2);
  mfn(t,A(t.r,t.s,r.v(x[0],x[1],x[2],x[3])),t));z=t;}
DF(rdf_o){if(l.r!=0&&(l.r!=1||l.s[0]!=1))err(5);if(!r.r)err(4);
 I lv=l.v.as(s32).scalar<I>();I ra=r.r-1;
  if((r.s[ra]+1)<lv)err(5);I rc=(I)((1+r.s[ra])-abs(lv));
 mapop(mfn,ll);A t(r.r,r.s,scl(0));t.s[ra]=rc;if(!cnt(t)){z=t;R;}
 if(!lv){t.v=ll.id(t.s);z=t;R;}seq rng(rc);af::index x[4];
 if(lv>=0){x[ra]=rng+((D)lv-1);t.v=r.v(x[0],x[1],x[2],x[3]);
  DO(lv-1,x[ra]=rng+((D)lv-(i+2));
   mfn(t,A(t.r,t.s,r.v(x[0],x[1],x[2],x[3])),t))
 }else{x[ra]=rng;t.v=r.v(x[0],x[1],x[2],x[3]);
  DO(abs(lv)-1,x[ra]=rng+(D)(i+1);
   mfn(t,A(t.r,t.s,r.v(x[0],x[1],x[2],x[3])),t))}
 z=t;}

