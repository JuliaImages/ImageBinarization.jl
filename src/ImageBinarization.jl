module ImageBinarization

using ImageContrastAdjustment
using ColorTypes
using ColorVectorSpace
using LinearAlgebra
using HistogramThresholding
using Polynomials

abstract type BinarizationAlgorithm end
struct Otsu <: BinarizationAlgorithm end
struct Polysegment <: BinarizationAlgorithm end
struct UnimodalRosin <: BinarizationAlgorithm end


include("otsu.jl")
include("polysegment.jl")
include("unimodal.jl")

export
	# main functions
    binarize,
	binarize!,
	Otsu,
	Polysegment,
	UnimodalRosin
end # module
