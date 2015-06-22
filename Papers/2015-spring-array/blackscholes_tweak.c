#include <math.h>
#include <dwa.h>
#include <dwa_fns.h>
#include <stdio.h>
int isinit=0;
#define PI 3.14159265358979323846
LOCALP *tenv = NULL;
LOCALP *env[]={NULL};
void static inline Init(LOCALP*z,LOCALP*l,LOCALP*r,LOCALP*penv[]);
void static inline fn_1_4ii(LOCALP*z,LOCALP*l,LOCALP*r,LOCALP*penv[]);
void static inline fn_1_4if(LOCALP*z,LOCALP*l,LOCALP*r,LOCALP*penv[]);
void static inline fn_1_4in(LOCALP*z,LOCALP*l,LOCALP*r,LOCALP*penv[]);
void static inline fn_1_4fi(LOCALP*z,LOCALP*l,LOCALP*r,LOCALP*penv[]);
void static inline fn_1_4ff(LOCALP*z,LOCALP*l,LOCALP*r,LOCALP*penv[]);
void static inline fn_1_4fn(LOCALP*z,LOCALP*l,LOCALP*r,LOCALP*penv[]);
void static inline fn_1_4_10_8_8_6_7ii(LOCALP*z,LOCALP*l,LOCALP*r,LOCALP*penv[]);
void static inline fn_1_4_10_8_8_6_7if(LOCALP*z,LOCALP*l,LOCALP*r,LOCALP*penv[]);
void static inline fn_1_4_10_8_8_6_7in(LOCALP*z,LOCALP*l,LOCALP*r,LOCALP*penv[]);
void static inline fn_1_4_10_8_8_6_7fi(LOCALP*z,LOCALP*l,LOCALP*r,LOCALP*penv[]);
void static inline fn_1_4_10_8_8_6_7ff(LOCALP*z,LOCALP*l,LOCALP*r,LOCALP*penv[]);
void static inline fn_1_4_10_8_8_6_7fn(LOCALP*z,LOCALP*l,LOCALP*r,LOCALP*penv[]);
void static inline fn_1_5ii(LOCALP*z,LOCALP*l,LOCALP*r,LOCALP*penv[]);
void static inline fn_1_5if(LOCALP*z,LOCALP*l,LOCALP*r,LOCALP*penv[]);
void static inline fn_1_5in(LOCALP*z,LOCALP*l,LOCALP*r,LOCALP*penv[]);
void static inline fn_1_5fi(LOCALP*z,LOCALP*l,LOCALP*r,LOCALP*penv[]);
void static inline fn_1_5ff(LOCALP*z,LOCALP*l,LOCALP*r,LOCALP*penv[]);
void static inline fn_1_5fn(LOCALP*z,LOCALP*l,LOCALP*r,LOCALP*penv[]);
void EXPORT CNDP2(LOCALP*z,LOCALP*l,LOCALP*r){
if(!isinit){Init(NULL,NULL,NULL,NULL);isinit=1;}
int tp=0;tp+=3*(r->p->ELTYPE==APLLONG?0:1);
tp+=(l==NULL)?2:(l->p->ELTYPE==APLLONG?0:1);
switch(tp){
case 0:fn_1_4ii(z,l,r,env);break;
case 1:fn_1_4if(z,l,r,env);break;
case 2:fn_1_4in(z,l,r,env);break;
case 3:fn_1_4fi(z,l,r,env);break;
case 4:fn_1_4ff(z,l,r,env);break;
case 5:fn_1_4fn(z,l,r,env);break;
}}

void EXPORT Run(LOCALP*z,LOCALP*l,LOCALP*r){
if(!isinit){Init(NULL,NULL,NULL,NULL);isinit=1;}
int tp=0;tp+=3*(r->p->ELTYPE==APLLONG?0:1);
tp+=(l==NULL)?2:(l->p->ELTYPE==APLLONG?0:1);
switch(tp){
case 0:fn_1_5ii(z,l,r,env);break;
case 1:fn_1_5if(z,l,r,env);break;
case 2:fn_1_5in(z,l,r,env);break;
case 3:fn_1_5fi(z,l,r,env);break;
case 4:fn_1_5ff(z,l,r,env);break;
case 5:fn_1_5fn(z,l,r,env);break;
}}

void static inline Init(LOCALP*z,LOCALP*l,LOCALP*r,LOCALP*penv[]){
LOCALP *env[]={tenv};
{BOUND i;for(i=0;i<0;i++){regp(&tenv[i]);}}
}

void static inline fn_1_4ii(LOCALP*z,LOCALP*l,LOCALP*r,LOCALP*penv[]){
LOCALP env0[3];LOCALP*env[]={env0,penv[0]};
{BOUND i;for(i=0;i<3;i++){regp(&env0[i]);}}
{BOUND prk=0;BOUND sp[15];BOUND cnt=1,i=0;
if(prk!=(r)->p->RANK){if(prk==0){
prk=(r)->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(r)->p->SHAPETC[i];}}
}else if((r)->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(r)->p->SHAPETC[i])error(4);}}
}
{BOUND i;for(i=0;i<prk;i++){cnt*=sp[i];}}
aplint32 *d0=ARRAYSTART((r)->p);
BOUND m0=(r)->p->RANK==0?0:1;
BOUND mz0=(r)->p->RANK==0?1:cnt;
POCKET*p0,*p1,*p2;
if(NULL==(&env[0][0])->p||prk!=(&env[0][0])->p->RANK
||(&env[0][0])->p->ELTYPE!=APLLONG)
p0=getarray(APLLONG,prk,sp,NULL);
else p0=(&env[0][0])->p;
if(NULL==(&env[0][1])->p||prk!=(&env[0][1])->p->RANK
||(&env[0][1])->p->ELTYPE!=APLLONG)
p1=getarray(APLLONG,prk,sp,NULL);
else p1=(&env[0][1])->p;
if(NULL==(&env[0][2])->p||prk!=(&env[0][2])->p->RANK
||(&env[0][2])->p->ELTYPE!=APLDOUB)
p2=getarray(APLDOUB,prk,sp,NULL);
else p2=(&env[0][2])->p;
aplint32 *r0=ARRAYSTART(p0);
aplint32 *r1=ARRAYSTART(p1);
double *r2=ARRAYSTART(p2);
#pragma acc parallel loop copyin(d0[0:mz0]) copyout(r0[0:cnt],r1[0:cnt],r2[0:cnt])
for(i=0;i<cnt;i++){
aplint32 f0=d0[i*m0];
aplint32 s0=fabs(f0);
aplint32 s1=f0>=0;
double s2=0.2316419*s0;
double s3=1+s2;
double s4=1.0/s3;
r0[i]=s0;
r1[i]=s1;
r2[i]=s4;
}
if((&env[0][0])->p!=p0){relp(&env[0][0]);(&env[0][0])->p=p0;}
if((&env[0][1])->p!=p1){relp(&env[0][1]);(&env[0][1])->p=p1;}
if((&env[0][2])->p!=p2){relp(&env[0][2]);(&env[0][2])->p=p2;}
}
{LOCALP *rslt=&env[0][2];LOCALP *rgt=&env[0][2];BOUND sp[15];{BOUND i;for(i=0;i<rgt->p->RANK;i++){sp[i]=rgt->p->SHAPETC[i];}}
if(rslt!=rgt){relp(rslt);getarray(APLDOUB,rgt->p->RANK,sp,rslt);}
LOCALP sz,sr;regp(&sz);regp(&sr);
getarray(APLDOUB,0,NULL,&sz);getarray(APLDOUB,0,NULL,&sr);
double *z;double *r;
BOUND c=1;{BOUND i;for(i=0;i<rgt->p->RANK;i++){c*=rgt->p->SHAPETC[i];}}
{BOUND i;for(i=0;i<c;i++){z=ARRAYSTART(sr.p);r=ARRAYSTART(rgt->p);z[0]=r[i];
fn_1_4_10_8_8_6_7fn(&sz,NULL,&sr,env);
z=ARRAYSTART(rslt->p);r=ARRAYSTART(sz.p);
z[i]=r[0];}}
cutp(&sz);
}
{BOUND prk=0;BOUND sp[15];BOUND cnt=1,i=0;
if(prk!=(&env[0][0])->p->RANK){if(prk==0){
prk=(&env[0][0])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][0])->p->SHAPETC[i];}}
}else if((&env[0][0])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][0])->p->SHAPETC[i])error(4);}}
}
if(prk!=(&env[0][2])->p->RANK){if(prk==0){
prk=(&env[0][2])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][2])->p->SHAPETC[i];}}
}else if((&env[0][2])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][2])->p->SHAPETC[i])error(4);}}
}
{BOUND i;for(i=0;i<prk;i++){cnt*=sp[i];}}
aplint32 *d0=ARRAYSTART((&env[0][0])->p);
BOUND m0=(&env[0][0])->p->RANK==0?0:1;
BOUND mz0=(&env[0][0])->p->RANK==0?1:cnt;
double *d1=ARRAYSTART((&env[0][2])->p);
BOUND m1=(&env[0][2])->p->RANK==0?0:1;
BOUND mz1=(&env[0][2])->p->RANK==0?1:cnt;
POCKET*p0;
if(NULL==(&env[0][0])->p||prk!=(&env[0][0])->p->RANK
||(&env[0][0])->p->ELTYPE!=APLDOUB)
p0=getarray(APLDOUB,prk,sp,NULL);
else p0=(&env[0][0])->p;
double *r0=ARRAYSTART(p0);
#pragma acc parallel loop copyin(d0[0:mz0],d1[0:mz1]) copyout(r0[0:cnt])
for(i=0;i<cnt;i++){
aplint32 f0=d0[i*m0];
double f1=d1[i*m1];
aplint32 s0=f0*f0;
double s1=((double)s0)/((double)-2);
double s2=exp((double)s1);
double s3=s2*f1;
double s4=0.3989422804*s3;
r0[i]=s4;
}
if((&env[0][0])->p!=p0){relp(&env[0][0]);(&env[0][0])->p=p0;}
}
{LOCALP *rslt=&env[0][2];LOCALP *rgt=&env[0][1];aplint32 l[]={0,-1};
BOUND sp[15];{BOUND i;for(i=0;i<rgt->p->RANK;i++){sp[i]=rgt->p->SHAPETC[i];}}
LOCALP*orz;LOCALP tp;tp.p=NULL;int tpused=0;
if(rslt==rgt){orz=rslt;rslt=&tp;tpused=1;}
relp(rslt);getarray(APLLONG,rgt->p->RANK,sp,rslt);
aplint32 *z;aplint32*r;z=ARRAYSTART(rslt->p);r=ARRAYSTART(rgt->p);
BOUND c=1;{BOUND i;for(i=0;i<rgt->p->RANK;i++){c*=rgt->p->SHAPETC[i];}}
{BOUND i;
#pragma simd
for(i=0;i<c;i++){z[i]=l[r[i]];}}
if(tpused){relp(orz);orz->p=zap(rslt->p);}
}
{BOUND prk=0;BOUND sp[15];BOUND cnt=1,i=0;
if(prk!=(&env[0][2])->p->RANK){if(prk==0){
prk=(&env[0][2])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][2])->p->SHAPETC[i];}}
}else if((&env[0][2])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][2])->p->SHAPETC[i])error(4);}}
}
if(prk!=(&env[0][0])->p->RANK){if(prk==0){
prk=(&env[0][0])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][0])->p->SHAPETC[i];}}
}else if((&env[0][0])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][0])->p->SHAPETC[i])error(4);}}
}
{BOUND i;for(i=0;i<prk;i++){cnt*=sp[i];}}
aplint32 *d0=ARRAYSTART((&env[0][2])->p);
BOUND m0=(&env[0][2])->p->RANK==0?0:1;
BOUND mz0=(&env[0][2])->p->RANK==0?1:cnt;
double *d1=ARRAYSTART((&env[0][0])->p);
BOUND m1=(&env[0][0])->p->RANK==0?0:1;
BOUND mz1=(&env[0][0])->p->RANK==0?1:cnt;
POCKET*p0;
if(NULL==(&env[0][0])->p||prk!=(&env[0][0])->p->RANK
||(&env[0][0])->p->ELTYPE!=APLDOUB)
p0=getarray(APLDOUB,prk,sp,NULL);
else p0=(&env[0][0])->p;
double *r0=ARRAYSTART(p0);
#pragma acc parallel loop copyin(d0[0:mz0],d1[0:mz1]) copyout(r0[0:cnt])
for(i=0;i<cnt;i++){
aplint32 f0=d0[i*m0];
double f1=d1[i*m1];
double s0=f0+f1;
r0[i]=s0;
}
if((&env[0][0])->p!=p0){relp(&env[0][0]);(&env[0][0])->p=p0;}
}
{LOCALP *rslt=&env[0][1];LOCALP *rgt=&env[0][1];aplint32 l[]={1,-1};
BOUND sp[15];{BOUND i;for(i=0;i<rgt->p->RANK;i++){sp[i]=rgt->p->SHAPETC[i];}}
LOCALP*orz;LOCALP tp;tp.p=NULL;int tpused=0;
if(rslt==rgt){orz=rslt;rslt=&tp;tpused=1;}
relp(rslt);getarray(APLLONG,rgt->p->RANK,sp,rslt);
aplint32 *z;aplint32*r;z=ARRAYSTART(rslt->p);r=ARRAYSTART(rgt->p);
BOUND c=1;{BOUND i;for(i=0;i<rgt->p->RANK;i++){c*=rgt->p->SHAPETC[i];}}
{BOUND i;
#pragma simd
for(i=0;i<c;i++){z[i]=l[r[i]];}}
if(tpused){relp(orz);orz->p=zap(rslt->p);}
}
{BOUND prk=0;BOUND sp[15];BOUND cnt=1,i=0;
if(prk!=(&env[0][1])->p->RANK){if(prk==0){
prk=(&env[0][1])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][1])->p->SHAPETC[i];}}
}else if((&env[0][1])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][1])->p->SHAPETC[i])error(4);}}
}
if(prk!=(&env[0][0])->p->RANK){if(prk==0){
prk=(&env[0][0])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][0])->p->SHAPETC[i];}}
}else if((&env[0][0])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][0])->p->SHAPETC[i])error(4);}}
}
{BOUND i;for(i=0;i<prk;i++){cnt*=sp[i];}}
aplint32 *d0=ARRAYSTART((&env[0][1])->p);
BOUND m0=(&env[0][1])->p->RANK==0?0:1;
BOUND mz0=(&env[0][1])->p->RANK==0?1:cnt;
double *d1=ARRAYSTART((&env[0][0])->p);
BOUND m1=(&env[0][0])->p->RANK==0?0:1;
BOUND mz1=(&env[0][0])->p->RANK==0?1:cnt;
POCKET*p0;
if(NULL==(&env[0][0])->p||prk!=(&env[0][0])->p->RANK
||(&env[0][0])->p->ELTYPE!=APLDOUB)
p0=getarray(APLDOUB,prk,sp,NULL);
else p0=(&env[0][0])->p;
double *r0=ARRAYSTART(p0);
#pragma acc parallel loop copyin(d0[0:mz0],d1[0:mz1]) copyout(r0[0:cnt])
for(i=0;i<cnt;i++){
aplint32 f0=d0[i*m0];
double f1=d1[i*m1];
double s0=f0*f1;
r0[i]=s0;
}
if((&env[0][0])->p!=p0){relp(&env[0][0]);(&env[0][0])->p=p0;}
}
z->p=zap((&env[0][0])->p);cutp(&env0[0]);
}

