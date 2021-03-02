NM(red,"red",0,0,DID,MT ,DFD,MT ,DAD)
ID(red,1,s32)
DEFN(red)
OM(red,"red",0,0,MFD,DFD,MAD,DAD)
DA(red_f){B ar=rnk(ax),lr=rnk(l),rr=rnk(r),zr;if(lr>4||rr>4)err(16);
 if(ar>1||cnt(ax)!=1)err(5);if(!isint(ax))err(11);
 I axv;CVSWITCH(ax.v,err(6),axv=v.as(s32).scalar<I>(),err(11))
 if(axv<0)err(11);if(axv>=rr)err(4);
 dim4 zs(1),ls(1),rs(1);DO((I)lr,ls[i]=l.s[i])DO((I)rr,rs[i]=r.s[i])
 if(lr>1)err(4);axv=(I)rr-axv-1;B lc=cnt(l),rsx=rs[axv];
 if(lr!=0&&lc!=1&&rr!=0&&rsx!=1&&lc!=rsx)err(5);
 arr lv;CVSWITCH(l.v,err(6),lv=moddims(v,ls),err(11))
 arr x=lc==1?tile(lv,(I)rsx):lv;B zc=sum<B>(abs(x));
 zr=rr?rr:1;zs=rs;zs[axv]=zc;z.s=SHP(zr);DO((I)zr,z.s[i]=zs[i])
 if(!cnt(z)){z.v=scl(0);R;}arr w=where(x).as(s32);
 CVSWITCH(r.v,err(6)
  ,arr rv=moddims(v,rs);arr y=rsx==1?tile(rv,(I)lc):rv;IDX ix[4];
   z.v=arr();arr&zv=std::get<arr>(z.v);
   if(zc==w.elements()){ix[axv]=w;zv=y(ix[0],ix[1],ix[2],ix[3]);
    if(zc==sum<B>(x(w)))R;dim4 sp(zs);sp[axv]=1;
    zv*=tile(x(w)>0,(I)sp[0],(I)sp[1],(I)sp[2],(I)sp[3]);zv=flat(zv);R;}
   arr s=(!sign(x(w))).as(s32);arr i=shift(accum(abs(x(w))),1);
   arr d=shift(w,1);arr t=shift(s,1);arr q(zc,s32);arr u(zc,s32);
   i(0)=0;d(0)=0;q=0;u=0;t(0)=0;q(i)=w-d;u(i)=s-t;ix[axv]=accum(q);
   zv=y(ix[0],ix[1],ix[2],ix[3]);
   dim4 s1(1);dim4 s2(zs);s1[axv]=zc;s2[axv]=1;u=arr(accum(u),s1);
   zv*=tile(u,(I)s2[0],(I)s2[1],(I)s2[2],(I)s2[3]);zv=flat(zv)
  ,err(16))}
