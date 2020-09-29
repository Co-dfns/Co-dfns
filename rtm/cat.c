NM(cat,"cat",0,0,MT ,MFD,DFD,MT ,DAD)
cat_f cat_c;
MF(cat_f){z.r=1;z.s[0]=cnt(r);z.v=flat(r.v);}
DA(cat_f){A nl=l,nr=r;D axv=ax.as(f64).scalar<D>();I fx=(I)ceil(axv);
 if(axv!=fx){if(r.r>3||l.r>3)err(10);
  if(nl.r){nl.r++;DO(3-fx,nl.s[3-i]=nl.s[3-(i+1)]);nl.s[fx]=1;}
  if(nr.r){nr.r++;DO(3-fx,nr.s[3-i]=nr.s[3-(i+1)]);nr.s[fx]=1;}
  if(nl.r)nl.v=moddims(nl.v,nl.s);if(nr.r)nr.v=moddims(nr.v,nr.s);
  cat_c(z,nl,nr,e,scl(fx));R;}
 if(fx<0||(fx>r.r&&fx>l.r))err(4);
 if(fx>=r.r&&fx>=l.r)err(4);
 if(l.r&&r.r&&std::abs((I)l.r-(I)r.r)>1)err(4);
 z.r=(l.r>=r.r)*l.r+(r.r>l.r)*r.r+(!r.r&&!l.r);
 dim4 ls=l.s;dim4 rs=r.s;
 if(!l.r){ls=rs;ls[fx]=1;}if(!r.r){rs=ls;rs[fx]=1;}
 if(r.r&&l.r>r.r){DO(3-fx,rs[3-i]=rs[3-(i+1)]);rs[fx]=1;}
 if(l.r&&r.r>l.r){DO(3-fx,ls[3-i]=ls[3-(i+1)]);ls[fx]=1;}
 DO(4,if(i!=fx&&rs[i]!=ls[i])err(5));
 DO(4,z.s[i]=(l.r>=r.r||i==fx)*ls[i]+(r.r>l.r||i==fx)*rs[i]);
 dtype mt=mxt(r.v,l.v);
 array lv=(l.r?moddims(l.v,ls):tile(l.v,ls)).as(mt);
 array rv=(r.r?moddims(r.v,rs):tile(r.v,rs)).as(mt);
 if(!cnt(l)){z.v=rv;R;}if(!cnt(r)){z.v=lv;R;}
 z.v=join(fx,lv,rv);}
DF(cat_f){if(l.r||r.r){cat_c(z,l,r,e,scl(0));R;}
 A a,b;cat_c(a,l,e);cat_c(b,r,e);cat_c(z,a,b,e);}
