#include <stdio.h>
#include <inttypes.h>
#include <math.h>
#include "dwa.h"
#include "dwa_fns.h"

void EXPORT
bs_acc(LOCALP *resA, LOCALP *SA, LOCALP *XA, LOCALP *TA)
{
	size_t i, c2, count;
    int32_t *restrict S, *restrict X; 
    double *restrict T, *restrict res;
    POCKET *p;
    BOUND sp[15];
    
    double a[2] = {1, -1}; double b[2] = {0, -1};

    #pragma acc enter data async copyin(a[0:2],b[0:2])

    count = TA->p->SHAPETC[0];

    S = ARRAYSTART(SA->p);

    #pragma acc enter data async copyin(S[0:count])

    X = ARRAYSTART(XA->p);

    #pragma acc enter data async copyin(X[0:count]) 

    T = ARRAYSTART(TA->p);

    #pragma acc enter data async copyin(T[0:count]) 
    
    c2 = count * 2;
    sp[0] = count; sp[1] = 2; 
    p = getarray(APLDOUB, 2, sp, NULL);
    res = ARRAYSTART(p);
    relp(resA);resA->p=p;

    #pragma acc enter data async create(res[0:c2])
    
    #pragma acc parallel loop wait present(S,X,T,a,b,res)
	for (i = 0; i < count; i++) {
        int tst;
	    double r, v, expRT, vsqrtT, D1, D2, CD1, CD2, K, L, R;
	    r = 0.02;
    	v = 0.03;
		expRT = exp(-r * T[i]);
		vsqrtT = v*pow(T[i], 0.5);
		D1 = log(((double)S[i]) / ((double)X[i]));
		D1 = (D1 + (r + pow(v, 2) / 2) * T[i]) / vsqrtT;
		D2 = D1 - vsqrtT;
		/* CD2 = CNDP2_c(D2); */
	    K = 1 / 1 + 0.2316419 * (L = fabs(D2));
	    R = 0;
        R += 0.31938153 * pow(K, 1);
        R += -0.356563782 * pow(K, 2);
        R += 1.781477937 * pow(K, 3);
        R += -1.821255978 * pow(K, 4);
        R += 1.33027442 * pow(K, 5);	
	    R = (1 / pow(6.283185307, 0.5)) * exp((L * L) / -2) * R;
	    tst = D2 >= 0;
        CD2 = a[tst] * (b[tst] + R);

		/* CD1 = CNDP2_c(D1); */
	    K = 1 / 1 + 0.2316419 * (L = fabs(D1));
	    R = 0;
        R += 0.31938153 * pow(K, 1);
        R += -0.356563782 * pow(K, 2);
        R += 1.781477937 * pow(K, 3);
        R += -1.821255978 * pow(K, 4);
        R += 1.33027442 * pow(K, 5);	
	    R = (1 / pow(6.283185307, 0.5)) * exp((L * L) / -2) * R;
	    tst = D1 >= 0;
        CD2 = a[tst] * (b[tst] + R);

		res[i * 2] = (S[i] * CD1) - X[i] * expRT * CD2;
		res[i * 2 + 1] = (X[i] * expRT * (1 - CD2)) - S[i] * (1 - CD1);
	}
    
    #pragma acc exit data copyout(res[0:c2])
    #pragma acc exit data delete(S,X,T,a,b)

	return;
}

