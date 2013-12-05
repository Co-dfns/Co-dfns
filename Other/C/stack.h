typedef struct stack {
	void **start;
	void **end;
	void **cur;
} Stack;

#define STACK_SIZE(s) ((s)->end - (s)->start)
#define STACK_AVAIL(s) ((s)->end - (s)->cur)
#define STACK_COUNT(s) ((s)->cur - (s)->start)

#define pop(s) (*(--(s)->cur))

int push(Stack *, void *);
Stack *new_stack_barrier(Stack *);
Stack *new_stack(int);
void stack_dispose(Stack *);
