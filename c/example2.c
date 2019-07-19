#include <stdio.h>

int GLOBAL_INTEGER;

int getInteger() {
  return GLOBAL_INTEGER;
}

void setInteger(int integer) {
  GLOBAL_INTEGER = integer;
}

int add(int integer) {
  return GLOBAL_INTEGER + integer;
}

void __attribute__ ((constructor)) initLibrary(void) {
    //
    // Function that is called when the library is loaded
    //
    printf("Library is initialized\n");
    GLOBAL_INTEGER = 0;
}
void __attribute__ ((destructor)) cleanUpLibrary(void) {
    //
    // Function that is called when the library is closed.
    //
    printf("Library is exited\n");
}

