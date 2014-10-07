#include "h.cuh"

__device__ type_d coe[]={0.31938153,-0.356563782,1.781477937,-1.821255978,1.33027442};

__global__ V redk(D*zp,D*wp,UI64 sz){UI64 i=blockDim.x*blockIdx.x+threadIdx.x;
 if(i<sz){D w=wp[i];D z=coe[0]*w*1;z+=coe[1]*w*2;z+=coe[2]*w*3;
  z+=coe[3]*w*4;z+=coe[4]*w*5;zp[i]=z;}}

extern "C" {
UDF(codfns_coeffred){h2g(rgt);D*ze;prep((V**)&ze,res,rgt);
 UI64 bs=(siz(res)+1024-1)/1024;ze=(D*)gpu(res);D*re=(D*)gpu(rgt);
 redk<<<bs,1024>>>(ze,re,siz(res));typ(res)=apl_type_d;ong(res)=1;R 0;}
}
