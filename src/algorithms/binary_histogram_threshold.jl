struct BinaryHistogramThreshold{T} <: AbstractImageBinarizationAlgorithm
    alg::T
    nbins::Int
    function BinaryHistogramThreshold(alg::T, nbins::Integer=256) where T <: ThresholdAlgorithm
        new{T}(alg, nbins)
    end
end

function binarize!(out::GenericGrayImage, img, f::ThresholdAlgorithm, args...; kwargs...)
    binarize!(out, img, BinaryHistogramThreshold(f), args...; kwargs...)
end
function binarize!(img::GenericGrayImage, f::ThresholdAlgorithm, args...; kwargs...)
    binarize!(img, BinaryHistogramThreshold(f), args...; kwargs...)
end
function binarize(::Type{T}, img, f::ThresholdAlgorithm, args...; kwargs...) where T
    binarize(T, img, BinaryHistogramThreshold(f), args...; kwargs...)
end
function binarize(img, f::ThresholdAlgorithm, args...; kwargs...)
    binarize(ccolor(Gray, eltype(img)), img, BinaryHistogramThreshold(f), args...; kwargs...)
end
function binarize(img::AbstractArray{T}, f::ThresholdAlgorithm, args...; kwargs...) where T <: Number
    # issue #46: Do not promote Number to Gray{<:Number}
    binarize(T, img, f, args...; kwargs...)
end

function (f::BinaryHistogramThreshold)(out::GenericGrayImage, img::GenericGrayImage)
    edges, counts = build_histogram(img,  f.nbins)
    t = find_threshold(f.alg, counts[1:end], edges)
    @simd for i in CartesianIndices(img)
        out[i] = img[i] < t ? 0 : 1
    end
    out
end

(f::BinaryHistogramThreshold)(out::GenericGrayImage, img::AbstractArray{<:Color3}) =
    f(out, of_eltype(Gray, img))
