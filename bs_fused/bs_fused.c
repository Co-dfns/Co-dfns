#include <stdio.h>
#include <math.h>

#include "rt/codfns.h"
#include "rt/scalar.h"
#include "rt/fusion.h"
#include "rt/internal.h"

double d1[] = {0.02};
double d2[] = {0.03};
double d3[] = {0.31938153, -0.356563782, 1.781477937, -1.821255978, 1.33027442};
int64_t d4[] = {1, -1};
int64_t d5[] = {0, -1};
int64_t d6[] = {5};
int64_t d7[] = {1};

uint32_t s1[] = {5};
uint32_t s2[] = {2};
uint32_t s3[] = {2};


struct codfns_array t1 = {
	0, 1, apl_type_d, NULL, d1
};

struct codfns_array t2 = {
	0, 1, apl_type_d, NULL, d2
};

struct codfns_array t3 = {
	1, 5, apl_type_d, s1, d3
};

struct codfns_array t4 = {
	1, 2, apl_type_i, s2, d4
};

struct codfns_array t5 = {
	1, 2, apl_type_i, s3, d5
};

struct codfns_array t6 = {
	0, 1, apl_type_i, NULL, d6
};

struct codfns_array t7 = {
	0, 1, apl_type_i, NULL, d7
};

struct codfns_array r;
struct codfns_array v;
struct codfns_array coeff;
struct codfns_array g1;
struct codfns_array g2;
struct codfns_array g3;
struct codfns_array g4;
struct codfns_array stgt;

int
Init(struct codfns_array *res, 
    struct codfns_array *lft, struct codfns_array *rgt)
{
	array_cp(&r, &t1);
	array_cp(&v, &t2);
	array_cp(&coeff, &t3);
	array_cp(&g1, &t4);
	array_cp(&g2, &t5);
	array_cp(&g3, &t6);
	array_cp(&g4, &t7);
	
	init_env(&stgt, 0);
	
	return 0;
}

int static inline
anon_f(struct codfns_array *res, 
    struct codfns_array *lft, struct codfns_array *rgt)
{
	codfns_indexgenm(res, NULL, &g3);
	codfns_addd(res, &g4, res);
	codfns_powerd(res, rgt, res);
	codfns_ptredd(res, &coeff, res); 
	
	return 0;
}

int static inline
anon_w(struct codfns_array *res, 
    struct codfns_array *lft, struct codfns_array *rgt,
    struct codfns_array **env)
{
	anon_f(res, lft, rgt);

	return 0;
}

int static inline
scalar1(int64_t i, void *res, void *rgt, struct codfns_array *env0)
{
	int64_t X;
	double *L, *K, Y, *w;
	
	L = ((double *)(&env0[0])->elements) + i;
	K = ((double *)(&env0[1])->elements) + i;
	w = ((double *)rgt) + i;
		
	*L = *w < 0 ? -1 * *w : *w;
	Y = 0.2316419;
	*K = Y * *L;
	X = 1;
	*K = X + *K;
	*K = 1.0 / *K;
	
	return 0;
}

int static inline
scalar4(int64_t i, void *res, void *rgt, struct codfns_array *env0)
{
	int64_t X, *g1s, *g2s, *B;
	double *R, *L, T, *ress, *w;
	
	L = ((double *)(&env0[0])->elements) + i;
	R = ((double *)(&env0[2])->elements) + i;
	B = ((int64_t *)(&env0[3])->elements) + i;
	w = ((double *)rgt) + i;

	T = *L * *L;
	X = -2;
	T = T / X;
	T = exp(T);
	*R = T * *R;
	T = 0.3989422804;
	*R = T * *R;
	
	X = 0;
	*B = *w >= X;
	g1s = ((int64_t *)g1.elements) + *B;
	g2s = ((int64_t *)g2.elements) + *B;
	ress = res;
	ress = ress + i;
	*ress = *g2s + *R;
	*ress = *g1s * *ress;

	return 0;
}

int
CNDP2(struct codfns_array *res,
    struct codfns_array *lft, struct codfns_array *rgt)
{
	struct codfns_array env0[5];
	struct codfns_array *ew[1];
	struct codfns_array *L, *K, *R, *B, *P;
	void *rese;
	int64_t i;
	
	init_env(env0, 5);
	
	L = &env0[0];
	K = &env0[1];
	R = &env0[2];
	B = &env0[3];
	P = &env0[4];
	
	prepare_res(&rese, L, rgt);
	prepare_res(&rese, K, rgt);
	prepare_res(&rese, R, rgt);
	prepare_res(&rese, B, rgt);
	prepare_res(&rese, res, rgt);
	
	codfns_sverify(P, L, K);
	codfns_sverify(P, R, P);
	codfns_sverify(P, rgt, R);
	
	res->type = L->type = K->type = R->type = apl_type_d;
	B->type = apl_type_i;
	
	for (i = 0; i < P->size; i++)
		scalar1(i, res->elements, rgt->elements, env0);
	
	ew[0] = env0;
	
	codfns_eachm(R, NULL, K, anon_w, ew);
	
	for (i = 0; i < P->size; i++)
		scalar4(i, res->elements, rgt->elements, env0);
		
