#define _GNU_SOURCE
#include <pthread.h>
#include <stdlib.h>
#include <errno.h>
#include <sched.h>
#include "scheme.h"

ptr thread_affinity_set(int cpu)
{
	pthread_t id;
	size_t cpusize;
	cpu_set_t *cpuset;
	
	id = pthread_self();
	cpusize = sizeof(cpu_set_t);
	
	if ((cpuset = malloc(cpusize)) == NULL) {
		return Sstring_to_symbol("malloc");
	}
	
	CPU_ZERO(cpuset);
	CPU_SET(cpu, cpuset);
	
	switch (pthread_setaffinity_np(id, cpusize, cpuset)) {
	case EFAULT: return Sstring_to_symbol("EFAULT");
	case EINVAL: return Sstring_to_symbol("EINVAL");
	case ESRCH: return Sstring_to_symbol("ESRCH");
	default: return Sstring_to_symbol("OKAY");
	}
	
	free(cpuset);
	
	return Sstring_to_symbol("OKAY");
}
	
