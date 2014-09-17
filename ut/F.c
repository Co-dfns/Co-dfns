#include "codfns.h"
uint64_t S0[]={};
type_i D0[]={5};
struct codfns_array L0={0,1,apl_type_i,S0,D0};
struct codfns_array *LC0=&L0;
int Init(struct codfns_array *res,
 struct codfns_array *lft,struct codfns_array *rgt){
 return 0;}
int f(struct codfns_array *res,
 struct codfns_array *lft,struct codfns_array *rgt){
 array_cp(res,LC0);
 return 0;}
int fm(struct codfns_array *res,
 struct codfns_array *lft,struct codfns_array *rgt){
 return f(res,lft,rgt);}
int fd(struct codfns_array *res,
 struct codfns_array *lft,struct codfns_array *rgt){
 return f(res,lft,rgt);}