void static inline fn_1_4if(LOCALP*z,LOCALP*l,LOCALP*r,LOCALP*penv[]){
LOCALP env0[3];LOCALP*env[]={env0,penv[0]};
{BOUND i;for(i=0;i<3;i++){regp(&env0[i]);}}
{BOUND prk=0;BOUND sp[15];BOUND cnt=1,i=0;
if(prk!=(r)->p->RANK){if(prk==0){
prk=(r)->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(r)->p->SHAPETC[i];}}
}else if((r)->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(r)->p->SHAPETC[i])error(4);}}
}
{BOUND i;for(i=0;i<prk;i++){cnt*=sp[i];}}
aplint32 *d0=ARRAYSTART((r)->p);
BOUND m0=(r)->p->RANK==0?0:1;
BOUND mz0=(r)->p->RANK==0?1:cnt;
POCKET*p0,*p1,*p2;
if(NULL==(&env[0][0])->p||prk!=(&env[0][0])->p->RANK
||(&env[0][0])->p->ELTYPE!=APLLONG)
p0=getarray(APLLONG,prk,sp,NULL);
else p0=(&env[0][0])->p;
if(NULL==(&env[0][1])->p||prk!=(&env[0][1])->p->RANK
||(&env[0][1])->p->ELTYPE!=APLLONG)
p1=getarray(APLLONG,prk,sp,NULL);
else p1=(&env[0][1])->p;
if(NULL==(&env[0][2])->p||prk!=(&env[0][2])->p->RANK
||(&env[0][2])->p->ELTYPE!=APLDOUB)
p2=getarray(APLDOUB,prk,sp,NULL);
else p2=(&env[0][2])->p;
aplint32 *r0=ARRAYSTART(p0);
aplint32 *r1=ARRAYSTART(p1);
double *r2=ARRAYSTART(p2);
#pragma acc parallel loop copyin(d0[0:mz0]) copyout(r0[0:cnt],r1[0:cnt],r2[0:cnt])
for(i=0;i<cnt;i++){
aplint32 f0=d0[i*m0];
aplint32 s0=fabs(f0);
aplint32 s1=f0>=0;
double s2=0.2316419*s0;
double s3=1+s2;
double s4=1.0/s3;
r0[i]=s0;
r1[i]=s1;
r2[i]=s4;
}
if((&env[0][0])->p!=p0){relp(&env[0][0]);(&env[0][0])->p=p0;}
if((&env[0][1])->p!=p1){relp(&env[0][1]);(&env[0][1])->p=p1;}
if((&env[0][2])->p!=p2){relp(&env[0][2]);(&env[0][2])->p=p2;}
}
{LOCALP *rslt=&env[0][2];LOCALP *rgt=&env[0][2];BOUND sp[15];{BOUND i;for(i=0;i<rgt->p->RANK;i++){sp[i]=rgt->p->SHAPETC[i];}}
if(rslt!=rgt){relp(rslt);getarray(APLDOUB,rgt->p->RANK,sp,rslt);}
LOCALP sz,sr;regp(&sz);regp(&sr);
getarray(APLDOUB,0,NULL,&sz);getarray(APLDOUB,0,NULL,&sr);
double *z;double *r;
BOUND c=1;{BOUND i;for(i=0;i<rgt->p->RANK;i++){c*=rgt->p->SHAPETC[i];}}
{BOUND i;for(i=0;i<c;i++){z=ARRAYSTART(sr.p);r=ARRAYSTART(rgt->p);z[0]=r[i];
fn_1_4_10_8_8_6_7fn(&sz,NULL,&sr,env);
z=ARRAYSTART(rslt->p);r=ARRAYSTART(sz.p);
z[i]=r[0];}}
cutp(&sz);
}
{BOUND prk=0;BOUND sp[15];BOUND cnt=1,i=0;
if(prk!=(&env[0][0])->p->RANK){if(prk==0){
prk=(&env[0][0])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][0])->p->SHAPETC[i];}}
}else if((&env[0][0])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][0])->p->SHAPETC[i])error(4);}}
}
if(prk!=(&env[0][2])->p->RANK){if(prk==0){
prk=(&env[0][2])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][2])->p->SHAPETC[i];}}
}else if((&env[0][2])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][2])->p->SHAPETC[i])error(4);}}
}
{BOUND i;for(i=0;i<prk;i++){cnt*=sp[i];}}
aplint32 *d0=ARRAYSTART((&env[0][0])->p);
BOUND m0=(&env[0][0])->p->RANK==0?0:1;
BOUND mz0=(&env[0][0])->p->RANK==0?1:cnt;
double *d1=ARRAYSTART((&env[0][2])->p);
BOUND m1=(&env[0][2])->p->RANK==0?0:1;
BOUND mz1=(&env[0][2])->p->RANK==0?1:cnt;
POCKET*p0;
if(NULL==(&env[0][0])->p||prk!=(&env[0][0])->p->RANK
||(&env[0][0])->p->ELTYPE!=APLDOUB)
p0=getarray(APLDOUB,prk,sp,NULL);
else p0=(&env[0][0])->p;
double *r0=ARRAYSTART(p0);
#pragma acc parallel loop copyin(d0[0:mz0],d1[0:mz1]) copyout(r0[0:cnt])
for(i=0;i<cnt;i++){
aplint32 f0=d0[i*m0];
double f1=d1[i*m1];
aplint32 s0=f0*f0;
double s1=((double)s0)/((double)-2);
double s2=exp((double)s1);
double s3=s2*f1;
double s4=0.3989422804*s3;
r0[i]=s4;
}
if((&env[0][0])->p!=p0){relp(&env[0][0]);(&env[0][0])->p=p0;}
}
{LOCALP *rslt=&env[0][2];LOCALP *rgt=&env[0][1];aplint32 l[]={0,-1};
BOUND sp[15];{BOUND i;for(i=0;i<rgt->p->RANK;i++){sp[i]=rgt->p->SHAPETC[i];}}
LOCALP*orz;LOCALP tp;tp.p=NULL;int tpused=0;
if(rslt==rgt){orz=rslt;rslt=&tp;tpused=1;}
relp(rslt);getarray(APLLONG,rgt->p->RANK,sp,rslt);
aplint32 *z;aplint32*r;z=ARRAYSTART(rslt->p);r=ARRAYSTART(rgt->p);
BOUND c=1;{BOUND i;for(i=0;i<rgt->p->RANK;i++){c*=rgt->p->SHAPETC[i];}}
{BOUND i;
#pragma simd
for(i=0;i<c;i++){z[i]=l[r[i]];}}
if(tpused){relp(orz);orz->p=zap(rslt->p);}
}
{BOUND prk=0;BOUND sp[15];BOUND cnt=1,i=0;
if(prk!=(&env[0][2])->p->RANK){if(prk==0){
prk=(&env[0][2])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][2])->p->SHAPETC[i];}}
}else if((&env[0][2])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][2])->p->SHAPETC[i])error(4);}}
}
if(prk!=(&env[0][0])->p->RANK){if(prk==0){
prk=(&env[0][0])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][0])->p->SHAPETC[i];}}
}else if((&env[0][0])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][0])->p->SHAPETC[i])error(4);}}
}
{BOUND i;for(i=0;i<prk;i++){cnt*=sp[i];}}
aplint32 *d0=ARRAYSTART((&env[0][2])->p);
BOUND m0=(&env[0][2])->p->RANK==0?0:1;
BOUND mz0=(&env[0][2])->p->RANK==0?1:cnt;
double *d1=ARRAYSTART((&env[0][0])->p);
BOUND m1=(&env[0][0])->p->RANK==0?0:1;
BOUND mz1=(&env[0][0])->p->RANK==0?1:cnt;
POCKET*p0;
if(NULL==(&env[0][0])->p||prk!=(&env[0][0])->p->RANK
||(&env[0][0])->p->ELTYPE!=APLDOUB)
p0=getarray(APLDOUB,prk,sp,NULL);
else p0=(&env[0][0])->p;
double *r0=ARRAYSTART(p0);
#pragma acc parallel loop copyin(d0[0:mz0],d1[0:mz1]) copyout(r0[0:cnt])
for(i=0;i<cnt;i++){
aplint32 f0=d0[i*m0];
double f1=d1[i*m1];
double s0=f0+f1;
r0[i]=s0;
}
if((&env[0][0])->p!=p0){relp(&env[0][0]);(&env[0][0])->p=p0;}
}
{LOCALP *rslt=&env[0][1];LOCALP *rgt=&env[0][1];aplint32 l[]={1,-1};
BOUND sp[15];{BOUND i;for(i=0;i<rgt->p->RANK;i++){sp[i]=rgt->p->SHAPETC[i];}}
LOCALP*orz;LOCALP tp;tp.p=NULL;int tpused=0;
if(rslt==rgt){orz=rslt;rslt=&tp;tpused=1;}
relp(rslt);getarray(APLLONG,rgt->p->RANK,sp,rslt);
aplint32 *z;aplint32*r;z=ARRAYSTART(rslt->p);r=ARRAYSTART(rgt->p);
BOUND c=1;{BOUND i;for(i=0;i<rgt->p->RANK;i++){c*=rgt->p->SHAPETC[i];}}
{BOUND i;
#pragma simd
for(i=0;i<c;i++){z[i]=l[r[i]];}}
if(tpused){relp(orz);orz->p=zap(rslt->p);}
}
{BOUND prk=0;BOUND sp[15];BOUND cnt=1,i=0;
if(prk!=(&env[0][1])->p->RANK){if(prk==0){
prk=(&env[0][1])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][1])->p->SHAPETC[i];}}
}else if((&env[0][1])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][1])->p->SHAPETC[i])error(4);}}
}
if(prk!=(&env[0][0])->p->RANK){if(prk==0){
prk=(&env[0][0])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][0])->p->SHAPETC[i];}}
}else if((&env[0][0])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][0])->p->SHAPETC[i])error(4);}}
}
{BOUND i;for(i=0;i<prk;i++){cnt*=sp[i];}}
aplint32 *d0=ARRAYSTART((&env[0][1])->p);
BOUND m0=(&env[0][1])->p->RANK==0?0:1;
BOUND mz0=(&env[0][1])->p->RANK==0?1:cnt;
double *d1=ARRAYSTART((&env[0][0])->p);
BOUND m1=(&env[0][0])->p->RANK==0?0:1;
BOUND mz1=(&env[0][0])->p->RANK==0?1:cnt;
POCKET*p0;
if(NULL==(&env[0][0])->p||prk!=(&env[0][0])->p->RANK
||(&env[0][0])->p->ELTYPE!=APLDOUB)
p0=getarray(APLDOUB,prk,sp,NULL);
else p0=(&env[0][0])->p;
double *r0=ARRAYSTART(p0);
#pragma acc parallel loop copyin(d0[0:mz0],d1[0:mz1]) copyout(r0[0:cnt])
for(i=0;i<cnt;i++){
aplint32 f0=d0[i*m0];
double f1=d1[i*m1];
double s0=f0*f1;
r0[i]=s0;
}
if((&env[0][0])->p!=p0){relp(&env[0][0]);(&env[0][0])->p=p0;}
}
z->p=zap((&env[0][0])->p);cutp(&env0[0]);
}

void static inline fn_1_4in(LOCALP*z,LOCALP*l,LOCALP*r,LOCALP*penv[]){
LOCALP env0[3];LOCALP*env[]={env0,penv[0]};
{BOUND i;for(i=0;i<3;i++){regp(&env0[i]);}}
{BOUND prk=0;BOUND sp[15];BOUND cnt=1,i=0;
if(prk!=(r)->p->RANK){if(prk==0){
prk=(r)->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(r)->p->SHAPETC[i];}}
}else if((r)->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(r)->p->SHAPETC[i])error(4);}}
}
{BOUND i;for(i=0;i<prk;i++){cnt*=sp[i];}}
aplint32 *d0=ARRAYSTART((r)->p);
BOUND m0=(r)->p->RANK==0?0:1;
BOUND mz0=(r)->p->RANK==0?1:cnt;
POCKET*p0,*p1,*p2;
if(NULL==(&env[0][0])->p||prk!=(&env[0][0])->p->RANK
||(&env[0][0])->p->ELTYPE!=APLLONG)
p0=getarray(APLLONG,prk,sp,NULL);
else p0=(&env[0][0])->p;
if(NULL==(&env[0][1])->p||prk!=(&env[0][1])->p->RANK
||(&env[0][1])->p->ELTYPE!=APLLONG)
p1=getarray(APLLONG,prk,sp,NULL);
else p1=(&env[0][1])->p;
if(NULL==(&env[0][2])->p||prk!=(&env[0][2])->p->RANK
||(&env[0][2])->p->ELTYPE!=APLDOUB)
p2=getarray(APLDOUB,prk,sp,NULL);
else p2=(&env[0][2])->p;
aplint32 *r0=ARRAYSTART(p0);
aplint32 *r1=ARRAYSTART(p1);
double *r2=ARRAYSTART(p2);
#pragma acc parallel loop copyin(d0[0:mz0]) copyout(r0[0:cnt],r1[0:cnt],r2[0:cnt])
for(i=0;i<cnt;i++){
aplint32 f0=d0[i*m0];
aplint32 s0=fabs(f0);
aplint32 s1=f0>=0;
double s2=0.2316419*s0;
double s3=1+s2;
double s4=1.0/s3;
r0[i]=s0;
r1[i]=s1;
r2[i]=s4;
}
if((&env[0][0])->p!=p0){relp(&env[0][0]);(&env[0][0])->p=p0;}
if((&env[0][1])->p!=p1){relp(&env[0][1]);(&env[0][1])->p=p1;}
if((&env[0][2])->p!=p2){relp(&env[0][2]);(&env[0][2])->p=p2;}
}
{LOCALP *rslt=&env[0][2];LOCALP *rgt=&env[0][2];BOUND sp[15];{BOUND i;for(i=0;i<rgt->p->RANK;i++){sp[i]=rgt->p->SHAPETC[i];}}
if(rslt!=rgt){relp(rslt);getarray(APLDOUB,rgt->p->RANK,sp,rslt);}
LOCALP sz,sr;regp(&sz);regp(&sr);
getarray(APLDOUB,0,NULL,&sz);getarray(APLDOUB,0,NULL,&sr);
double *z;double *r;
BOUND c=1;{BOUND i;for(i=0;i<rgt->p->RANK;i++){c*=rgt->p->SHAPETC[i];}}
{BOUND i;for(i=0;i<c;i++){z=ARRAYSTART(sr.p);r=ARRAYSTART(rgt->p);z[0]=r[i];
fn_1_4_10_8_8_6_7fn(&sz,NULL,&sr,env);
z=ARRAYSTART(rslt->p);r=ARRAYSTART(sz.p);
z[i]=r[0];}}
cutp(&sz);
}
{BOUND prk=0;BOUND sp[15];BOUND cnt=1,i=0;
if(prk!=(&env[0][0])->p->RANK){if(prk==0){
prk=(&env[0][0])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][0])->p->SHAPETC[i];}}
}else if((&env[0][0])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][0])->p->SHAPETC[i])error(4);}}
}
if(prk!=(&env[0][2])->p->RANK){if(prk==0){
prk=(&env[0][2])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][2])->p->SHAPETC[i];}}
}else if((&env[0][2])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][2])->p->SHAPETC[i])error(4);}}
}
{BOUND i;for(i=0;i<prk;i++){cnt*=sp[i];}}
aplint32 *d0=ARRAYSTART((&env[0][0])->p);
BOUND m0=(&env[0][0])->p->RANK==0?0:1;
BOUND mz0=(&env[0][0])->p->RANK==0?1:cnt;
double *d1=ARRAYSTART((&env[0][2])->p);
BOUND m1=(&env[0][2])->p->RANK==0?0:1;
BOUND mz1=(&env[0][2])->p->RANK==0?1:cnt;
POCKET*p0;
if(NULL==(&env[0][0])->p||prk!=(&env[0][0])->p->RANK
||(&env[0][0])->p->ELTYPE!=APLDOUB)
p0=getarray(APLDOUB,prk,sp,NULL);
else p0=(&env[0][0])->p;
double *r0=ARRAYSTART(p0);
#pragma acc parallel loop copyin(d0[0:mz0],d1[0:mz1]) copyout(r0[0:cnt])
for(i=0;i<cnt;i++){
aplint32 f0=d0[i*m0];
double f1=d1[i*m1];
aplint32 s0=f0*f0;
double s1=((double)s0)/((double)-2);
double s2=exp((double)s1);
double s3=s2*f1;
double s4=0.3989422804*s3;
r0[i]=s4;
}
if((&env[0][0])->p!=p0){relp(&env[0][0]);(&env[0][0])->p=p0;}
}
{LOCALP *rslt=&env[0][2];LOCALP *rgt=&env[0][1];aplint32 l[]={0,-1};
BOUND sp[15];{BOUND i;for(i=0;i<rgt->p->RANK;i++){sp[i]=rgt->p->SHAPETC[i];}}
LOCALP*orz;LOCALP tp;tp.p=NULL;int tpused=0;
if(rslt==rgt){orz=rslt;rslt=&tp;tpused=1;}
relp(rslt);getarray(APLLONG,rgt->p->RANK,sp,rslt);
aplint32 *z;aplint32*r;z=ARRAYSTART(rslt->p);r=ARRAYSTART(rgt->p);
BOUND c=1;{BOUND i;for(i=0;i<rgt->p->RANK;i++){c*=rgt->p->SHAPETC[i];}}
{BOUND i;
#pragma simd
for(i=0;i<c;i++){z[i]=l[r[i]];}}
if(tpused){relp(orz);orz->p=zap(rslt->p);}
}
{BOUND prk=0;BOUND sp[15];BOUND cnt=1,i=0;
if(prk!=(&env[0][2])->p->RANK){if(prk==0){
prk=(&env[0][2])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][2])->p->SHAPETC[i];}}
}else if((&env[0][2])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][2])->p->SHAPETC[i])error(4);}}
}
if(prk!=(&env[0][0])->p->RANK){if(prk==0){
prk=(&env[0][0])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][0])->p->SHAPETC[i];}}
}else if((&env[0][0])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][0])->p->SHAPETC[i])error(4);}}
}
{BOUND i;for(i=0;i<prk;i++){cnt*=sp[i];}}
aplint32 *d0=ARRAYSTART((&env[0][2])->p);
BOUND m0=(&env[0][2])->p->RANK==0?0:1;
BOUND mz0=(&env[0][2])->p->RANK==0?1:cnt;
double *d1=ARRAYSTART((&env[0][0])->p);
BOUND m1=(&env[0][0])->p->RANK==0?0:1;
BOUND mz1=(&env[0][0])->p->RANK==0?1:cnt;
POCKET*p0;
if(NULL==(&env[0][0])->p||prk!=(&env[0][0])->p->RANK
||(&env[0][0])->p->ELTYPE!=APLDOUB)
p0=getarray(APLDOUB,prk,sp,NULL);
else p0=(&env[0][0])->p;
double *r0=ARRAYSTART(p0);
#pragma acc parallel loop copyin(d0[0:mz0],d1[0:mz1]) copyout(r0[0:cnt])
for(i=0;i<cnt;i++){
aplint32 f0=d0[i*m0];
double f1=d1[i*m1];
double s0=f0+f1;
r0[i]=s0;
}
if((&env[0][0])->p!=p0){relp(&env[0][0]);(&env[0][0])->p=p0;}
}
{LOCALP *rslt=&env[0][1];LOCALP *rgt=&env[0][1];aplint32 l[]={1,-1};
BOUND sp[15];{BOUND i;for(i=0;i<rgt->p->RANK;i++){sp[i]=rgt->p->SHAPETC[i];}}
LOCALP*orz;LOCALP tp;tp.p=NULL;int tpused=0;
if(rslt==rgt){orz=rslt;rslt=&tp;tpused=1;}
relp(rslt);getarray(APLLONG,rgt->p->RANK,sp,rslt);
aplint32 *z;aplint32*r;z=ARRAYSTART(rslt->p);r=ARRAYSTART(rgt->p);
BOUND c=1;{BOUND i;for(i=0;i<rgt->p->RANK;i++){c*=rgt->p->SHAPETC[i];}}
{BOUND i;
#pragma simd
for(i=0;i<c;i++){z[i]=l[r[i]];}}
if(tpused){relp(orz);orz->p=zap(rslt->p);}
}
{BOUND prk=0;BOUND sp[15];BOUND cnt=1,i=0;
if(prk!=(&env[0][1])->p->RANK){if(prk==0){
prk=(&env[0][1])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][1])->p->SHAPETC[i];}}
}else if((&env[0][1])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][1])->p->SHAPETC[i])error(4);}}
}
if(prk!=(&env[0][0])->p->RANK){if(prk==0){
prk=(&env[0][0])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][0])->p->SHAPETC[i];}}
}else if((&env[0][0])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][0])->p->SHAPETC[i])error(4);}}
}
{BOUND i;for(i=0;i<prk;i++){cnt*=sp[i];}}
aplint32 *d0=ARRAYSTART((&env[0][1])->p);
BOUND m0=(&env[0][1])->p->RANK==0?0:1;
BOUND mz0=(&env[0][1])->p->RANK==0?1:cnt;
double *d1=ARRAYSTART((&env[0][0])->p);
BOUND m1=(&env[0][0])->p->RANK==0?0:1;
BOUND mz1=(&env[0][0])->p->RANK==0?1:cnt;
POCKET*p0;
if(NULL==(&env[0][0])->p||prk!=(&env[0][0])->p->RANK
||(&env[0][0])->p->ELTYPE!=APLDOUB)
p0=getarray(APLDOUB,prk,sp,NULL);
else p0=(&env[0][0])->p;
double *r0=ARRAYSTART(p0);
#pragma acc parallel loop copyin(d0[0:mz0],d1[0:mz1]) copyout(r0[0:cnt])
for(i=0;i<cnt;i++){
aplint32 f0=d0[i*m0];
double f1=d1[i*m1];
double s0=f0*f1;
r0[i]=s0;
}
if((&env[0][0])->p!=p0){relp(&env[0][0]);(&env[0][0])->p=p0;}
}
z->p=zap((&env[0][0])->p);cutp(&env0[0]);
}

