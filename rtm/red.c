NM(red,"red",0,0,DID,MT ,DFD,MT ,DAD)
ID(red,1,s32)
red_f red_c;
OM(red,"red",0,0,MFD,DFD)
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
MF(red_o){A t(r.r?r.r-1:0,dim4(1),z.v);DO(t.r,t.s[i]=r.s[i+1])
 I rc=(I)r.s[0];I zc=(I)cnt(t);if(!zc){t.v=scl(0);z=t;R;}
 if(!rc){t.v=ll.id(t.s);z=t;R;}
 if(1==rc){t.v=array(r.v,t.s);z=t;R;}
 if("add"==ll.nm){if(r.v.isbool())t.v=count(r.v,0).as(s32);
  else t.v=moddims(sum(r.v.as(f64),0),t.s);z=t;R;}
 if("mul"==ll.nm){t.v=moddims(product(r.v.as(f64),0),t.s);z=t;R;}
 if("min"==ll.nm){t.v=moddims(min(r.v,0),t.s);z=t;R;}
 if("max"==ll.nm){t.v=moddims(max(r.v,0),t.s);z=t;R;}
 if("and"==ll.nm){t.v=moddims(allTrue(r.v,0),t.s);z=t;R;}
 if("lor"==ll.nm){t.v=moddims(anyTrue(r.v,0),t.s);z=t;R;}
 if(("neq"==ll.nm)&&r.v.isbool()){
  t.v=moddims((1&sum(r.v,0)).as(b8),t.s);z=t;R;}
 t.v=r.v(rc-1,span);map_o mfn_c(ll);
 DO(rc-1,mfn_c(t,A(t.r,t.s,r.v(rc-(i+2),span)),t,e))z=t;}
DF(red_o){if(l.r!=0&&(l.r!=1||l.s[0]!=1))err(5);if(!r.r)err(4);
 I lv=l.v.as(s32).scalar<I>();if((r.s[0]+1)<lv)err(5);
 I rc=(I)((1+r.s[0])-abs(lv));map_o mfn_c(ll);
 A t(r.r,r.s,scl(0));t.s[0]=rc;if(!cnt(t)){z=t;R;}
 if(!lv){t.v=ll.id(t.s);z=t;R;}seq rng(rc);
 if(lv>=0){t.v=r.v(rng+((D)lv-1),span);
  DO(lv-1,mfn_c(t,A(t.r,t.s,r.v(rng+((D)lv-(i+2)),span)),t,e))
 }else{t.v=r.v(rng,span);
  DO(abs(lv)-1,mfn_c(t,A(t.r,t.s,r.v(rng+(D)(i+1),span)),t,e))}
 z=t;}

