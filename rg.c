MF(gdd_f){if(r.r<1)err(4);z.r=1;z.s=dim4(r.s[r.r-1]);
 if(!cnt(r)){z.v=r.v;R;}I c=1;DO(r.r-1,c*=(I)r.s[i]);
 array mt,a=array(r.v,c,r.s[r.r-1]);z.v=iota(z.s,dim4(1),s32);
 DO(c,sort(mt,z.v,flat(a(c-(i+1),z.v)),z.v,0,false))}
DF(gdd_f){err(16);}
MF(gdu_f){if(r.r<1)err(4);z.r=1;z.s=dim4(r.s[r.r-1]);
 if(!cnt(r)){z.v=r.v;R;}I c=1;DO(r.r-1,c*=(I)r.s[i]);
 array mt,a=array(r.v,c,r.s[r.r-1]);z.v=iota(z.s,dim4(1),s32);
 DO(c,sort(mt,z.v,flat(a(c-(i+1),z.v)),z.v,0,true))}
DF(gdu_f){err(16);}
SF(gte_f,z.v=lv>=rv)
SF(gth_f,z.v=lv>rv)
DF(int_f){if(r.r>1||l.r>1)err(4);
 if(!cnt(r)||!cnt(l)){z.v=scl(0);z.s=dim4(0);z.r=1;R;}
 dtype mt=mxt(l.v,r.v);z.v=setIntersect(l.v.as(mt),r.v.as(mt));
 z.r=1;z.s=dim4(z.v.elements());}
MF(iot_f){if(r.r>1)err(4);B c=cnt(r);if(c>4)err(10);
 if(c>1)err(16);
 z.r=1;z.s=dim4(r.v.as(s32).scalar<I>());
 z.v=z.s[0]?iota(z.s,dim4(1),s32):scl(0);}
DF(iot_f){z.r=r.r;z.s=r.s;B c=cnt(r);if(!c){z.v=scl(0);R;}
 B lc=cnt(l)+1;if(lc==1){z.v=scl(0);R;};if(l.r>1)err(16);
 array rf=flat(r.v).T();dtype mt=mxt(l.v,rf);
 z.v=join(0,tile(l.v,1,(U)c).as(mt),rf.as(mt))==tile(rf,(U)lc,1);
 z.v=min((z.v*iota(dim4(lc),dim4(1,c),s32)+((!z.v)*lc).as(s32)),0);
 z.v=array(z.v,z.s);}
MF(lft_f){z=r;}
DF(lft_f){z=l;}
MF(log_f){z.r=r.r;z.s=r.s;z.v=log(r.v.as(f64));}
SF(log_f,z.v=log(rv.as(f64))/log(lv.as(f64)))
SF(lor_f,if(rv.isbool()&&lv.isbool())z.v=lv||rv;
 else if(allTrue<I>(lv>=0&&lv<=1&&rv<=1&&rv>=0))z.v=lv||rv;
 else err(16);)
SF(lte_f,z.v=lv<=rv)
SF(lth_f,z.v=lv<rv)
MF(max_f){z.r=r.r;z.s=r.s;z.v=ceil(r.v).as(r.v.type());}
SF(max_f,z.v=max(lv,rv))
MF(mem_f){z.r=1;z.s=dim4(cnt(r));z.v=flat(r.v);}
DF(mem_f){z.r=l.r;z.s=l.s;I lc=(I)cnt(z);if(!lc){z.v=scl(0);R;}
 if(!cnt(r)){z.v=array(z.s,b8);z.v=0;R;}
 array y=setUnique(flat(r.v));I rc=(I)y.elements();
 array x=array(flat(l.v),lc,1);y=array(y,1,rc);
 z.v=array(anyTrue(tile(x,1,rc)==tile(y,lc,1),1),z.s);}
MF(min_f){z.r=r.r;z.s=r.s;z.v=floor(r.v).as(r.v.type());}
SF(min_f,z.v=min(lv,rv))
MF(mul_f){z.r=r.r;z.s=r.s;z.v=(r.v>0)-(r.v<0);}
SF(mul_f,z.v=lv*rv)
