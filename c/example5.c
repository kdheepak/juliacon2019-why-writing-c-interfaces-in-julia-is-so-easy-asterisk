#include <stdio.h>
#include <stdlib.h>

#define LIBRARY_EXPORT __attribute__ ((visibility ("default")))

#ifdef __cplusplus

extern "C" {

#endif

// Integers
// Strings
// Arrays
// Structs

int LIBRARY_EXPORT incrementIntegerValueReturnValue(int input) {
    int output;
    output = 0;
    output = input + 1;
    return output;
}

int LIBRARY_EXPORT incrementIntegerPointerReturnValue(int * input) {
    int output;
    output = 0;
    output = *input + 1;
    return output;
}

void LIBRARY_EXPORT incrementIntegerPointerInInput(int * input) {
    *input = *input + 1;
    return;
}

void LIBRARY_EXPORT incrementIntegersInIntStarArray(int * input, int length) {
    for (int i=0; i < length; i++) {
        *(input + i) = *(input + i) + 1;
    }
    return;
}

void LIBRARY_EXPORT incrementIntegersInIntStarStarArray(int ** input, int length) {
    for (int i=0; i < length; i++) {
        *(*input + i) = *(*input + i) + 1;
    }
    return;
}

struct Structure {
    int integer;
};

struct Structure LIBRARY_EXPORT incrementIntegerInStruct(struct Structure s) {
    s.integer = s.integer + 1;
    return s;
}

void LIBRARY_EXPORT incrementIntegerInStructPointer(struct Structure * s) {
    s->integer = s->integer + 1;
    return;
}

struct Structure LIBRARY_EXPORT initializeStructureStack() {
    struct Structure s;
    s = (struct Structure) { 10 };
    return s;
}

struct Structure * LIBRARY_EXPORT initializeStructureHeap() {
    struct Structure * s = malloc(sizeof(struct Structure));
    s->integer = 13;
    return s;
}


#ifdef __cplusplus

}

#endif


