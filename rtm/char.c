#include "internal.h"

static int 
cp_utf8(unsigned char *buf, unsigned int point)
{
	/* https://stackoverflow.com/a/42013433 */
	
	if (point <= 0x7F) {
		buf[0] = point;
		return 1;
	}
	
	if (point <= 0x7FF) {
		buf[0] = 0xC0 | (point >> 6);            /* 110xxxxx */
		buf[1] = 0x80 | (point & 0x3F);          /* 10xxxxxx */
		return 2;
	}
	
	if (point <= 0xFFFF) {
		buf[0] = 0xE0 | (point >> 12);           /* 1110xxxx */
		buf[1] = 0x80 | ((point >> 6) & 0x3F);   /* 10xxxxxx */
		buf[2] = 0x80 | (point & 0x3F);          /* 10xxxxxx */
		return 3;
	}
	
	if (point <= 0x10FFFF) {
		buf[0] = 0xF0 | (point >> 18);           /* 11110xxx */
		buf[1] = 0x80 | ((point >> 12) & 0x3F);  /* 10xxxxxx */
		buf[2] = 0x80 | ((point >> 6) & 0x3F);   /* 10xxxxxx */
		buf[3] = 0x80 | (point & 0x3F);          /* 10xxxxxx */
		return 4;
	}

	return 0;
}

void
print_cp8(uint8_t *pts, size_t count)
{
	for (size_t i = 0; i < count; i++) {
		putchar(*pts++);
	}
}

void
print_cp16(uint16_t *pts, size_t count)
{
	unsigned char buf[4];
	
	for (size_t i = 0; i < count; i++) {
		int w = cp_utf8(buf, *pts++);
		
		for (int j = 0; j < w; j++)
			putchar(buf[j]);
	}
}

void
print_cp32(uint32_t *pts, size_t count)
{
	unsigned char buf[4];
	
	for (size_t i = 0; i < count; i++) {
		int w = cp_utf8(buf, *pts++);
		
		for (int j = 0; j < w; j++)
			putchar(buf[j]);
	}
}
