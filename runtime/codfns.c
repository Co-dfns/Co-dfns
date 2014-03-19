#include "codfns.h"

uint64_t
FFIGetSize(struct codfns_array *arr)
{
  return arr->size;
}

uint16_t
FFIGetRank(struct codfns_array *arr)
{
  return arr->rank;
}

void
FFIGetDataInt(int64_t **res, struct codfns_array *arr)
{
  *res = arr->elements;
  return;
}

void
FFIGetShape(uint32_t **res, struct codfns_array *arr)
{
  *res = arr->shape;
  return;
}