	clean_env(env0, 5);

	return 0;
}


int static inline
scalar2(int64_t i, void *res, void *rgt, struct codfns_array *env0)
{
 	double *T, r, v, *D1, *D2, tf, *expRT, *vsqrtT;
 	int64_t *S, *X, ti;
 	
 	S = ((int64_t *)(&env0[0])->elements) + i;
 	X = ((int64_t *)(&env0[1])->elements) + i;
 	expRT = ((double *)(&env0[3])->elements) + i;
 	vsqrtT = ((double *)(&env0[4])->elements) + i;
 	D1 = ((double *)(&env0[5])->elements) + i;
 	D2 = ((double *)(&env0[6])->elements) + i;
 	T = ((double *)rgt) + i;
	r = 0.02;
	v = 0.03;
	tf = 0.5;
	ti = 2;
 	
 	*expRT = -r;
 	*expRT = *expRT * *T;
 	*expRT = exp(*expRT);
 	*vsqrtT = pow(*T, tf);
 	*vsqrtT = v * *vsqrtT;
 	*D1 = pow(v, ti);
 	*D1 = *D1 / ti;
 	*D1 = r + *D1;
 	*D1 = *D1 * *T;
 	tf = (double)*S / (double)*X;
 	tf = log(tf);
 	*D1 = tf + *D1;
 	*D1 = *D1 / *vsqrtT;
 	*D2 = *D1 - *vsqrtT;
	
	return 0;
}

int static inline
scalar3(int64_t i, void *res, void *rgt, struct codfns_array *env0)
{
	int64_t *S, *X, ti;
	double *R, *CD1, *CD2, *expRT, *TMP, tf;
	
	S = ((int64_t *)(&env0[0])->elements) + i;
	X = ((int64_t *)(&env0[1])->elements) + i;
	R = ((double *)(&env0[9])->elements) + i;
	CD1 = ((double *)(&env0[7])->elements) + i;
	CD2 = ((double *)(&env0[8])->elements) + i;
	expRT = ((double *)(&env0[3])->elements) + i;
	TMP = ((double *)(&env0[10])->elements) + i;
	ti = 1;
	
	*R = *expRT * *CD2;
	*R = *X * *R;
	tf = *S * *CD1;
	*R = tf - *R;
	*TMP = ti - *CD1;
	*TMP = *S * *TMP;
	tf = ti - *CD2;
	tf = *expRT * tf;
	tf = *X * tf;
	*TMP = tf - *TMP;

	return 0;
}

int
bs_codfnsm(struct codfns_array *res, 
    struct codfns_array *lft, struct codfns_array *rgt)
{
	struct codfns_array env0[13];
	struct codfns_array *scl, *S, *X, *T;
	struct codfns_array *P, *expRT, *vsqrtT, *D1, *D2, *CD1, *CD2;
	struct codfns_array *R, *TMP, *s;
	int64_t i, z; void *na;
	
	init_env(env0, 13);
		
	S = &env0[0];
	X = &env0[1];
	P = &env0[2];
	expRT = &env0[3];
	vsqrtT = &env0[4];
	D1 = &env0[5];
	D2 = &env0[6];
	CD1 = &env0[7];
	CD2 = &env0[8];
	R = &env0[9];
	TMP = &env0[10];
	s = &env0[11];
	scl = &env0[12];
	
	s->type = X->type = S->type = apl_type_i;
	D2->type = D1->type = vsqrtT->type = expRT->type = apl_type_d;
	CD1->type = CD2->type = R->type = TMP->type = apl_type_d;
	
	scl->type = apl_type_i;
	scl->size = 1;
	scl->elements = &z;
		
	z = 0;
	codfns_squadd(S, scl, lft);
	
	z = 1;
	codfns_squadd(X, scl, lft);
	
	T = rgt;
	
	codfns_sverify(P, &r, T);
	prepare_res(&na, expRT, P);
	codfns_sverify(P, &v, T);
	prepare_res(&na, vsqrtT, P);
	codfns_sverify(P, S, P);
	codfns_sverify(P, X, P);
	codfns_sverify(P, &r, P);
	codfns_sverify(P, &v, P);
	codfns_sverify(P, T, P);
	prepare_res(&na, D1, P);
	codfns_sverify(P, D1, vsqrtT);
	prepare_res(&na, D2, P);
	
	for (i = 0; i < P->size; i++)
		scalar2(i, res->elements, rgt->elements, env0);
		
	CNDP2(CD1, NULL, D1);
	CNDP2(CD2, NULL, D2);
		
	codfns_sverify(P, expRT, CD2);
	codfns_sverify(P, X, P);
	codfns_sverify(P, CD1, P);
	codfns_sverify(P, S, P);
	prepare_res(&na, R, P);
	prepare_res(&na, TMP, P);
	
	for (i = 0; i < P->size; i++)
		scalar3(i, res->elements, rgt->elements, env0);
	
	codfns_reshapem(s, NULL, S);
	z = 2;
	codfns_catenated(s, scl, s);
	codfns_catenated(TMP, R, TMP);
	codfns_reshaped(res, s, TMP);
	
	clean_env(env0, 12);

	return 0;
}

