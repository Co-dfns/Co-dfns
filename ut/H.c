#include "codfns.h"
uint64_t S0[]={};
type_i D0[]={1};
struct codfns_array L0={0,1,apl_type_i,S0,D0};
struct codfns_array *LC0=&L0;
int Init(struct codfns_array *res,
 struct codfns_array *lft,struct codfns_array *rgt){
 return 0;}
int h(struct codfns_array *res,
 struct codfns_array *lft,struct codfns_array *rgt){
 codfns_addd(res,lft,rgt);
 codfns_addd(res,LC0,res);
 return 0;}
int hm(struct codfns_array *res,
 struct codfns_array *lft,struct codfns_array *rgt){
 return h(res,lft,rgt);}
int hd(struct codfns_array *res,
 struct codfns_array *lft,struct codfns_array *rgt){
 return h(res,lft,rgt);}
