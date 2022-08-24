#pragma once

#define EXPORT __declspec(dllexport)
#ifdef EXPORTING
        #define DECLSPEC EXPORT
#else
        #define DECLSPEC __declspec(dllimport)
#endif
enum cell_type {
        CELL_VOID,
        CELL_VOID_BOX,
        CELL_ARRAY_BOX,
        CELL_FUNC_BOX,
        CELL_MOPER_BOX,
        CELL_DOPER_BOX,
        CELL_ENV_BOX,
        CELL_ARRAY, 
        CELL_CLOSURE,
};
enum array_type {
        ARR_SPAN,
        ARR_CHAR8, ARR_CHAR16, ARR_CHAR32,
        ARR_BOOL, ARR_SINT, ARR_INT, ARR_DBL, ARR_CMPX,
        ARR_MIXED, ARR_NESTED
};

enum array_storage {
        STG_HOST, STG_DEVICE
};
struct cell_void {
        enum cell_type ctyp;
        unsigned int refc;
};
struct apl_cmpx {
        double real;
        double imag;
};
struct cell_array_box {
        enum cell_type ctyp;
        unsigned int refc;
        struct cell_array *value;
}
struct cell_func_box {
        enum cell_type ctyp;
        unsigned int refc;
        struct cell_func *value;
}
struct cell_moper_box {
        enum cell_type ctyp;
        unsigned int refc;
        struct cell_moper *value;
}
struct cell_doper_box {
        enum cell_type ctyp;
        unsigned int refc;
        struct cell_doper *value;
}
struct cell_env_box {
        enum cell_type ctyp;
        unsigned int refc;
        struct cell_env *value;
}
struct cell_void_box {
        enum cell_type ctyp;
        unsigned int refc;
        struct cell_void *value;
}
struct cell_array {
        enum cell_type ctyp;
        unsigned int refc;
        enum array_storage storage;
        enum array_type type;
        void *values;
        unsigned int rank;
        unsigned long long shape[];
};
struct cell_closure {
        enum cell_type ctyp;
        unsigned int refc;
        int (*fn)(struct cell_array **,
            struct cell_array *, struct cell_array *, void **);
        unsigned int fs;
        void *fv[];
}
DECLSPEC int mk_void(struct cell_void **);
DECLSPEC void release_void(struct cell_void *);
DECLSPEC void release_cell(void *);
DECLSPEC void *retain_cell(void *);
DECLSPEC void set_dmx_message(wchar_t *);
DECLSPEC void dwa_error(unsigned int);
DECLSPEC void set_codfns_error(void *);
DECLSPEC int mk_array_box(struct cell_array_box **,
     struct cell_array *);
DECLSPEC int mk_func_box(struct cell_func_box **,
     struct cell_func *);
DECLSPEC int mk_moper_box(struct cell_moper_box **,
     struct cell_moper *);
DECLSPEC int mk_doper_box(struct cell_doper_box **,
     struct cell_doper *);
DECLSPEC int mk_env_box(struct cell_env_box **,
     struct cell_env *);
DECLSPEC int mk_void_box(struct cell_void_box **,
     struct cell_void *);
DECLSPEC void
release_array_box(struct cell_array_box *);
DECLSPEC void
release_func_box(struct cell_func_box *);
DECLSPEC void
release_moper_box(struct cell_moper_box *);
DECLSPEC void
release_doper_box(struct cell_doper_box *);
DECLSPEC void
release_env_box(struct cell_env_box *);
DECLSPEC void
release_void_box(struct cell_void_box *);
DECLSPEC int mk_array(struct cell_array **, ...);
DECLSPEC void release_array(struct cell_array *);
DECLSPEC int dwa2array(struct cell_array **, void *);
DECLSPEC int array2dwa(void **, struct cell_array *, void *);
DECLSPEC int mk_closure(struct cell_closure **,
    int (*)(struct cell_array **,
        struct cell_array *, struct cell_array *, void **),
    unsigned int);
DECLSPEC void release_closure(struct cell_closure *);
DECLSPEC int cdf_init(void);
