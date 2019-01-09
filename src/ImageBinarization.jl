module ImageBinarization

using Images
using LinearAlgebra
using HistogramThresholding
using Polynomials

abstract type BinarizationAlgorithm end
struct Otsu <: BinarizationAlgorithm end
struct Polysegment <: BinarizationAlgorithm end


include("otsu.jl")
include("polysegment.jl")

export
	# main functions
    binarize,
	binarize!,
	Otsu,
	Polysegment

end # module
