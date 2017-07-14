EXPORT A*mkarray(lp*d){A*z=new A;cpda(*z,d);R z;}
EXPORT V frea(A*a){delete a;}
EXPORT V exarray(lp*d,A*a){cpad(d,*a);}
EXPORT Window *w_new(char *k){R new Window(k);}
EXPORT I w_close(Window*w){R w->close();}
EXPORT V w_del(Window*w){delete w;}
EXPORT V w_img(lp*d,Window*w){A a;cpda(a,d);
 w->image(a.v.as(a.r==2?f32:u8));}
EXPORT V w_plot(lp*d,Window*w){A a;cpda(a,d);w->plot(a.v.as(f32));}
EXPORT V w_hist(lp*d,D l,D h,Window*w){A a;cpda(a,d);
 w->hist(a.v.as(u32),l,h);}
EXPORT V loadimg(lp*z,char*p,I c){array a=loadImage(p,c);
 A b(a.numdims(),a.dims(),a.as(s16));cpad(z,b);}
EXPORT V saveimg(lp*im,char*p){A a;cpda(a,im);
 saveImageNative(p,a.v.as(a.v.type()==s32?u16:u8));}

