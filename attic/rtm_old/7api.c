EXPORT A*mkarray(lp*d){A*z=new A;cpda(*z,d);R z;}
EXPORT V frea(A*a){delete a;}
EXPORT V exarray(lp*d,A*a){cpad(d,*a);}
EXPORT V afsync(){sync();}
EXPORT Window *w_new(char *k){R new Window(k);}
EXPORT I w_close(Window*w){R w->close();}
EXPORT V w_del(Window*w){delete w;}
EXPORT V w_img(lp*d,Window*w){A a;cpda(a,d);
 std::visit(visitor{
   [&](NIL&_){err(6);},
   [&](VEC<A>&v){err(16,L"Image requires a flat array.");},
   [&](carr&v){w->image(unrav(v,a.s).T().as(rnk(a)==2?f32:u8));}},
  a.v);}
EXPORT V w_plot(lp*d,Window*w){A a;cpda(a,d);
 std::visit(visitor{
   [&](NIL&_){err(6);},
   [&](VEC<A>&v){err(16,L"Plot requires a flat array.");},
   [&](carr&v){w->plot(unrav(v,a.s).T().as(f32));}},
  a.v);}
EXPORT V w_hist(lp*d,D l,D h,Window*w){A a;cpda(a,d);
 std::visit(visitor{
   [&](NIL&_){err(6);},
   [&](VEC<A>&v){err(16,L"Hist requires a flat array.");},
   [&](carr&v){w->hist(unrav(v,a.s).T().as(u32),l,h);}},
  a.v);}
EXPORT V loadimg(lp*z,char*p,I c){array a=loadImage(p,c);
 I rk=a.numdims();dim4 s=a.dims();
 A b(rk,flat(a).as(s16));DO(rk,b.s[i]=s[i])cpad(z,b);}
EXPORT V saveimg(lp*im,char*p){A a;cpda(a,im);
 std::visit(visitor{
   [&](NIL&_){err(6);},
   [&](VEC<A>&v){err(16,L"Save requires a flat array.");},
   [&](carr&v){saveImageNative(p,v.as(v.type()==s32?u16:u8));}},
  a.v);}
EXPORT V cd_sync(V){sync();}
