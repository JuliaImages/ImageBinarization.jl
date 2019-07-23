using Base: depwarn

# issue #23: swap argument order
function binarize(f::AbstractImageBinarizationAlgorithm, img::AbstractArray, args...; kwargs...)
    depwarn("binarize(alg, img) is deprecated, use binarize(img, alg) instead", :binarize)
    binarize(img, f, args...; kwargs...)
end
