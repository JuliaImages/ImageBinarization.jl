# usage example for package developer:
#
#     import BinarizationAPI: AbstractImageBinarizationAlgorithm,
#                             binarize, binarize!

"""
    AbstractImageBinarizationAlgorithm <: AbstractImageFilter

The root type for `ImageBinarization` package.

Any concrete binarization algorithm shall subtype it to support
[`binarize`](@ref) and [`binarize!`](@ref) APIs.

# Examples

All algorithms in ImageBinarization are called in the following pattern:

```julia
# first generate an algorithm instance
f = Otsu()

# then pass the algorithm to `binarize`
img₀₁ = binarize(img, f) # `eltype(img₀₁)` is `Gray{N0f8}`

# or use in-place version `binarize!`
img₀₁ = similar(img)
binarize!(img₀₁, img, f)
```

Some algorithms also receive additional information of image as an argument to infer the
"best" parameters, e.g., `window_size` of `AdaptiveThreshold`.

```julia
# you could explicit specify the it
f = AdaptiveThreshold(window_size = 32)

# or infer the "best" default value from given image
img = testimage("cameraman")
f = AdaptiveThreshold(img)
```

For more examples, please check [`binarize`](@ref) and [`binarize!`](@ref) and concret
algorithms.
"""
abstract type AbstractImageBinarizationAlgorithm <: AbstractImageFilter end

binarize!(out::GenericGrayImage,
          img,
          f::AbstractImageBinarizationAlgorithm,
          args...; kwargs...) =
    f(out, img, args...; kwargs...)

# in-place binarize! only supports gray image input
function binarize!(img::GenericGrayImage,
                   f::AbstractImageBinarizationAlgorithm,
                   args...; kwargs...)
    tmp = copy(img)
    f(img, tmp, args...; kwargs...)
    return img
end

function binarize(::Type{T},
                  img,
                  f::AbstractImageBinarizationAlgorithm,
                  args...; kwargs...) where T
    out = Array{T}(undef, size(img))
    binarize!(out, img, f, args...; kwargs...)
    return out
end

binarize(img::AbstractArray{T},
         f::AbstractImageBinarizationAlgorithm,
         args...; kwargs...) where T <:Union{Number, Colorant} =
    binarize(Gray{eltype(T)}, img, f, args...; kwargs...)

### Docstrings

"""
    binarize!([out,] img, f::AbstractImageBinarizationAlgorithm, args...; kwargs...)

Binarize `img` using algorithm `f`.

# Output

If `out` is specified, it will be changed in place. Otherwise `img` will be changed in place.

# Examples

Just simply pass an algorithm to `binarize!`:

```julia
img₀₁ = similar(img)
binarize!(img₀₁, img, f)
```

For cases you just want to change `img` in place, you don't necessarily need to manually
allocate `img₀₁`; just use the convenient method:

```julia
binarize!(img, f)
```

See also: [`binarize`](@ref)
"""
binarize!

"""
    binarize([T::Type,] img, f::AbstractImageBinarizationAlgorithm, args...; kwargs...)

Binarize `img` using algorithm `f`.

# Output

The return image `img₀₁` is an `Array{T}`.

If `T` is not specified, then it's inferred as
`Gray{eltype(eltype(img))}`, which is `Gray{N0f8}` for img of type `Array{N0f8}` and `Array{Gray{N0f8}}`, and `Gray{Float32}` for img of type `Array{Float32}` and `Array{Gray{Float32}}`

# Examples

Just simply pass the input image and algorithm to `binarize`

```julia
img₀₁ = binarize(img, f)
```

This reads as "`binarize` image `img` using binarization algorithm `f`".

You can also explicitly specify the return type:

```julia
img₀₁_float32 = binarize(Gray{Float32}, img, f)
```

See also [`binarize!`](@ref) for in-place binarization.
"""
binarize
