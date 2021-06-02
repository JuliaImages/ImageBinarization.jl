@doc raw"""
    AdaptiveThreshold <: AbstractImageBinarizationAlgorithm
    AdaptiveThreshold([img]; [window_size,] percentage = 15)

    binarize([T,] img, f::AdaptiveThreshold)
    binarize!([out,] img, f::AdaptiveThreshold)

Binarize `img` using a threshold that varies according to background
illumination.

# Output

Return the binarized image as an `Array{Gray{T}}` of size `size(img)`. If
`T` is not specified, it is inferred from `out` and `img`.

# Details

If the value of a pixel is `t` percent less than the average of an ``s
\times s`` window of pixels centered around the pixel, then the pixel is set
to black, otherwise it is set to white.

A computationally efficient method for computing the average of an ``s
\times s`` neighbourhood is achieved by using an *integral image*
`integral_image`.

This algorithm works particularly well on images that have distinct contrast
between background and foreground. See [1] for more details.

# Arguments

The function argument is described in more detail below.

##  `img::AbstractArray`

The image that need to be binarized. The image is automatically converted
to `Gray` in order to construct the requisite graylevel histogram.

You can also pass `img` to `AdaptiveThreshold` to automatically infer the "best"
`window_size`.

# Options

Various options for the parameters of `AdaptiveThreshold`, `binarize` and
`binarize!` are described in more detail below.

## Choices for `percentage`

You can specify an integer for the `percentage` (denoted by `t` in [1])
which must be between 0 and 100. Default: 15

## Choices for `window_size`

The argument `window_size` (denoted by `s` in [1]) specifies the size of
pixel's square neighbourhood which must be greater than zero.

If `img` is passed to `AdaptiveThreshold` constructor, then `window_size` is infered as
the integer closest to 1/8 of the average of the width and height of `img`.

# Examples

```julia
using TestImages

img = testimage("cameraman")
f = AdaptiveThreshold(window_size = 16)
img₀₁ = binarize(img, f)

f = AdaptiveThreshold(img) # infer the best `window_size` using `img`
img₀₁ = binarize(img, f)
```

See also [`binarize!`](@ref) for in-place operation.

# References

[1] Bradley, D. (2007). Adaptive Thresholding using Integral Image. *Journal of Graphic Tools*, 12(2), pp.13-21. [doi:10.1080/2151237x.2007.10129236](https://doi.org/10.1080/2151237x.2007.10129236)

"""
struct AdaptiveThreshold <: AbstractImageBinarizationAlgorithm
    window_size::Int
    percentage::Float64

    function AdaptiveThreshold(window_size::Integer, percentage::Real)
        window_size < 0 && throw(ArgumentError("window_size should be non-negative."))
        (percentage < 0 || percentage > 100) && throw(ArgumentError("percentage should be ∈ [0, 100]."))
        new(window_size, percentage)
    end
end

function AdaptiveThreshold(img::Union{AbstractArray, Nothing}=nothing;
                           window_size::Union{Integer, Nothing} = nothing,
                           percentage::Real = 15)
    if window_size == nothing
        if img == nothing
            depwarn("deprecated: without img given, window_size will be required in the future.", :AdaptiveThreshold)
            window_size = 32
            # Deprecated in ImageBinarization v0.3
            # throw(ArgumentError("window_size is required without img given"))
        else
            window_size = round(Int, mean(size(img))/8)
        end
    end
    return AdaptiveThreshold(window_size, percentage)
end


function (f::AdaptiveThreshold)(out::GenericGrayImage,
                                img::GenericGrayImage)

    size(out) == size(img) || throw(ArgumentError("out and img should have the same shape, instead they are $(size(out)) and $(size(img))"))

    rₛ = CartesianIndex(Tuple(repeated(f.window_size ÷ 2, ndims(img))))
    R = CartesianIndices(img)
    p_first, p_last = first(R), last(R)

    integral_img = integral_image(img)
    @simd for p in R
        p_tl = max(p_first, p - rₛ)
        p_br = min(p_last, p + rₛ)
        # can we pre-calculate this before the for-loop?
        total = boxdiff(integral_img, p_tl, p_br)
        count = length(_colon(p_tl, p_br))
        if img[p] * count <= total * ((100 - f.percentage) / 100)
            out[p] = 0
        else
            out[p] = 1
        end
    end
    out
end

# first do Color3 to Gray conversion
(f::AdaptiveThreshold)(out::GenericGrayImage, img::AbstractArray{<:Color3}, args...; kwargs...) =
    f(out, eltype(out).(img), args...; kwargs...)
