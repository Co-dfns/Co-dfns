#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "env.h"

Environment *
new_env(int c)
{
	Environment *res;

	res = malloc(sizeof(Environment));

	if (res == NULL) {
		perror("new_env");
		exit(EXIT_FAILURE);
	}

	res->start = malloc(c * sizeof(struct env_entry));

	if (res->start == NULL) {
		perror("new_env");
		free(res);
		exit(EXIT_FAILURE);
	}

	res->end = res->start + c;
	res->cur = res->start;

	return res;
}

void
env_dispose(Environment *env)
{
	free(env->start);
	free(env);
}

int
env_lookup(Environment *env, const char *s, enum env_type *t, void **v)
{
	int i, c;
	struct env_entry *es;

	es = env->cur;
	c = ENV_COUNT(env);

	for (i = 0; i < c; i++) {
		es--;
		if (!strcmp(es->name, s)) {
			*t = es->type;
			*v = es->value;
			return 1;
		}
	}

	return 0;
}

void
env_insert_frame(Environment *env)
{
	env_insert(env, "", ENV_FRAME, NULL);
}

void
env_clear_frame(Environment *env)
{
	int i, c;
	struct env_entry *es;

	es = env->cur;
	c = ENV_COUNT(env);

	for (i = 0; i < c; i++) {
		es--;
		if (es->type == ENV_FRAME) {
			env->cur = es;
			return;
		}
	}

	env->cur = env->start;
}

void
env_resize(Environment *env, int nc)
{
	int c;
	struct env_entry *new;

	c = ENV_COUNT(env);
	new = realloc(env->start, nc * sizeof(struct env_entry));

	if (new == NULL) {
		perror("env_resize");
		exit(EXIT_FAILURE);
	}

	env->start = new;
	env->end = new + nc;
	env->cur = new + c;
}

void
env_insert(Environment *env, const char *s, enum env_type t, void *v)
{
	struct env_entry *e;

	if (ENV_AVAIL(env) == 0)
		env_resize(env, 1.5 * ENV_SIZE(env));

	e = env->cur;

	e->name = s;
	e->type = t;
	e->value = v;

	env->cur++;
}
