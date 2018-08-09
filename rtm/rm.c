MF(trn_f){z.r=r.r;DO(r.r,z.s[i]=r.s[r.r-(i+1)])
 switch(r.r){CS(0,z.v=r.v)CS(1,z.v=r.v)CS(2,z.v=r.v.T())
  CS(3,z.v=reorder(r.v,2,1,0))CS(4,z.v=reorder(r.v,3,2,1,0))}}
DF(trn_f){I lv[4];if(l.r>1||cnt(l)!=r.r)err(5);
 l.v.as(s32).host(lv);DO(r.r,if(lv[i]<0||lv[i]>=r.r)err(4))
 U8 f[]={0,0,0,0};DO(r.r,f[lv[i]]=1)
 U8 t=1;DO(r.r,if(t&&!f[i])t=0;else if(!t&&f[i])err(5))
 DO(r.r,if(!f[i])err(16))
 z.r=r.r;DO(r.r,z.s[r.r-(lv[i]+1)]=r.s[r.r-(i+1)])
 I s[4];DO(r.r,s[r.r-(lv[i]+1)]=r.r-(i+1))
 switch(r.r){CS(0,z.v=r.v)CS(1,z.v=r.v)
  CS(2,z.v=reorder(r.v,s[0],s[1]))
  CS(3,z.v=reorder(r.v,s[0],s[1],s[2]))
  CS(4,z.v=reorder(r.v,s[0],s[1],s[2],s[3]))}}
MF(unq_f){if(r.r>1)err(4);z.r=1;if(!cnt(r)){z.s=r.s;z.v=r.v;R;}
 array a,b;sort(a,b,r.v);z.v=a!=shift(a,1);z.v(0)=1;
 z.v=where(z.v);sort(b,z.v,b(z.v),a(z.v));
 z.s=dim4(z.v.elements());}
DF(unq_f){if(r.r>1||l.r>1)err(4);z.r=1;dtype mt=mxt(l.v,r.v);
 if(!cnt(l)){z.s=r.s;z.v=r.v;R;}if(!cnt(r)){z.s=l.s;z.v=l.v;R;}
 array x=setUnique(l.v);B c=x.elements();
 z.v=!anyTrue(tile(r.v,1,(U)c)==tile(array(x,1,c),(U)r.s[0],1),1);
 z.v=join(0,l.v.as(mt),r.v(where(z.v)).as(mt));
 z.s=dim4(z.v.elements());}
