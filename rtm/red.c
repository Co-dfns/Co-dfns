NM(red,"red",0,0,DID,MT ,DFD,MT ,DAD)
ID(red,1,s32)
red_f red_c;
OM(red,"red",0,0,MFD,DFD,MAD,DAD)
DA(red_f){z.f=1;B ar=rnk(ax),lr=rnk(l),rr=rnk(r),zr;if(lr>4||rr>4)err(16);
 dim4 zs,ls,rs;DO((I)lr,ls[i]=l.s[i])DO((I)rr,rs[i]=r.s[i])
 array lv=moddims(l.v,ls),rv=moddims(r.v,rs);
 if(ar>1||cnt(ax)!=1)err(5);if(!ax.v.isinteger())err(11);
 I axv=ax.v.as(s32).scalar<I>();if(axv<0)err(11);if(axv>=rr)err(4);
 if(lr>1)err(4);axv=(I)rr-axv-1;B lc=cnt(l),rsx=rs[axv];
 if(lr!=0&&lc!=1&&rr!=0&&rsx!=1&&lc!=rsx)err(5);
 array x=lc==1?tile(lv,(I)rsx):lv,y=rsx==1?tile(rv,(I)lc):rv;
 B zc=sum<B>(abs(x));zr=rr?rr:1;zs=rs;zs[axv]=zc;
 z.s=SHP(zr);DO((I)zr,z.s[i]=zs[i])
 if(!cnt(z)){z.v=scl(0);R;}array w=where(x).as(s32);index ix[4];
 if(zc==w.elements()){ix[axv]=w;z.v=y(ix[0],ix[1],ix[2],ix[3]);
  if(zc==sum<B>(x(w)))R;dim4 sp(zs);sp[axv]=1;
  z.v*=tile(x(w)>0,(I)sp[0],(I)sp[1],(I)sp[2],(I)sp[3]);
  z.v=flat(z.v);R;}
 array i=shift(accum(abs(x(w))),1),d=shift(w,1);i(0)=0;d(0)=0;
 array v=array(zc,s32),u=array(zc,s32);v=0;u=0;
 array s=(!sign(x(w))).as(s32);array t=shift(s,1);t(0)=0;
 v(i)=w-d;u(i)=s-t;ix[axv]=accum(v);z.v=y(ix[0],ix[1],ix[2],ix[3]);
 dim4 s1(1),s2(zs);s1[axv]=zc;s2[axv]=1;u=array(accum(u),s1);
 z.v*=tile(u,(I)s2[0],(I)s2[1],(I)s2[2],(I)s2[3]);
 z.v=flat(z.v);}
DF(red_f){A x=r;if(!rnk(r))cat_c(x,r,e);red_c(z,l,x,e,scl(scl(rnk(x)-1)));}
MA(red_o){z.f=1;B ar=rnk(ax),rr=rnk(r);if(rr>4)err(16);
 dim4 rs;DO((I)rr,rs[i]=r.s[i])
 arr rv=moddims(r.v,rs);
 if(ar>1)err(4);if(cnt(ax)!=1)err(5);
 if(!isint(ax))err(11);I av;ax.v.as(s32).host(&av);
 if(av<0)err(11);if(av>=rr)err(4);av=(I)rr-av-1;I rc=(I)rs[av];
 A t(rr-1,rv(0));I ib=isbool(r);
 DO(av,t.s[i]=rs[i])DO((I)rr-av-1,t.s[av+i]=rs[av+i+1])
 dim4 ts;DO((I)rnk(t),ts[i]=t.s[i])
 if(!cnt(t)){t.v=scl(0);z=t;R;}
 if(!rc){t.v=ll.id(t.s);z=t;R;}
 if(1==rc){t.v=r.v;z=t;R;}
 if("add"==ll.nm&&ib){t.v=count(rv,av).as(s32);z=t;z.v=flat(z.v);R;}
 if("add"==ll.nm){t.v=moddims(sum(rv.as(f64),av),ts);z=t;z.v=flat(z.v);R;}
 if("mul"==ll.nm){t.v=moddims(product(rv.as(f64),av),ts);z=t;z.v=flat(z.v);R;}
 if("min"==ll.nm){t.v=moddims(min(rv,av),ts);z=t;z.v=flat(z.v);R;}
 if("max"==ll.nm){t.v=moddims(max(rv,av),ts);z=t;z.v=flat(z.v);R;}
 if("and"==ll.nm&&ib){t.v=moddims(allTrue(rv,av),ts);z=t;z.v=flat(z.v);R;}
 if("lor"==ll.nm&&ib){t.v=moddims(anyTrue(rv,av),ts);z=t;z.v=flat(z.v);R;}
 if("neq"==ll.nm&&ib){t.v=moddims((1&sum(rv,0)).as(b8),ts);z=t;z.v=flat(z.v);R;}
 map_o mfn_c(ll);af::index x[4];x[av]=rc-1;
 t.v=moddims(rv(x[0],x[1],x[2],x[3]),ts);
 DO(rc-1,x[av]=rc-i-2;
  mfn_c(t,A(t.s,flat(moddims(rv(x[0],x[1],x[2],x[3]),ts))),t,e))
 z=t;z.v=flat(z.v);}
MF(red_o){z.f=1;A x=r;if(!rnk(r))cat_c(x,r,e);
 red_o mfn(ll);mfn(z,x,e,scl(scl((I)rnk(x)-1)));}
DA(red_o){z.f=1;B ar=rnk(ax),lr=rnk(l),rr=rnk(r);if(lr>4||rr>4)err(16);
 dim4 ls,rs;DO((I)lr,ls[i]=l.s[i])DO((I)rr,rs[i]=r.s[i])
 arr rv=moddims(r.v,rs);
 if(ar>1)err(4);if(cnt(ax)!=1)err(5);
 if(!isint(ax))err(11);I av;ax.v.as(s32).host(&av);
 if(av<0)err(11);if(av>=rr)err(4);av=(I)rr-av-1;
 if(lr>1)err(4);if(cnt(l)!=1)err(5);
 if(!isint(l))err(11);I lv=l.v.as(s32).scalar<I>();I rc=(I)rs[av]+1;
 if(rc<lv)err(5);rc=(I)(rc-abs(lv));map_o mfn_c(ll);
 A t(rr,scl(0));t.s[av]=rc;if(!cnt(t)){z=t;R;}
 dim4 ts;DO((I)rnk(t),ts[i]=t.s[i])
 if(!lv){t.v=ll.id(t.s);z=t;z.v=flat(z.v);R;}seq rng(rc);af::index x[4];
 if(lv>=0){x[av]=rng+((D)lv-1);t.v=flat(rv(x[0],x[1],x[2],x[3]));
  DO(lv-1,x[av]=rng+(D)(lv-i-2);
   mfn_c(t,A(t.s,flat(rv(x[0],x[1],x[2],x[3]))),t,e))
 }else{x[av]=rng;t.v=flat(rv(x[0],x[1],x[2],x[3]));
  DO(abs(lv)-1,x[av]=rng+(D)(i+1);
   mfn_c(t,A(t.s,flat(rv(x[0],x[1],x[2],x[3]))),t,e))}
 z=t;z.v=flat(z.v);}
DF(red_o){if(!rnk(r))err(4);
 red_o mfn_c(ll);mfn_c(z,l,r,e,scl(scl((I)rnk(r)-1)));}
