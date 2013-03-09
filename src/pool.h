typedef struct pool {
	void *start;
	void *end;
	void *cur;
} Pool;

#define POOL_SIZE(p) ((char *)(p)->end - (char *)(p)->start)
#define POOL_AVAIL(p) ((char *)(p)->end - (char *)(p)->cur)

#define NEW_NODE(p, t, s) ((t*)pool_alloc((p), ((s)+sizeof(t))))

void *pool_alloc(Pool *, size_t);
void pool_dispose(Pool *);
Pool *new_pool(size_t);
