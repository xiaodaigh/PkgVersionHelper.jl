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
    upcheck(; indirect_deps=false)

Checks which package is not up to date. It wil return a
`Dict{String, Tuple{VersionNumber, VersionNumber}}` with these key-value paiars

    `PkgName => (installed_version, latest_version)`

Keyword argument `indirect_deps` if `true` includes the indirect dependencies.
"""
function upcheck(; indirect_deps = false)
    deps = Pkg.dependencies()
    installs = Dict{String, Tuple{VersionNumber, VersionNumber}}()
    for (uuid, dep) in deps
        # is it direct dependency?
        dep.is_direct_dep | indirect_deps || continue

        # is it a standard library
        Pkg.Types.is_stdlib(uuid) && continue

        try
            if max_ver(dep.name) <= dep.version
                continue
            end
            installs[dep.name] = (dep.version, max_ver(dep.name))
        catch e
            println("$(dep.name) may not be a registered package")
        end
    end
    return installs
end

end