void static inline fn_1_4fi(LOCALP*z,LOCALP*l,LOCALP*r,LOCALP*penv[]){
LOCALP env0[3];LOCALP*env[]={env0,penv[0]};
{BOUND i;for(i=0;i<3;i++){regp(&env0[i]);}}
{BOUND prk=0;BOUND sp[15];BOUND cnt=1,i=0;
if(prk!=(r)->p->RANK){if(prk==0){
prk=(r)->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(r)->p->SHAPETC[i];}}
}else if((r)->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(r)->p->SHAPETC[i])error(4);}}
}
{BOUND i;for(i=0;i<prk;i++){cnt*=sp[i];}}
double *d0=ARRAYSTART((r)->p);
BOUND m0=(r)->p->RANK==0?0:1;
BOUND mz0=(r)->p->RANK==0?1:cnt;
POCKET*p0,*p1,*p2;
if(NULL==(&env[0][0])->p||prk!=(&env[0][0])->p->RANK
||(&env[0][0])->p->ELTYPE!=APLDOUB)
p0=getarray(APLDOUB,prk,sp,NULL);
else p0=(&env[0][0])->p;
if(NULL==(&env[0][1])->p||prk!=(&env[0][1])->p->RANK
||(&env[0][1])->p->ELTYPE!=APLLONG)
p1=getarray(APLLONG,prk,sp,NULL);
else p1=(&env[0][1])->p;
if(NULL==(&env[0][2])->p||prk!=(&env[0][2])->p->RANK
||(&env[0][2])->p->ELTYPE!=APLDOUB)
p2=getarray(APLDOUB,prk,sp,NULL);
else p2=(&env[0][2])->p;
double *r0=ARRAYSTART(p0);
aplint32 *r1=ARRAYSTART(p1);
double *r2=ARRAYSTART(p2);
#pragma acc parallel loop copyin(d0[0:mz0]) copyout(r0[0:cnt],r1[0:cnt],r2[0:cnt])
for(i=0;i<cnt;i++){
double f0=d0[i*m0];
double s0=fabs(f0);
aplint32 s1=f0>=0;
double s2=0.2316419*s0;
double s3=1+s2;
double s4=1.0/s3;
r0[i]=s0;
r1[i]=s1;
r2[i]=s4;
}
if((&env[0][0])->p!=p0){relp(&env[0][0]);(&env[0][0])->p=p0;}
if((&env[0][1])->p!=p1){relp(&env[0][1]);(&env[0][1])->p=p1;}
if((&env[0][2])->p!=p2){relp(&env[0][2]);(&env[0][2])->p=p2;}
}
{LOCALP *rslt=&env[0][2];LOCALP *rgt=&env[0][2];BOUND sp[15];{BOUND i;for(i=0;i<rgt->p->RANK;i++){sp[i]=rgt->p->SHAPETC[i];}}
if(rslt!=rgt){relp(rslt);getarray(APLDOUB,rgt->p->RANK,sp,rslt);}
LOCALP sz,sr;regp(&sz);regp(&sr);
getarray(APLDOUB,0,NULL,&sz);getarray(APLDOUB,0,NULL,&sr);
double *z;double *r;
BOUND c=1;{BOUND i;for(i=0;i<rgt->p->RANK;i++){c*=rgt->p->SHAPETC[i];}}
{BOUND i;for(i=0;i<c;i++){z=ARRAYSTART(sr.p);r=ARRAYSTART(rgt->p);z[0]=r[i];
fn_1_4_10_8_8_6_7fn(&sz,NULL,&sr,env);
z=ARRAYSTART(rslt->p);r=ARRAYSTART(sz.p);
z[i]=r[0];}}
cutp(&sz);
}
{BOUND prk=0;BOUND sp[15];BOUND cnt=1,i=0;
if(prk!=(&env[0][0])->p->RANK){if(prk==0){
prk=(&env[0][0])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][0])->p->SHAPETC[i];}}
}else if((&env[0][0])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][0])->p->SHAPETC[i])error(4);}}
}
if(prk!=(&env[0][2])->p->RANK){if(prk==0){
prk=(&env[0][2])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][2])->p->SHAPETC[i];}}
}else if((&env[0][2])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][2])->p->SHAPETC[i])error(4);}}
}
{BOUND i;for(i=0;i<prk;i++){cnt*=sp[i];}}
double *d0=ARRAYSTART((&env[0][0])->p);
BOUND m0=(&env[0][0])->p->RANK==0?0:1;
BOUND mz0=(&env[0][0])->p->RANK==0?1:cnt;
double *d1=ARRAYSTART((&env[0][2])->p);
BOUND m1=(&env[0][2])->p->RANK==0?0:1;
BOUND mz1=(&env[0][2])->p->RANK==0?1:cnt;
POCKET*p0;
if(NULL==(&env[0][0])->p||prk!=(&env[0][0])->p->RANK
||(&env[0][0])->p->ELTYPE!=APLDOUB)
p0=getarray(APLDOUB,prk,sp,NULL);
else p0=(&env[0][0])->p;
double *r0=ARRAYSTART(p0);
#pragma acc parallel loop copyin(d0[0:mz0],d1[0:mz1]) copyout(r0[0:cnt])
for(i=0;i<cnt;i++){
double f0=d0[i*m0];
double f1=d1[i*m1];
double s0=f0*f0;
double s1=((double)s0)/((double)-2);
double s2=exp((double)s1);
double s3=s2*f1;
double s4=0.3989422804*s3;
r0[i]=s4;
}
if((&env[0][0])->p!=p0){relp(&env[0][0]);(&env[0][0])->p=p0;}
}
{LOCALP *rslt=&env[0][2];LOCALP *rgt=&env[0][1];aplint32 l[]={0,-1};
BOUND sp[15];{BOUND i;for(i=0;i<rgt->p->RANK;i++){sp[i]=rgt->p->SHAPETC[i];}}
LOCALP*orz;LOCALP tp;tp.p=NULL;int tpused=0;
if(rslt==rgt){orz=rslt;rslt=&tp;tpused=1;}
relp(rslt);getarray(APLLONG,rgt->p->RANK,sp,rslt);
aplint32 *z;aplint32*r;z=ARRAYSTART(rslt->p);r=ARRAYSTART(rgt->p);
BOUND c=1;{BOUND i;for(i=0;i<rgt->p->RANK;i++){c*=rgt->p->SHAPETC[i];}}
{BOUND i;
#pragma simd
for(i=0;i<c;i++){z[i]=l[r[i]];}}
if(tpused){relp(orz);orz->p=zap(rslt->p);}
}
{BOUND prk=0;BOUND sp[15];BOUND cnt=1,i=0;
if(prk!=(&env[0][2])->p->RANK){if(prk==0){
prk=(&env[0][2])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][2])->p->SHAPETC[i];}}
}else if((&env[0][2])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][2])->p->SHAPETC[i])error(4);}}
}
if(prk!=(&env[0][0])->p->RANK){if(prk==0){
prk=(&env[0][0])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][0])->p->SHAPETC[i];}}
}else if((&env[0][0])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][0])->p->SHAPETC[i])error(4);}}
}
{BOUND i;for(i=0;i<prk;i++){cnt*=sp[i];}}
aplint32 *d0=ARRAYSTART((&env[0][2])->p);
BOUND m0=(&env[0][2])->p->RANK==0?0:1;
BOUND mz0=(&env[0][2])->p->RANK==0?1:cnt;
double *d1=ARRAYSTART((&env[0][0])->p);
BOUND m1=(&env[0][0])->p->RANK==0?0:1;
BOUND mz1=(&env[0][0])->p->RANK==0?1:cnt;
POCKET*p0;
if(NULL==(&env[0][0])->p||prk!=(&env[0][0])->p->RANK
||(&env[0][0])->p->ELTYPE!=APLDOUB)
p0=getarray(APLDOUB,prk,sp,NULL);
else p0=(&env[0][0])->p;
double *r0=ARRAYSTART(p0);
#pragma acc parallel loop copyin(d0[0:mz0],d1[0:mz1]) copyout(r0[0:cnt])
for(i=0;i<cnt;i++){
aplint32 f0=d0[i*m0];
double f1=d1[i*m1];
double s0=f0+f1;
r0[i]=s0;
}
if((&env[0][0])->p!=p0){relp(&env[0][0]);(&env[0][0])->p=p0;}
}
{LOCALP *rslt=&env[0][1];LOCALP *rgt=&env[0][1];aplint32 l[]={1,-1};
BOUND sp[15];{BOUND i;for(i=0;i<rgt->p->RANK;i++){sp[i]=rgt->p->SHAPETC[i];}}
LOCALP*orz;LOCALP tp;tp.p=NULL;int tpused=0;
if(rslt==rgt){orz=rslt;rslt=&tp;tpused=1;}
relp(rslt);getarray(APLLONG,rgt->p->RANK,sp,rslt);
aplint32 *z;aplint32*r;z=ARRAYSTART(rslt->p);r=ARRAYSTART(rgt->p);
BOUND c=1;{BOUND i;for(i=0;i<rgt->p->RANK;i++){c*=rgt->p->SHAPETC[i];}}
{BOUND i;
#pragma simd
for(i=0;i<c;i++){z[i]=l[r[i]];}}
if(tpused){relp(orz);orz->p=zap(rslt->p);}
}
{BOUND prk=0;BOUND sp[15];BOUND cnt=1,i=0;
if(prk!=(&env[0][1])->p->RANK){if(prk==0){
prk=(&env[0][1])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][1])->p->SHAPETC[i];}}
}else if((&env[0][1])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][1])->p->SHAPETC[i])error(4);}}
}
if(prk!=(&env[0][0])->p->RANK){if(prk==0){
prk=(&env[0][0])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][0])->p->SHAPETC[i];}}
}else if((&env[0][0])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][0])->p->SHAPETC[i])error(4);}}
}
{BOUND i;for(i=0;i<prk;i++){cnt*=sp[i];}}
aplint32 *d0=ARRAYSTART((&env[0][1])->p);
BOUND m0=(&env[0][1])->p->RANK==0?0:1;
BOUND mz0=(&env[0][1])->p->RANK==0?1:cnt;
double *d1=ARRAYSTART((&env[0][0])->p);
BOUND m1=(&env[0][0])->p->RANK==0?0:1;
BOUND mz1=(&env[0][0])->p->RANK==0?1:cnt;
POCKET*p0;
if(NULL==(&env[0][0])->p||prk!=(&env[0][0])->p->RANK
||(&env[0][0])->p->ELTYPE!=APLDOUB)
p0=getarray(APLDOUB,prk,sp,NULL);
else p0=(&env[0][0])->p;
double *r0=ARRAYSTART(p0);
#pragma acc parallel loop copyin(d0[0:mz0],d1[0:mz1]) copyout(r0[0:cnt])
for(i=0;i<cnt;i++){
aplint32 f0=d0[i*m0];
double f1=d1[i*m1];
double s0=f0*f1;
r0[i]=s0;
}
if((&env[0][0])->p!=p0){relp(&env[0][0]);(&env[0][0])->p=p0;}
}
z->p=zap((&env[0][0])->p);cutp(&env0[0]);
}

void static inline fn_1_4ff(LOCALP*z,LOCALP*l,LOCALP*r,LOCALP*penv[]){
LOCALP env0[3];LOCALP*env[]={env0,penv[0]};
{BOUND i;for(i=0;i<3;i++){regp(&env0[i]);}}
{BOUND prk=0;BOUND sp[15];BOUND cnt=1,i=0;
if(prk!=(r)->p->RANK){if(prk==0){
prk=(r)->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(r)->p->SHAPETC[i];}}
}else if((r)->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(r)->p->SHAPETC[i])error(4);}}
}
{BOUND i;for(i=0;i<prk;i++){cnt*=sp[i];}}
double *d0=ARRAYSTART((r)->p);
BOUND m0=(r)->p->RANK==0?0:1;
BOUND mz0=(r)->p->RANK==0?1:cnt;
POCKET*p0,*p1,*p2;
if(NULL==(&env[0][0])->p||prk!=(&env[0][0])->p->RANK
||(&env[0][0])->p->ELTYPE!=APLDOUB)
p0=getarray(APLDOUB,prk,sp,NULL);
else p0=(&env[0][0])->p;
if(NULL==(&env[0][1])->p||prk!=(&env[0][1])->p->RANK
||(&env[0][1])->p->ELTYPE!=APLLONG)
p1=getarray(APLLONG,prk,sp,NULL);
else p1=(&env[0][1])->p;
if(NULL==(&env[0][2])->p||prk!=(&env[0][2])->p->RANK
||(&env[0][2])->p->ELTYPE!=APLDOUB)
p2=getarray(APLDOUB,prk,sp,NULL);
else p2=(&env[0][2])->p;
double *r0=ARRAYSTART(p0);
aplint32 *r1=ARRAYSTART(p1);
double *r2=ARRAYSTART(p2);
#pragma acc parallel loop copyin(d0[0:mz0]) copyout(r0[0:cnt],r1[0:cnt],r2[0:cnt])
for(i=0;i<cnt;i++){
double f0=d0[i*m0];
double s0=fabs(f0);
aplint32 s1=f0>=0;
double s2=0.2316419*s0;
double s3=1+s2;
double s4=1.0/s3;
r0[i]=s0;
r1[i]=s1;
r2[i]=s4;
}
if((&env[0][0])->p!=p0){relp(&env[0][0]);(&env[0][0])->p=p0;}
if((&env[0][1])->p!=p1){relp(&env[0][1]);(&env[0][1])->p=p1;}
if((&env[0][2])->p!=p2){relp(&env[0][2]);(&env[0][2])->p=p2;}
}
{LOCALP *rslt=&env[0][2];LOCALP *rgt=&env[0][2];BOUND sp[15];{BOUND i;for(i=0;i<rgt->p->RANK;i++){sp[i]=rgt->p->SHAPETC[i];}}
if(rslt!=rgt){relp(rslt);getarray(APLDOUB,rgt->p->RANK,sp,rslt);}
LOCALP sz,sr;regp(&sz);regp(&sr);
getarray(APLDOUB,0,NULL,&sz);getarray(APLDOUB,0,NULL,&sr);
double *z;double *r;
BOUND c=1;{BOUND i;for(i=0;i<rgt->p->RANK;i++){c*=rgt->p->SHAPETC[i];}}
{BOUND i;for(i=0;i<c;i++){z=ARRAYSTART(sr.p);r=ARRAYSTART(rgt->p);z[0]=r[i];
fn_1_4_10_8_8_6_7fn(&sz,NULL,&sr,env);
z=ARRAYSTART(rslt->p);r=ARRAYSTART(sz.p);
z[i]=r[0];}}
cutp(&sz);
}
{BOUND prk=0;BOUND sp[15];BOUND cnt=1,i=0;
if(prk!=(&env[0][0])->p->RANK){if(prk==0){
prk=(&env[0][0])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][0])->p->SHAPETC[i];}}
}else if((&env[0][0])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][0])->p->SHAPETC[i])error(4);}}
}
if(prk!=(&env[0][2])->p->RANK){if(prk==0){
prk=(&env[0][2])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][2])->p->SHAPETC[i];}}
}else if((&env[0][2])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][2])->p->SHAPETC[i])error(4);}}
}
{BOUND i;for(i=0;i<prk;i++){cnt*=sp[i];}}
double *d0=ARRAYSTART((&env[0][0])->p);
BOUND m0=(&env[0][0])->p->RANK==0?0:1;
BOUND mz0=(&env[0][0])->p->RANK==0?1:cnt;
double *d1=ARRAYSTART((&env[0][2])->p);
BOUND m1=(&env[0][2])->p->RANK==0?0:1;
BOUND mz1=(&env[0][2])->p->RANK==0?1:cnt;
POCKET*p0;
if(NULL==(&env[0][0])->p||prk!=(&env[0][0])->p->RANK
||(&env[0][0])->p->ELTYPE!=APLDOUB)
p0=getarray(APLDOUB,prk,sp,NULL);
else p0=(&env[0][0])->p;
double *r0=ARRAYSTART(p0);
#pragma acc parallel loop copyin(d0[0:mz0],d1[0:mz1]) copyout(r0[0:cnt])
for(i=0;i<cnt;i++){
double f0=d0[i*m0];
double f1=d1[i*m1];
double s0=f0*f0;
double s1=((double)s0)/((double)-2);
double s2=exp((double)s1);
double s3=s2*f1;
double s4=0.3989422804*s3;
r0[i]=s4;
}
if((&env[0][0])->p!=p0){relp(&env[0][0]);(&env[0][0])->p=p0;}
}
{LOCALP *rslt=&env[0][2];LOCALP *rgt=&env[0][1];aplint32 l[]={0,-1};
BOUND sp[15];{BOUND i;for(i=0;i<rgt->p->RANK;i++){sp[i]=rgt->p->SHAPETC[i];}}
LOCALP*orz;LOCALP tp;tp.p=NULL;int tpused=0;
if(rslt==rgt){orz=rslt;rslt=&tp;tpused=1;}
relp(rslt);getarray(APLLONG,rgt->p->RANK,sp,rslt);
aplint32 *z;aplint32*r;z=ARRAYSTART(rslt->p);r=ARRAYSTART(rgt->p);
BOUND c=1;{BOUND i;for(i=0;i<rgt->p->RANK;i++){c*=rgt->p->SHAPETC[i];}}
{BOUND i;
#pragma simd
for(i=0;i<c;i++){z[i]=l[r[i]];}}
if(tpused){relp(orz);orz->p=zap(rslt->p);}
}
{BOUND prk=0;BOUND sp[15];BOUND cnt=1,i=0;
if(prk!=(&env[0][2])->p->RANK){if(prk==0){
prk=(&env[0][2])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][2])->p->SHAPETC[i];}}
}else if((&env[0][2])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][2])->p->SHAPETC[i])error(4);}}
}
if(prk!=(&env[0][0])->p->RANK){if(prk==0){
prk=(&env[0][0])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][0])->p->SHAPETC[i];}}
}else if((&env[0][0])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][0])->p->SHAPETC[i])error(4);}}
}
{BOUND i;for(i=0;i<prk;i++){cnt*=sp[i];}}
aplint32 *d0=ARRAYSTART((&env[0][2])->p);
BOUND m0=(&env[0][2])->p->RANK==0?0:1;
BOUND mz0=(&env[0][2])->p->RANK==0?1:cnt;
double *d1=ARRAYSTART((&env[0][0])->p);
BOUND m1=(&env[0][0])->p->RANK==0?0:1;
BOUND mz1=(&env[0][0])->p->RANK==0?1:cnt;
POCKET*p0;
if(NULL==(&env[0][0])->p||prk!=(&env[0][0])->p->RANK
||(&env[0][0])->p->ELTYPE!=APLDOUB)
p0=getarray(APLDOUB,prk,sp,NULL);
else p0=(&env[0][0])->p;
double *r0=ARRAYSTART(p0);
#pragma acc parallel loop copyin(d0[0:mz0],d1[0:mz1]) copyout(r0[0:cnt])
for(i=0;i<cnt;i++){
aplint32 f0=d0[i*m0];
double f1=d1[i*m1];
double s0=f0+f1;
r0[i]=s0;
}
if((&env[0][0])->p!=p0){relp(&env[0][0]);(&env[0][0])->p=p0;}
}
{LOCALP *rslt=&env[0][1];LOCALP *rgt=&env[0][1];aplint32 l[]={1,-1};
BOUND sp[15];{BOUND i;for(i=0;i<rgt->p->RANK;i++){sp[i]=rgt->p->SHAPETC[i];}}
LOCALP*orz;LOCALP tp;tp.p=NULL;int tpused=0;
if(rslt==rgt){orz=rslt;rslt=&tp;tpused=1;}
relp(rslt);getarray(APLLONG,rgt->p->RANK,sp,rslt);
aplint32 *z;aplint32*r;z=ARRAYSTART(rslt->p);r=ARRAYSTART(rgt->p);
BOUND c=1;{BOUND i;for(i=0;i<rgt->p->RANK;i++){c*=rgt->p->SHAPETC[i];}}
{BOUND i;
#pragma simd
for(i=0;i<c;i++){z[i]=l[r[i]];}}
if(tpused){relp(orz);orz->p=zap(rslt->p);}
}
{BOUND prk=0;BOUND sp[15];BOUND cnt=1,i=0;
if(prk!=(&env[0][1])->p->RANK){if(prk==0){
prk=(&env[0][1])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][1])->p->SHAPETC[i];}}
}else if((&env[0][1])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][1])->p->SHAPETC[i])error(4);}}
}
if(prk!=(&env[0][0])->p->RANK){if(prk==0){
prk=(&env[0][0])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][0])->p->SHAPETC[i];}}
}else if((&env[0][0])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][0])->p->SHAPETC[i])error(4);}}
}
{BOUND i;for(i=0;i<prk;i++){cnt*=sp[i];}}
aplint32 *d0=ARRAYSTART((&env[0][1])->p);
BOUND m0=(&env[0][1])->p->RANK==0?0:1;
BOUND mz0=(&env[0][1])->p->RANK==0?1:cnt;
double *d1=ARRAYSTART((&env[0][0])->p);
BOUND m1=(&env[0][0])->p->RANK==0?0:1;
BOUND mz1=(&env[0][0])->p->RANK==0?1:cnt;
POCKET*p0;
if(NULL==(&env[0][0])->p||prk!=(&env[0][0])->p->RANK
||(&env[0][0])->p->ELTYPE!=APLDOUB)
p0=getarray(APLDOUB,prk,sp,NULL);
else p0=(&env[0][0])->p;
double *r0=ARRAYSTART(p0);
#pragma acc parallel loop copyin(d0[0:mz0],d1[0:mz1]) copyout(r0[0:cnt])
for(i=0;i<cnt;i++){
aplint32 f0=d0[i*m0];
double f1=d1[i*m1];
double s0=f0*f1;
r0[i]=s0;
}
if((&env[0][0])->p!=p0){relp(&env[0][0]);(&env[0][0])->p=p0;}
}
z->p=zap((&env[0][0])->p);cutp(&env0[0]);
}

