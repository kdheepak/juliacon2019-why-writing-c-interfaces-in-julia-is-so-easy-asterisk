module Hello

Base.@ccallable foo(x::Cint)::Cint = 42
Base.@ccallable function bar(x::Cint)::Cint
    return 42
end

end
