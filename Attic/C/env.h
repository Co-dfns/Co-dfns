enum env_type {
	ENV_FRAME, ENV_VALUE, ENV_FUNC
};

struct env_entry {
	const char *name;
	enum env_type type;
	void *value;
};

typedef struct env {
	struct env_entry *start;
	struct env_entry *end;
	struct env_entry *cur;
} Environment;

#define ENV_SIZE(e) ((e)->end - (e)->start)
#define ENV_AVAIL(e) ((e)->end - (e)->cur)
#define ENV_COUNT(e) ((e)->cur - (e)->start)

Environment *new_env(int);
void env_dispose(Environment *);
int env_lookup(Environment *, const char *, enum env_type *, void **);
void env_insert_frame(Environment *);
void env_clear_frame(Environment *);
void env_insert(Environment *, const char *, enum env_type, void *);