void static inline fn_1_4fn(LOCALP*z,LOCALP*l,LOCALP*r,LOCALP*penv[]){
double coeff[]={0.31938153,-0.356563782,1.781477937,-1.821255978,1.33027442};
aplint32 l1[]={0, -1};aplint32 l2[]={1, -1};
LOCALP *env0=NULL;LOCALP*env[]={NULL,penv[0]};
{BOUND i;for(i=0;i<0;i++){regp(&env0[i]);}}
{BOUND prk=0;BOUND sp[15];BOUND cnt=1,i=0;
if(prk!=(r)->p->RANK){if(prk==0){
prk=(r)->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(r)->p->SHAPETC[i];}}
}else if((r)->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(r)->p->SHAPETC[i])error(4);}}
}
{BOUND i;for(i=0;i<prk;i++){cnt*=sp[i];}}
POCKET*p0;
if(NULL==(z)->p||prk!=(z)->p->RANK
||(z)->p->ELTYPE!=APLDOUB)
p0=getarray(APLDOUB,prk,sp,NULL);
else p0=(z)->p;
double *r0=ARRAYSTART(p0);
double *d0=ARRAYSTART((r)->p);
BOUND m0=(r)->p->RANK==0?0:1;
BOUND mz0=(r)->p->RANK==0?1:cnt;
#pragma acc parallel loop copyin(d0[0:mz0],coeff[0:5],l1[0:2],l2[0:2]) copyout(r0[0:cnt])
for(i=0;i<cnt;i++){
double f0=d0[i*m0];
double s0=fabs(f0);
aplint32 s1=f0>=0;
double s2=0.2316419*s0;
double s3=1+s2;
double s4=1.0/s3;
double s5=coeff[0]*pow(s4,1);
  s5+=coeff[1]*pow(s4,2);
  s5+=coeff[2]*pow(s4,3);
  s5+=coeff[3]*pow(s4,4);
  s5+=coeff[4]*pow(s4,5);
double s6=s0*s0;
double s7=((double)s6)/((double)-2);
double s8=exp((double)s7);
double s9=s8*s5;
double s10=0.3989422804*s9;
aplint32 s11=l1[s1];
double s12=s11+s10;
aplint32 s13=l2[s1];
double s14=s13*s12;
r0[i]=s14;
}
if((z)->p!=p0){relp(z);(z)->p=p0;}
}
/*
{LOCALP *rslt=&env[0][2];LOCALP *rgt=&env[0][2];BOUND sp[15];{BOUND i;for(i=0;i<rgt->p->RANK;i++){sp[i]=rgt->p->SHAPETC[i];}}
if(rslt!=rgt){relp(rslt);getarray(APLDOUB,rgt->p->RANK,sp,rslt);}
LOCALP sz,sr;regp(&sz);regp(&sr);
getarray(APLDOUB,0,NULL,&sz);getarray(APLDOUB,0,NULL,&sr);
double *z;double *r;
BOUND c=1;{BOUND i;for(i=0;i<rgt->p->RANK;i++){c*=rgt->p->SHAPETC[i];}}
{BOUND i;for(i=0;i<c;i++){z=ARRAYSTART(sr.p);r=ARRAYSTART(rgt->p);z[0]=r[i];
fn_1_4_10_8_8_6_7fn(&sz,NULL,&sr,env);
z=ARRAYSTART(rslt->p);r=ARRAYSTART(sz.p);
z[i]=r[0];}}
cutp(&sz);
}
*/
/*
{LOCALP *rslt=&env[0][2];LOCALP *rgt=&env[0][2];BOUND sp[15];{BOUND i;for(i=0;i<rgt->p->RANK;i++){sp[i]=rgt->p->SHAPETC[i];}}
if(rslt!=rgt){relp(rslt);getarray(APLDOUB,rgt->p->RANK,sp,rslt);}
double *z;double *r;
z=ARRAYSTART(rslt->p);r=ARRAYSTART(rgt->p);
BOUND c=1;{BOUND i;for(i=0;i<rgt->p->RANK;i++){c*=rgt->p->SHAPETC[i];}}
double coeff[]={0.31938153,-0.356563782,1.781477937,-1.821255978,1.33027442};
{BOUND i;
#pragma acc parallel loop copyin(r[0:c],coeff[0:5]) copyout(z[0:c])
for(i=0;i<c;i++){
  z[i]=coeff[0]*pow(r[i],1);
  z[i]+=coeff[1]*pow(r[i],2);
  z[i]+=coeff[2]*pow(r[i],3);
  z[i]+=coeff[3]*pow(r[i],4);
  z[i]+=coeff[4]*pow(r[i],5);
}}
}
*/
/*
{BOUND prk=0;BOUND sp[15];BOUND cnt=1,i=0;
if(prk!=(&env[0][0])->p->RANK){if(prk==0){
prk=(&env[0][0])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][0])->p->SHAPETC[i];}}
}else if((&env[0][0])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][0])->p->SHAPETC[i])error(4);}}
}
if(prk!=(&env[0][2])->p->RANK){if(prk==0){
prk=(&env[0][2])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][2])->p->SHAPETC[i];}}
}else if((&env[0][2])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][2])->p->SHAPETC[i])error(4);}}
}
{BOUND i;for(i=0;i<prk;i++){cnt*=sp[i];}}
double *d0=ARRAYSTART((&env[0][0])->p);
BOUND m0=(&env[0][0])->p->RANK==0?0:1;
BOUND mz0=(&env[0][0])->p->RANK==0?1:cnt;
double *d1=ARRAYSTART((&env[0][2])->p);
BOUND m1=(&env[0][2])->p->RANK==0?0:1;
BOUND mz1=(&env[0][2])->p->RANK==0?1:cnt;
POCKET*p0;
if(NULL==(&env[0][0])->p||prk!=(&env[0][0])->p->RANK
||(&env[0][0])->p->ELTYPE!=APLDOUB)
p0=getarray(APLDOUB,prk,sp,NULL);
else p0=(&env[0][0])->p;
double *r0=ARRAYSTART(p0);
#pragma acc parallel loop copyin(d0[0:mz0],d1[0:mz1]) copyout(r0[0:cnt])
for(i=0;i<cnt;i++){
double f0=d0[i*m0];
double f1=d1[i*m1];
double s0=f0*f0;
double s1=((double)s0)/((double)-2);
double s2=exp((double)s1);
double s3=s2*f1;
double s4=0.3989422804*s3;
r0[i]=s4;
}
if((&env[0][0])->p!=p0){relp(&env[0][0]);(&env[0][0])->p=p0;}
}
*/
/*
{LOCALP *rslt=&env[0][2];LOCALP *rgt=&env[0][1];aplint32 l[]={0,-1};
BOUND sp[15];{BOUND i;for(i=0;i<rgt->p->RANK;i++){sp[i]=rgt->p->SHAPETC[i];}}
LOCALP*orz;LOCALP tp;tp.p=NULL;int tpused=0;
if(rslt==rgt){orz=rslt;rslt=&tp;tpused=1;}
relp(rslt);getarray(APLLONG,rgt->p->RANK,sp,rslt);
aplint32 *z;aplint32*r;z=ARRAYSTART(rslt->p);r=ARRAYSTART(rgt->p);
BOUND c=1;{BOUND i;for(i=0;i<rgt->p->RANK;i++){c*=rgt->p->SHAPETC[i];}}
{BOUND i;
#pragma simd
for(i=0;i<c;i++){z[i]=l[r[i]];}}
if(tpused){relp(orz);orz->p=zap(rslt->p);}
}
{BOUND prk=0;BOUND sp[15];BOUND cnt=1,i=0;
if(prk!=(&env[0][2])->p->RANK){if(prk==0){
prk=(&env[0][2])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][2])->p->SHAPETC[i];}}
}else if((&env[0][2])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][2])->p->SHAPETC[i])error(4);}}
}
if(prk!=(&env[0][0])->p->RANK){if(prk==0){
prk=(&env[0][0])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][0])->p->SHAPETC[i];}}
}else if((&env[0][0])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][0])->p->SHAPETC[i])error(4);}}
}
{BOUND i;for(i=0;i<prk;i++){cnt*=sp[i];}}
aplint32 *d0=ARRAYSTART((&env[0][2])->p);
BOUND m0=(&env[0][2])->p->RANK==0?0:1;
BOUND mz0=(&env[0][2])->p->RANK==0?1:cnt;
double *d1=ARRAYSTART((&env[0][0])->p);
BOUND m1=(&env[0][0])->p->RANK==0?0:1;
BOUND mz1=(&env[0][0])->p->RANK==0?1:cnt;
POCKET*p0;
if(NULL==(&env[0][0])->p||prk!=(&env[0][0])->p->RANK
||(&env[0][0])->p->ELTYPE!=APLDOUB)
p0=getarray(APLDOUB,prk,sp,NULL);
else p0=(&env[0][0])->p;
double *r0=ARRAYSTART(p0);
#pragma acc parallel loop copyin(d0[0:mz0],d1[0:mz1]) copyout(r0[0:cnt])
for(i=0;i<cnt;i++){
aplint32 f0=d0[i*m0];
double f1=d1[i*m1];
double s0=f0+f1;
r0[i]=s0;
}
if((&env[0][0])->p!=p0){relp(&env[0][0]);(&env[0][0])->p=p0;}
}
{LOCALP *rslt=&env[0][1];LOCALP *rgt=&env[0][1];aplint32 l[]={1,-1};
BOUND sp[15];{BOUND i;for(i=0;i<rgt->p->RANK;i++){sp[i]=rgt->p->SHAPETC[i];}}
LOCALP*orz;LOCALP tp;tp.p=NULL;int tpused=0;
if(rslt==rgt){orz=rslt;rslt=&tp;tpused=1;}
relp(rslt);getarray(APLLONG,rgt->p->RANK,sp,rslt);
aplint32 *z;aplint32*r;z=ARRAYSTART(rslt->p);r=ARRAYSTART(rgt->p);
BOUND c=1;{BOUND i;for(i=0;i<rgt->p->RANK;i++){c*=rgt->p->SHAPETC[i];}}
{BOUND i;
#pragma simd
for(i=0;i<c;i++){z[i]=l[r[i]];}}
if(tpused){relp(orz);orz->p=zap(rslt->p);}
}
{BOUND prk=0;BOUND sp[15];BOUND cnt=1,i=0;
if(prk!=(&env[0][1])->p->RANK){if(prk==0){
prk=(&env[0][1])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][1])->p->SHAPETC[i];}}
}else if((&env[0][1])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][1])->p->SHAPETC[i])error(4);}}
}
if(prk!=(&env[0][0])->p->RANK){if(prk==0){
prk=(&env[0][0])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][0])->p->SHAPETC[i];}}
}else if((&env[0][0])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][0])->p->SHAPETC[i])error(4);}}
}
{BOUND i;for(i=0;i<prk;i++){cnt*=sp[i];}}
aplint32 *d0=ARRAYSTART((&env[0][1])->p);
BOUND m0=(&env[0][1])->p->RANK==0?0:1;
BOUND mz0=(&env[0][1])->p->RANK==0?1:cnt;
double *d1=ARRAYSTART((&env[0][0])->p);
BOUND m1=(&env[0][0])->p->RANK==0?0:1;
BOUND mz1=(&env[0][0])->p->RANK==0?1:cnt;
POCKET*p0;
if(NULL==(&env[0][0])->p||prk!=(&env[0][0])->p->RANK
||(&env[0][0])->p->ELTYPE!=APLDOUB)
p0=getarray(APLDOUB,prk,sp,NULL);
else p0=(&env[0][0])->p;
double *r0=ARRAYSTART(p0);
#pragma acc parallel loop copyin(d0[0:mz0],d1[0:mz1]) copyout(r0[0:cnt])
for(i=0;i<cnt;i++){
aplint32 f0=d0[i*m0];
double f1=d1[i*m1];
double s0=f0*f1;
r0[i]=s0;
}
if((&env[0][0])->p!=p0){relp(&env[0][0]);(&env[0][0])->p=p0;}
}
z->p=zap((&env[0][0])->p);cutp(&env0[0]);
*/
}

void static inline fn_1_4_10_8_8_6_7ii(LOCALP*z,LOCALP*l,LOCALP*r,LOCALP*penv[]){
LOCALP env0[1];LOCALP*env[]={env0,penv[0],penv[1]};
{BOUND i;for(i=0;i<1;i++){regp(&env0[i]);}}
{BOUND prk=0;BOUND sp[15];BOUND cnt=1,i=0;
if(prk!=(r)->p->RANK){if(prk==0){
prk=(r)->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(r)->p->SHAPETC[i];}}
}else if((r)->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(r)->p->SHAPETC[i])error(4);}}
}
if(prk!=1){if(prk==0){prk=1;sp[0]=5;}else error(4);}else if(sp[0]!=5)error(4);
{BOUND i;for(i=0;i<prk;i++){cnt*=sp[i];}}
aplint32 *d0=ARRAYSTART((r)->p);
BOUND m0=(r)->p->RANK==0?0:1;
BOUND mz0=(r)->p->RANK==0?1:cnt;
aplint32 d1[]={1,2,3,4,5};
BOUND m1=cnt;
BOUND mz1=cnt;
POCKET*p0;
if(NULL==(&env[0][0])->p||prk!=(&env[0][0])->p->RANK
||(&env[0][0])->p->ELTYPE!=APLLONG)
p0=getarray(APLLONG,prk,sp,NULL);
else p0=(&env[0][0])->p;
aplint32 *r0=ARRAYSTART(p0);
#pragma acc parallel loop copyin(d0[0:mz0],d1[0:mz1]) copyout(r0[0:cnt])
for(i=0;i<cnt;i++){
aplint32 f0=d0[i*m0];
aplint32 f1=d1[i*m1];
aplint32 s0=pow((double)f0,(double)f1);
r0[i]=s0;
}
if((&env[0][0])->p!=p0){relp(&env[0][0]);(&env[0][0])->p=p0;}
}
{LOCALP *rslt=&env[0][0];LOCALP *rgt=&env[0][0];double l[]={0.31938153,-0.356563782,1.781477937,-1.821255978,1.33027442};
LOCALP*orz;LOCALP tp;tp.p=NULL;int tpused=0;
if(rslt==rgt){orz=rslt;rslt=&tp;tpused=1;}
getarray(APLDOUB,0,NULL,rslt);BOUND c=1;
{BOUND i;for(i=0;i<rgt->p->RANK;i++){c*=rgt->p->SHAPETC[i];}}
double *z;aplint32 *r;
z=ARRAYSTART(rslt->p);
r=ARRAYSTART(rgt->p);

{BOUND i;
#pragma simd reduction(+:z)
for(i=0;i<c;i++){z[0]+=l[i]*r[i];}}
if(tpused){relp(orz);orz->p=zap(rslt->p);}
}
z->p=zap((&env[0][0])->p);cutp(&env0[0]);
}

void static inline fn_1_4_10_8_8_6_7if(LOCALP*z,LOCALP*l,LOCALP*r,LOCALP*penv[]){
LOCALP env0[1];LOCALP*env[]={env0,penv[0],penv[1]};
{BOUND i;for(i=0;i<1;i++){regp(&env0[i]);}}
{BOUND prk=0;BOUND sp[15];BOUND cnt=1,i=0;
if(prk!=(r)->p->RANK){if(prk==0){
prk=(r)->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(r)->p->SHAPETC[i];}}
}else if((r)->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(r)->p->SHAPETC[i])error(4);}}
}
if(prk!=1){if(prk==0){prk=1;sp[0]=5;}else error(4);}else if(sp[0]!=5)error(4);
{BOUND i;for(i=0;i<prk;i++){cnt*=sp[i];}}
aplint32 *d0=ARRAYSTART((r)->p);
BOUND m0=(r)->p->RANK==0?0:1;
BOUND mz0=(r)->p->RANK==0?1:cnt;
aplint32 d1[]={1,2,3,4,5};
BOUND m1=cnt;
BOUND mz1=cnt;
POCKET*p0;
if(NULL==(&env[0][0])->p||prk!=(&env[0][0])->p->RANK
||(&env[0][0])->p->ELTYPE!=APLLONG)
p0=getarray(APLLONG,prk,sp,NULL);
else p0=(&env[0][0])->p;
aplint32 *r0=ARRAYSTART(p0);
#pragma acc parallel loop copyin(d0[0:mz0],d1[0:mz1]) copyout(r0[0:cnt])
for(i=0;i<cnt;i++){
aplint32 f0=d0[i*m0];
aplint32 f1=d1[i*m1];
aplint32 s0=pow((double)f0,(double)f1);
r0[i]=s0;
}
if((&env[0][0])->p!=p0){relp(&env[0][0]);(&env[0][0])->p=p0;}
}
{LOCALP *rslt=&env[0][0];LOCALP *rgt=&env[0][0];double l[]={0.31938153,-0.356563782,1.781477937,-1.821255978,1.33027442};
LOCALP*orz;LOCALP tp;tp.p=NULL;int tpused=0;
if(rslt==rgt){orz=rslt;rslt=&tp;tpused=1;}
getarray(APLDOUB,0,NULL,rslt);BOUND c=1;
{BOUND i;for(i=0;i<rgt->p->RANK;i++){c*=rgt->p->SHAPETC[i];}}
double *z;aplint32 *r;
z=ARRAYSTART(rslt->p);
r=ARRAYSTART(rgt->p);

{BOUND i;
#pragma simd reduction(+:z)
for(i=0;i<c;i++){z[0]+=l[i]*r[i];}}
if(tpused){relp(orz);orz->p=zap(rslt->p);}
}
z->p=zap((&env[0][0])->p);cutp(&env0[0]);
}

void static inline fn_1_4_10_8_8_6_7in(LOCALP*z,LOCALP*l,LOCALP*r,LOCALP*penv[]){
LOCALP env0[1];LOCALP*env[]={env0,penv[0],penv[1]};
{BOUND i;for(i=0;i<1;i++){regp(&env0[i]);}}
{BOUND prk=0;BOUND sp[15];BOUND cnt=1,i=0;
if(prk!=(r)->p->RANK){if(prk==0){
prk=(r)->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(r)->p->SHAPETC[i];}}
}else if((r)->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(r)->p->SHAPETC[i])error(4);}}
}
if(prk!=1){if(prk==0){prk=1;sp[0]=5;}else error(4);}else if(sp[0]!=5)error(4);
{BOUND i;for(i=0;i<prk;i++){cnt*=sp[i];}}
aplint32 *d0=ARRAYSTART((r)->p);
BOUND m0=(r)->p->RANK==0?0:1;
BOUND mz0=(r)->p->RANK==0?1:cnt;
aplint32 d1[]={1,2,3,4,5};
BOUND m1=cnt;
BOUND mz1=cnt;
POCKET*p0;
if(NULL==(&env[0][0])->p||prk!=(&env[0][0])->p->RANK
||(&env[0][0])->p->ELTYPE!=APLLONG)
p0=getarray(APLLONG,prk,sp,NULL);
else p0=(&env[0][0])->p;
aplint32 *r0=ARRAYSTART(p0);
#pragma acc parallel loop copyin(d0[0:mz0],d1[0:mz1]) copyout(r0[0:cnt])
for(i=0;i<cnt;i++){
aplint32 f0=d0[i*m0];
aplint32 f1=d1[i*m1];
aplint32 s0=pow((double)f0,(double)f1);
r0[i]=s0;
}
if((&env[0][0])->p!=p0){relp(&env[0][0]);(&env[0][0])->p=p0;}
}
{LOCALP *rslt=&env[0][0];LOCALP *rgt=&env[0][0];double l[]={0.31938153,-0.356563782,1.781477937,-1.821255978,1.33027442};
LOCALP*orz;LOCALP tp;tp.p=NULL;int tpused=0;
if(rslt==rgt){orz=rslt;rslt=&tp;tpused=1;}
getarray(APLDOUB,0,NULL,rslt);BOUND c=1;
{BOUND i;for(i=0;i<rgt->p->RANK;i++){c*=rgt->p->SHAPETC[i];}}
double *z;aplint32 *r;
z=ARRAYSTART(rslt->p);
r=ARRAYSTART(rgt->p);

{BOUND i;
#pragma simd reduction(+:z)
for(i=0;i<c;i++){z[0]+=l[i]*r[i];}}
if(tpused){relp(orz);orz->p=zap(rslt->p);}
}
z->p=zap((&env[0][0])->p);cutp(&env0[0]);
}

void static inline fn_1_4_10_8_8_6_7fi(LOCALP*z,LOCALP*l,LOCALP*r,LOCALP*penv[]){
LOCALP env0[1];LOCALP*env[]={env0,penv[0],penv[1]};
{BOUND i;for(i=0;i<1;i++){regp(&env0[i]);}}
{BOUND prk=0;BOUND sp[15];BOUND cnt=1,i=0;
if(prk!=(r)->p->RANK){if(prk==0){
prk=(r)->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(r)->p->SHAPETC[i];}}
}else if((r)->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(r)->p->SHAPETC[i])error(4);}}
}
if(prk!=1){if(prk==0){prk=1;sp[0]=5;}else error(4);}else if(sp[0]!=5)error(4);
{BOUND i;for(i=0;i<prk;i++){cnt*=sp[i];}}
double *d0=ARRAYSTART((r)->p);
BOUND m0=(r)->p->RANK==0?0:1;
BOUND mz0=(r)->p->RANK==0?1:cnt;
aplint32 d1[]={1,2,3,4,5};
BOUND m1=cnt;
BOUND mz1=cnt;
POCKET*p0;
if(NULL==(&env[0][0])->p||prk!=(&env[0][0])->p->RANK
||(&env[0][0])->p->ELTYPE!=APLDOUB)
p0=getarray(APLDOUB,prk,sp,NULL);
else p0=(&env[0][0])->p;
double *r0=ARRAYSTART(p0);
#pragma acc parallel loop copyin(d0[0:mz0],d1[0:mz1]) copyout(r0[0:cnt])
for(i=0;i<cnt;i++){
double f0=d0[i*m0];
aplint32 f1=d1[i*m1];
double s0=pow((double)f0,(double)f1);
r0[i]=s0;
}
if((&env[0][0])->p!=p0){relp(&env[0][0]);(&env[0][0])->p=p0;}
}
{LOCALP *rslt=&env[0][0];LOCALP *rgt=&env[0][0];double l[]={0.31938153,-0.356563782,1.781477937,-1.821255978,1.33027442};
LOCALP*orz;LOCALP tp;tp.p=NULL;int tpused=0;
if(rslt==rgt){orz=rslt;rslt=&tp;tpused=1;}
getarray(APLDOUB,0,NULL,rslt);BOUND c=1;
{BOUND i;for(i=0;i<rgt->p->RANK;i++){c*=rgt->p->SHAPETC[i];}}
double *z;double *r;
z=ARRAYSTART(rslt->p);
r=ARRAYSTART(rgt->p);

{BOUND i;
#pragma simd reduction(+:z)
for(i=0;i<c;i++){z[0]+=l[i]*r[i];}}
if(tpused){relp(orz);orz->p=zap(rslt->p);}
}
z->p=zap((&env[0][0])->p);cutp(&env0[0]);
}

