using Base: depwarn

# issue #23: swap argument order
# Deprecated in ImageBinarization v0.3
function binarize(f::AbstractImageBinarizationAlgorithm, img::AbstractArray, args...; kwargs...)
    depwarn("binarize(alg, img) is deprecated, use binarize(img, alg) instead", :binarize)
    binarize(img, f, args...; kwargs...)
end

# move window_size out of AdaptiveThreshold and unexport recommend_size
# Deprecated in ImageBinarization v0.3
function AdaptiveThreshold(window_size, percentage)
    depwarn("deprecated: window_size is no longer used as an `AdaptiveThreshold` field, instead, it's a keyword argument of `binarize`. Please check `AdaptiveThreshold` for more details.", :AdaptiveThreshold)
    AdaptiveThreshold(percentage)
end

function recommend_size(img)
    depwarn("deprecated: `binarize` automatically calls `recommend_size` now, it will be unexported in the future. Please check `AdaptiveThreshold` for more details.", :recommend_size)
    default_AdaptiveThreshold_window_size(img)
end

# move window_size out of Niblack
# Deprecated in ImageBinarization v0.3
function Niblack(window_size, bias)
    depwarn("deprecated: window_size is no longer used as an `Niblac` field, instead, it's a keyword argument of `binarize`. Please check `Niblack` for more details.", :Niblack)
    Niblack(bias)
end
