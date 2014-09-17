#include "codfns.h"
uint64_t S0[]={};
type_i D0[]={1};
struct codfns_array L0={0,1,apl_type_i,S0,D0};
struct codfns_array *LC0=&L0;
int Init(struct codfns_array *res,
 struct codfns_array *lft,struct codfns_array *rgt){
 return 0;}
int g(struct codfns_array *res,
 struct codfns_array *lft,struct codfns_array *rgt){
 codfns_addd(res,LC0,rgt);
 return 0;}
int gm(struct codfns_array *res,
 struct codfns_array *lft,struct codfns_array *rgt){
 return g(res,lft,rgt);}
int gd(struct codfns_array *res,
 struct codfns_array *lft,struct codfns_array *rgt){
 return g(res,lft,rgt);}
