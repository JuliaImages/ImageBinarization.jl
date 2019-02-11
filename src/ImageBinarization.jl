module ImageBinarization

using ImageContrastAdjustment
using ColorTypes
using ColorVectorSpace
using LinearAlgebra
using HistogramThresholding
using Polynomials
using Statistics

abstract type BinarizationAlgorithm end
struct Otsu <: BinarizationAlgorithm end
struct Polysegment <: BinarizationAlgorithm end
struct Sauvola <: BinarizationAlgorithm end


include("otsu.jl")
include("polysegment.jl")
include("sauvola.jl")
include("util.jl")

export
	# main functions
    binarize,
	binarize!,
	Otsu,
	Polysegment,
	Sauvola

end # module
