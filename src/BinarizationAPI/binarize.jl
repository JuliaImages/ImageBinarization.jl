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

TODO: Otsu

"""
abstract type AbstractImageBinarizationAlgorithm <: AbstractImageFilter end

binarize!(out, img,
          f::AbstractImageBinarizationAlgorithm,
          args...; kwargs...) =
    f(out, img, args...; kwargs...)

function binarize!(img,
                   f::AbstractImageBinarizationAlgorithm,
                   args...; kwargs...)
    tmp = copy(img)
    f(img, tmp, args...; kwargs...)
    return img
end

function binarize(::Type{T},
                  img,
                  f::AbstractImageBinarizationAlgorithm,
                  args...; kwargs...)
    out = Array{T}(undef, size(img))
    binarize!(out, img, f, args...; kwargs...)
    return out
end

binarize(img,
         f::AbstractImageBinarizationAlgorithm,
         args...; kwargs...) =
    binarize(eltype(img), img, f, args...; kwargs...)

### Docstrings

"""
    binarize!([out,] img, f::AbstractImageBinarizationAlgorithm, args...; kwargs...)

Binarize `img` using algorithm `f`.

!!! info

    If `out` is specified, it will be changed in place. Otherwise `img` will be changed in place.

# Examples

TODO: Otsu

See also: [`binarize!`](@ref)
"""
binarize!

"""
    binarize([::Type,] img, f::AbstractImageBinarizationAlgorithm, args...; kwargs...)

Binarize `img` using algorithm `f`.

# Examples

TODO: Otsu

See also [`binarize!`](@ref) for in-place binarization.
"""
binarize
