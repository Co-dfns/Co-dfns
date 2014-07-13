int
codfns_indexgenm(struct codfns_array *, 
    struct codfns_array *, struct codfns_array *);

int
codfns_ptredd(struct codfns_array *, 
    struct codfns_array *, struct codfns_array *);

void
init_env(struct codfns_array *, int);

int
codfns_reshaped(struct codfns_array *, 
    struct codfns_array *, struct codfns_array *);

int
codfns_reshapem(struct codfns_array *, 
    struct codfns_array *, struct codfns_array *);

int
codfns_catenated(struct codfns_array *, 
    struct codfns_array *, struct codfns_array *);

int
codfns_squadd(struct codfns_array *, 
    struct codfns_array *, struct codfns_array *);

int
codfns_eachm(struct codfns_array *,
    struct codfns_array *, struct codfns_array *,
    int (*)(struct codfns_array *, struct codfns_array *,
        struct codfns_array *, struct codfns_array **),
    struct codfns_array **);

int times_if(double *, int64_t *, double *);
int times_fi(double *, double *, int64_t *);
int times_ff(double *, double *, double *);
int add_if(double *, int64_t *, double *);
int residue_f(double *, double *);
int reciprocal_f(double *, double *);
int divide_fi(double *, double *, int64_t *);
int exponent_f(double *, double *);
int greateq_fi(int64_t *, double *, int64_t *);

int print_array(struct codfns_array *);
