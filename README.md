%title: Writing C interfaces in Julia - JuliaCon 2019
%author: kdheepak
%date: 2019-07-24

-> Why writing C interfaces in Julia is so easy* <-
===================================================

-> Dheepak Krishnamurthy <-

-> *July 24th* <-

-> *JuliaCon 2019, Baltimore, MD* <-

-> [Slides](https://github.com/kdheepak/juliacon2019-why-writing-c-interfaces-in-julia-is-so-easy-asterisk) <-

-------------------------------------------------

-> About Me <-
==============

- Python, Julia
- Written interfaces in Python and Julia using the C ABI

-------------------------------------------------

-> What this talk is about <-
=============================

- What C interfaces are and how they work
- How to use them in Julia using `ccall`
- Best practices for:
    - for writing/building C interfaces
    - for writing Julia code

-------------------------------------------------

-> What are C interfaces? <-
==============================

-------------------------------------------------

## What is a shared library?

Technique for placing library functions into a single unit that can be shared by multiple processes at run time

- A shared library or shared object
    - .so on Linux
    - .dylib on Apple
    - .dll on Windows

*Note*: `-fPIC` allows code to be located at any virtual address at run time.

-------------------------------------------------

## Shared library source code

```
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
```

```
clang -dynamiclib -fPIC c/example1.c -o o/liblibrary_default_cc_example1c.dylib
gcc -shared -fPIC c/example1.c -o o/liblibrary_default_cc_example1c.so
```

```
nm o/liblibrary_default_cc_example1c.dylib
0000000000001000 S _GLOBAL_INTEGER
0000000000000fa0 T _add
0000000000000f70 T _getInteger
0000000000000f80 T _setInteger
                 U dyld_stub_binder
```

-----------------------------------------

## Shared libraries

- Native machine code
- Typically loaded at run-time
- Provides an Application Binary Interface (ABI)

----------------------------

## Run time loading

```
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
```

```
cc c/main o/main
```

```
julia julia/main.jl
```

----------------------------

## Load library into Julia

```
import Libdl

lib = Libdl.dlopen("libexample1c.dylib") # must be called during initialization phase
```

----------------------------

## Call function from Julia

```
@show ccall(:getInteger, Cint, ())
```

------------------------------------------

## Application Binary Interfaces (ABI)

- interface between two binary program modules
- defines how data structures or computational routines are accessed in machine code
- low-level
- hardware-dependent format

-----------------------------------------

## Application Binary Interfaces (ABI)

- ABI implemented for each platform
- Various calling conventions implemented in almost every language out there
    - Order to put parameters on the call stack
    - `cdecl`, `stdcall`, `syscall`, `pascal` and more
- `dlopen` API contains `dlopen`, `dlsym`, `dlclose`, `dlerror` functions

---------------------------------------------------

-> API and ABI <-
================

-------------------------------------------------

## API and ABI

```
#include "user.h"

struct User * createUser(char *);

int main() {

    struct User * user = createUser("kdheepak");
    free(user);

}

```

----------------------------


## API changes [1]

```
struct User {
  char * username;
};

struct User * createUser(char * username) {
    struct User * user = malloc(sizeof(struct User));
    user->username = username;
    return user;
}
```

----------------------------

## API changes [2]

```
struct User {
  char * username;
  int id;
};

struct User * createUser(char * username, int id) {
    struct User * user = malloc(sizeof(struct User));
    user->username = username;
    user->id = id;
    return user;
}
```

----------------------------

## ABI changes [1]

```
struct User {
  char * username;
};

struct User * createUser(char * username) {
    struct User * user = malloc(sizeof(struct User));
    user->username = username;
    return user;
}
```

----------------------------

## ABI changes [2]

```
struct User {
  int id;
  char * username;
};

struct User * createUser(char * username) {
    struct User * user = malloc(sizeof(struct User));
    user->id = 0;
    user->username = username;
    return user;
}
```

----------------------------

-> Tips for writing C code <-
=================================

----------------------------

## Initialization and clean up

```
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
```

```
make example2.dylib
```

----------------------------

## Difference between C++ compilers


```
void print_hello(std::string arg) {

    std::cout << "hello " << arg << std::endl;

}
```

----------------------------

## Guards

```cpp
#ifdef __cplusplus

extern "C" {

#endif

...

#ifdef __cplusplus

}

#endif
```

----------------------------

## Visibility

```cpp
// Define EXPORTED for any platform
#if defined _WIN32 || defined __CYGWIN__
  #ifdef WIN_EXPORT
    // Exporting...
    #ifdef __GNUC__
      #define EXPORTED __attribute__ ((dllexport))
    #else
      #define EXPORTED __declspec(dllexport) // Note: actually gcc seems to also supports this syntax.
    #endif
  #else
    #ifdef __GNUC__
      #define EXPORTED __attribute__ ((dllimport))
    #else
      #define EXPORTED __declspec(dllimport) // Note: actually gcc seems to also supports this syntax.
    #endif
  #endif
#else
  #if __GNUC__ >= 4
    #define EXPORTED __attribute__ ((visibility ("default")))
  #else
    #define EXPORTED
  #endif
#endif
```

----------------------------

-> Tips for writing Julia code <-
=================================

----------------------------

## Julia and C

- [example5.jl](./julia/example5.jl)
- [example5.c](./c/example5.c)

----------------------------

## Memory management

- Let `ccall` handle converts
- The [Julia manual documentation](https://docs.julialang.org/en/v1/manual/calling-c-and-fortran-code/index.html) is great!

----------------------------

## Clang.jl

- [Clang.jl](https://github.com/JuliaInterop/Clang.jl) can parse C and C++ header files
- Can be used to generate Julia `ccall` code.

----------------------------

## Two levels of wrapping in Julia

- Wrap functions generated in Julia
    - Examples [here](https://github.com/GMLC-TDC/HELICS.jl/blob/bd5b2fe9f7d5e838824533ce3890d1b056441056/src/lib.jl) and [here](https://github.com/dss-extensions/OpenDSSDirect.jl/blob/66ba87f823b3e3d21752a39f83cdbfefcbbcca0d/src/lib.jl)
- Wrapping functions allows for more Julian interface
    - Example [here](https://github.com/GMLC-TDC/HELICS.jl/blob/bd5b2fe9f7d5e838824533ce3890d1b056441056/src/lib.jl#L691) and [here](https://github.com/GMLC-TDC/HELICS.jl/blob/bd5b2fe9f7d5e838824533ce3890d1b056441056/src/api.jl#L1421)

----------------------------

## Julia Package Compiler


```
juliac.jl -vas hello.jl
```

----------------------------

-> Questions? <-
==========================

Thanks to *@staticfloat* for reviewing my slides!
