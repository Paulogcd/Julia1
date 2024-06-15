# packages.jl

using Pkg

list = ["DataFrames",
	"CSV",
	"Plots", 
	"GLM", 
	"StatsPlots", 
	"MLBase"]

Pkg.add(list)
