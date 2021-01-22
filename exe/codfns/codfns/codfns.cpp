#include <iostream>
#include <string>

extern int compile(char *);

int main(int argc, char *argv[])
{
    if (argc < 2) {
        std::cout << "codfns [file] ..." << std::endl;
        return 1;
    }

    for (int i = 1; i < argc; i++)
        compile(argv[i]);

    return 0;
}
