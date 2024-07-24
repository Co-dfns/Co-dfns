NM(conv,"conv",0,0,MT ,MT ,DFD,MT ,MT )
DEFN(conv)
DF(conv_f){
 arr signal=unrav(std::get<arr>(r.v),r.s);arr filter=unrav(std::get<arr>(l.v),l.s);
 dim4 stride(1,1,1,1);dim4 padding(0,0,0,0);dim4 dilation(1,1,1,1);
 arr zv=af::convolve2NN(signal, filter, stride, padding, dilation);
 dim4 s=zv.dims();I rk=zv.numdims();z.s=SHP(rk);DO(rk,z.s[i]=s[i]);
 z.v=flat(zv);
}
