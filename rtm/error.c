#include <string.h>
#include <stdio.h>
#include <wchar.h>

#include "internal.h"

DECLSPEC struct cell_array *debug_info = NULL;

DECLSPEC void
debug_trace(int err, const char *file, int line, const char *func, 
    const wchar_t *expr)
{
	struct cell_array *tmp;
	size_t msgcnt;
	wchar_t *dbg, *fmt;
	
	fmt = L"%ws%hs:%d(%hs) %ws\r";
	dbg = L"";
	
	if (debug_info)
		dbg = debug_info->values;
	
	msgcnt = swprintf(NULL, 0, fmt, dbg, file, line, func, expr);
	
	if (mk_array(&tmp, ARR_CHAR16, STG_HOST, 1))
		return;
	
	tmp->shape[0] = msgcnt + 1;
	
	if (alloc_array(tmp))
		return;
	
	swprintf(tmp->values, msgcnt + 1, fmt, dbg, file, line, func, expr);
	
	release_array(debug_info);
	
	debug_info = tmp;
}