void static inline fn_1_4_10_8_8_6_7ff(LOCALP*z,LOCALP*l,LOCALP*r,LOCALP*penv[]){
LOCALP env0[1];LOCALP*env[]={env0,penv[0],penv[1]};
{BOUND i;for(i=0;i<1;i++){regp(&env0[i]);}}
{BOUND prk=0;BOUND sp[15];BOUND cnt=1,i=0;
if(prk!=(r)->p->RANK){if(prk==0){
prk=(r)->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(r)->p->SHAPETC[i];}}
}else if((r)->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(r)->p->SHAPETC[i])error(4);}}
}
if(prk!=1){if(prk==0){prk=1;sp[0]=5;}else error(4);}else if(sp[0]!=5)error(4);
{BOUND i;for(i=0;i<prk;i++){cnt*=sp[i];}}
double *d0=ARRAYSTART((r)->p);
BOUND m0=(r)->p->RANK==0?0:1;
BOUND mz0=(r)->p->RANK==0?1:cnt;
aplint32 d1[]={1,2,3,4,5};
BOUND m1=cnt;
BOUND mz1=cnt;
POCKET*p0;
if(NULL==(&env[0][0])->p||prk!=(&env[0][0])->p->RANK
||(&env[0][0])->p->ELTYPE!=APLDOUB)
p0=getarray(APLDOUB,prk,sp,NULL);
else p0=(&env[0][0])->p;
double *r0=ARRAYSTART(p0);
#pragma acc parallel loop copyin(d0[0:mz0],d1[0:mz1]) copyout(r0[0:cnt])
for(i=0;i<cnt;i++){
double f0=d0[i*m0];
aplint32 f1=d1[i*m1];
double s0=pow((double)f0,(double)f1);
r0[i]=s0;
}
if((&env[0][0])->p!=p0){relp(&env[0][0]);(&env[0][0])->p=p0;}
}
{LOCALP *rslt=&env[0][0];LOCALP *rgt=&env[0][0];double l[]={0.31938153,-0.356563782,1.781477937,-1.821255978,1.33027442};
LOCALP*orz;LOCALP tp;tp.p=NULL;int tpused=0;
if(rslt==rgt){orz=rslt;rslt=&tp;tpused=1;}
getarray(APLDOUB,0,NULL,rslt);BOUND c=1;
{BOUND i;for(i=0;i<rgt->p->RANK;i++){c*=rgt->p->SHAPETC[i];}}
double *z;double *r;
z=ARRAYSTART(rslt->p);
r=ARRAYSTART(rgt->p);

{BOUND i;
#pragma simd reduction(+:z)
for(i=0;i<c;i++){z[0]+=l[i]*r[i];}}
if(tpused){relp(orz);orz->p=zap(rslt->p);}
}
z->p=zap((&env[0][0])->p);cutp(&env0[0]);
}

void static inline fn_1_4_10_8_8_6_7fn(LOCALP*z,LOCALP*l,LOCALP*r,LOCALP*penv[]){
LOCALP env0[1];LOCALP*env[]={env0,penv[0],penv[1]};
{BOUND i;for(i=0;i<1;i++){regp(&env0[i]);}}
{BOUND prk=0;BOUND sp[15];BOUND cnt=1,i=0;
if(prk!=(r)->p->RANK){if(prk==0){
prk=(r)->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(r)->p->SHAPETC[i];}}
}else if((r)->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(r)->p->SHAPETC[i])error(4);}}
}
if(prk!=1){if(prk==0){prk=1;sp[0]=5;}else error(4);}else if(sp[0]!=5)error(4);
{BOUND i;for(i=0;i<prk;i++){cnt*=sp[i];}}
double *d0=ARRAYSTART((r)->p);
BOUND m0=(r)->p->RANK==0?0:1;
BOUND mz0=(r)->p->RANK==0?1:cnt;
aplint32 d1[]={1,2,3,4,5};
BOUND m1=cnt;
BOUND mz1=cnt;
POCKET*p0;
if(NULL==(&env[0][0])->p||prk!=(&env[0][0])->p->RANK
||(&env[0][0])->p->ELTYPE!=APLDOUB)
p0=getarray(APLDOUB,prk,sp,NULL);
else p0=(&env[0][0])->p;
double *r0=ARRAYSTART(p0);
#pragma acc parallel loop copyin(d0[0:mz0],d1[0:mz1]) copyout(r0[0:cnt])
for(i=0;i<cnt;i++){
double f0=d0[i*m0];
aplint32 f1=d1[i*m1];
double s0=pow((double)f0,(double)f1);
r0[i]=s0;
}
if((&env[0][0])->p!=p0){relp(&env[0][0]);(&env[0][0])->p=p0;}
}
{LOCALP *rslt=&env[0][0];LOCALP *rgt=&env[0][0];double l[]={0.31938153,-0.356563782,1.781477937,-1.821255978,1.33027442};
LOCALP*orz;LOCALP tp;tp.p=NULL;int tpused=0;
if(rslt==rgt){orz=rslt;rslt=&tp;tpused=1;}
getarray(APLDOUB,0,NULL,rslt);BOUND c=1;
{BOUND i;for(i=0;i<rgt->p->RANK;i++){c*=rgt->p->SHAPETC[i];}}
double *z;double *r;
z=ARRAYSTART(rslt->p);
r=ARRAYSTART(rgt->p);

{BOUND i;
#pragma simd reduction(+:z)
for(i=0;i<c;i++){z[0]+=l[i]*r[i];}}
if(tpused){relp(orz);orz->p=zap(rslt->p);}
}
z->p=zap((&env[0][0])->p);cutp(&env0[0]);
}

void static inline fn_1_5ii(LOCALP*z,LOCALP*l,LOCALP*r,LOCALP*penv[]){
LOCALP env0[7];LOCALP*env[]={env0,penv[0]};
{BOUND i;for(i=0;i<7;i++){regp(&env0[i]);}}
{LOCALP *rslt=&env[0][0];LOCALP *rgt=r;aplint32 v[]={0};
BOUND c,j,k,m,*p,r;j=1;
r=rgt->p->RANK-j;
BOUND sp[15];{BOUND i;for(i=0;i<r;i++){sp[i]=rgt->p->SHAPETC[j+i];}}
LOCALP tp;int tpused=0;tp.p=NULL;LOCALP*orz;
if(rslt==rgt){orz=rslt;rslt=&tp;tpused=1;}
relp(rslt);getarray(APLLONG,(unsigned)r,sp,rslt);
p=rgt->p->SHAPETC;c=1;{BOUND i;for(i=0;i<r;i++){c*=sp[i];}}
m=c;k=0;
{BOUND i;for(i=0;i<j;i++){BOUND a=j-(i+1);k+=m*v[a];m*=p[a];}}
aplint32 *src,*dst;
dst=ARRAYSTART(rslt->p);src=ARRAYSTART(rgt->p);
{BOUND i;
#pragma simd
for(i=0;i<c;i++){dst[i]=src[k+i];}}
if(tpused){relp(orz);orz->p=zap(rslt->p);}
}
{LOCALP *rslt=&env[0][1];LOCALP *rgt=r;aplint32 v[]={1};
BOUND c,j,k,m,*p,r;j=1;
r=rgt->p->RANK-j;
BOUND sp[15];{BOUND i;for(i=0;i<r;i++){sp[i]=rgt->p->SHAPETC[j+i];}}
LOCALP tp;int tpused=0;tp.p=NULL;LOCALP*orz;
if(rslt==rgt){orz=rslt;rslt=&tp;tpused=1;}
relp(rslt);getarray(APLLONG,(unsigned)r,sp,rslt);
p=rgt->p->SHAPETC;c=1;{BOUND i;for(i=0;i<r;i++){c*=sp[i];}}
m=c;k=0;
{BOUND i;for(i=0;i<j;i++){BOUND a=j-(i+1);k+=m*v[a];m*=p[a];}}
aplint32 *src,*dst;
dst=ARRAYSTART(rslt->p);src=ARRAYSTART(rgt->p);
{BOUND i;
#pragma simd
for(i=0;i<c;i++){dst[i]=src[k+i];}}
if(tpused){relp(orz);orz->p=zap(rslt->p);}
}
{BOUND prk=0;BOUND sp[15];BOUND cnt=1,i=0;
if(prk!=(l)->p->RANK){if(prk==0){
prk=(l)->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(l)->p->SHAPETC[i];}}
}else if((l)->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(l)->p->SHAPETC[i])error(4);}}
}
if(prk!=(&env[0][0])->p->RANK){if(prk==0){
prk=(&env[0][0])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][0])->p->SHAPETC[i];}}
}else if((&env[0][0])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][0])->p->SHAPETC[i])error(4);}}
}
if(prk!=(&env[0][1])->p->RANK){if(prk==0){
prk=(&env[0][1])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][1])->p->SHAPETC[i];}}
}else if((&env[0][1])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][1])->p->SHAPETC[i])error(4);}}
}
{BOUND i;for(i=0;i<prk;i++){cnt*=sp[i];}}
aplint32 *d0=ARRAYSTART((l)->p);
BOUND m0=(l)->p->RANK==0?0:1;
BOUND mz0=(l)->p->RANK==0?1:cnt;
aplint32 *d1=ARRAYSTART((&env[0][0])->p);
BOUND m1=(&env[0][0])->p->RANK==0?0:1;
BOUND mz1=(&env[0][0])->p->RANK==0?1:cnt;
aplint32 *d2=ARRAYSTART((&env[0][1])->p);
BOUND m2=(&env[0][1])->p->RANK==0?0:1;
BOUND mz2=(&env[0][1])->p->RANK==0?1:cnt;
POCKET*p0,*p1,*p2;
if(NULL==(&env[0][2])->p||prk!=(&env[0][2])->p->RANK
||(&env[0][2])->p->ELTYPE!=APLDOUB)
p0=getarray(APLDOUB,prk,sp,NULL);
else p0=(&env[0][2])->p;
if(NULL==(&env[0][3])->p||prk!=(&env[0][3])->p->RANK
||(&env[0][3])->p->ELTYPE!=APLDOUB)
p1=getarray(APLDOUB,prk,sp,NULL);
else p1=(&env[0][3])->p;
if(NULL==(&env[0][4])->p||prk!=(&env[0][4])->p->RANK
||(&env[0][4])->p->ELTYPE!=APLDOUB)
p2=getarray(APLDOUB,prk,sp,NULL);
else p2=(&env[0][4])->p;
double *r0=ARRAYSTART(p0);
double *r1=ARRAYSTART(p1);
double *r2=ARRAYSTART(p2);
#pragma acc parallel loop copyin(d0[0:mz0],d1[0:mz1],d2[0:mz2]) copyout(r0[0:cnt],r1[0:cnt],r2[0:cnt])
for(i=0;i<cnt;i++){
aplint32 f0=d0[i*m0];
aplint32 f1=d1[i*m1];
aplint32 f2=d2[i*m2];
double s0=pow((double)f0,(double)0.5);
double s1=0.03*s0;
double s2=0.02045*f0;
double s3=((double)f1)/((double)f2);
double s4=log((double)s3);
double s5=s4+s2;
double s6=((double)s5)/((double)s1);
double s7=s6-s1;
r0[i]=s7;
r1[i]=s6;
r2[i]=s4;
}
if((&env[0][2])->p!=p0){relp(&env[0][2]);(&env[0][2])->p=p0;}
if((&env[0][3])->p!=p1){relp(&env[0][3]);(&env[0][3])->p=p1;}
if((&env[0][4])->p!=p2){relp(&env[0][4]);(&env[0][4])->p=p2;}
}
fn_1_4fn(&env[0][3],NULL,&env[0][3],env);
fn_1_4fn(&env[0][2],NULL,&env[0][2],env);
{BOUND prk=0;BOUND sp[15];BOUND cnt=1,i=0;
if(prk!=(l)->p->RANK){if(prk==0){
prk=(l)->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(l)->p->SHAPETC[i];}}
}else if((l)->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(l)->p->SHAPETC[i])error(4);}}
}
if(prk!=(&env[0][3])->p->RANK){if(prk==0){
prk=(&env[0][3])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][3])->p->SHAPETC[i];}}
}else if((&env[0][3])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][3])->p->SHAPETC[i])error(4);}}
}
if(prk!=(&env[0][0])->p->RANK){if(prk==0){
prk=(&env[0][0])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][0])->p->SHAPETC[i];}}
}else if((&env[0][0])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][0])->p->SHAPETC[i])error(4);}}
}
if(prk!=(&env[0][2])->p->RANK){if(prk==0){
prk=(&env[0][2])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][2])->p->SHAPETC[i];}}
}else if((&env[0][2])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][2])->p->SHAPETC[i])error(4);}}
}
if(prk!=(&env[0][1])->p->RANK){if(prk==0){
prk=(&env[0][1])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][1])->p->SHAPETC[i];}}
}else if((&env[0][1])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][1])->p->SHAPETC[i])error(4);}}
}
{BOUND i;for(i=0;i<prk;i++){cnt*=sp[i];}}
aplint32 *d0=ARRAYSTART((l)->p);
BOUND m0=(l)->p->RANK==0?0:1;
BOUND mz0=(l)->p->RANK==0?1:cnt;
double *d1=ARRAYSTART((&env[0][3])->p);
BOUND m1=(&env[0][3])->p->RANK==0?0:1;
BOUND mz1=(&env[0][3])->p->RANK==0?1:cnt;
aplint32 *d2=ARRAYSTART((&env[0][0])->p);
BOUND m2=(&env[0][0])->p->RANK==0?0:1;
BOUND mz2=(&env[0][0])->p->RANK==0?1:cnt;
double *d3=ARRAYSTART((&env[0][2])->p);
BOUND m3=(&env[0][2])->p->RANK==0?0:1;
BOUND mz3=(&env[0][2])->p->RANK==0?1:cnt;
aplint32 *d4=ARRAYSTART((&env[0][1])->p);
BOUND m4=(&env[0][1])->p->RANK==0?0:1;
BOUND mz4=(&env[0][1])->p->RANK==0?1:cnt;
POCKET*p0,*p1,*p2,*p3,*p4,*p5;
if(NULL==(&env[0][4])->p||prk!=(&env[0][4])->p->RANK
||(&env[0][4])->p->ELTYPE!=APLDOUB)
p0=getarray(APLDOUB,prk,sp,NULL);
else p0=(&env[0][4])->p;
if(NULL==(&env[0][5])->p||prk!=(&env[0][5])->p->RANK
||(&env[0][5])->p->ELTYPE!=APLDOUB)
p1=getarray(APLDOUB,prk,sp,NULL);
else p1=(&env[0][5])->p;
if(NULL==(&env[0][6])->p||prk!=(&env[0][6])->p->RANK
||(&env[0][6])->p->ELTYPE!=APLDOUB)
p2=getarray(APLDOUB,prk,sp,NULL);
else p2=(&env[0][6])->p;
if(NULL==(&env[0][2])->p||prk!=(&env[0][2])->p->RANK
||(&env[0][2])->p->ELTYPE!=APLDOUB)
p3=getarray(APLDOUB,prk,sp,NULL);
else p3=(&env[0][2])->p;
if(NULL==(&env[0][1])->p||prk!=(&env[0][1])->p->RANK
||(&env[0][1])->p->ELTYPE!=APLDOUB)
p4=getarray(APLDOUB,prk,sp,NULL);
else p4=(&env[0][1])->p;
if(NULL==(&env[0][0])->p||prk!=(&env[0][0])->p->RANK
||(&env[0][0])->p->ELTYPE!=APLDOUB)
p5=getarray(APLDOUB,prk,sp,NULL);
else p5=(&env[0][0])->p;
double *r0=ARRAYSTART(p0);
double *r1=ARRAYSTART(p1);
double *r2=ARRAYSTART(p2);
double *r3=ARRAYSTART(p3);
double *r4=ARRAYSTART(p4);
double *r5=ARRAYSTART(p5);
#pragma acc parallel loop copyin(d0[0:mz0],d1[0:mz1],d2[0:mz2],d3[0:mz3],d4[0:mz4]) copyout(r0[0:cnt],r1[0:cnt],r2[0:cnt],r3[0:cnt],r4[0:cnt],r5[0:cnt])
for(i=0;i<cnt;i++){
aplint32 f0=d0[i*m0];
double f1=d1[i*m1];
aplint32 f2=d2[i*m2];
double f3=d3[i*m3];
aplint32 f4=d4[i*m4];
double s0=-0.02*f0;
double s1=exp((double)s0);
double s2=1-f1;
double s3=f2*s2;
double s4=1-f3;
double s5=s1*s4;
double s6=f4*s5;
double s7=s6-s3;
double s8=s1*f3;
double s9=f4*s8;
double s10=f2*f1;
double s11=s10-s9;
r0[i]=s1;
r1[i]=s7;
r2[i]=s6;
r3[i]=s8;
r4[i]=s9;
r5[i]=s11;
}
if((&env[0][4])->p!=p0){relp(&env[0][4]);(&env[0][4])->p=p0;}
if((&env[0][5])->p!=p1){relp(&env[0][5]);(&env[0][5])->p=p1;}
if((&env[0][6])->p!=p2){relp(&env[0][6]);(&env[0][6])->p=p2;}
if((&env[0][2])->p!=p3){relp(&env[0][2]);(&env[0][2])->p=p3;}
if((&env[0][1])->p!=p4){relp(&env[0][1]);(&env[0][1])->p=p4;}
if((&env[0][0])->p!=p5){relp(&env[0][0]);(&env[0][0])->p=p5;}
}
{LOCALP *rslt=&env[0][0];LOCALP *rgt=&env[0][5];LOCALP *lft=&env[0][0];
BOUND s[]={rgt->p->SHAPETC[0],2};LOCALP*orz;LOCALP tp;tp.p=NULL;int tpused=0;
if(rslt==lft||rslt==rgt){orz=rslt;rslt=&tp;tpused=1;}
relp(rslt);getarray(APLDOUB,2,s,rslt);
double *z;double *r;double *l;
z=ARRAYSTART(rslt->p);
r=ARRAYSTART(rgt->p);
l=ARRAYSTART(lft->p);
{BOUND i;
#pragma simd
for(i=0;i<s[0];i++){z[i*2]=l[i];z[i*2+1]=r[i];}}
if(tpused){relp(orz);orz->p=zap(rslt->p);}
}
z->p=zap((&env[0][0])->p);cutp(&env0[0]);
}

