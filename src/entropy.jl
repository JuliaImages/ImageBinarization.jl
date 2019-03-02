"""
```
binarize(Entropy(), img)
```
An algorithm for finding the binarization threshold value using
the entropy of the image histogram.

# Output

Returns the binarized image as an `Array{Gray{Bool},2}`.

# Details

This algorithm uses the entropy of a one-dimensional histogram to produce a threshold
value.

Let ``f_1, f_2, \\ldots, f_I`` be the frequencies in the various bins of the
histogram and ``I`` the number of bins. With ``N = \\sum_{i=1}^{I}f_i``, let
``p_i = \\frac{f_i}{N}`` (``i = 1, \\ldots, I``) denote the probability
distribution of gray levels. From this distribution one derives two additional
distributions. The first defined for discrete values ``1`` to ``s`` and the
other, from ``s+1`` to ``I``. These distributions are

```math
A: \\frac{p_1}{P_s}, \\frac{p_2}{P_s}, \\ldots, \\frac{p_s}{P_s}
\\quad \\text{and} \\quad
B: \\frac{p_{s+1}}{1-P_s}, \\ldots, \\frac{p_n}{1-P_s}
\\quad \\text{where} \\quad
P_s = \\sum_{i=1}^{s}p_i.
```

The entropies associated with each distribution are as follows:

```math
H(A) = \\ln(P_s) + \\frac{H_s}{P_s}
```
```math
H(B) = \\ln(1-P_s) + \\frac{H_n-H_s}{1-P_s}
```
```math
\\quad \\text{where} \\quad
H_s = -\\sum_{i=1}^{s}p_i\\ln{p_i}
\\quad \\text{and} \\quad
H_n = -\\sum_{i=1}^{I}p_i\\ln{p_i}.
```

Combining these two entropy functions we have

```math
\\psi(s) = \\ln(P_s(1-P_s)) + \\frac{H_s}{P_s} + \\frac{H_n-H_s}{1-P_s}.
```
Finding the discrete value ``s`` which maximises the function ``\\psi(s)`` produces
the sought-after threshold value (i.e. the bin which determines the threshold).

See Section 4 of [1] for more details on the derivation of the entropy.

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
img_binary = binarize(Entropy(), img)
```

# References
1. J. N. Kapur, P. K. Sahoo, and A. K. C. Wong, “A new method for gray-level picture thresholding using the entropy of the histogram,” *Computer Vision, Graphics, and Image Processing*, vol. 29, no. 1, p. 140, Jan. 1985.[doi:10.1016/s0734-189x(85)90156-2](https://doi.org/10.1016/s0734-189x%2885%2990156-2)
"""
function binarize(algorithm::Entropy,  img::AbstractArray{T,2}) where T <: Colorant
  img₀₁ = zeros(Gray{Bool}, axes(img))
  edges, counts = build_histogram(img,  256)
  t = find_threshold(HistogramThresholding.Entropy(), counts[1:end], edges)
  for i in CartesianIndices(img)
    img₀₁[i] = img[i] < t ? 0 : 1
  end
  img₀₁
end
