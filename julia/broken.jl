import Libdl


function main()

    if length(ARGS) != 1
        println("ERROR: First argument must be the library to be loaded")
        exit(-1)
    end

    library = ARGS[1]

    println()

    lib = Libdl.dlopen(library)

    println()
    println("# Get GLOBAL_INTEGER from shared library: ")
    println()
    @show ccall(:getInteger, Cint, ())
    println()

    println("# Add 100 to GLOBAL_INTEGER from shared library and return result: ")
    println()
    @show ccall(:add, Cint, (Cint, ), 100)
    println()

    println("# Set GLOBAL_INTEGER in shared library: ")
    println()
    @show ccall(:setInteger, Cvoid, (Cint, ), 5)
    println()

    println("# Add 100 to GLOBAL_INTEGER from shared library and return result: ")
    println()
    @show ccall(:add, Cint, (Cint, ), 100)
    println()

    Libdl.dlclose(lib)

end

main()

