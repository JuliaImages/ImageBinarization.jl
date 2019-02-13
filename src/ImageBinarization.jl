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
struct MinimumIntermodes <: BinarizationAlgorithm end
struct Intermodes <: BinarizationAlgorithm end


include("otsu.jl")
include("polysegment.jl")
include("minimum.jl")
include("intermodes.jl")

export
	# main functions
    binarize,
	binarize!,
	Otsu,
	Polysegment,
  	MinimumIntermodes,
  	Intermodes
end # module
