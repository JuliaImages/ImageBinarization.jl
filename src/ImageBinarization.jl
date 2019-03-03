module ImageBinarization

using ImageContrastAdjustment
using ColorTypes
using ColorVectorSpace
using LinearAlgebra
using HistogramThresholding
using Polynomials
using Statistics
using ImageCore

#import Images

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

struct AdaptiveThreshold <: BinarizationAlgorithm
	window_size::Int
	percentage::Int
end

struct Sauvola <: BinarizationAlgorithm
    window_size::Int
    bias::Float32
end

struct Niblack <: BinarizationAlgorithm
    window_size::Int
    bias::Float32
end

include("integral_image.jl")
include("util.jl")
include("balanced.jl")
include("otsu.jl")
include("polysegment.jl")
include("unimodal.jl")
include("minimum.jl")
include("intermodes.jl")
include("adaptive_threshold.jl")
include("minimum_error.jl")
include("yen.jl")
include("entropy.jl")
include("sauvola.jl")
include("niblack.jl")


export
	# main functions
    binarize,
    recommend_size,
    AdaptiveThreshold,
    Otsu,
    Balanced,
    Yen,
    Polysegment,
    MinimumIntermodes,
    Intermodes,
    MinimumError,
    UnimodalRosin,
    Entropy,
    Sauvola,
    Niblack
end # module
