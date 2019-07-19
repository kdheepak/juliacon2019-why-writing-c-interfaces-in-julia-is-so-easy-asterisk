import Libdl


lib = Libdl.dlopen(joinpath(@__DIR__, "../o/liblibrary_default_cc_example5c.dylib"))

println("-----------------------------------------------------")
x = Int32(5)
@show x
@show ccall(:incrementIntegerValueReturnValue, Cint, (Cint, ), 5)
@show x

println("-----------------------------------------------------")
x = Int32(5)
@show x
@show ccall(:incrementIntegerPointerReturnValue, Cint, (Ptr{Cint}, ), Ref(Int32(x)))
@show x

println("-----------------------------------------------------")
x = Int32(5)
ref_x = Ref(x)
@show ref_x[]
@show ccall(:incrementIntegerPointerInInput, Cvoid, (Ptr{Cint}, ), ref_x)
@show ref_x[]

println("-----------------------------------------------------")
arr = Int32[0, 1, 2, 3, 4]
@show arr
@show ccall(:incrementIntegersInIntStarArray, Cvoid, (Ptr{Vector{Cint}}, Cint), pointer(arr), length(arr))
@show arr

println("-----------------------------------------------------")
arr = Int32[0, 1, 2, 3, 4]
@show arr
@show ccall(:incrementIntegersInIntStarStarArray, Cvoid, (Vector{Cint}, Cint), arr, length(arr))
@show arr

println("-----------------------------------------------------")
arr = Int32[0, 1, 2, 3, 4]
ref_arr = Ref(arr)
@show arr
@show ccall(:incrementIntegersInIntStarStarArray, Cvoid, (Ptr{Vector{Cint}}, Cint), ref_arr, length(arr))
@show arr

println("-----------------------------------------------------")
mutable struct Structure
    integer::Cint
end

s = Structure(1)
@show s
@show ccall(:incrementIntegerInStruct, Structure, (Structure, ), s)
@show s

println("-----------------------------------------------------")

s = Structure(1)
@show s
@show ccall(:incrementIntegerInStructPointer, Cvoid, (Ref{Structure}, ), s)
@show s

println("-----------------------------------------------------")
s = Structure(1)
@show s
@show ccall(:incrementIntegerInStructPointer, Cvoid, (Ptr{Nothing}, ), pointer_from_objref(s))
@show s

println("-----------------------------------------------------")
@show s = ccall(:initializeStructureStack, Structure, ())

println("-----------------------------------------------------")
@show s = unsafe_load(ccall(:initializeStructureHeap, Ptr{Structure}, ()))

println("-----------------------------------------------------")
Libdl.dlclose(lib)