void static inline fn_1_5if(LOCALP*z,LOCALP*l,LOCALP*r,LOCALP*penv[]){
LOCALP env0[7];LOCALP*env[]={env0,penv[0]};
{BOUND i;for(i=0;i<7;i++){regp(&env0[i]);}}
{LOCALP *rslt=&env[0][0];LOCALP *rgt=r;aplint32 v[]={0};
BOUND c,j,k,m,*p,r;j=1;
r=rgt->p->RANK-j;
BOUND sp[15];{BOUND i;for(i=0;i<r;i++){sp[i]=rgt->p->SHAPETC[j+i];}}
LOCALP tp;int tpused=0;tp.p=NULL;LOCALP*orz;
if(rslt==rgt){orz=rslt;rslt=&tp;tpused=1;}
relp(rslt);getarray(APLLONG,(unsigned)r,sp,rslt);
p=rgt->p->SHAPETC;c=1;{BOUND i;for(i=0;i<r;i++){c*=sp[i];}}
m=c;k=0;
{BOUND i;for(i=0;i<j;i++){BOUND a=j-(i+1);k+=m*v[a];m*=p[a];}}
aplint32 *src,*dst;
dst=ARRAYSTART(rslt->p);src=ARRAYSTART(rgt->p);
{BOUND i;
#pragma simd
for(i=0;i<c;i++){dst[i]=src[k+i];}}
if(tpused){relp(orz);orz->p=zap(rslt->p);}
}
{LOCALP *rslt=&env[0][1];LOCALP *rgt=r;aplint32 v[]={1};
BOUND c,j,k,m,*p,r;j=1;
r=rgt->p->RANK-j;
BOUND sp[15];{BOUND i;for(i=0;i<r;i++){sp[i]=rgt->p->SHAPETC[j+i];}}
LOCALP tp;int tpused=0;tp.p=NULL;LOCALP*orz;
if(rslt==rgt){orz=rslt;rslt=&tp;tpused=1;}
relp(rslt);getarray(APLLONG,(unsigned)r,sp,rslt);
p=rgt->p->SHAPETC;c=1;{BOUND i;for(i=0;i<r;i++){c*=sp[i];}}
m=c;k=0;
{BOUND i;for(i=0;i<j;i++){BOUND a=j-(i+1);k+=m*v[a];m*=p[a];}}
aplint32 *src,*dst;
dst=ARRAYSTART(rslt->p);src=ARRAYSTART(rgt->p);
{BOUND i;
#pragma simd
for(i=0;i<c;i++){dst[i]=src[k+i];}}
if(tpused){relp(orz);orz->p=zap(rslt->p);}
}
{BOUND prk=0;BOUND sp[15];BOUND cnt=1,i=0;
if(prk!=(l)->p->RANK){if(prk==0){
prk=(l)->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(l)->p->SHAPETC[i];}}
}else if((l)->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(l)->p->SHAPETC[i])error(4);}}
}
if(prk!=(&env[0][0])->p->RANK){if(prk==0){
prk=(&env[0][0])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][0])->p->SHAPETC[i];}}
}else if((&env[0][0])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][0])->p->SHAPETC[i])error(4);}}
}
if(prk!=(&env[0][1])->p->RANK){if(prk==0){
prk=(&env[0][1])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][1])->p->SHAPETC[i];}}
}else if((&env[0][1])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][1])->p->SHAPETC[i])error(4);}}
}
{BOUND i;for(i=0;i<prk;i++){cnt*=sp[i];}}
double *d0=ARRAYSTART((l)->p);
BOUND m0=(l)->p->RANK==0?0:1;
BOUND mz0=(l)->p->RANK==0?1:cnt;
aplint32 *d1=ARRAYSTART((&env[0][0])->p);
BOUND m1=(&env[0][0])->p->RANK==0?0:1;
BOUND mz1=(&env[0][0])->p->RANK==0?1:cnt;
aplint32 *d2=ARRAYSTART((&env[0][1])->p);
BOUND m2=(&env[0][1])->p->RANK==0?0:1;
BOUND mz2=(&env[0][1])->p->RANK==0?1:cnt;
POCKET*p0,*p1,*p2;
if(NULL==(&env[0][2])->p||prk!=(&env[0][2])->p->RANK
||(&env[0][2])->p->ELTYPE!=APLDOUB)
p0=getarray(APLDOUB,prk,sp,NULL);
else p0=(&env[0][2])->p;
if(NULL==(&env[0][3])->p||prk!=(&env[0][3])->p->RANK
||(&env[0][3])->p->ELTYPE!=APLDOUB)
p1=getarray(APLDOUB,prk,sp,NULL);
else p1=(&env[0][3])->p;
if(NULL==(&env[0][4])->p||prk!=(&env[0][4])->p->RANK
||(&env[0][4])->p->ELTYPE!=APLDOUB)
p2=getarray(APLDOUB,prk,sp,NULL);
else p2=(&env[0][4])->p;
double *r0=ARRAYSTART(p0);
double *r1=ARRAYSTART(p1);
double *r2=ARRAYSTART(p2);
#pragma acc parallel loop copyin(d0[0:mz0],d1[0:mz1],d2[0:mz2]) copyout(r0[0:cnt],r1[0:cnt],r2[0:cnt])
for(i=0;i<cnt;i++){
double f0=d0[i*m0];
aplint32 f1=d1[i*m1];
aplint32 f2=d2[i*m2];
double s0=pow((double)f0,(double)0.5);
double s1=0.03*s0;
double s2=0.02045*f0;
double s3=((double)f1)/((double)f2);
double s4=log((double)s3);
double s5=s4+s2;
double s6=((double)s5)/((double)s1);
double s7=s6-s1;
r0[i]=s7;
r1[i]=s6;
r2[i]=s4;
}
if((&env[0][2])->p!=p0){relp(&env[0][2]);(&env[0][2])->p=p0;}
if((&env[0][3])->p!=p1){relp(&env[0][3]);(&env[0][3])->p=p1;}
if((&env[0][4])->p!=p2){relp(&env[0][4]);(&env[0][4])->p=p2;}
}
fn_1_4fn(&env[0][3],NULL,&env[0][3],env);
fn_1_4fn(&env[0][2],NULL,&env[0][2],env);
{BOUND prk=0;BOUND sp[15];BOUND cnt=1,i=0;
if(prk!=(l)->p->RANK){if(prk==0){
prk=(l)->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(l)->p->SHAPETC[i];}}
}else if((l)->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(l)->p->SHAPETC[i])error(4);}}
}
if(prk!=(&env[0][3])->p->RANK){if(prk==0){
prk=(&env[0][3])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][3])->p->SHAPETC[i];}}
}else if((&env[0][3])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][3])->p->SHAPETC[i])error(4);}}
}
if(prk!=(&env[0][0])->p->RANK){if(prk==0){
prk=(&env[0][0])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][0])->p->SHAPETC[i];}}
}else if((&env[0][0])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][0])->p->SHAPETC[i])error(4);}}
}
if(prk!=(&env[0][2])->p->RANK){if(prk==0){
prk=(&env[0][2])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][2])->p->SHAPETC[i];}}
}else if((&env[0][2])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][2])->p->SHAPETC[i])error(4);}}
}
if(prk!=(&env[0][1])->p->RANK){if(prk==0){
prk=(&env[0][1])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][1])->p->SHAPETC[i];}}
}else if((&env[0][1])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][1])->p->SHAPETC[i])error(4);}}
}
{BOUND i;for(i=0;i<prk;i++){cnt*=sp[i];}}
double *d0=ARRAYSTART((l)->p);
BOUND m0=(l)->p->RANK==0?0:1;
BOUND mz0=(l)->p->RANK==0?1:cnt;
double *d1=ARRAYSTART((&env[0][3])->p);
BOUND m1=(&env[0][3])->p->RANK==0?0:1;
BOUND mz1=(&env[0][3])->p->RANK==0?1:cnt;
aplint32 *d2=ARRAYSTART((&env[0][0])->p);
BOUND m2=(&env[0][0])->p->RANK==0?0:1;
BOUND mz2=(&env[0][0])->p->RANK==0?1:cnt;
double *d3=ARRAYSTART((&env[0][2])->p);
BOUND m3=(&env[0][2])->p->RANK==0?0:1;
BOUND mz3=(&env[0][2])->p->RANK==0?1:cnt;
aplint32 *d4=ARRAYSTART((&env[0][1])->p);
BOUND m4=(&env[0][1])->p->RANK==0?0:1;
BOUND mz4=(&env[0][1])->p->RANK==0?1:cnt;
POCKET*p0,*p1,*p2,*p3,*p4,*p5;
if(NULL==(&env[0][4])->p||prk!=(&env[0][4])->p->RANK
||(&env[0][4])->p->ELTYPE!=APLDOUB)
p0=getarray(APLDOUB,prk,sp,NULL);
else p0=(&env[0][4])->p;
if(NULL==(&env[0][5])->p||prk!=(&env[0][5])->p->RANK
||(&env[0][5])->p->ELTYPE!=APLDOUB)
p1=getarray(APLDOUB,prk,sp,NULL);
else p1=(&env[0][5])->p;
if(NULL==(&env[0][6])->p||prk!=(&env[0][6])->p->RANK
||(&env[0][6])->p->ELTYPE!=APLDOUB)
p2=getarray(APLDOUB,prk,sp,NULL);
else p2=(&env[0][6])->p;
if(NULL==(&env[0][2])->p||prk!=(&env[0][2])->p->RANK
||(&env[0][2])->p->ELTYPE!=APLDOUB)
p3=getarray(APLDOUB,prk,sp,NULL);
else p3=(&env[0][2])->p;
if(NULL==(&env[0][1])->p||prk!=(&env[0][1])->p->RANK
||(&env[0][1])->p->ELTYPE!=APLDOUB)
p4=getarray(APLDOUB,prk,sp,NULL);
else p4=(&env[0][1])->p;
if(NULL==(&env[0][0])->p||prk!=(&env[0][0])->p->RANK
||(&env[0][0])->p->ELTYPE!=APLDOUB)
p5=getarray(APLDOUB,prk,sp,NULL);
else p5=(&env[0][0])->p;
double *r0=ARRAYSTART(p0);
double *r1=ARRAYSTART(p1);
double *r2=ARRAYSTART(p2);
double *r3=ARRAYSTART(p3);
double *r4=ARRAYSTART(p4);
double *r5=ARRAYSTART(p5);
#pragma acc parallel loop copyin(d0[0:mz0],d1[0:mz1],d2[0:mz2],d3[0:mz3],d4[0:mz4]) copyout(r0[0:cnt],r1[0:cnt],r2[0:cnt],r3[0:cnt],r4[0:cnt],r5[0:cnt])
for(i=0;i<cnt;i++){
double f0=d0[i*m0];
double f1=d1[i*m1];
aplint32 f2=d2[i*m2];
double f3=d3[i*m3];
aplint32 f4=d4[i*m4];
double s0=-0.02*f0;
double s1=exp((double)s0);
double s2=1-f1;
double s3=f2*s2;
double s4=1-f3;
double s5=s1*s4;
double s6=f4*s5;
double s7=s6-s3;
double s8=s1*f3;
double s9=f4*s8;
double s10=f2*f1;
double s11=s10-s9;
r0[i]=s1;
r1[i]=s7;
r2[i]=s6;
r3[i]=s8;
r4[i]=s9;
r5[i]=s11;
}
if((&env[0][4])->p!=p0){relp(&env[0][4]);(&env[0][4])->p=p0;}
if((&env[0][5])->p!=p1){relp(&env[0][5]);(&env[0][5])->p=p1;}
if((&env[0][6])->p!=p2){relp(&env[0][6]);(&env[0][6])->p=p2;}
if((&env[0][2])->p!=p3){relp(&env[0][2]);(&env[0][2])->p=p3;}
if((&env[0][1])->p!=p4){relp(&env[0][1]);(&env[0][1])->p=p4;}
if((&env[0][0])->p!=p5){relp(&env[0][0]);(&env[0][0])->p=p5;}
}
{LOCALP *rslt=&env[0][0];LOCALP *rgt=&env[0][5];LOCALP *lft=&env[0][0];
BOUND s[]={rgt->p->SHAPETC[0],2};LOCALP*orz;LOCALP tp;tp.p=NULL;int tpused=0;
if(rslt==lft||rslt==rgt){orz=rslt;rslt=&tp;tpused=1;}
relp(rslt);getarray(APLDOUB,2,s,rslt);
double *z;double *r;double *l;
z=ARRAYSTART(rslt->p);
r=ARRAYSTART(rgt->p);
l=ARRAYSTART(lft->p);
{BOUND i;
#pragma simd
for(i=0;i<s[0];i++){z[i*2]=l[i];z[i*2+1]=r[i];}}
if(tpused){relp(orz);orz->p=zap(rslt->p);}
}
z->p=zap((&env[0][0])->p);cutp(&env0[0]);
}

void static inline fn_1_5in(LOCALP*z,LOCALP*l,LOCALP*r,LOCALP*penv[]){
LOCALP env0[7];LOCALP*env[]={env0,penv[0]};
{BOUND i;for(i=0;i<7;i++){regp(&env0[i]);}}
{LOCALP *rslt=&env[0][0];LOCALP *rgt=r;aplint32 v[]={0};
BOUND c,j,k,m,*p,r;j=1;
r=rgt->p->RANK-j;
BOUND sp[15];{BOUND i;for(i=0;i<r;i++){sp[i]=rgt->p->SHAPETC[j+i];}}
LOCALP tp;int tpused=0;tp.p=NULL;LOCALP*orz;
if(rslt==rgt){orz=rslt;rslt=&tp;tpused=1;}
relp(rslt);getarray(APLLONG,(unsigned)r,sp,rslt);
p=rgt->p->SHAPETC;c=1;{BOUND i;for(i=0;i<r;i++){c*=sp[i];}}
m=c;k=0;
{BOUND i;for(i=0;i<j;i++){BOUND a=j-(i+1);k+=m*v[a];m*=p[a];}}
aplint32 *src,*dst;
dst=ARRAYSTART(rslt->p);src=ARRAYSTART(rgt->p);
{BOUND i;
#pragma simd
for(i=0;i<c;i++){dst[i]=src[k+i];}}
if(tpused){relp(orz);orz->p=zap(rslt->p);}
}
{LOCALP *rslt=&env[0][1];LOCALP *rgt=r;aplint32 v[]={1};
BOUND c,j,k,m,*p,r;j=1;
r=rgt->p->RANK-j;
BOUND sp[15];{BOUND i;for(i=0;i<r;i++){sp[i]=rgt->p->SHAPETC[j+i];}}
LOCALP tp;int tpused=0;tp.p=NULL;LOCALP*orz;
if(rslt==rgt){orz=rslt;rslt=&tp;tpused=1;}
relp(rslt);getarray(APLLONG,(unsigned)r,sp,rslt);
p=rgt->p->SHAPETC;c=1;{BOUND i;for(i=0;i<r;i++){c*=sp[i];}}
m=c;k=0;
{BOUND i;for(i=0;i<j;i++){BOUND a=j-(i+1);k+=m*v[a];m*=p[a];}}
aplint32 *src,*dst;
dst=ARRAYSTART(rslt->p);src=ARRAYSTART(rgt->p);
{BOUND i;
#pragma simd
for(i=0;i<c;i++){dst[i]=src[k+i];}}
if(tpused){relp(orz);orz->p=zap(rslt->p);}
}
{BOUND prk=0;BOUND sp[15];BOUND cnt=1,i=0;
if(prk!=(l)->p->RANK){if(prk==0){
prk=(l)->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(l)->p->SHAPETC[i];}}
}else if((l)->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(l)->p->SHAPETC[i])error(4);}}
}
if(prk!=(&env[0][0])->p->RANK){if(prk==0){
prk=(&env[0][0])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][0])->p->SHAPETC[i];}}
}else if((&env[0][0])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][0])->p->SHAPETC[i])error(4);}}
}
if(prk!=(&env[0][1])->p->RANK){if(prk==0){
prk=(&env[0][1])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][1])->p->SHAPETC[i];}}
}else if((&env[0][1])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][1])->p->SHAPETC[i])error(4);}}
}
{BOUND i;for(i=0;i<prk;i++){cnt*=sp[i];}}
/* XXX */ aplint32 *d0=ARRAYSTART((l)->p);
BOUND m0=(l)->p->RANK==0?0:1;
BOUND mz0=(l)->p->RANK==0?1:cnt;
aplint32 *d1=ARRAYSTART((&env[0][0])->p);
BOUND m1=(&env[0][0])->p->RANK==0?0:1;
BOUND mz1=(&env[0][0])->p->RANK==0?1:cnt;
aplint32 *d2=ARRAYSTART((&env[0][1])->p);
BOUND m2=(&env[0][1])->p->RANK==0?0:1;
BOUND mz2=(&env[0][1])->p->RANK==0?1:cnt;
POCKET*p0,*p1,*p2;
if(NULL==(&env[0][2])->p||prk!=(&env[0][2])->p->RANK
||(&env[0][2])->p->ELTYPE!=/* XXX */ APLLONG)
p0=getarray(/* XXX */ APLLONG,prk,sp,NULL);
else p0=(&env[0][2])->p;
if(NULL==(&env[0][3])->p||prk!=(&env[0][3])->p->RANK
||(&env[0][3])->p->ELTYPE!=/* XXX */ APLLONG)
p1=getarray(/* XXX */ APLLONG,prk,sp,NULL);
else p1=(&env[0][3])->p;
if(NULL==(&env[0][4])->p||prk!=(&env[0][4])->p->RANK
||(&env[0][4])->p->ELTYPE!=APLDOUB)
p2=getarray(APLDOUB,prk,sp,NULL);
else p2=(&env[0][4])->p;
/* XXX */ aplint32 *r0=ARRAYSTART(p0);
/* XXX */ aplint32 *r1=ARRAYSTART(p1);
double *r2=ARRAYSTART(p2);
#pragma acc parallel loop copyin(d0[0:mz0],d1[0:mz1],d2[0:mz2]) copyout(r0[0:cnt],r1[0:cnt],r2[0:cnt])
for(i=0;i<cnt;i++){
/* XXX */ aplint32 f0=d0[i*m0];
aplint32 f1=d1[i*m1];
aplint32 f2=d2[i*m2];
/* XXX */ aplint32 s0=pow((double)f0,(double)0.5);
/* XXX */ aplint32 s1=0.03*s0;
/* XXX */ aplint32 s2=0.02045*f0;
double s3=((double)f1)/((double)f2);
double s4=log((double)s3);
/* XXX */ aplint32 s5=s4+s2;
/* XXX */ aplint32 s6=((double)s5)/((double)s1);
/* XXX */ aplint32 s7=s6-s1;
r0[i]=s7;
r1[i]=s6;
r2[i]=s4;
}
if((&env[0][2])->p!=p0){relp(&env[0][2]);(&env[0][2])->p=p0;}
if((&env[0][3])->p!=p1){relp(&env[0][3]);(&env[0][3])->p=p1;}
if((&env[0][4])->p!=p2){relp(&env[0][4]);(&env[0][4])->p=p2;}
}
fn_1_4in(&env[0][3],NULL,&env[0][3],env);
fn_1_4in(&env[0][2],NULL,&env[0][2],env);
{BOUND prk=0;BOUND sp[15];BOUND cnt=1,i=0;
if(prk!=(l)->p->RANK){if(prk==0){
prk=(l)->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(l)->p->SHAPETC[i];}}
}else if((l)->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(l)->p->SHAPETC[i])error(4);}}
}
if(prk!=(&env[0][3])->p->RANK){if(prk==0){
prk=(&env[0][3])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][3])->p->SHAPETC[i];}}
}else if((&env[0][3])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][3])->p->SHAPETC[i])error(4);}}
}
if(prk!=(&env[0][0])->p->RANK){if(prk==0){
prk=(&env[0][0])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][0])->p->SHAPETC[i];}}
}else if((&env[0][0])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][0])->p->SHAPETC[i])error(4);}}
}
if(prk!=(&env[0][2])->p->RANK){if(prk==0){
prk=(&env[0][2])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][2])->p->SHAPETC[i];}}
}else if((&env[0][2])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][2])->p->SHAPETC[i])error(4);}}
}
if(prk!=(&env[0][1])->p->RANK){if(prk==0){
prk=(&env[0][1])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][1])->p->SHAPETC[i];}}
}else if((&env[0][1])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][1])->p->SHAPETC[i])error(4);}}
}
{BOUND i;for(i=0;i<prk;i++){cnt*=sp[i];}}
/* XXX */ aplint32 *d0=ARRAYSTART((l)->p);
BOUND m0=(l)->p->RANK==0?0:1;
BOUND mz0=(l)->p->RANK==0?1:cnt;
/* XXX */ aplint32 *d1=ARRAYSTART((&env[0][3])->p);
BOUND m1=(&env[0][3])->p->RANK==0?0:1;
BOUND mz1=(&env[0][3])->p->RANK==0?1:cnt;
aplint32 *d2=ARRAYSTART((&env[0][0])->p);
BOUND m2=(&env[0][0])->p->RANK==0?0:1;
BOUND mz2=(&env[0][0])->p->RANK==0?1:cnt;
/* XXX */ aplint32 *d3=ARRAYSTART((&env[0][2])->p);
BOUND m3=(&env[0][2])->p->RANK==0?0:1;
BOUND mz3=(&env[0][2])->p->RANK==0?1:cnt;
aplint32 *d4=ARRAYSTART((&env[0][1])->p);
BOUND m4=(&env[0][1])->p->RANK==0?0:1;
BOUND mz4=(&env[0][1])->p->RANK==0?1:cnt;
POCKET*p0,*p1,*p2,*p3,*p4,*p5;
if(NULL==(&env[0][4])->p||prk!=(&env[0][4])->p->RANK
||(&env[0][4])->p->ELTYPE!=/* XXX */ APLLONG)
p0=getarray(/* XXX */ APLLONG,prk,sp,NULL);
else p0=(&env[0][4])->p;
if(NULL==(&env[0][5])->p||prk!=(&env[0][5])->p->RANK
||(&env[0][5])->p->ELTYPE!=/* XXX */ APLLONG)
p1=getarray(/* XXX */ APLLONG,prk,sp,NULL);
else p1=(&env[0][5])->p;
if(NULL==(&env[0][6])->p||prk!=(&env[0][6])->p->RANK
||(&env[0][6])->p->ELTYPE!=/* XXX */ APLLONG)
p2=getarray(/* XXX */ APLLONG,prk,sp,NULL);
else p2=(&env[0][6])->p;
if(NULL==(&env[0][2])->p||prk!=(&env[0][2])->p->RANK
||(&env[0][2])->p->ELTYPE!=/* XXX */ APLLONG)
p3=getarray(/* XXX */ APLLONG,prk,sp,NULL);
else p3=(&env[0][2])->p;
if(NULL==(&env[0][1])->p||prk!=(&env[0][1])->p->RANK
||(&env[0][1])->p->ELTYPE!=/* XXX */ APLLONG)
p4=getarray(/* XXX */ APLLONG,prk,sp,NULL);
else p4=(&env[0][1])->p;
if(NULL==(&env[0][0])->p||prk!=(&env[0][0])->p->RANK
||(&env[0][0])->p->ELTYPE!=/* XXX */ APLLONG)
p5=getarray(/* XXX */ APLLONG,prk,sp,NULL);
else p5=(&env[0][0])->p;
/* XXX */ aplint32 *r0=ARRAYSTART(p0);
/* XXX */ aplint32 *r1=ARRAYSTART(p1);
/* XXX */ aplint32 *r2=ARRAYSTART(p2);
/* XXX */ aplint32 *r3=ARRAYSTART(p3);
/* XXX */ aplint32 *r4=ARRAYSTART(p4);
/* XXX */ aplint32 *r5=ARRAYSTART(p5);
#pragma acc parallel loop copyin(d0[0:mz0],d1[0:mz1],d2[0:mz2],d3[0:mz3],d4[0:mz4]) copyout(r0[0:cnt],r1[0:cnt],r2[0:cnt],r3[0:cnt],r4[0:cnt],r5[0:cnt])
for(i=0;i<cnt;i++){
/* XXX */ aplint32 f0=d0[i*m0];
/* XXX */ aplint32 f1=d1[i*m1];
aplint32 f2=d2[i*m2];
/* XXX */ aplint32 f3=d3[i*m3];
aplint32 f4=d4[i*m4];
/* XXX */ aplint32 s0=-0.02*f0;
/* XXX */ aplint32 s1=exp((double)s0);
/* XXX */ aplint32 s2=1-f1;
/* XXX */ aplint32 s3=f2*s2;
/* XXX */ aplint32 s4=1-f3;
/* XXX */ aplint32 s5=s1*s4;
/* XXX */ aplint32 s6=f4*s5;
/* XXX */ aplint32 s7=s6-s3;
/* XXX */ aplint32 s8=s1*f3;
/* XXX */ aplint32 s9=f4*s8;
/* XXX */ aplint32 s10=f2*f1;
/* XXX */ aplint32 s11=s10-s9;
r0[i]=s1;
r1[i]=s7;
r2[i]=s6;
r3[i]=s8;
r4[i]=s9;
r5[i]=s11;
}
if((&env[0][4])->p!=p0){relp(&env[0][4]);(&env[0][4])->p=p0;}
if((&env[0][5])->p!=p1){relp(&env[0][5]);(&env[0][5])->p=p1;}
if((&env[0][6])->p!=p2){relp(&env[0][6]);(&env[0][6])->p=p2;}
if((&env[0][2])->p!=p3){relp(&env[0][2]);(&env[0][2])->p=p3;}
if((&env[0][1])->p!=p4){relp(&env[0][1]);(&env[0][1])->p=p4;}
if((&env[0][0])->p!=p5){relp(&env[0][0]);(&env[0][0])->p=p5;}
}
{LOCALP *rslt=&env[0][0];LOCALP *rgt=&env[0][5];LOCALP *lft=&env[0][0];
BOUND s[]={rgt->p->SHAPETC[0],2};LOCALP*orz;LOCALP tp;tp.p=NULL;int tpused=0;
if(rslt==lft||rslt==rgt){orz=rslt;rslt=&tp;tpused=1;}
relp(rslt);getarray(/* XXX */ APLLONG,2,s,rslt);
/* XXX */ aplint32 *z;/* XXX */ aplint32 *r;/* XXX */ aplint32 *l;
z=ARRAYSTART(rslt->p);
r=ARRAYSTART(rgt->p);
l=ARRAYSTART(lft->p);
{BOUND i;
#pragma simd
for(i=0;i<s[0];i++){z[i*2]=l[i];z[i*2+1]=r[i];}}
if(tpused){relp(orz);orz->p=zap(rslt->p);}
}
z->p=zap((&env[0][0])->p);cutp(&env0[0]);
}