DF(red_f){A x=r;if(!rnk(r))cat_c(x,r,e);red_c(z,l,x,e,scl(scl(rnk(x)-1)));}
MA(red_o){B ar=rnk(ax),rr=rnk(r);if(rr>4)err(16);
 if(ar>1)err(4);if(cnt(ax)!=1)err(5);if(!isint(ax))err(11);
 I av;CVSWITCH(ax.v,err(6),av=v.as(s32).scalar<I>(),err(11))
 if(av<0)err(11);if(av>=rr)err(4);av=(I)rr-av-1;I rc=(I)r.s[av];
 z.s=SHP(rr-1);I ib=isbool(r);
 DO(av,z.s[i]=r.s[i])DO((I)rr-av-1,z.s[av+i]=r.s[av+i+1])
 if(!cnt(z)){z.v=scl(0);R;}
 if(!rc){z.v=ll.id(z.s);R;}
 if(1==rc){z.v=r.v;R;}
 CVSWITCH(r.v,err(6)
  ,arr rv=axis(v,r.s,av);
   if("rgt"==ll.nm){z.v=flat(rv(span,rc-1,span));R;}
   if("lft"==ll.nm){z.v=flat(rv(span,0,span));R;}
   if("add"==ll.nm&&ib){z.v=flat(count(rv,1).as(s32));R;}
   if("add"==ll.nm){z.v=flat(sum(rv.as(f64),1));R;}
   if("mul"==ll.nm){z.v=flat(product(rv.as(f64),1));R;}
   if("min"==ll.nm){z.v=flat(min(rv,1));R;}
   if("max"==ll.nm){z.v=flat(max(rv,1));R;}
   if("and"==ll.nm&&ib){z.v=flat(allTrue(rv,1));R;}
   if("lor"==ll.nm&&ib){z.v=flat(anyTrue(rv,1));R;}
   if("neq"==ll.nm&&ib){z.v=flat((1&sum(rv,1)).as(b8));R;}
   map_o mfn_c(llp);dim4 zs;DO((I)rnk(z),zs[i]=z.s[i])
   z.v=flat(rv(span,rc-1,span));
   DO(rc-1,mfn_c(z,A(z.s,flat(rv(span,rc-i-2,span))),z,e))
  ,B zc=cnt(z);z.v=VEC<A>(cnt(z));VEC<A>&zv=std::get<VEC<A>>(z.v);
   B bs=1;DOB(av,bs*=z.s[i])B as=1;DOB(rr-av-1,as*=z.s[av+i])
   B ms=bs*rc;B mi=rc*bs-bs;
   if("rgt"==ll.nm){DOB(as,B j=i;DOB(bs,zv[j*bs+i]=v[j*ms+mi+i]))R;}
   if("lft"==ll.nm){DOB(as,B j=i;DOB(bs,zv[j*bs+i]=v[j*ms+i]))R;}
   DOB(as,B k=i;DOB(bs,zv[k*bs+i]=v[k*ms+mi+i]))
   DOB(rc-1,B j=(rc-i-2)*bs;
    DOB(as,B k=i;DOB(bs,A&zvi=zv[k*bs+i];ll(zvi,v[k*ms+j+i],zvi,e)))))}
MF(red_o){A x=r;if(!rnk(r))cat_c(x,r,e);this_c(z,x,e,scl(scl(rnk(x)-1)));}
DA(red_o){B ar=rnk(ax),lr=rnk(l),rr=rnk(r);if(lr>4||rr>4)err(16);
 if(ar>1)err(4);if(cnt(ax)!=1)err(5);if(!isint(ax))err(11);
 I av;CVSWITCH(ax.v,err(6),av=v.as(s32).scalar<I>(),err(11))
 if(av<0)err(11);if(av>=rr)err(4);av=(I)rr-av-1;
 if(lr>1)err(4);if(cnt(l)!=1)err(5);if(!isint(l))err(11);
 I lv;CVSWITCH(l.v,err(6),lv=v.as(s32).scalar<I>(),err(11))
 I rc=(I)r.s[av]+1;if(rc<lv)err(5);rc=(I)(rc-abs(lv));
 A t(r.s,scl(0));t.s[av]=rc;
 if(!cnt(t)){z=t;R;}if(!lv){t.v=ll.id(t.s);z=t;R;}
 seq rng(rc);IDX x[4];map_o mfn_c(llp);
 CVSWITCH(r.v,err(6)
  ,arr rv=unrav(v,r.s);
   if(lv>=0){x[av]=rng+((D)lv-1);t.v=flat(rv(x[0],x[1],x[2],x[3]));
    DO(lv-1,x[av]=rng+(D)(lv-i-2);
     mfn_c(t,A(t.s,flat(rv(x[0],x[1],x[2],x[3]))),t,e))
   }else{x[av]=rng;t.v=flat(rv(x[0],x[1],x[2],x[3]));
    DO(abs(lv)-1,x[av]=rng+(D)(i+1);
     mfn_c(t,A(t.s,flat(rv(x[0],x[1],x[2],x[3]))),t,e))}
   z=t;
  ,err(16))}
DF(red_o){if(!rnk(r))err(4);
 red_o mfn_c(llp);mfn_c(z,l,r,e,scl(scl((I)rnk(r)-1)));}
