#include "internal.h"

#define CONSTANT(name, atype, ctype, rank, shp, val)	\
ctype name##_##data[] = val;				\
unsigned name##_##vrefc = 1;				\
struct cell_array name = {				\
	CELL_ARRAY, 1, NULL, STG_HOST, atype, 		\
	name##_##data, &name##_##vrefc, rank, shp	\
};

CONSTANT(NUM_0, ARR_BOOL, int8_t, 0, , {0});
CONSTANT(NUM_1, ARR_BOOL, int8_t, 0, , {1});

CONSTANT(NUM_11, ARR_SINT, int16_t, 0, , {11});
CONSTANT(NUM_80, ARR_SINT, int16_t, 0, , {80});
CONSTANT(NUM_160, ARR_SINT, int16_t, 0, , {160});
CONSTANT(NUM_163, ARR_SINT, int16_t, 0, , {163});
CONSTANT(NUM_320, ARR_SINT, int16_t, 0, , {320});
CONSTANT(NUM_323, ARR_SINT, int16_t, 0, , {323});
CONSTANT(NUM_326, ARR_SINT, int16_t, 0, , {326});
CONSTANT(NUM_645, ARR_SINT, int16_t, 0, , {645});
CONSTANT(NUM_1289, ARR_SINT, int16_t, 0, , {1289});