void static inline fn_1_5fi(LOCALP*z,LOCALP*l,LOCALP*r,LOCALP*penv[]){
LOCALP env0[7];LOCALP*env[]={env0,penv[0]};
{BOUND i;for(i=0;i<7;i++){regp(&env0[i]);}}
{LOCALP *rslt=&env[0][0];LOCALP *rgt=r;aplint32 v[]={0};
BOUND c,j,k,m,*p,r;j=1;
r=rgt->p->RANK-j;
BOUND sp[15];{BOUND i;for(i=0;i<r;i++){sp[i]=rgt->p->SHAPETC[j+i];}}
LOCALP tp;int tpused=0;tp.p=NULL;LOCALP*orz;
if(rslt==rgt){orz=rslt;rslt=&tp;tpused=1;}
relp(rslt);getarray(APLDOUB,(unsigned)r,sp,rslt);
p=rgt->p->SHAPETC;c=1;{BOUND i;for(i=0;i<r;i++){c*=sp[i];}}
m=c;k=0;
{BOUND i;for(i=0;i<j;i++){BOUND a=j-(i+1);k+=m*v[a];m*=p[a];}}
double *src,*dst;
dst=ARRAYSTART(rslt->p);src=ARRAYSTART(rgt->p);
{BOUND i;
#pragma simd
for(i=0;i<c;i++){dst[i]=src[k+i];}}
if(tpused){relp(orz);orz->p=zap(rslt->p);}
}
{LOCALP *rslt=&env[0][1];LOCALP *rgt=r;aplint32 v[]={1};
BOUND c,j,k,m,*p,r;j=1;
r=rgt->p->RANK-j;
BOUND sp[15];{BOUND i;for(i=0;i<r;i++){sp[i]=rgt->p->SHAPETC[j+i];}}
LOCALP tp;int tpused=0;tp.p=NULL;LOCALP*orz;
if(rslt==rgt){orz=rslt;rslt=&tp;tpused=1;}
relp(rslt);getarray(APLDOUB,(unsigned)r,sp,rslt);
p=rgt->p->SHAPETC;c=1;{BOUND i;for(i=0;i<r;i++){c*=sp[i];}}
m=c;k=0;
{BOUND i;for(i=0;i<j;i++){BOUND a=j-(i+1);k+=m*v[a];m*=p[a];}}
double *src,*dst;
dst=ARRAYSTART(rslt->p);src=ARRAYSTART(rgt->p);
{BOUND i;
#pragma simd
for(i=0;i<c;i++){dst[i]=src[k+i];}}
if(tpused){relp(orz);orz->p=zap(rslt->p);}
}
{BOUND prk=0;BOUND sp[15];BOUND cnt=1,i=0;
if(prk!=(l)->p->RANK){if(prk==0){
prk=(l)->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(l)->p->SHAPETC[i];}}
}else if((l)->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(l)->p->SHAPETC[i])error(4);}}
}
if(prk!=(&env[0][0])->p->RANK){if(prk==0){
prk=(&env[0][0])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][0])->p->SHAPETC[i];}}
}else if((&env[0][0])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][0])->p->SHAPETC[i])error(4);}}
}
if(prk!=(&env[0][1])->p->RANK){if(prk==0){
prk=(&env[0][1])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][1])->p->SHAPETC[i];}}
}else if((&env[0][1])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][1])->p->SHAPETC[i])error(4);}}
}
{BOUND i;for(i=0;i<prk;i++){cnt*=sp[i];}}
aplint32 *d0=ARRAYSTART((l)->p);
BOUND m0=(l)->p->RANK==0?0:1;
BOUND mz0=(l)->p->RANK==0?1:cnt;
double *d1=ARRAYSTART((&env[0][0])->p);
BOUND m1=(&env[0][0])->p->RANK==0?0:1;
BOUND mz1=(&env[0][0])->p->RANK==0?1:cnt;
double *d2=ARRAYSTART((&env[0][1])->p);
BOUND m2=(&env[0][1])->p->RANK==0?0:1;
BOUND mz2=(&env[0][1])->p->RANK==0?1:cnt;
POCKET*p0,*p1,*p2;
if(NULL==(&env[0][2])->p||prk!=(&env[0][2])->p->RANK
||(&env[0][2])->p->ELTYPE!=APLDOUB)
p0=getarray(APLDOUB,prk,sp,NULL);
else p0=(&env[0][2])->p;
if(NULL==(&env[0][3])->p||prk!=(&env[0][3])->p->RANK
||(&env[0][3])->p->ELTYPE!=APLDOUB)
p1=getarray(APLDOUB,prk,sp,NULL);
else p1=(&env[0][3])->p;
if(NULL==(&env[0][4])->p||prk!=(&env[0][4])->p->RANK
||(&env[0][4])->p->ELTYPE!=APLDOUB)
p2=getarray(APLDOUB,prk,sp,NULL);
else p2=(&env[0][4])->p;
double *r0=ARRAYSTART(p0);
double *r1=ARRAYSTART(p1);
double *r2=ARRAYSTART(p2);
#pragma acc parallel loop copyin(d0[0:mz0],d1[0:mz1],d2[0:mz2]) copyout(r0[0:cnt],r1[0:cnt],r2[0:cnt])
for(i=0;i<cnt;i++){
aplint32 f0=d0[i*m0];
double f1=d1[i*m1];
double f2=d2[i*m2];
double s0=pow((double)f0,(double)0.5);
double s1=0.03*s0;
double s2=0.02045*f0;
double s3=((double)f1)/((double)f2);
double s4=log((double)s3);
double s5=s4+s2;
double s6=((double)s5)/((double)s1);
double s7=s6-s1;
r0[i]=s7;
r1[i]=s6;
r2[i]=s4;
}
if((&env[0][2])->p!=p0){relp(&env[0][2]);(&env[0][2])->p=p0;}
if((&env[0][3])->p!=p1){relp(&env[0][3]);(&env[0][3])->p=p1;}
if((&env[0][4])->p!=p2){relp(&env[0][4]);(&env[0][4])->p=p2;}
}
fn_1_4fn(&env[0][3],NULL,&env[0][3],env);
fn_1_4fn(&env[0][2],NULL,&env[0][2],env);
{BOUND prk=0;BOUND sp[15];BOUND cnt=1,i=0;
if(prk!=(l)->p->RANK){if(prk==0){
prk=(l)->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(l)->p->SHAPETC[i];}}
}else if((l)->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(l)->p->SHAPETC[i])error(4);}}
}
if(prk!=(&env[0][3])->p->RANK){if(prk==0){
prk=(&env[0][3])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][3])->p->SHAPETC[i];}}
}else if((&env[0][3])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][3])->p->SHAPETC[i])error(4);}}
}
if(prk!=(&env[0][0])->p->RANK){if(prk==0){
prk=(&env[0][0])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][0])->p->SHAPETC[i];}}
}else if((&env[0][0])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][0])->p->SHAPETC[i])error(4);}}
}
if(prk!=(&env[0][2])->p->RANK){if(prk==0){
prk=(&env[0][2])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][2])->p->SHAPETC[i];}}
}else if((&env[0][2])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][2])->p->SHAPETC[i])error(4);}}
}
if(prk!=(&env[0][1])->p->RANK){if(prk==0){
prk=(&env[0][1])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][1])->p->SHAPETC[i];}}
}else if((&env[0][1])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][1])->p->SHAPETC[i])error(4);}}
}
{BOUND i;for(i=0;i<prk;i++){cnt*=sp[i];}}
aplint32 *d0=ARRAYSTART((l)->p);
BOUND m0=(l)->p->RANK==0?0:1;
BOUND mz0=(l)->p->RANK==0?1:cnt;
double *d1=ARRAYSTART((&env[0][3])->p);
BOUND m1=(&env[0][3])->p->RANK==0?0:1;
BOUND mz1=(&env[0][3])->p->RANK==0?1:cnt;
double *d2=ARRAYSTART((&env[0][0])->p);
BOUND m2=(&env[0][0])->p->RANK==0?0:1;
BOUND mz2=(&env[0][0])->p->RANK==0?1:cnt;
double *d3=ARRAYSTART((&env[0][2])->p);
BOUND m3=(&env[0][2])->p->RANK==0?0:1;
BOUND mz3=(&env[0][2])->p->RANK==0?1:cnt;
double *d4=ARRAYSTART((&env[0][1])->p);
BOUND m4=(&env[0][1])->p->RANK==0?0:1;
BOUND mz4=(&env[0][1])->p->RANK==0?1:cnt;
POCKET*p0,*p1,*p2,*p3,*p4,*p5;
if(NULL==(&env[0][4])->p||prk!=(&env[0][4])->p->RANK
||(&env[0][4])->p->ELTYPE!=APLDOUB)
p0=getarray(APLDOUB,prk,sp,NULL);
else p0=(&env[0][4])->p;
if(NULL==(&env[0][5])->p||prk!=(&env[0][5])->p->RANK
||(&env[0][5])->p->ELTYPE!=APLDOUB)
p1=getarray(APLDOUB,prk,sp,NULL);
else p1=(&env[0][5])->p;
if(NULL==(&env[0][6])->p||prk!=(&env[0][6])->p->RANK
||(&env[0][6])->p->ELTYPE!=APLDOUB)
p2=getarray(APLDOUB,prk,sp,NULL);
else p2=(&env[0][6])->p;
if(NULL==(&env[0][2])->p||prk!=(&env[0][2])->p->RANK
||(&env[0][2])->p->ELTYPE!=APLDOUB)
p3=getarray(APLDOUB,prk,sp,NULL);
else p3=(&env[0][2])->p;
if(NULL==(&env[0][1])->p||prk!=(&env[0][1])->p->RANK
||(&env[0][1])->p->ELTYPE!=APLDOUB)
p4=getarray(APLDOUB,prk,sp,NULL);
else p4=(&env[0][1])->p;
if(NULL==(&env[0][0])->p||prk!=(&env[0][0])->p->RANK
||(&env[0][0])->p->ELTYPE!=APLDOUB)
p5=getarray(APLDOUB,prk,sp,NULL);
else p5=(&env[0][0])->p;
double *r0=ARRAYSTART(p0);
double *r1=ARRAYSTART(p1);
double *r2=ARRAYSTART(p2);
double *r3=ARRAYSTART(p3);
double *r4=ARRAYSTART(p4);
double *r5=ARRAYSTART(p5);
#pragma acc parallel loop copyin(d0[0:mz0],d1[0:mz1],d2[0:mz2],d3[0:mz3],d4[0:mz4]) copyout(r0[0:cnt],r1[0:cnt],r2[0:cnt],r3[0:cnt],r4[0:cnt],r5[0:cnt])
for(i=0;i<cnt;i++){
aplint32 f0=d0[i*m0];
double f1=d1[i*m1];
double f2=d2[i*m2];
double f3=d3[i*m3];
double f4=d4[i*m4];
double s0=-0.02*f0;
double s1=exp((double)s0);
double s2=1-f1;
double s3=f2*s2;
double s4=1-f3;
double s5=s1*s4;
double s6=f4*s5;
double s7=s6-s3;
double s8=s1*f3;
double s9=f4*s8;
double s10=f2*f1;
double s11=s10-s9;
r0[i]=s1;
r1[i]=s7;
r2[i]=s6;
r3[i]=s8;
r4[i]=s9;
r5[i]=s11;
}
if((&env[0][4])->p!=p0){relp(&env[0][4]);(&env[0][4])->p=p0;}
if((&env[0][5])->p!=p1){relp(&env[0][5]);(&env[0][5])->p=p1;}
if((&env[0][6])->p!=p2){relp(&env[0][6]);(&env[0][6])->p=p2;}
if((&env[0][2])->p!=p3){relp(&env[0][2]);(&env[0][2])->p=p3;}
if((&env[0][1])->p!=p4){relp(&env[0][1]);(&env[0][1])->p=p4;}
if((&env[0][0])->p!=p5){relp(&env[0][0]);(&env[0][0])->p=p5;}
}
{LOCALP *rslt=&env[0][0];LOCALP *rgt=&env[0][5];LOCALP *lft=&env[0][0];
BOUND s[]={rgt->p->SHAPETC[0],2};LOCALP*orz;LOCALP tp;tp.p=NULL;int tpused=0;
if(rslt==lft||rslt==rgt){orz=rslt;rslt=&tp;tpused=1;}
relp(rslt);getarray(APLDOUB,2,s,rslt);
double *z;double *r;double *l;
z=ARRAYSTART(rslt->p);
r=ARRAYSTART(rgt->p);
l=ARRAYSTART(lft->p);
{BOUND i;
#pragma simd
for(i=0;i<s[0];i++){z[i*2]=l[i];z[i*2+1]=r[i];}}
if(tpused){relp(orz);orz->p=zap(rslt->p);}
}
z->p=zap((&env[0][0])->p);cutp(&env0[0]);
}

