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
void FFIGetDataInt(int64_t **, struct codfns_array *);
void FFIGetShape(uint32_t **, struct codfns_array *);
