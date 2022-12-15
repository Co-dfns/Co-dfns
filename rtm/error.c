#include <string.h>
#include <stdio.h>

#include "internal.h"

DECLSPEC struct cell_array *debug_info = NULL;

DECLSPEC void
debug_trace(int err, const char *file, int line, const char *func, 
    const char *expr)
{
	struct cell_array *tmp;
	size_t msgcnt;
	char *dbg, *fmt;
	
	fmt = "%s%s:%d\t%s\t%s\n";
	dbg = "";
	
	if (debug_info)
		dbg = debug_info->values;
	
	msgcnt = snprintf(NULL, 0, fmt, dbg, file, line, func, expr);
	
	if (mk_array(&tmp, ARR_CHAR8, STG_HOST, 1))
		return;
	
	tmp->shape[0] = msgcnt + 1;
	
	if (alloc_array(tmp))
		return;
	
	snprintf(tmp->values, msgcnt + 1, fmt, dbg, file, line, func, expr);
	
	release_array(debug_info);
	
	debug_info = tmp;
}
