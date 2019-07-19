#include <stdio.h>
#include <stdlib.h>

// Library code
struct User {
  char * username;
};

struct User * createUser(char * username) {
    struct User * user = malloc(sizeof(struct User));
    user->username = username;
    return user;
}

// Application code
struct User * createUser(char *);

int main() {

    struct User * user = createUser("kdheepak");
    free(user);

}
