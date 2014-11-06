#pragma once

/* Dyadic CPU Kernel */
#define sdi(nm, zt, lt, rt, code) __global__ void \
nm##_##g##lt##rt(I*c,type_##zt*z,type_##lt*l,type_##rt*r,UI64 sz,UI64 sl,UI64 sr)\
{UI64 i=blockDim.x*blockIdx.x+threadIdx.x;if(i<sz){code;}}\
__global__ void \
nm##_##g##lt##s##rt(I*c,type_##zt*z,type_##lt*lo,type_##rt*r,UI64 sz,UI64 sr)\
{type_##lt lv=*lo;__threadfence();UI64 i=blockDim.x*blockIdx.x+threadIdx.x;\
 type_##lt*l=&lv;UI64 sl=1;if(i<sz){code;}}\
__global__ void \
nm##_##g##lt##rt##s(I*c,type_##zt*z,type_##lt*l,type_##rt*ro,UI64 sz,UI64 sl)\
{type_##rt rv=*ro;__threadfence();UI64 i=blockDim.x*blockIdx.x+threadIdx.x;\
 type_##rt*r=&rv;UI64 sr=1;if(i<sz){code;}}\
void static inline \
nm##_##lt##rt(I*c,type_##zt*z,type_##lt*l,type_##rt*r,UI64 i,UI64 sl,UI64 sr)\
{code;}\
void static inline \
nm##_##lt##s##rt(I*c,type_##zt*z,type_##lt lv,type_##rt*r,UI64 i,UI64 sr)\
{type_##lt*l=&lv;UI64 sl=1;code;}\
void static inline \
nm##_##lt##rt##s(I*c,type_##zt*z,type_##lt*l,type_##rt rv,UI64 i,UI64 sl)\
{type_##rt*r=&rv;UI64 sr=1;code;}

/* Monadic CPU Kernel */
#define smi(nm, zt, rt, code) __global__ void \
nm##_##g##rt(I*c,type_##zt*z,type_##rt*r,UI64 sz)\
{UI64 i=blockDim.x*blockIdx.x+threadIdx.x;if(i<sz){code;}} \
void static inline \
nm##_##rt(I*c,type_##zt*z,type_##rt*r,UI64 i)\
{code;}

