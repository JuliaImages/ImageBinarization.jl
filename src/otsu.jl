@doc raw"""
    Otsu <: AbstractImageBinarizationAlgorithm
    Otsu()

    binarize([T,] img, f::Otsu)
    binarize!([out,] img, f::Otsu)

Under the assumption that the image histogram is bimodal the binarization
threshold is set so that the resultant between-class variance is maximal.

# Output

Return the binarized image as an `Array{Gray{T}}` of size `size(img)`. If
`T` is not specified, it is inferred from `out` and `img`.

# Details

Let ``f_i`` ``(i=1 \ldots I)`` denote the number of observations in the
``i``th bin of the image histogram. Then the probability that an observation
belongs to the ``i``th bin is given by  ``p_i = \frac{f_i}{N}`` (``i = 1,
\ldots, I``), where ``N = \sum_{i=1}^{I}f_i``.

The choice of a threshold ``T`` partitions the data into two categories, ``C_0``
and ``C_1``. Let
```math
P_0(T) = \sum_{i = 1}^T p_i \quad \text{and} \quad P_1(T) = \sum_{i = T+1}^I p_i
```
denote the cumulative probabilities,
```math
\mu_0(T) = \sum_{i = 1}^T i \frac{p_i}{P_0(T)} \quad \text{and} \quad \mu_1(T) = \sum_{i = T+1}^I i \frac{p_i}{P_1(T)}
```
denote the means, and
```math
\sigma_0^2(T) = \sum_{i = 1}^T (i-\mu_0(T))^2 \frac{p_i}{P_0(T)} \quad \text{and} \quad \sigma_1^2(T) = \sum_{i = T+1}^I (i-\mu_1(T))^2 \frac{p_i}{P_1(T)}
```
denote the variances of categories ``C_0`` and ``C_1``, respectively.
Furthermore, let
```math
\mu = P_0(T)\mu_0(T) + P_1(T)\mu_1(T),
```
represent the overall mean,
```math
\sigma_b^2(T) = P_0(T)(\mu_0(T) - \mu)^2 + P_1(T)(\mu_1(T) - \mu)^2,
```
the between-category variance, and
```math
\sigma_w^2(T) = P_0(T) \sigma_0^2(T) +  P_1(T)\sigma_1^2(T)
```
the within-category variance, respectively.

Finding the discrete value ``T`` which maximises the function ``\sigma_b^2(T)``
produces the sought-after threshold value (i.e. the bin which determines the
threshold). As it turns out, that threshold value is equal to the threshold
decided by minimizing the within-category variances criterion ``\sigma_w^2(T)``.
Furthermore, that threshold is also the same as the threshold calculated by
maximizing the ratio of between-category variance to within-category variance.

# Arguments

The function argument is described in more detail below.

##  `img::AbstractArray`

The image that needs to be binarized.  The image is automatically converted
to `Gray` in order to construct the requisite graylevel histogram.


# Example

Binarize the "cameraman" image in the `TestImages` package.

```julia
using TestImages, ImageBinarization

img = testimage("cameraman")
img_binary = binarize(img, Otsu())
```

# Reference

1. Nobuyuki Otsu (1979). “A threshold selection method from gray-level histograms”. *IEEE Trans. Sys., Man., Cyber.* 9 (1): 62–66. [doi:10.1109/TSMC.1979.4310076](http://dx.doi.org/doi:10.1109/TSMC.1979.4310076)
"""
struct Otsu <: AbstractImageBinarizationAlgorithm end

function (f::Otsu)(out::GenericGrayImage, img::GenericGrayImage)
    edges, counts = build_histogram(img,  256)
    t = find_threshold(HistogramThresholding.Otsu(), counts[1:end], edges)
    @simd for i in CartesianIndices(img)
        out[i] = img[i] < t ? 0 : 1
    end
    out
end

(f::Otsu)(out::GenericGrayImage, img::AbstractArray{<:Color3}) =
    f(out, of_eltype(Gray, img))
