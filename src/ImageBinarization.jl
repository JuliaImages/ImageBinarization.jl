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
struct MinimumIntermodes <: BinarizationAlgorithm end
struct Intermodes <: BinarizationAlgorithm end
struct MinimumError <: BinarizationAlgorithm end
struct Balanced <: BinarizationAlgorithm end
struct Yen <: BinarizationAlgorithm end
struct Entropy <: BinarizationAlgorithm end

include("balanced.jl")
include("otsu.jl")
include("polysegment.jl")
include("unimodal.jl")
include("minimum.jl")
include("intermodes.jl")
include("minimum_error.jl")
include("yen.jl")
include("entropy.jl")


export
	# main functions
    binarize,
    Otsu,
    Balanced,
    Yen,
    Polysegment,
    MinimumIntermodes,
    Intermodes,
    MinimumError,
    UnimodalRosin,
    Entropy
end # module
