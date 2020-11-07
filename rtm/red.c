NM(red,"red",0,0,DID,MT ,DFD,MT ,DAD)
ID(red,1,s32)
red_f red_c;
OM(red,"red",0,0,MFD,DFD,MAD,DAD)
DA(red_f){if(ax.r>1||cnt(ax)!=1)err(5);if(!ax.v.isinteger())err(11);
 I axv=ax.v.as(s32).scalar<I>();if(axv<0)err(11);if(axv>=r.r)err(4);
 if(l.r>1)err(4);axv=r.r-axv-1;B lc=cnt(l),rsx=r.s[axv];
 if(l.r!=0&&lc!=1&&r.r!=0&&rsx!=1&&lc!=rsx)err(5);
 array x=lc==1?tile(l.v,(I)rsx):l.v,y=rsx==1?tile(r.v,(I)lc):r.v;
 B zc=sum<B>(abs(x));z.r=r.r?r.r:1;z.s=r.s;z.s[axv]=zc;
 if(!cnt(z)){z.v=scl(0);R;}array w=where(x).as(s32);index ix[4];
 if(zc==w.elements()){ix[axv]=w;z.v=y(ix[0],ix[1],ix[2],ix[3]);
  if(zc==sum<B>(x(w)))R;dim4 sp(z.s);sp[axv]=1;
  z.v*=tile(x(w)>0,(I)sp[0],(I)sp[1],(I)sp[2],(I)sp[3]);R;}
 array i=shift(accum(abs(x(w))),1),d=shift(w,1);i(0)=0;d(0)=0;
 array v=array(zc,s32),u=array(zc,s32);v=0;u=0;
 array s=(!sign(x(w))).as(s32);array t=shift(s,1);t(0)=0;
 v(i)=w-d;u(i)=s-t;ix[axv]=accum(v);z.v=y(ix[0],ix[1],ix[2],ix[3]);
 dim4 s1(1),s2(z.s);s1[axv]=zc;s2[axv]=1;u=array(accum(u),s1);
 z.v*=tile(u,(I)s2[0],(I)s2[1],(I)s2[2],(I)s2[3]);}
DF(red_f){A x=r;if(!r.r)cat_c(x,r,e);red_c(z,l,x,e,scl(scl(x.r-1)));}
MA(red_o){if(ax.r>1)err(4);if(cnt(ax)!=1)err(5);
 if(!isint(ax))err(11);I av;ax.v.as(s32).host(&av);
 if(av<0)err(11);if(av>=r.r)err(4);av=r.r-av-1;I rc=(I)r.s[av];
 A t(r.r-1,dim4(1),r.v(0));I ib=isbool(r);
 DO(av,t.s[i]=r.s[i])DO(t.r-av,t.s[av+i]=r.s[av+i+1])
 if(!cnt(t)){t.v=scl(0);z=t;R;}
 if(!rc){t.v=ll.id(t.s);z=t;R;}
 if(1==rc){t.v=array(r.v,t.s);z=t;R;}
 if("add"==ll.nm&&ib){t.v=count(r.v,av).as(s32);z=t;R;}
 if("add"==ll.nm){t.v=moddims(sum(r.v.as(f64),av),t.s);z=t;R;}
 if("mul"==ll.nm){t.v=moddims(product(r.v.as(f64),av),t.s);z=t;R;}
 if("min"==ll.nm){t.v=moddims(min(r.v,av),t.s);z=t;R;}
 if("max"==ll.nm){t.v=moddims(max(r.v,av),t.s);z=t;R;}
 if("and"==ll.nm&&ib){t.v=moddims(allTrue(r.v,av),t.s);z=t;R;}
 if("lor"==ll.nm&&ib){t.v=moddims(anyTrue(r.v,av),t.s);z=t;R;}
 if("neq"==ll.nm&&ib){t.v=moddims((1&sum(r.v,0)).as(b8),t.s);z=t;R;}
 map_o mfn_c(ll);af::index x[4];x[av]=rc-1;
 t.v=moddims(r.v(x[0],x[1],x[2],x[3]),t.s);
 DO(rc-1,x[av]=rc-i-2;
  mfn_c(t,A(t.r,t.s,moddims(r.v(x[0],x[1],x[2],x[3]),t.s)),t,e))
 z=t;}
MF(red_o){A x=r;if(!r.r)cat_c(x,r,e);
 red_o mfn(ll);mfn(z,x,e,scl(scl(x.r-1)));}
DA(red_o){if(ax.r>1)err(4);if(cnt(ax)!=1)err(5);
 if(!isint(ax))err(11);I av;ax.v.as(s32).host(&av);
 if(av<0)err(11);if(av>=r.r)err(4);av=r.r-av-1;
 if(l.r>1)err(4);if(cnt(l)!=1)err(5);
 if(!isint(l))err(11);I lv=l.v.as(s32).scalar<I>();I rc=(I)r.s[av]+1;
 if(rc<lv)err(5);rc=(I)(rc-abs(lv));map_o mfn_c(ll);
 A t(r.r,r.s,scl(0));t.s[av]=rc;if(!cnt(t)){z=t;R;}
 if(!lv){t.v=ll.id(t.s);z=t;R;}seq rng(rc);af::index x[4];
 if(lv>=0){x[av]=rng+((D)lv-1);t.v=r.v(x[0],x[1],x[2],x[3]);
  DO(lv-1,x[av]=rng+(D)(lv-i-2);
   mfn_c(t,A(t.r,t.s,r.v(x[0],x[1],x[2],x[3])),t,e))
 }else{x[av]=rng;t.v=r.v(x[0],x[1],x[2],x[3]);
  DO(abs(lv)-1,x[av]=rng+(D)(i+1);
   mfn_c(t,A(t.r,t.s,r.v(x[0],x[1],x[2],x[3])),t,e))}
 z=t;}
DF(red_o){if(!r.r)err(4);
 red_o mfn_c(ll);mfn_c(z,l,r,e,scl(scl(r.r-1)));}
