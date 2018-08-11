NM(fnd,"fnd",0,0,MT ,MT ,DFD,MT ,MT )
DF(fnd_f){A t(r.r,r.s,array(r.s,b8));if(!cnt(t)){t.v=scl(0);z=t;R;}
 t.v=0;if(l.r>r.r){z=t;R;}DO(4,if(l.s[i]>r.s[i]){z=t;R;})
 if(!cnt(l)){t.v=1;z=t;R;}dim4 sp;DO(4,sp[i]=1+(t.s[i]-l.s[i]))
 seq x[4];DO(4,x[i]=seq((D)sp[i]))t.v(x[0],x[1],x[2],x[3])=1;
 DO((I)l.s[0],I m=i;
  DO((I)l.s[1],I k=i;
   DO((I)l.s[2],I j=i;
    DO((I)l.s[3],t.v(x[0],x[1],x[2],x[3])=t.v(x[0],x[1],x[2],x[3])
     &(tile(l.v(m,k,j,i),sp)
      ==r.v(x[0]+(D)m,x[1]+(D)k,x[2]+(D)j,x[3]+(D)i))))))
 z=t;}

