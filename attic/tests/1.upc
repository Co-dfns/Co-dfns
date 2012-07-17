#include <stdio.h>
#include "hpapl.h"

int main(int argc, char *argv[]) {
decl  (res        );
alloc (res,0,0,1,1);
assign(res,0,5    );
apl_print(res);
return 0;
}