void static inline fn_1_5ff(LOCALP*z,LOCALP*l,LOCALP*r,LOCALP*penv[]){
LOCALP env0[7];LOCALP*env[]={env0,penv[0]};
{BOUND i;for(i=0;i<7;i++){regp(&env0[i]);}}
{LOCALP *rslt=&env[0][0];LOCALP *rgt=r;aplint32 v[]={0};
BOUND c,j,k,m,*p,r;j=1;
r=rgt->p->RANK-j;
BOUND sp[15];{BOUND i;for(i=0;i<r;i++){sp[i]=rgt->p->SHAPETC[j+i];}}
LOCALP tp;int tpused=0;tp.p=NULL;LOCALP*orz;
if(rslt==rgt){orz=rslt;rslt=&tp;tpused=1;}
relp(rslt);getarray(APLDOUB,(unsigned)r,sp,rslt);
p=rgt->p->SHAPETC;c=1;{BOUND i;for(i=0;i<r;i++){c*=sp[i];}}
m=c;k=0;
{BOUND i;for(i=0;i<j;i++){BOUND a=j-(i+1);k+=m*v[a];m*=p[a];}}
double *src,*dst;
dst=ARRAYSTART(rslt->p);src=ARRAYSTART(rgt->p);
{BOUND i;
#pragma simd
for(i=0;i<c;i++){dst[i]=src[k+i];}}
if(tpused){relp(orz);orz->p=zap(rslt->p);}
}
{LOCALP *rslt=&env[0][1];LOCALP *rgt=r;aplint32 v[]={1};
BOUND c,j,k,m,*p,r;j=1;
r=rgt->p->RANK-j;
BOUND sp[15];{BOUND i;for(i=0;i<r;i++){sp[i]=rgt->p->SHAPETC[j+i];}}
LOCALP tp;int tpused=0;tp.p=NULL;LOCALP*orz;
if(rslt==rgt){orz=rslt;rslt=&tp;tpused=1;}
relp(rslt);getarray(APLDOUB,(unsigned)r,sp,rslt);
p=rgt->p->SHAPETC;c=1;{BOUND i;for(i=0;i<r;i++){c*=sp[i];}}
m=c;k=0;
{BOUND i;for(i=0;i<j;i++){BOUND a=j-(i+1);k+=m*v[a];m*=p[a];}}
double *src,*dst;
dst=ARRAYSTART(rslt->p);src=ARRAYSTART(rgt->p);
{BOUND i;
#pragma simd
for(i=0;i<c;i++){dst[i]=src[k+i];}}
if(tpused){relp(orz);orz->p=zap(rslt->p);}
}
{BOUND prk=0;BOUND sp[15];BOUND cnt=1,i=0;
if(prk!=(l)->p->RANK){if(prk==0){
prk=(l)->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(l)->p->SHAPETC[i];}}
}else if((l)->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(l)->p->SHAPETC[i])error(4);}}
}
if(prk!=(&env[0][0])->p->RANK){if(prk==0){
prk=(&env[0][0])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][0])->p->SHAPETC[i];}}
}else if((&env[0][0])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][0])->p->SHAPETC[i])error(4);}}
}
if(prk!=(&env[0][1])->p->RANK){if(prk==0){
prk=(&env[0][1])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][1])->p->SHAPETC[i];}}
}else if((&env[0][1])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][1])->p->SHAPETC[i])error(4);}}
}
{BOUND i;for(i=0;i<prk;i++){cnt*=sp[i];}}
double *d0=ARRAYSTART((l)->p);
BOUND m0=(l)->p->RANK==0?0:1;
BOUND mz0=(l)->p->RANK==0?1:cnt;
double *d1=ARRAYSTART((&env[0][0])->p);
BOUND m1=(&env[0][0])->p->RANK==0?0:1;
BOUND mz1=(&env[0][0])->p->RANK==0?1:cnt;
double *d2=ARRAYSTART((&env[0][1])->p);
BOUND m2=(&env[0][1])->p->RANK==0?0:1;
BOUND mz2=(&env[0][1])->p->RANK==0?1:cnt;
POCKET*p0,*p1,*p2;
if(NULL==(&env[0][2])->p||prk!=(&env[0][2])->p->RANK
||(&env[0][2])->p->ELTYPE!=APLDOUB)
p0=getarray(APLDOUB,prk,sp,NULL);
else p0=(&env[0][2])->p;
if(NULL==(&env[0][3])->p||prk!=(&env[0][3])->p->RANK
||(&env[0][3])->p->ELTYPE!=APLDOUB)
p1=getarray(APLDOUB,prk,sp,NULL);
else p1=(&env[0][3])->p;
if(NULL==(&env[0][4])->p||prk!=(&env[0][4])->p->RANK
||(&env[0][4])->p->ELTYPE!=APLDOUB)
p2=getarray(APLDOUB,prk,sp,NULL);
else p2=(&env[0][4])->p;
double *r0=ARRAYSTART(p0);
double *r1=ARRAYSTART(p1);
double *r2=ARRAYSTART(p2);
#pragma acc parallel loop copyin(d0[0:mz0],d1[0:mz1],d2[0:mz2]) copyout(r0[0:cnt],r1[0:cnt],r2[0:cnt])
for(i=0;i<cnt;i++){
double f0=d0[i*m0];
double f1=d1[i*m1];
double f2=d2[i*m2];
double s0=pow((double)f0,(double)0.5);
double s1=0.03*s0;
double s2=0.02045*f0;
double s3=((double)f1)/((double)f2);
double s4=log((double)s3);
double s5=s4+s2;
double s6=((double)s5)/((double)s1);
double s7=s6-s1;
r0[i]=s7;
r1[i]=s6;
r2[i]=s4;
}
if((&env[0][2])->p!=p0){relp(&env[0][2]);(&env[0][2])->p=p0;}
if((&env[0][3])->p!=p1){relp(&env[0][3]);(&env[0][3])->p=p1;}
if((&env[0][4])->p!=p2){relp(&env[0][4]);(&env[0][4])->p=p2;}
}
fn_1_4fn(&env[0][3],NULL,&env[0][3],env);
fn_1_4fn(&env[0][2],NULL,&env[0][2],env);
{BOUND prk=0;BOUND sp[15];BOUND cnt=1,i=0;
if(prk!=(l)->p->RANK){if(prk==0){
prk=(l)->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(l)->p->SHAPETC[i];}}
}else if((l)->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(l)->p->SHAPETC[i])error(4);}}
}
if(prk!=(&env[0][3])->p->RANK){if(prk==0){
prk=(&env[0][3])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][3])->p->SHAPETC[i];}}
}else if((&env[0][3])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][3])->p->SHAPETC[i])error(4);}}
}
if(prk!=(&env[0][0])->p->RANK){if(prk==0){
prk=(&env[0][0])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][0])->p->SHAPETC[i];}}
}else if((&env[0][0])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][0])->p->SHAPETC[i])error(4);}}
}
if(prk!=(&env[0][2])->p->RANK){if(prk==0){
prk=(&env[0][2])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][2])->p->SHAPETC[i];}}
}else if((&env[0][2])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][2])->p->SHAPETC[i])error(4);}}
}
if(prk!=(&env[0][1])->p->RANK){if(prk==0){
prk=(&env[0][1])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][1])->p->SHAPETC[i];}}
}else if((&env[0][1])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][1])->p->SHAPETC[i])error(4);}}
}
{BOUND i;for(i=0;i<prk;i++){cnt*=sp[i];}}
double *d0=ARRAYSTART((l)->p);
BOUND m0=(l)->p->RANK==0?0:1;
BOUND mz0=(l)->p->RANK==0?1:cnt;
double *d1=ARRAYSTART((&env[0][3])->p);
BOUND m1=(&env[0][3])->p->RANK==0?0:1;
BOUND mz1=(&env[0][3])->p->RANK==0?1:cnt;
double *d2=ARRAYSTART((&env[0][0])->p);
BOUND m2=(&env[0][0])->p->RANK==0?0:1;
BOUND mz2=(&env[0][0])->p->RANK==0?1:cnt;
double *d3=ARRAYSTART((&env[0][2])->p);
BOUND m3=(&env[0][2])->p->RANK==0?0:1;
BOUND mz3=(&env[0][2])->p->RANK==0?1:cnt;
double *d4=ARRAYSTART((&env[0][1])->p);
BOUND m4=(&env[0][1])->p->RANK==0?0:1;
BOUND mz4=(&env[0][1])->p->RANK==0?1:cnt;
POCKET*p0,*p1,*p2,*p3,*p4,*p5;
if(NULL==(&env[0][4])->p||prk!=(&env[0][4])->p->RANK
||(&env[0][4])->p->ELTYPE!=APLDOUB)
p0=getarray(APLDOUB,prk,sp,NULL);
else p0=(&env[0][4])->p;
if(NULL==(&env[0][5])->p||prk!=(&env[0][5])->p->RANK
||(&env[0][5])->p->ELTYPE!=APLDOUB)
p1=getarray(APLDOUB,prk,sp,NULL);
else p1=(&env[0][5])->p;
if(NULL==(&env[0][6])->p||prk!=(&env[0][6])->p->RANK
||(&env[0][6])->p->ELTYPE!=APLDOUB)
p2=getarray(APLDOUB,prk,sp,NULL);
else p2=(&env[0][6])->p;
if(NULL==(&env[0][2])->p||prk!=(&env[0][2])->p->RANK
||(&env[0][2])->p->ELTYPE!=APLDOUB)
p3=getarray(APLDOUB,prk,sp,NULL);
else p3=(&env[0][2])->p;
if(NULL==(&env[0][1])->p||prk!=(&env[0][1])->p->RANK
||(&env[0][1])->p->ELTYPE!=APLDOUB)
p4=getarray(APLDOUB,prk,sp,NULL);
else p4=(&env[0][1])->p;
if(NULL==(&env[0][0])->p||prk!=(&env[0][0])->p->RANK
||(&env[0][0])->p->ELTYPE!=APLDOUB)
p5=getarray(APLDOUB,prk,sp,NULL);
else p5=(&env[0][0])->p;
double *r0=ARRAYSTART(p0);
double *r1=ARRAYSTART(p1);
double *r2=ARRAYSTART(p2);
double *r3=ARRAYSTART(p3);
double *r4=ARRAYSTART(p4);
double *r5=ARRAYSTART(p5);
#pragma acc parallel loop copyin(d0[0:mz0],d1[0:mz1],d2[0:mz2],d3[0:mz3],d4[0:mz4]) copyout(r0[0:cnt],r1[0:cnt],r2[0:cnt],r3[0:cnt],r4[0:cnt],r5[0:cnt])
for(i=0;i<cnt;i++){
double f0=d0[i*m0];
double f1=d1[i*m1];
double f2=d2[i*m2];
double f3=d3[i*m3];
double f4=d4[i*m4];
double s0=-0.02*f0;
double s1=exp((double)s0);
double s2=1-f1;
double s3=f2*s2;
double s4=1-f3;
double s5=s1*s4;
double s6=f4*s5;
double s7=s6-s3;
double s8=s1*f3;
double s9=f4*s8;
double s10=f2*f1;
double s11=s10-s9;
r0[i]=s1;
r1[i]=s7;
r2[i]=s6;
r3[i]=s8;
r4[i]=s9;
r5[i]=s11;
}
if((&env[0][4])->p!=p0){relp(&env[0][4]);(&env[0][4])->p=p0;}
if((&env[0][5])->p!=p1){relp(&env[0][5]);(&env[0][5])->p=p1;}
if((&env[0][6])->p!=p2){relp(&env[0][6]);(&env[0][6])->p=p2;}
if((&env[0][2])->p!=p3){relp(&env[0][2]);(&env[0][2])->p=p3;}
if((&env[0][1])->p!=p4){relp(&env[0][1]);(&env[0][1])->p=p4;}
if((&env[0][0])->p!=p5){relp(&env[0][0]);(&env[0][0])->p=p5;}
}
{LOCALP *rslt=&env[0][0];LOCALP *rgt=&env[0][5];LOCALP *lft=&env[0][0];
BOUND s[]={rgt->p->SHAPETC[0],2};LOCALP*orz;LOCALP tp;tp.p=NULL;int tpused=0;
if(rslt==lft||rslt==rgt){orz=rslt;rslt=&tp;tpused=1;}
relp(rslt);getarray(APLDOUB,2,s,rslt);
double *z;double *r;double *l;
z=ARRAYSTART(rslt->p);
r=ARRAYSTART(rgt->p);
l=ARRAYSTART(lft->p);
{BOUND i;
#pragma simd
for(i=0;i<s[0];i++){z[i*2]=l[i];z[i*2+1]=r[i];}}
if(tpused){relp(orz);orz->p=zap(rslt->p);}
}
z->p=zap((&env[0][0])->p);cutp(&env0[0]);
}

void static inline fn_1_5fn(LOCALP*z,LOCALP*l,LOCALP*r,LOCALP*penv[]){
LOCALP env0[7];LOCALP*env[]={env0,penv[0]};
{BOUND i;for(i=0;i<7;i++){regp(&env0[i]);}}
{LOCALP *rslt=&env[0][0];LOCALP *rgt=r;aplint32 v[]={0};
BOUND c,j,k,m,*p,r;j=1;
r=rgt->p->RANK-j;
BOUND sp[15];{BOUND i;for(i=0;i<r;i++){sp[i]=rgt->p->SHAPETC[j+i];}}
LOCALP tp;int tpused=0;tp.p=NULL;LOCALP*orz;
if(rslt==rgt){orz=rslt;rslt=&tp;tpused=1;}
relp(rslt);getarray(APLDOUB,(unsigned)r,sp,rslt);
p=rgt->p->SHAPETC;c=1;{BOUND i;for(i=0;i<r;i++){c*=sp[i];}}
m=c;k=0;
{BOUND i;for(i=0;i<j;i++){BOUND a=j-(i+1);k+=m*v[a];m*=p[a];}}
double *src,*dst;
dst=ARRAYSTART(rslt->p);src=ARRAYSTART(rgt->p);
{BOUND i;
#pragma simd
for(i=0;i<c;i++){dst[i]=src[k+i];}}
if(tpused){relp(orz);orz->p=zap(rslt->p);}
}
{LOCALP *rslt=&env[0][1];LOCALP *rgt=r;aplint32 v[]={1};
BOUND c,j,k,m,*p,r;j=1;
r=rgt->p->RANK-j;
BOUND sp[15];{BOUND i;for(i=0;i<r;i++){sp[i]=rgt->p->SHAPETC[j+i];}}
LOCALP tp;int tpused=0;tp.p=NULL;LOCALP*orz;
if(rslt==rgt){orz=rslt;rslt=&tp;tpused=1;}
relp(rslt);getarray(APLDOUB,(unsigned)r,sp,rslt);
p=rgt->p->SHAPETC;c=1;{BOUND i;for(i=0;i<r;i++){c*=sp[i];}}
m=c;k=0;
{BOUND i;for(i=0;i<j;i++){BOUND a=j-(i+1);k+=m*v[a];m*=p[a];}}
double *src,*dst;
dst=ARRAYSTART(rslt->p);src=ARRAYSTART(rgt->p);
{BOUND i;
#pragma simd
for(i=0;i<c;i++){dst[i]=src[k+i];}}
if(tpused){relp(orz);orz->p=zap(rslt->p);}
}
{BOUND prk=0;BOUND sp[15];BOUND cnt=1,i=0;
if(prk!=(l)->p->RANK){if(prk==0){
prk=(l)->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(l)->p->SHAPETC[i];}}
}else if((l)->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(l)->p->SHAPETC[i])error(4);}}
}
if(prk!=(&env[0][0])->p->RANK){if(prk==0){
prk=(&env[0][0])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][0])->p->SHAPETC[i];}}
}else if((&env[0][0])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][0])->p->SHAPETC[i])error(4);}}
}
if(prk!=(&env[0][1])->p->RANK){if(prk==0){
prk=(&env[0][1])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][1])->p->SHAPETC[i];}}
}else if((&env[0][1])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][1])->p->SHAPETC[i])error(4);}}
}
{BOUND i;for(i=0;i<prk;i++){cnt*=sp[i];}}
/* XXX */ aplint32 *d0=ARRAYSTART((l)->p);
BOUND m0=(l)->p->RANK==0?0:1;
BOUND mz0=(l)->p->RANK==0?1:cnt;
double *d1=ARRAYSTART((&env[0][0])->p);
BOUND m1=(&env[0][0])->p->RANK==0?0:1;
BOUND mz1=(&env[0][0])->p->RANK==0?1:cnt;
double *d2=ARRAYSTART((&env[0][1])->p);
BOUND m2=(&env[0][1])->p->RANK==0?0:1;
BOUND mz2=(&env[0][1])->p->RANK==0?1:cnt;
POCKET*p0,*p1,*p2;
if(NULL==(&env[0][2])->p||prk!=(&env[0][2])->p->RANK
||(&env[0][2])->p->ELTYPE!=/* XXX */ APLLONG)
p0=getarray(/* XXX */ APLLONG,prk,sp,NULL);
else p0=(&env[0][2])->p;
if(NULL==(&env[0][3])->p||prk!=(&env[0][3])->p->RANK
||(&env[0][3])->p->ELTYPE!=/* XXX */ APLLONG)
p1=getarray(/* XXX */ APLLONG,prk,sp,NULL);
else p1=(&env[0][3])->p;
if(NULL==(&env[0][4])->p||prk!=(&env[0][4])->p->RANK
||(&env[0][4])->p->ELTYPE!=APLDOUB)
p2=getarray(APLDOUB,prk,sp,NULL);
else p2=(&env[0][4])->p;
/* XXX */ aplint32 *r0=ARRAYSTART(p0);
/* XXX */ aplint32 *r1=ARRAYSTART(p1);
double *r2=ARRAYSTART(p2);
#pragma acc parallel loop copyin(d0[0:mz0],d1[0:mz1],d2[0:mz2]) copyout(r0[0:cnt],r1[0:cnt],r2[0:cnt])
for(i=0;i<cnt;i++){
/* XXX */ aplint32 f0=d0[i*m0];
double f1=d1[i*m1];
double f2=d2[i*m2];
/* XXX */ aplint32 s0=pow((double)f0,(double)0.5);
/* XXX */ aplint32 s1=0.03*s0;
/* XXX */ aplint32 s2=0.02045*f0;
double s3=((double)f1)/((double)f2);
double s4=log((double)s3);
/* XXX */ aplint32 s5=s4+s2;
/* XXX */ aplint32 s6=((double)s5)/((double)s1);
/* XXX */ aplint32 s7=s6-s1;
r0[i]=s7;
r1[i]=s6;
r2[i]=s4;
}
if((&env[0][2])->p!=p0){relp(&env[0][2]);(&env[0][2])->p=p0;}
if((&env[0][3])->p!=p1){relp(&env[0][3]);(&env[0][3])->p=p1;}
if((&env[0][4])->p!=p2){relp(&env[0][4]);(&env[0][4])->p=p2;}
}
fn_1_4in(&env[0][3],NULL,&env[0][3],env);
fn_1_4in(&env[0][2],NULL,&env[0][2],env);
{BOUND prk=0;BOUND sp[15];BOUND cnt=1,i=0;
if(prk!=(l)->p->RANK){if(prk==0){
prk=(l)->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(l)->p->SHAPETC[i];}}
}else if((l)->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(l)->p->SHAPETC[i])error(4);}}
}
if(prk!=(&env[0][3])->p->RANK){if(prk==0){
prk=(&env[0][3])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][3])->p->SHAPETC[i];}}
}else if((&env[0][3])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][3])->p->SHAPETC[i])error(4);}}
}
if(prk!=(&env[0][0])->p->RANK){if(prk==0){
prk=(&env[0][0])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][0])->p->SHAPETC[i];}}
}else if((&env[0][0])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][0])->p->SHAPETC[i])error(4);}}
}
if(prk!=(&env[0][2])->p->RANK){if(prk==0){
prk=(&env[0][2])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][2])->p->SHAPETC[i];}}
}else if((&env[0][2])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][2])->p->SHAPETC[i])error(4);}}
}
if(prk!=(&env[0][1])->p->RANK){if(prk==0){
prk=(&env[0][1])->p->RANK;
{BOUND i;for(i=0;i<prk;i++){sp[i]=(&env[0][1])->p->SHAPETC[i];}}
}else if((&env[0][1])->p->RANK!=0)error(4);
}else{
{BOUND i;for(i=0;i<prk;i++){if(sp[i]!=(&env[0][1])->p->SHAPETC[i])error(4);}}
}
{BOUND i;for(i=0;i<prk;i++){cnt*=sp[i];}}
/* XXX */ aplint32 *d0=ARRAYSTART((l)->p);
BOUND m0=(l)->p->RANK==0?0:1;
BOUND mz0=(l)->p->RANK==0?1:cnt;
/* XXX */ aplint32 *d1=ARRAYSTART((&env[0][3])->p);
BOUND m1=(&env[0][3])->p->RANK==0?0:1;
BOUND mz1=(&env[0][3])->p->RANK==0?1:cnt;
double *d2=ARRAYSTART((&env[0][0])->p);
BOUND m2=(&env[0][0])->p->RANK==0?0:1;
BOUND mz2=(&env[0][0])->p->RANK==0?1:cnt;
/* XXX */ aplint32 *d3=ARRAYSTART((&env[0][2])->p);
BOUND m3=(&env[0][2])->p->RANK==0?0:1;
BOUND mz3=(&env[0][2])->p->RANK==0?1:cnt;
double *d4=ARRAYSTART((&env[0][1])->p);
BOUND m4=(&env[0][1])->p->RANK==0?0:1;
BOUND mz4=(&env[0][1])->p->RANK==0?1:cnt;
POCKET*p0,*p1,*p2,*p3,*p4,*p5;
if(NULL==(&env[0][4])->p||prk!=(&env[0][4])->p->RANK
||(&env[0][4])->p->ELTYPE!=/* XXX */ APLLONG)
p0=getarray(/* XXX */ APLLONG,prk,sp,NULL);
else p0=(&env[0][4])->p;
if(NULL==(&env[0][5])->p||prk!=(&env[0][5])->p->RANK
||(&env[0][5])->p->ELTYPE!=/* XXX */ APLLONG)
p1=getarray(/* XXX */ APLLONG,prk,sp,NULL);
else p1=(&env[0][5])->p;
if(NULL==(&env[0][6])->p||prk!=(&env[0][6])->p->RANK
||(&env[0][6])->p->ELTYPE!=/* XXX */ APLLONG)
p2=getarray(/* XXX */ APLLONG,prk,sp,NULL);
else p2=(&env[0][6])->p;
if(NULL==(&env[0][2])->p||prk!=(&env[0][2])->p->RANK
||(&env[0][2])->p->ELTYPE!=/* XXX */ APLLONG)
p3=getarray(/* XXX */ APLLONG,prk,sp,NULL);
else p3=(&env[0][2])->p;
if(NULL==(&env[0][1])->p||prk!=(&env[0][1])->p->RANK
||(&env[0][1])->p->ELTYPE!=/* XXX */ APLLONG)
p4=getarray(/* XXX */ APLLONG,prk,sp,NULL);
else p4=(&env[0][1])->p;
if(NULL==(&env[0][0])->p||prk!=(&env[0][0])->p->RANK
||(&env[0][0])->p->ELTYPE!=/* XXX */ APLLONG)
p5=getarray(/* XXX */ APLLONG,prk,sp,NULL);
else p5=(&env[0][0])->p;
/* XXX */ aplint32 *r0=ARRAYSTART(p0);
/* XXX */ aplint32 *r1=ARRAYSTART(p1);
/* XXX */ aplint32 *r2=ARRAYSTART(p2);
/* XXX */ aplint32 *r3=ARRAYSTART(p3);
/* XXX */ aplint32 *r4=ARRAYSTART(p4);
/* XXX */ aplint32 *r5=ARRAYSTART(p5);
#pragma acc parallel loop copyin(d0[0:mz0],d1[0:mz1],d2[0:mz2],d3[0:mz3],d4[0:mz4]) copyout(r0[0:cnt],r1[0:cnt],r2[0:cnt],r3[0:cnt],r4[0:cnt],r5[0:cnt])
for(i=0;i<cnt;i++){
/* XXX */ aplint32 f0=d0[i*m0];
/* XXX */ aplint32 f1=d1[i*m1];
double f2=d2[i*m2];
/* XXX */ aplint32 f3=d3[i*m3];
double f4=d4[i*m4];
/* XXX */ aplint32 s0=-0.02*f0;
/* XXX */ aplint32 s1=exp((double)s0);
/* XXX */ aplint32 s2=1-f1;
/* XXX */ aplint32 s3=f2*s2;
/* XXX */ aplint32 s4=1-f3;
/* XXX */ aplint32 s5=s1*s4;
/* XXX */ aplint32 s6=f4*s5;
/* XXX */ aplint32 s7=s6-s3;
/* XXX */ aplint32 s8=s1*f3;
/* XXX */ aplint32 s9=f4*s8;
/* XXX */ aplint32 s10=f2*f1;
/* XXX */ aplint32 s11=s10-s9;
r0[i]=s1;
r1[i]=s7;
r2[i]=s6;
r3[i]=s8;
r4[i]=s9;
r5[i]=s11;
}
if((&env[0][4])->p!=p0){relp(&env[0][4]);(&env[0][4])->p=p0;}
if((&env[0][5])->p!=p1){relp(&env[0][5]);(&env[0][5])->p=p1;}
if((&env[0][6])->p!=p2){relp(&env[0][6]);(&env[0][6])->p=p2;}
if((&env[0][2])->p!=p3){relp(&env[0][2]);(&env[0][2])->p=p3;}
if((&env[0][1])->p!=p4){relp(&env[0][1]);(&env[0][1])->p=p4;}
if((&env[0][0])->p!=p5){relp(&env[0][0]);(&env[0][0])->p=p5;}
}
{LOCALP *rslt=&env[0][0];LOCALP *rgt=&env[0][5];LOCALP *lft=&env[0][0];
BOUND s[]={rgt->p->SHAPETC[0],2};LOCALP*orz;LOCALP tp;tp.p=NULL;int tpused=0;
if(rslt==lft||rslt==rgt){orz=rslt;rslt=&tp;tpused=1;}
relp(rslt);getarray(/* XXX */ APLLONG,2,s,rslt);
/* XXX */ aplint32 *z;/* XXX */ aplint32 *r;/* XXX */ aplint32 *l;
z=ARRAYSTART(rslt->p);
r=ARRAYSTART(rgt->p);
l=ARRAYSTART(lft->p);
{BOUND i;
#pragma simd
for(i=0;i<s[0];i++){z[i*2]=l[i];z[i*2+1]=r[i];}}
if(tpused){relp(orz);orz->p=zap(rslt->p);}
}
z->p=zap((&env[0][0])->p);cutp(&env0[0]);
}

