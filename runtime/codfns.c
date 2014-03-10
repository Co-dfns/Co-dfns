#include "codfns.h"

uint64_t
FFIGetSize(struct codfns_array *arr)
{
  return arr->size;
}

void
FFIGetDataInt(int64_t **res, struct codfns_array *arr)
{
  *res = arr->elements;
  return;
}
