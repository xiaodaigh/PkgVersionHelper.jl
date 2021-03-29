## PkgVersionHelper

*Do I have the latest dependencies for my packages in the `[compat]` section of Project.toml?*

This is simple package that can help you check whether you have the most up-to-date package in your Project.toml.

### Usage

```
using PkgVersionHelper: upcheck

upcheck()
```

This will check through the direct dependencies (i.e. those packages in your Project.toml) and return a `Dict` like this

```
PkgName => (installed_version, latest_version)
```

For example, this was the output for one of my packages

```
julia> upcheck()
Dict{String,Tuple{VersionNumber,VersionNumber}} with 2 entries:
  "ScientificTypes" => (v"0.8.1", v"1.0.0")
  "MLJBase"         => (v"0.14.9", v"0.15.0")
```

If you wish to check the _indirect_ dependencies as well. Simply do `upcheck(indirect_deps=true)`.

### Why?

CompatHelper.jl is great but sometimes you are not able to upgrade your packages right away and often you are often left wondering "Do I have the latest dependencies?" I am often in such a spot so I've decided to gather [the answers on StackOverflow](https://stackoverflow.com/questions/62667741/julia-is-there-a-way-to-find-the-latest-possible-version-number-of-a-package) and make a simple package.

Thanks to the wonderful @bkamins for helping me with my query.
