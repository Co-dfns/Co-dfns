#include <stdlib.h>
#include <error.h>
#include <inttypes.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

#include "codfns.h"

/* init_env()
 * Intended Function: Initialize a frame environment.
 */

void
init_env(struct codfns_array *env, int count)
{
	int i;
	
	for (i = 0; i < count; i++, env++) {
		env->type = 0;
		env->rank = 0;
		env->size = 0;
		env->shape = NULL;
		env->elements = NULL;
		env->gpu_elements = NULL;
		env->on_gpu = 0;
	}
}

/* clean_env()
 *
 * Intended Function: Given an environment pointer and its size, free
 * the arrays in that environment.
 */

void
clean_env(struct codfns_array *env, int count)
{
	int i;
	struct codfns_array *cur;

	for (i = 0, cur = env; i < count; i++)
		array_free(cur++);

	return;
}

