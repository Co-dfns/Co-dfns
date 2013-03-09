#include <stdio.h>
#include <string.h>

#include "pool.h"

unsigned short var_counter = 0;

char *
unique_name(Pool *mp, char *prefix)
{
	char *buf;
	size_t siz;
	siz = 5 + strlen(prefix); /* Length, not including |'\0'| */
	buf = NEW_NODE(mp, char, siz);
	sprintf(buf, "%s%d", prefix, var_counter);
	buf[siz] = '\0';
	var_counter = (var_counter + 1) % 65536;
	return buf;
}

