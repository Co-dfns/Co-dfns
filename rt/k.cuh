#pragma once

/* Dyadic CPU Kernel */
#define sdi(nm, zt, lt, rt, code) void \
nm##_##lt##rt(I*c,type_##zt*z,type_##lt*l,type_##rt*r,UI64 i,UI64 sl,UI64 sr)\
{code;}

/* Monadic CPU Kernel */
#define smi(nm, zt, rt, code) __global__ void \
nm##_##rt(I*c,type_##zt*z,type_##rt*r,UI64 ig){UI64 i=threadIdx.x;code;}

