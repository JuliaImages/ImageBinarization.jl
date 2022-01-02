module ImageBinarization

using Base.Iterators: repeated
using LinearAlgebra
using Polynomials
using Statistics
using Reexport

@reexport using HistogramThresholding

using ImageCore
using ImageCore.MappedArrays
using ImageCore: GenericGrayImage
using ColorVectorSpace

# TODO: port BinarizationAPI to ImagesAPI
include("BinarizationAPI/BinarizationAPI.jl")
import .BinarizationAPI: AbstractImageBinarizationAlgorithm,
                         binarize, binarize!
import HistogramThresholding: AbstractThresholdAlgorithm

include("integral_image.jl")
include("util.jl")
include("compat.jl")

# Concrete binarization algorithms

# Balanced, Entropy, Intermodes, Minimum, MinimumError, Moments, Otsu, UnimodalRosin, Yen
include("algorithms/single_histogram_threshold.jl")
include("algorithms/adaptive_threshold.jl") # AdaptiveThreshold
include("algorithms/niblack.jl") # Niblack
include("algorithms/polysegment.jl") # Polysegment
include("algorithms/sauvola.jl") # Sauvola

include("deprecations.jl")

export
    # generic API
    binarize, binarize!,

    # Algorithms
    AdaptiveThreshold, recommend_size,
    Niblack,
    Polysegment,
    Sauvola,
    
    # also reexport algorithms in HistogramThresholding
    SingleHistogramThreshold

end # module ImageBinarization
