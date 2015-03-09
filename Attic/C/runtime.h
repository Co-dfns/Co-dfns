typedef struct array {
	int size;
	int rank;
	long *shape;
	long *elems;
} Array;

Array *codfns_plus(Pool *, Array *, Array *);
