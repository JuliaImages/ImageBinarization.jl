@doc raw"""
    AdaptiveThreshold <: AbstractImageBinarizationAlgorithm
    AdaptiveThreshold(; window_size = 32, percentage = 15)

    binarize(img, f::AdaptiveThreshold)
    binarize!([out,] img, f::AdaptiveThreshold)

Binarize `img` using a threshold that varies according to background
illumination.

If the value of a pixel is `t` percent less than the average of its
neighbourhood, then the pixel is set to black, otherwise it is set to white.

!!! note

    This algorithm works particularly well on images that have distinct
    contrast between background and foreground. See [1] for more details.

# Options

* `window_size` : the size of pixel's square neighbourhood. See also  [`recommend_size`](@ref) for `window_size` estimation. Default: 32
* `percentage` : dynamically determines the binarization threshold at each pixel. Larger `percentage` encourages more white pixels in the output. Default: 15

# Examples

```julia
using TestImages

img = testimage("cameraman")
s = recommend_size(img)
f = AdaptiveThreshold(window_size = s, percentage = 15)

# usage 1
out = binarize(img, f)

# usage 2
out = similar(img)
binarize!(out, img, f) # out will be changed in place

# usage 3
binarize!(img, f) # img will be changed in place
```

# References

[1] Bradley, D. (2007). Adaptive Thresholding using Integral Image. *Journal of Graphic Tools*, 12(2), pp.13-21. [doi:10.1080/2151237x.2007.10129236](https://doi.org/10.1080/2151237x.2007.10129236)

"""
struct AdaptiveThreshold <: AbstractImageBinarizationAlgorithm
    window_size::Int
    percentage::Float64

    function AdaptiveThreshold(window_size, percentage)
        window_size < 0 && throw(ArgumentError("window_size should be non-negative."))
        (percentage < 0 || percentage > 100) && throw(ArgumentError("percentage should be ∈ [0, 100]."))
        new(window_size, percentage)
    end
end
AdaptiveThreshold(; window_size::Integer = 32, percentage::Real = 15) = AdaptiveThreshold(window_size, percentage)

function (f::AdaptiveThreshold)(out::GenericGrayImage, img::GenericGrayImage)
    size(out) == size(img) || throw(ArgumentError("out and img should have the same shape, instead they are $(size(out)) and $(size(img))"))

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

# first do Color3 to Gray conversion
(f::AdaptiveThreshold)(out::GenericGrayImage, img::AbstractArray{<:Color3}) =
    f(out, of_eltype(Gray, img))

"""
    recommend_size(img)::Int

Estimate the appropriate `window_size` for [`AdaptiveThreshold`](@ref) algorithm using `round(mean(size(img))/8)`

"""
recommend_size(img::AbstractArray) = round(mean(size(img))/8)
