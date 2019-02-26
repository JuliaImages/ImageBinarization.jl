@doc raw"""
```
t = find_threshold(MinimumError(), histogram, edges)
```

Under the assumption that the histogram is a mixture of two Gaussian
distributions the binarization threshold is chosen such that the expected
misclassification error rate is minimised.

# Output

Returns the binarized image as an `Array{Gray{Bool},2}`.

# Details

Let ``f_i`` ``(i=1 \ldots I)`` denote the number of observations in the
``i``th bin of the histogram. Then the probability that an observation
belongs to the ``i``th bin is given by  ``p_i = \frac{f_i}{N}`` (``i = 1,
\ldots, I``), where ``N = \sum_{i=1}^{I}f_i``.

The minimum error thresholding method assumes that one can find a threshold
``T`` which partitions the data into two categories,  ``C_0`` and ``C_1``, such that
the data can be modelled by a mixture of two Gaussian distribution. Let
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

Kittler and Illingworth proposed to use the minimum error criterion function
```math
J(T) = 1 + 2 \left[ P_0(T) \ln \sigma_0(T) + P_1(T) \ln \sigma_1(T) \right] - 2 \left[P_0(T) \ln P_0(T) + P_1(T) \ln P_1(T) \right]
```
to assess the discreprancy between the mixture of Gaussians implied by a particular threshold ``T``,
and the piecewise-constant probability density function represented by the histogram.
The discrete value ``T`` which minimizes the function ``J(T)`` produces
the sought-after threshold value (i.e. the bin which determines the threshold).

# Arguments

The function argument is described in more detail below.

##  `img`

An `AbstractArray` representing an image. The image is automatically converted
to `Gray` in order to construct the requisite graylevel histogram.

# Example

Binarize the "cameraman" image in the `TestImages` package.

```julia
using TestImages, ImageBinarization

img = testimage("cameraman")
img_binary = binarize(MinimumError(), img)
```

# References

1. J. Kittler and J. Illingworth, “Minimum error thresholding,” Pattern Recognition, vol. 19, no. 1, pp. 41–47, Jan. 1986. [doi:10.1016/0031-3203(86)90030-0](https://doi.org/10.1016/0031-3203%2886%2990030-0)
2. Q.-Z. Ye and P.-E. Danielsson, “On minimum error thresholding and its implementations,” Pattern Recognition Letters, vol. 7, no. 4, pp. 201–206, Apr. 1988. [doi:10.1016/0167-8655(88)90103-1](https://doi.org/10.1016/0167-8655%2888%2990103-1)
"""
function binarize(algorithm::MinimumError,  img::AbstractArray{T,2}) where T <: Colorant
  img₀₁ = zeros(Gray{Bool}, axes(img))
  edges, counts = build_histogram(img,  256)
  t = find_threshold(HistogramThresholding.MinimumError(), counts[1:end], edges)
  for i in CartesianIndices(img)
    img₀₁[i] = img[i] < t ? 0 : 1
  end
  img₀₁
end
