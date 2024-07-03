using Pkg
used_packages = ["BenchmarkTools", "OrderedCollections", "Plots", "Distributions", "DataFrames", "CSV",
"LaTeXStrings", "Statistics", "DataFramesMeta", "StatsBase", "HypothesisTests"]
Pkg.add(used_packages)
Pkg.update()