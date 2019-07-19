
VISIBILITY?=default

CFLAGS=-dynamiclib -fPIC -Wall -Werror -Wextra -pedantic -fvisibility=$(VISIBILITY) $^

slides:
	@mdp -icf README.md

version:
	@$(CC) --version
	@$(CXX) --version

example1c.dylib: c/example1.c
	$(CC) -dynamiclib -fPIC $^ -o o/liblibrary_$(VISIBILITY)_$(notdir $(CC))_$@

main: c/main.c
	$(CC) $^ -o o/$@

user.dylib: c/user.c
	$(CC) $(CFLAGS) -o o/$@

example2c.dylib: c/example2.c
	$(CC) $(CFLAGS) -o o/liblibrary_$(VISIBILITY)_$(notdir $(CC))_$@

example2cpp.dylib: c/example2.cpp
	$(CXX) $(CFLAGS) -o o/liblibrary_$(VISIBILITY)_$(notdir $(CXX))_$@

example3cpp.dylib: c/example3.cpp
	$(CXX) $(CFLAGS) -o o/liblibrary_$(VISIBILITY)_$(notdir $(CXX))_$@

example4cpp.dylib: c/example4.cpp
	$(CXX) $(CFLAGS) -o o/liblibrary_$(VISIBILITY)_$(notdir $(CXX))_$@

example5c.dylib: c/example5.c
	$(CC) $(CFLAGS) -o o/liblibrary_$(VISIBILITY)_$(notdir $(CC))_$@

