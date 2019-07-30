@doc raw"""
    AdaptiveThreshold <: AbstractImageBinarizationAlgorithm
    AdaptiveThreshold(; percentage = 15)

    binarize([T,] img, f::AdaptiveThreshold; [window_size])
    binarize!([out,] img, f::AdaptiveThreshold; [window_size])

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
to `Gray` in order to construct the requisite graylevel histogram..

# Options

Various options for the parameters of `AdaptiveThreshold`, `binarize` and
`binarize!` are described in more detail below.

## Choices for `percentage`

You can specify an integer for the `percentage` (denoted by `t` in [1])
which must be between 0 and 100. Default: 15

## Choices for `window_size`

The argument `window_size` (denoted by `s` in [1]) specifies the size of
pixel's square neighbourhood which must be greater than zero.

The default value is the integer which is closest to 1/8 of the average of
the width and height of `img`.

!!! info

    `window_size` is a keyword argument in [`binarize`](@ref) and [`binarize!`](@ref)

# Examples

```julia
using TestImages

img = testimage("cameraman")
f = AdaptiveThreshold()

img₀₁_1 = binarize(img, f)
img₀₁_2 = binarize(img, f, window_size=16)
```

See also [`binarize!`](@ref) for in-place operation.

# References

[1] Bradley, D. (2007). Adaptive Thresholding using Integral Image. *Journal of Graphic Tools*, 12(2), pp.13-21. [doi:10.1080/2151237x.2007.10129236](https://doi.org/10.1080/2151237x.2007.10129236)

"""
struct AdaptiveThreshold <: AbstractImageBinarizationAlgorithm
    percentage::Float64

    function AdaptiveThreshold(percentage)
        (percentage < 0 || percentage > 100) && throw(ArgumentError("percentage should be ∈ [0, 100]."))
        new(percentage)
    end
end

function AdaptiveThreshold(; percentage::Real = 15, window_size=nothing)
    if window_size === nothing
        return AdaptiveThreshold(percentage)
    else
        # deprecate window_size
        return AdaptiveThreshold(window_size, percentage)
    end
end

function (f::AdaptiveThreshold)(out::GenericGrayImage,
                                img::GenericGrayImage;
                                window_size::Union{Nothing, Integer}=nothing)
    if window_size === nothing
        window_size = default_AdaptiveThreshold_window_size(img)
    end

    window_size < 0 && throw(ArgumentError("window_size should be non-negative."))
    size(out) == size(img) || throw(ArgumentError("out and img should have the same shape, instead they are $(size(out)) and $(size(img))"))

    t = f.percentage
    rₛ = CartesianIndex(Tuple(repeated(window_size ÷ 2, ndims(img))))
    R = CartesianIndices(img)
    p_first, p_last = first(R), last(R)

    integral_img = integral_image(img)
    @simd for p in R
        p_tl = max(p_first, p - rₛ)
        p_br = min(p_last, p + rₛ)
        # can we pre-calculate this before the for-loop?
        total = boxdiff(integral_img, p_tl, p_br)
        count = length(_colon(p_tl, p_br))
        if img[p] * count <= total * ((100 - t) / 100)
            out[p] = 0
        else
            out[p] = 1
        end
    end
    out
end

# first do Color3 to Gray conversion
(f::AdaptiveThreshold)(out::GenericGrayImage, img::AbstractArray{<:Color3}, args...; kwargs...) =
    f(out, of_eltype(Gray, img), args...; kwargs...)

"""
    default_AdaptiveThreshold_window_size(img)::Int

Estimate the appropriate `window_size` for [`AdaptiveThreshold`](@ref) algorithm using `round(mean(size(img))/8)`
"""
default_AdaptiveThreshold_window_size(img::AbstractArray) = round(Int, mean(size(img)) / 8)
