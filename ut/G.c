#include "codfns.h"
uint64_t S0[]={};
type_i D0[]={1};
struct codfns_array L0={0,1,apl_type_i,0,S0,D0,NULL};
struct codfns_array *LC0=&L0;
UDF(Init){
 return 0;}
UDF(g){
 codfns_addd(res,LC0,rgt,NULL);
 return 0;}

