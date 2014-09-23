#include "codfns.h"
uint64_t S0[]={};
type_i D0[]={5};
struct codfns_array L0={0,1,1,apl_type_i,0,S0,D0,NULL};
struct codfns_array *LC0=&L0;
UDF(Init){
 return 0;}
UDF(f){
 array_cp(res,LC0);
 return 0;}

