"""
```
binarize(Polysegment(), img)
```

Uses the *polynomial segmentation* technique to group the image pixels
into two categories (foreground and background).

# Details

The approach involves constructing a univariate second-degree polynomial
such that the two roots of the polynomial represent the graylevels
of two cluster centers (i.e the foreground and background). Pixels are then
assigned to the foreground or background depending on which cluster center
is closest.

# Arguments

The function argument is described in more detail below.

##  `img`

An `AbstractArray` representing an image. The image is automatically converted
to `Gray`.


# Example

Binarize the "cameraman" image in the `TestImages` package.

```julia
using TestImages, ImageBinarization

img = testimage("cameraman")
img_binary = binarize(Polysegment(), img)
```

## Reference

1. R. E. Vidal, "Generalized Principal Component Analysis (GPCA): An Algebraic Geometric Approach to Subspace Clustering and Motion Segmentation." Order No. 3121739, University of California, Berkeley, Ann Arbor, 2003.
"""
function binarize(algorithm::Polysegment,  img::AbstractArray{T,2}) where T <: Colorant
  binarize(Polysegment(), Gray.(img))
end

function binarize(algorithm::Polysegment,  img::AbstractArray{T,2}) where T <: Gray
  # Construct data matrix for second-degree polynomial (Equation 2.3) in [1].
  x = vec(img)
  Lₙ = hcat(ones(length(x)), x, x.^2)
  F = svd(Lₙ)
  c = F.Vt[end,:]
  p = Poly(vec(c))
  μ₁, μ₂ = sort(roots(p))
  # Binarize the image.
  img₀₁ = zeros(Gray{Bool}, axes(img))
  for i in CartesianIndices(img)
    val = img[i]
    img₀₁[i] = (val-μ₁)^2 < (val-μ₂)^2 ? 0 : 1
  end
  img₀₁
end
