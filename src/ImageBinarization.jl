module ImageBinarization

using ImageContrastAdjustment
using ColorTypes
using ColorVectorSpace
using LinearAlgebra
using HistogramThresholding
using Polynomials
using Statistics
using ImageCore

# TODO: port BinarizationAPI to ImagesAPI
include("BinarizationAPI/BinarizationAPI.jl")
import .BinarizationAPI: AbstractImageBinarizationAlgorithm,
                         binarize, binarize!

include("integral_image.jl")
include("util.jl")

# Concrete binarization algorithms

include("adaptive_threshold.jl") # AdaptiveThreshold
include("balanced.jl") # Balanced
include("entropy.jl") # Entropy
include("intermodes.jl") # Intermodes
include("minimum.jl") # MinimumIntermodes
include("minimum_error.jl") # MinimumError
include("moments.jl") # Moments
include("niblack.jl") # Niblack
include("otsu.jl") # Otsu
include("polysegment.jl") # Polysegment
include("sauvola.jl") # Sauvola
include("unimodal.jl") # UnimodalRosin
include("yen.jl") # Yen


export
    # generic API
    binarize, binarize!,

    # Algorithms
    AdaptiveThreshold, recommend_size,
    Balanced,
    Entropy,
    Intermodes,
    MinimumError,
    MinimumIntermodes,
    Moments,
    Niblack,
    Otsu,
    Polysegment,
    Sauvola,
    UnimodalRosin,
    Yen

end # module ImageBinarization
