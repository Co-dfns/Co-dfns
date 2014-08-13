#include <stdio.h>
#include <inttypes.h>
#include <math.h>

double
CNDP2(double D)
{
	int i;
	double K, L, R;
	
	double c[5] = {0.31938153, -0.356563782, 1.781477937, -1.821255978, 1.33027442};
	K = 1 / 1 + 0.2316419 * (L = fabs(D));
	
	for (R = 0, i = 0; i < 5; i++)
		R += c[i] * pow(D, 1+i);
	
	R = (1 / pow(6.283185307, 0.5)) * exp((L * L) / -2) * R;
	
	if (D >= 0) 
		return -1 * (-1 + R);
	else
		return R;
}


int64_t
bs_c(double *res, int64_t *S, int64_t *X, double *T, size_t count)
{
	int i;
	double r, v, expRT, vsqrtT, D1, D2, CD1, CD2;
	
	r = 0.02;
	v = 0.03;
	
	for (i = 0; i < count; i++) {
		expRT = exp(-r * T[i]);
		vsqrtT = v*pow(T[i], 0.5);
		D1 = log(((double)S[i]) / ((double)X[i]));
		D1 = (D1 + (r + pow(v, 2) / 2) * T[i]) / vsqrtT;
		D2 = D1 - vsqrtT;
		CD2 = CNDP2(D2);
		CD1 = CNDP2(D1);
		res[i * 2] = (S[i] * CD1) - X[i] * expRT * CD2;
		res[i * 2 + 1] = (X[i] * expRT * (1 - CD2)) - S[i] * (1 - CD1);
	}

	return 0;
}

