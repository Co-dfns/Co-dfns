#include <stdio.h>

extern int compile(char *);

int main(int argc, char *argv[])
{
    if (argc < 2) {
        printf("codfns [file] ...\n");
        return 1;
    }

    for (int i = 1; i < argc; i++) {
        int res = compile(argv[i]);
        if (res)
            return res;
    }

        
    return 0;
}
