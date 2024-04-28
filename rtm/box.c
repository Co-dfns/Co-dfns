#include <stdlib.h>
#include "internal.h"

#define DEF_BOX_FNS(type, name)				\
size_t mk_##type##_box_count = 0;			\
size_t free_##type##_box_count = 0;			\
							\
DECLSPEC int						\
mk_##type##_box(struct cell_##type##_box **box,		\
    struct cell_##type *value)				\
{							\
        struct cell_##type##_box *tmp;			\
							\
	mk_##type##_box_count++;			\
							\
        tmp = malloc(sizeof(struct cell_##type##_box));	\
							\
        if (tmp == NULL)				\
                return 1;				\
							\
        tmp->ctyp = CELL_##name##_BOX;			\
        tmp->refc = 1;					\
        tmp->value = value;				\
							\
        *box = tmp;					\
							\
        return 0;					\
}							\
							\
DECLSPEC void						\
release_##type##_box(struct cell_##type##_box *box)	\
{							\
        if (box == NULL)				\
                return;					\
							\
        if (!box->refc)					\
                return;					\
							\
        box->refc--;					\
							\
        if (box->refc)					\
                return;					\
							\
        release_##type(box->value);			\
							\
	free_##type##_box_count++;			\
							\
        free(box);					\
}

DEF_BOX_FNS(void, VOID);
DEF_BOX_FNS(array, ARRAY);
DEF_BOX_FNS(func, FUNC);
DEF_BOX_FNS(moper, MOPER);
DEF_BOX_FNS(doper, DOPER);

void
print_box_stats(void)
{
	printf("\tvoid_box alloc: %zd freed: %zd\n",
	    mk_void_box_count, free_void_box_count);
	printf("\tarray_box alloc: %zd freed: %zd\n",
	    mk_array_box_count, free_array_box_count);
	printf("\tfunc_box alloc: %zd freed: %zd\n",
	    mk_func_box_count, free_func_box_count);
	printf("\tmoper_box alloc: %zd freed: %zd\n",
	    mk_moper_box_count, free_moper_box_count);
	printf("\tdoper_box alloc: %zd freed: %zd\n",
	    mk_doper_box_count, free_doper_box_count);
}