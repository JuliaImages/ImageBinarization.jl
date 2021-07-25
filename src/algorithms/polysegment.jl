"""
    Polysegment <: AbstractImageBinarizationAlgorithm
    Polysegment()

    binarize([T,] img, f::Polysegment)
    binarize!([out,] img, f::Polysegment)

Uses the *polynomial segmentation* technique to group the image pixels
into two categories (foreground and background).

# Output

Return the binarized image as an `Array{Gray{T}}` of size `size(img)`. If
`T` is not specified, it is inferred from `out` and `img`.

# Details

The approach involves constructing a univariate second-degree polynomial
such that the two roots of the polynomial represent the graylevels
of two cluster centers (i.e the foreground and background). Pixels are then
assigned to the foreground or background depending on which cluster center
is closest.

# Arguments

The function argument is described in more detail below.

##  `img::AbstractArray`

The image that needs to be binarized. The image is automatically converted
to `Gray`.


# Example

Binarize the "cameraman" image in the `TestImages` package.

```julia
using TestImages, ImageBinarization

img = testimage("cameraman")
img_binary = binarize(img, Polysegment())
```

## Reference

1. R. E. Vidal, "Generalized Principal Component Analysis (GPCA): An Algebraic Geometric Approach to Subspace Clustering and Motion Segmentation." Order No. 3121739, University of California, Berkeley, Ann Arbor, 2003.
"""
struct Polysegment <: AbstractImageBinarizationAlgorithm end

function (f::Polysegment)(out::GenericGrayImage, img::GenericGrayImage)
  # Construct data matrix for second-degree polynomial (Equation 2.3) in [1].
  x = vec(img)
  Lₙ = hcat(ones(length(x)), x, x.^2)
  F = svd(Lₙ)
  c = F.Vt[end,:]
  p = Polynomial(vec(c))
  μ₁, μ₂ = sort(roots(p))
  # Binarize the image.
  @simd for i in CartesianIndices(img)
    val = img[i]
    out[i] = (val-μ₁)^2 < (val-μ₂)^2 ? 0 : 1
  end
  out
end

function (f::Polysegment)(out::GenericGrayImage, img::AbstractArray{<:Color3})
    # map `img` to grayspace while keeping the storage type
    # TODO: this mapping operation can be done lazily to reduce memory allocation
    GT = base_color_type(eltype(out)){eltype(eltype(img))}
    f(out, GT.(img))
end
  