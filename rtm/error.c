#include <string.h>

#include "internal.h"

DECLSPEC struct cell_array *debug_info = NULL;

DECLSPEC void
debug_trace(int err, const char *file, int line, const char *func, 
    const char *expr)
{
	return;
}
