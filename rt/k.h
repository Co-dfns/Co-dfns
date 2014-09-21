#pragma once

/* Dyadic CPU Kernel */
#define sdi(nm, zt, lt, rt, code) void inline static \
nm##_##lt##rt(I*c,type_##zt*z,type_##lt*l,type_##rt*r,UI64 i,UI64 sl,UI64 sr)\
{code;}

/* Monadic CPU Kernel */
#define smi(nm, zt, rt, code) void inline static \
nm##_##rt(I*c,type_##zt*z,type_##rt*r,UI64 i){code;}

