"""
```
binarize(AdaptiveThreshold(; percentage = 15, window_size = 32), img)
```
Uses a binarization threshold that varies across the image according
to background illumination.

# Output

Returns the binarized image as an `Array{Gray{Bool},2}`.

# Details

If the value of a pixel is ``t`` percent less than the  average of an ``s
\\times s`` window of pixels centered around the pixel, then the pixel is set
to black, otherwise it is set to white.

A computationally efficient method for computing the average of an ``s \\times s``
neighbourhood is achieved by using an *integral image*.

This algorithm works particularly well on images that have distinct contrast
between background and foreground. See [1] for more details.

# Options
Various options for the parameters of this function are described in more detail
below.

## Choices for `percentage`
You can specify an integer for the `percentage` (denoted by ``t`` in the
publication) which must be between 0 and 100. If left unspecified a default
value of 15 is utilised.

## Choices for `window_size`
The argument `window_size` (denoted by ``s`` in the publication)  specifies the
size of pixel's square neighbourhood which must be greater than zero. A
recommended size is the integer value which is closest to 1/8 of the average of
the width and height. You can use the convenience function
`recommend_size(::AbstractArray{T,2})` to obtain this suggested value.
If left unspecified, a default value of 32 is utilised.

#Example

```julia
using TestImages

img = testimage("cameraman")
s = recommend_size(img)
binarize(AdaptiveThreshold(percentage = 15, window_size = s), img)
```

# References
1. Bradley, D. (2007). Adaptive Thresholding using Integral Image. *Journal of Graphic Tools*, 12(2), pp.13-21. [doi:10.1080/2151237x.2007.10129236](https://doi.org/10.1080/2151237x.2007.10129236)
"""
struct AdaptiveThreshold <: AbstractImageBinarizationAlgorithm
    window_size::Int
    percentage::Float64

    function AdaptiveThreshold(window_size, percentage)
        s < 0 && raise(ArgumentError("window_size must be Non-negative."))
        (t < 0 || t > 100) && raise(ArgumentError("percentage must be between [0, 100]"))
        new(window_size, percentage)
    end
end
AdaptiveThreshold(; window_size::Integer = 32, percentage::AbstractFloat = 15) = AdaptiveThreshold(window_size, percentage)

function (f::AdaptiveThreshold)(out::GenericGrayImage, img::GenericGrayImage)
    size(out) == size(img) || raise(ArgumentError("out and img should have the same shape, instead they are $(size(out)) and $(size(img))"))

    t = f.percentage
    rₛ = CartesianIndex(Tuple(repeated(f.window_size ÷ 2, ndims(img))))
    R = CartesianIndices(img)
    p_first, p_last = first(R), last(R)

    integral_img = integral_image(img)
    @simd for p in R
        p_tl = max(p_first, p - rₛ)
        p_br = min(p_last, p + rₛ)
        # can we pre-calculate this before the for-loop?
        total = boxdiff(integral_img, p_tl, p_br)
        count = length(p_tl:p_br)
        if img[p] * count <= total * ((100 - t) / 100)
            out[p] = 0
        else
            out[p] = 1
        end
    end
    out
end

function (f::AdaptiveThreshold)(out, img::AbstractArray{<:Color3})
    f(out, of_eltype(Gray, img))
end

"""
    recommend_size(img)::Int

Estimate the appropriate `window_size` for [`AdaptiveThreshold`](@ref) algorithm using `round(mean(size(img))/8)`

"""
recommend_size(img::AbstractArray) = round(mean(size(img))/8)
