module ImageBinarization

using Base.Iterators: repeated
using MappedArrays
using LinearAlgebra
using Polynomials
using Statistics

using ImageContrastAdjustment
using HistogramThresholding

using ImageCore
using ImageCore: GenericGrayImage
using ColorVectorSpace

# TODO: port BinarizationAPI to ImagesAPI
include("BinarizationAPI/BinarizationAPI.jl")
import .BinarizationAPI: AbstractImageBinarizationAlgorithm,
                         binarize, binarize!

include("integral_image.jl")
include("util.jl")
include("compat.jl")

# Concrete binarization algorithms

include("algorithms/adaptive_threshold.jl") # AdaptiveThreshold
include("algorithms/balanced.jl") # Balanced
include("algorithms/entropy.jl") # Entropy
include("algorithms/intermodes.jl") # Intermodes
include("algorithms/minimum.jl") # MinimumIntermodes
include("algorithms/minimum_error.jl") # MinimumError
include("algorithms/moments.jl") # Moments
include("algorithms/niblack.jl") # Niblack
include("algorithms/otsu.jl") # Otsu
include("algorithms/polysegment.jl") # Polysegment
include("algorithms/sauvola.jl") # Sauvola
include("algorithms/unimodal.jl") # UnimodalRosin
include("algorithms/yen.jl") # Yen


include("deprecations.jl")

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
