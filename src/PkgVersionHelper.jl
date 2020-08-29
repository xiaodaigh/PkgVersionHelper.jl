module PkgVersionHelper

export upcheck

using Pkg

# from https://stackoverflow.com/questions/62667741/julia-is-there-a-way-to-find-the-latest-possible-version-number-of-a-package
function max_ver(pkgname::AbstractString)
    path = joinpath(DEPOT_PATH[1], "registries", "General",
                    first(pkgname, 1), pkgname, "Versions.toml")
    maximum(VersionNumber.(keys(Pkg.TOML.parse(read(path, String)))))
end


"""
    Checks which package is not up to date
"""
function upcheck()
    deps = Pkg.dependencies()
    installs = Dict{String, Tuple{VersionNumber, VersionNumber}}()
    for (_, dep) in deps
        dep.is_direct_dep || continue
        try
            if max_ver(dep.name) <= dep.version
                continue
            end
            installs[dep.name] = (dep.version, max_ver(dep.name))
        catch e
            println("$(dep.name) may not be a registered pacakge")
        end
    end
    return installs
end

end
