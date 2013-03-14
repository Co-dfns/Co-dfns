typedef struct pool {
	void *start;
	void *end;
	void *cur;
} Pool;

#define POOL_SIZE(p) ((size_t)((char *)(p)->end - (char *)(p)->start))
#define POOL_AVAIL(p) ((size_t)((char *)(p)->end - (char *)(p)->cur))

#define NEW_NODE(p, t) ((t*)pool_alloc((p), sizeof(t)))

void *pool_alloc(Pool *, size_t);
void pool_dispose(Pool *);
Pool *new_pool(size_t);
