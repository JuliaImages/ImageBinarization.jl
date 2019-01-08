module ImageBinarization

using Images
using LinearAlgebra
using HistogramThresholding

abstract type BinarizationAlgorithm end
struct Otsu <: BinarizationAlgorithm end

include("otsu.jl")

export
	# main functions
    binarize,
	binarize!,
	Otsu

end # module
