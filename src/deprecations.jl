using Base: depwarn

# issue #23: swap argument order
# Deprecated in ImageBinarization v0.3
function binarize(f::AbstractImageBinarizationAlgorithm, img::AbstractArray, args...; kwargs...)
    depwarn("binarize(alg, img) is deprecated, use binarize(img, alg) instead", :binarize)
    binarize(img, f, args...; kwargs...)
end

# unexport recommend_size
# Deprecated in ImageBinarization v0.3
function recommend_size(img)
    depwarn("recommend_size is deprecated, use AdaptiveThreshold(img) to directly generate the algorithm", :recommend_size)
    return round(Int, mean(size(img))/8)
end

# move window_size out of Niblack
# Deprecated in ImageBinarization v0.3
function Niblack(window_size, bias)
    depwarn("deprecated: window_size is no longer used as an `Niblac` field, instead, it's a keyword argument of `binarize`. Please check `Niblack` for more details.", :Niblack)
    Niblack(bias)
end
