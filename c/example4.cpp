#include <stdio.h>
#include <string>
#include <iostream>

#define LIBRARY_EXPORT __attribute__ ((visibility ("default")))

#ifdef __cplusplus

extern "C" {

#endif

int GLOBAL_INTEGER;

int LIBRARY_EXPORT getInteger() {
  return GLOBAL_INTEGER;
}

void LIBRARY_EXPORT setInteger(int integer) {
  GLOBAL_INTEGER = integer;
}

int LIBRARY_EXPORT add(int integer) {
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

#ifdef __cplusplus

}

#endif


