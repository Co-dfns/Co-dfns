#include "codfns.h"
uint64_t S0[]={};
type_i D0[]={5};
struct codfns_array L0={0,1,apl_type_i,S0,D0};
struct codfns_array *LC0=&L0;
uint64_t S1[]={};
type_i D1[]={1};
struct codfns_array L1={0,1,apl_type_i,S1,D1};
struct codfns_array *LC1=&L1;
UDF(Init){
 return 0;}
UDF(f){
 array_cp(res,LC0);
 return 0;}
UDF(g){
 codfns_addd(res,LC1,rgt,NULL);
 return 0;}

