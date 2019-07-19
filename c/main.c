#include <dlfcn.h>
#include <stdio.h>

int main() {

    void * lib;
    lib = dlopen("o/liblibrary_default_cc_example1c.dylib", RTLD_GLOBAL);

    int (*funcp)(void);

    funcp = dlsym(lib, "getInteger");

    if (funcp != NULL) {
        int x = (*funcp)();
        printf("x = %d\n", x);
    }

    dlclose(lib);
}
