module ImageBinarization

using ImageContrastAdjustment
using ColorTypes
using ColorVectorSpace
using LinearAlgebra
using HistogramThresholding
using Polynomials
using Statistics
using ImageCore

abstract type BinarizationAlgorithm end

include("integral_image.jl")
include("util.jl")
include("balanced.jl")
include("otsu.jl")
include("polysegment.jl")
include("unimodal.jl")
include("minimum.jl")
include("moments.jl")
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
    BinarizationAlgorithm,
    recommend_size, # AdaptiveThreshold
    AdaptiveThreshold,
    Otsu,
    Balanced,
    Yen,
    Polysegment,
    MinimumIntermodes,
    Moments,
    Intermodes,
    MinimumError,
    UnimodalRosin,
    Entropy,
    Sauvola,
    Niblack

"""
`BinarizationAlgorithm` is an abstract type, you can't instantiate it.

A list of implemented alogrithms are:

* [`AdaptiveThreshold(; percentage = 15, window_size = 32)`](@ref ImageBinarization.AdaptiveThreshold)
* [`Balanced()`](@ref ImageBinarization.Balanced)
* [`Entropy()`](@ref ImageBinarization.Entropy)
* [`Intermodes()`](@ref ImageBinarization.Intermodes)
* [`MinimumError()`](@ref ImageBinarization.MinimumError)
* [`MinimumIntermodes()`](@ref ImageBinarization.MinimumIntermodes)
* [`Moments()`](@ref ImageBinarization.Moments)
* [`Niblack(; window_size = 7, bias = 0.2)`](@ref ImageBinarization.Niblack)
* [`Otsu()`](@ref ImageBinarization.Otsu)
* [`Polysegment()`](@ref ImageBinarization.Polysegment)
* [`Sauvola(; window_size = 7, bias = 0.2)`](@ref ImageBinarization.Sauvola)
* [`UnimodalRosin()`](@ref ImageBinarization.UnimodalRosin)
* [`Yen()`](@ref ImageBinarization.Yen)
"""
BinarizationAlgorithm

"""
    binarize(algorithm::BinarizationAlgorithm,  img::AbstractArray{T,2}) where T <: Colorant

Returns the binarized image as an `Array{Gray{Bool},2}`

# Example
Binarizes the "cameraman" image in the `TestImages` package using `Otsu` method. All other algorithms are used in a similar way.

```julia
using TestImages, ImageBinarization

img = testimage("cameraman")
binarize_method = Otsu()
img_binary = binarize(binarize_method, img)
```

!!! warning
    * color image input `img` is automatically converted to `Gray` if a graylevel histogram is needed.

See also: [`BinarizationAlgorithm`](@ref ImageBinarization.BinarizationAlgorithm)
"""
binarize

end # module
