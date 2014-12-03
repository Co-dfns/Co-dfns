#include <stdio.h>
#include <inttypes.h>
#include <math.h>
#include <cuda_runtime_api.h>
#include <cuda_runtime.h>

__device__ double c[5] = {0.31938153, -0.356563782, 1.781477937, -1.821255978, 1.33027442};
__device__ double r = 0.02;
__device__ double v = 0.03;

#define CNDP2m(R,D)\
{\
	double K, L;\
	\
	K = 1 / (1 + 0.2316419 * (L = fabs(D)));\
	R = 0;\
	R += c[0] * pow(K, 1);\
	R += c[1] * pow(K, 2);\
	R += c[2] * pow(K, 3);\
	R += c[3] * pow(K, 4);\
	R += c[4] * pow(K, 5);\
	R = 0.3989422804 * exp((L * L) / -2) * R;\
	R = ((D >= 0) ? -1 * (-1 + R) : R);\
}

__global__ void
kernel(double *res, int64_t *S, int64_t *X, double *T, size_t count)
{
	int i;
	double expRT, vsqrtT, D1, D2, CD1, CD2;
	
	i = blockDim.x * blockIdx.x + threadIdx.x;

	if (i < count) {	
		expRT = exp(-r * T[i]);
		vsqrtT = v*pow(T[i], 0.5);
		D1 = log(((double)S[i]) / ((double)X[i]));
		D1 = (D1 + (r + (v*v) / 2) * T[i]) / vsqrtT;
		D2 = D1 - vsqrtT;
		CNDP2m(CD2,D2);
		CNDP2m(CD1,D1);
		res[i*2] = (S[i] * CD1) - X[i] * expRT * CD2;
		res[i*2+1] = (X[i] * expRT * (1 - CD2)) - S[i] * (1 - CD1);
	}
}

extern "C" void
copy_data(double **res, int64_t **Sp, int64_t **Xp, double **Tp, int64_t *S, int64_t *X, int64_t *T, size_t count)
{
	*Tp = (double*)malloc(count * sizeof(double));
	*Sp = (int64_t*)malloc(count * sizeof(int64_t));
	*Xp = (int64_t*)malloc(count * sizeof(int64_t));
	*res = (double*)malloc (2 * count * sizeof(double));
	
	memcpy(*Tp,T,count*sizeof(double));
	memcpy(*Sp,S,count*sizeof(int64_t));
	memcpy(*Xp,X,count*sizeof(int64_t));
}

#define chk(m,x) if(cudaSuccess != (x)){printf("\n\n\n\n\n\n\nFailure: %s!\n",(m));return 1;}

extern "C" int64_t
bs_c(double *res, int64_t *S, int64_t *X, double *T, size_t count)
{
	int bs,tc;
	size_t db,ib;
	double *gres, *gT;
	int64_t *gS, *gX;
	
	ib=count*sizeof(int64_t);db=count*sizeof(double);
	
	chk("gres alloc",cudaMalloc(&gres,2*db));
	chk("gS alloc",cudaMalloc(&gS,ib));
	chk("gX alloc",cudaMalloc(&gX,ib));
	chk("gT alloc",cudaMalloc(&gT,db));
	
	chk("gS copy",cudaMemcpy(gS,S,ib,cudaMemcpyHostToDevice));
	chk("gX copy",cudaMemcpy(gX,X,ib,cudaMemcpyHostToDevice));
	chk("gT copy",cudaMemcpy(gT,T,db,cudaMemcpyHostToDevice));
	
	tc = 896;
	bs = (count+tc-1)/tc;
	kernel<<<bs,tc>>>(gres,gS,gX,gT,count);
	
	chk("res copy",cudaMemcpy(res,gres,2*db,cudaMemcpyDeviceToHost));

	cudaFree(gres);cudaFree(gS);cudaFree(gX);cudaFree(gT);
	
	return 0;
}

