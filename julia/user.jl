import Libdl

lib = Libdl.dlopen("o/user.dylib")

struct User
    username::String
end

user = ccall(:createUser, Ptr{User}, (String, ), "kdheepak") |> unsafe_load

@show user
