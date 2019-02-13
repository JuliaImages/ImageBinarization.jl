module ImageBinarization

using Images
using LinearAlgebra
using HistogramThresholding
using Polynomials

abstract type BinarizationAlgorithm end
struct Otsu <: BinarizationAlgorithm end
struct Polysegment <: BinarizationAlgorithm end
struct AdaptiveThreshold <: BinarizationAlgorithm end

include("otsu.jl")
include("polysegment.jl")
include("adaptive_threshold.jl")
include("util.jl")

export
	# main functions
    binarize,
	binarize!,
	Otsu,
	Polysegment,
	AdaptiveThreshold

end # module
