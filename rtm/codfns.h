#pragma once

#define EXPORT __declspec(dllexport)
#ifdef EXPORTING
        #define DECLSPEC EXPORT
#else
        #define DECLSPEC __declspec(dllimport)
#endif
enum cell_type {
        CELL_VOID
        , CELL_ARRAY
        , CELL_BOX
        , CELL_CLOSURE
};
enum array_type {
        ARR_SPAN
        , ARR_CHAR
        ARR_BOOL, ARR_SINT, ARR_INT, ARR_DBL, ARR_CMP,
        ARR_MIXED, ARR_NESTED
};

enum array_storage {
        STG_HOST, STG_DEVICE
};
struct cell_void {
        enum cell_type ctyp;
        unsigned int refc;
};
struct cell_array {
        enum cell_type ctyp;
        unsigned int refc;
        enum array_storage storage;
        enum array_type type;
        void *values;
        unsigned int rank;
        unsigned long long shape[];
};
struct cell_box {
        enum cell_type ctyp;
        unsigned int refc;
        void *value;
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
DECLSPEC int mk_array(struct cell_array **, ...);
DECLSPEC void release_array(struct cell_array *);
DECLSPEC int dwa2array(struct cell_array **, void *);
DECLSPEC int array2dwa(void **, struct cell_array *, void *);
DECLSPEC int mk_box(struct cell_box **, void *);
DECLSPEC void release_box(struct cell_box *);
DECLSPEC int mk_closure(struct cell_closure **,
    int (*)(struct cell_array **,
        struct cell_array *, struct cell_array *, void **),
    unsigned int);
DECLSPEC void release_closure(struct cell_closure *);
DECLSPEC int cdf_init(void);
