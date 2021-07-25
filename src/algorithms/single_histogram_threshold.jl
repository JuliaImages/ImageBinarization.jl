# Alternatively, we could use `InteractiveUtils.subtypes` to get a list of it.
threshold_methods = (
    Balanced,
    Entropy,
    Intermodes,
    MinimumError,
    MinimumIntermodes,
    Moments,
    Otsu,
    UnimodalRosin,
    Yen
)

"""
    SingleHistogramThreshold <: AbstractImageBinarizationAlgorithm
    SingleHistogramThreshold(alg::ThresholdAlgorithm; nbins=256)

    binarize([T,] img, f::ThresholdAlgorithm; nbins=256)
    binarize!([out,] img, f::ThresholdAlgorithm; nbins=256)

Binarizes the image `img` using the threshold found by given threshold finding algorithm `alg`.

# Output

Return the binarized image as an `Array{Gray{T}}` of size `size(img)`. If `T` is not specified, it
is inferred from `out` and `img`.

# Arguments

The function argument is described in more detail below.

##  `img::AbstractArray`

The image that needs to be binarized.  The image is automatically converted to `Gray` in order to
construct the requisite graylevel histogram.

## `alg::ThresholdAlgorithm`

`ThresholdAlgorithm` is an Abstract type defined in `ThresholdAlgorithm.jl`, it provides various
threshold finding algorithms:

$(mapreduce(x->"- [`"*string(x)*"`](@ref)", (x,y)->x*"\n"*y, threshold_methods))

For the more detailed explaination and the construction, please refer to each concrete algorithm.
For example, type `?Otsu` in REPL will give you more details on how to use `Otsu` methods.

## `nbins::Integer`

The number of discrete bins that used to build the histogram. A smaller `nbins` could possibly gives
a less noisy, or in other words, a smoother output. The default value is `256`.

# Examples

All the usage follows the same pattern, take `Otsu` as an example:

```julia
using TestImages, ImageBinarization

img = testimage("cameraman")
img_binary = binarize(img, Otsu())
```

It is less convenient, but still, you could also construct a `SingleHistogramThreshold` by yourself:

```julia
using TestImages, ImageBinarization

img = testimage("cameraman")
f = SingleHistogramThreshold(Otsu(), nbins=256)
img_binary = binarize(img, f)
```

"""
struct SingleHistogramThreshold{T} <: AbstractImageBinarizationAlgorithm
    alg::T
    nbins::Int
    function SingleHistogramThreshold(alg::T; nbins::Integer) where T <: ThresholdAlgorithm
        new{T}(alg, nbins)
    end
end

function binarize!(out::GenericGrayImage, img, f::ThresholdAlgorithm, args...; nbins::Integer=256, kwargs...)
    binarize!(out, img, SingleHistogramThreshold(f, nbins=nbins), args...; kwargs...)
end
function binarize!(img::GenericGrayImage, f::ThresholdAlgorithm, args...; nbins::Integer=256, kwargs...)
    binarize!(img, SingleHistogramThreshold(f, nbins=nbins), args...; kwargs...)
end
function binarize(::Type{T}, img, f::ThresholdAlgorithm, args...; nbins::Integer=256, kwargs...) where T
    binarize(T, img, SingleHistogramThreshold(f, nbins=nbins), args...; kwargs...)
end
function binarize(img, f::ThresholdAlgorithm, args...; nbins::Integer=256, kwargs...)
    binarize(ccolor(Gray, eltype(img)), img, SingleHistogramThreshold(f, nbins=nbins), args...; kwargs...)
end
function binarize(img::AbstractArray{T}, f::ThresholdAlgorithm, args...; kwargs...) where T <: Number
    # issue #46: Do not promote Number to Gray{<:Number}
    binarize(T, img, f, args...; kwargs...)
end


function (f::SingleHistogramThreshold)(out::GenericGrayImage, img::GenericGrayImage)
    edges, counts = build_histogram(img, f.nbins)
    t = find_threshold(f.alg, counts[1:end], edges)
    @. out = img > t # here we rely on implicit type conversion to `eltype(out)`
end

function (f::SingleHistogramThreshold)(out::GenericGrayImage, img::AbstractArray{<:Color3})
    # map `img` to grayspace while keeping the storage type
    # TODO: this mapping operation can be done lazily to reduce memory allocation
    GT = base_color_type(eltype(out)){eltype(eltype(img))}
    f(out, GT.(img))
end
