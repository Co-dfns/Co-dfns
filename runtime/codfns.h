/* Co-dfns Foreign Structures and Helper Functions */

#include <inttypes.h>

struct codfns_array {
  uint16_t  rank;
  uint64_t  size;
  uint8_t   type;
  uint32_t *shape;
  int64_t  *elements;
};

uint64_t FFIGetSize(struct codfns_array *);
uint16_t FFIGetRank(struct codfns_array *);
void FFIGetDataInt(int64_t *, struct codfns_array *);
void FFIGetShape(uint32_t *, struct codfns_array *);
int FFIMakeArray(struct codfns_array **res,
    uint16_t rnk, uint64_t sz, uint32_t *shp, int64_t *dat);
void array_free(struct codfns_array *arr);
int array_cp(struct codfns_array *tgt, struct codfns_array *src);

int codfns_same_shape(struct codfns_array *, struct codfns_array *); 
int codfns_add(struct codfns_array *, struct codfns_array *, 
    struct codfns_array *);
int codfns_subtract(struct codfns_array *, struct codfns_array *, 
    struct codfns_array *);
int codfns_multiply(struct codfns_array *, 
    struct codfns_array *, struct codfns_array *);
int codfns_divide(struct codfns_array *, 
    struct codfns_array *, struct codfns_array *, int );
int codfns_not(struct codfns_array *, 
    struct codfns_array *, struct codfns_array *); 
int codfns_less(struct codfns_array *, struct codfns_array *, struct codfns_array *);
int codfns_less_or_equal(struct codfns_array *, struct codfns_array *, struct codfns_array *);
int codfns_equal(struct codfns_array *, struct codfns_array *, struct codfns_array *);
int codfns_greater_or_equal(struct codfns_array *, struct codfns_array *, struct codfns_array *);
int codfns_not_equal(struct codfns_array *, struct codfns_array *, struct codfns_array *);
int codfns_power(struct codfns_array *ret, struct codfns_array *lft, struct codfns_array *rgt);
int codfns_magnitude(struct codfns_array *ret, struct codfns_array *lft, struct codfns_array *rgt);

