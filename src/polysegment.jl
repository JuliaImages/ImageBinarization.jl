"""
```
imgb = binarize(Polysegment(), img)
binarize!(Polysegment(), img)
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

The function arguments are described in more detail below.

##  `img`

An `AbstractGray` image which is to be binarized into background (`Gray(0)`)
and foreground (`Gray(1)`) pixels.

## Reference

[1] R. E. Vidal, "Generalized Principal Component Analysis (GPCA): An Algebraic Geometric Approach to Subspace Clustering and Motion Segmentation." Order No. 3121739, University of California, Berkeley, Ann Arbor, 2003.
"""
function binarize(algorithm::Polysegment,  img::AbstractArray{T,2}) where T <: AbstractGray
  binarize!(algorithm, copy(img))
end

"""
```
t = binarize!(Polysegment(), img)
```
Same as [`binarize`](@ref binarize(::Polysegment, ::AbstractArray{<:AbstractGray,2})) except that it modifies the image that was passed as an argument.
"""
function binarize!(algorithm::Polysegment,  img::AbstractArray{T,2}) where T <: AbstractGray
  # Construct data matrix for second-degree polynomial (Equation 2.3) in [1].
  x = vec(img)
  Lₙ = hcat(ones(length(x)), x, x.^2)
  F = svd(Lₙ)
  c = F.Vt[end,:]
  p = Poly(vec(c))
  μ₁, μ₂ = roots(p)
  # Binarize the image.
  map!(img,img) do val
    (val-μ₁)^2 < (val-μ₂)^2 ? Gray(0) : Gray(1)
  end
end
