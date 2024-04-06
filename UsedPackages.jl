using Pkg
used_packages = ["BenchmarkTools", "OrderedCollections", "Plots", "Distributions", "DataFrames", "CSV",
"LaTeXStrings", "Statistics", "DataFramesMeta"]
Pkg.add(used_packages)
Pkg.update()