import Libdl

Libdl.dlopen("o/liblibrary_default_cc_example1c.dylib")

x = ccall(:getInteger, Int, ())

@show x
