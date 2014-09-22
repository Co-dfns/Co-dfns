#pragma once

extern "C" {

#include "t.h"

#define scalar(x) ((x)->rank == 0)

#include "l.cuh"
#include "k.cuh"

/* Scalar monadic primitive */
#define scalar_monadic_main(nm, dt, it) int \
codfns_##nm(A*res,A*lft,A*rgt,A**onv){smd(nm,dt,it)}

/* Scalar dyadic primitive */
#define scalar_dyadic_main(nm, ddt, dit, idt, iit) int \
codfns_##nm(A*res,A*lft,A*rgt,A**onv){sdd(nm,ddt,dit,idt,iit)}

/* Scalar monadic definition */
#define scalar_monadic(nm, dt, it, code) \
smi(nm, dt, d, code) smi(nm, it, i, code) scalar_monadic_main(nm, dt, it)

/* Scalar dyadic definition */
#define scalar_dyadic(nm, ddt, dit, idt, iit, code) \
sdi(nm, ddt, d, d, code) sdi(nm, dit, d, i, code) sdi(nm, idt, i, d, code) \
sdi(nm, iit, i, i, code) scalar_dyadic_main(nm, ddt, dit, idt, iit)

I same_shape(A*,A*);
I copy_shape(A*,A*);
I scale_elements(A*,UI64);
I scale_shape(A*,UI16);
I scale(A*,UI16,UI64);
I prep(V**,A*,A*);
UI64 tr(UI64,UI64*);
V h2g(A*);
V g2h(A*);

V ps(A*);
V pa(A*);
V pei(A*);
V ped(A*);
}
