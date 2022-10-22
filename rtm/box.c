#include <stdlib.h>
#include "internal.h"

#define DEF_BOX_FNS(type, name)				\
DECLSPEC int						\
mk_##type##_box(struct cell_##type##_box **box,		\
    struct cell_##type *value)				\
{							\
        struct cell_##type##_box *tmp;			\
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
        free(box);					\
}

DEF_BOX_FNS(void, VOID);
DEF_BOX_FNS(array, ARRAY);
DEF_BOX_FNS(func, FUNC);
