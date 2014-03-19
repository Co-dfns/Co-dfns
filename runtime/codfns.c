#include <stdlib.h>
#include <error.h>
#include <stdio.h>
#include <string.h>

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

int
FFIMakeArray(struct codfns_array **res,
    uint16_t rnk, uint64_t sz, uint32_t *shp, int64_t *dat)
{
  struct codfns_array *arr;

  arr = malloc(sizeof(struct codfns_array));

  if (arr == NULL) {
    perror("FFIMakeArray");
    return 1;
  }

  arr->rank = rnk;
  arr->size = sz;
  arr->shape = shp;
  arr->elements = dat;
  *res = arr;

  return 0;
}

void
array_free(struct codfns_array *arr)
{
  free(arr->elements);
  free(arr->shape);
  arr->size = 0;
  arr->rank = 0;
  arr->shape = NULL;
  arr->elements = NULL;

  return;
}

int
array_cp(struct codfns_array *tgt, struct codfns_array *src)
{
  uint32_t *shp;
  int64_t *dat;

  if (tgt == src) return 0;

  shp = realloc(tgt->shape, src->rank);

  if (shp == NULL) {
    perror("array_cp");
    return 1;
  }

  dat = realloc(tgt->elements, src->size);

  if (dat == NULL) {
    perror("array_cp");
    return 2;
  }

  memcpy(shp, src->shape, src->rank);
  memcpy(dat, src->elements, src->size);

  tgt->rank = src->rank;
  tgt->size = src->size;
  tgt->shape = shp;
  tgt->elements = dat;

  return 0;
}

void
clean_env(struct codfns_array *env, int count)
{
  int i;
  struct codfns_array *cur;

  for (i = 0, cur = env; i < count; i++)
    array_free(cur++);

  return;
}
