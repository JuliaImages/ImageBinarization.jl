"""
    UnimodalRosin()

Constructs a `UnimodalRosin` image binarization algorithm.

# Details

This algorithm first selects the bin in the image histogram with the highest
frequency. The algorithm then searches from the location of the maximum bin to
the last bin of the histogram for the first bin with a frequency of 0 (known as
the minimum bin.). A line is then drawn that passes through both the maximum and
minimum bins. The bin with the greatest orthogonal distance to the line is
chosen as the threshold value.

## Assumptions

This algorithm assumes that:

* The histogram is unimodal.
* There is always at least one bin that has a frequency of 0. If not, the algorithm will use the last bin as the minimum bin.

If the histogram includes multiple bins with a frequency of 0, the algorithm
will select the first zero bin as its minimum. If there are multiple bins with
the greatest orthogonal distance, the leftmost bin is selected as the threshold.

# Reference

1. P. L. Rosin, “Unimodal thresholding,” Pattern Recognition, vol. 34, no. 11, pp. 2083–2096, Nov. 2001.[doi:10.1016/s0031-3203(00)00136-9](https://doi.org/10.1016/s0031-3203%2800%2900136-9)
"""
struct UnimodalRosin <: BinarizationAlgorithm end


"""
    binarize(algorithm::UnimodalRosin,  img::AbstractArray{T,2}) where T <: Colorant

Binarizes the image using Rosin's Unimodal threshold algorithm.

Check [`UnimodalRosin`](@ref ImageBinarization.UnimodalRosin) for more details
"""
function binarize(algorithm::UnimodalRosin,  img::AbstractArray{T,2}) where T <: Colorant
  img₀₁ = zeros(Gray{Bool}, axes(img))
  edges, counts = build_histogram(img,  256)
  t = find_threshold(HistogramThresholding.UnimodalRosin(), counts[1:end], edges)
  for i in CartesianIndices(img)
    img₀₁[i] = img[i] < t ? 0 : 1
  end
  img₀₁
end
