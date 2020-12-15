NM(cat,"cat",0,0,MT ,MFD,DFD,MAD,DAD)
cat_f cat_c;
MF(cat_f){z.f=1;z.s=SHP(1,cnt(r));z.v=flat(r.v);}
MA(cat_f){z.f=1;B ac=cnt(ax),ar=rnk(ax),rr=rnk(r);if(ac>1&&ar>1)err(4);
 VEC<D> axv(ac);ax.v.as(f64).host(axv.data());
 if(ac==1&&(axv[0]<=-1||rr<=axv[0]))err(4);
 if(ac>1){I c=(I)axv[0];if(c<0)err(11);DO((I)ac,if(axv[i]!=c++)err(11))
  if(c>rr)err(4);}
 I xt=(!ac||(ac==1&&!isint(axv[0])));if(rr==4&&xt)err(16);
 z=r;B zr=rr;if(!xt&&ac==1)R;DO((I)ac,axv[i]=ceil(rr-axv[i]-1))
 if(xt){zr++;SHP sp(zr);DOB(rr,sp[i]=r.s[i])B pt=ac?(B)axv[0]:0;
  DOB(rr-pt,sp[zr-i-1]=sp[zr-i-2])sp[pt]=1;z.s=sp;R;}
 B s=(B)axv[ac-1],ei=(B)axv[0],c=1;
 DOB(ac-1,z.s[s]*=z.s[s+i+1])DOB(zr-ei-1,z.s[s+i+1]=z.s[ei+i+1])}
DA(cat_f){z.f=1;B ar=rnk(ax),lr=rnk(l),rr=rnk(r);
 if(ar>1)err(4);if(cnt(ax)!=1)err(5);D ox=ax.v.as(f64).scalar<D>();
 B rk=lr>rr?lr:rr;if(ox<=-1)err(11);if(ox>=rk)err(4);
 if(lr&&rr&&std::abs((I)lr-rr)>1)err(4);
 A nl=l,nr=r;D axv=rk-ox-1;I fx=(I)ceil(axv);
 if(axv!=fx){if(rr>3||lr>3)err(16);if(rr&&lr&&lr!=rr)err(4);
  if(lr)cat_c(nl,l,e,ax);if(rr)cat_c(nr,r,e,ax);
  if(!lr&&!rr)cat_c(nl,l,e,ax);cat_c(nr,r,e,ax);
  cat_c(z,nl,nr,e,scl(scl((I)ceil(ox))));R;}
 z.s=SHP((lr>=rr)*lr+(rr>lr)*rr+(!rr&&!lr));
 dim4 ls(1),rs(1);DO((I)lr,ls[i]=l.s[i])DO((I)rr,rs[i]=r.s[i])
 if(!lr){ls=rs;ls[fx]=1;}if(!rr){rs=ls;rs[fx]=1;}
 if(rr&&lr>rr){DO(3-fx,rs[3-i]=rs[3-i-1]);rs[fx]=1;}
 if(lr&&rr>lr){DO(3-fx,ls[3-i]=ls[3-i-1]);ls[fx]=1;}
 DO(4,if(i!=fx&&rs[i]!=ls[i])err(5));
 DO((I)rnk(z),z.s[i]=(lr>=rr||i==fx)*ls[i]+(rr>lr||i==fx)*rs[i]);
 dtype mt=mxt(r.v,l.v);
 array lv=(lr?moddims(l.v,ls):tile(l.v,ls)).as(mt);
 array rv=(rr?moddims(r.v,rs):tile(r.v,rs)).as(mt);
 if(!cnt(l)){z.v=flat(rv);R;}if(!cnt(r)){z.v=flat(lv);R;}
 z.v=flat(join(fx,lv,rv));}
DF(cat_f){z.f=1;B lr=rnk(l),rr=rnk(r);
 if(lr||rr){cat_c(z,l,r,e,scl(scl((lr>rr?lr:rr)-1)));R;}
 A a,b;cat_c(a,l,e);cat_c(b,r,e);cat_c(z,a,b,e);}
