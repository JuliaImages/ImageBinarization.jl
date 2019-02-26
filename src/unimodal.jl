"""
```
binarize!(UnimodalRosin(), img)
```

Binarizes the unimodal image passed into the `img` parameter into background (`Gray(0)`)
pixels, and foreground (`Gray(1)`) pixels using Rosin's algorithm.

# Arguments

## `img`
An `AbstractGray` image which is to be binarized into background (`Gray(0)`)
and foreground (`Gray(1)`) pixels.

# Output
Modifies the `img` parameter to become the binarized image.


# Details
This algorithm first selects the bin in the histogram with the highest frequency.
The algorithm then searches from the location of the maximum bin to the last bin
of the histogram for the first bin with a frequency of 0 (known as the minimum bin.).
A line is then drawn that passes through both the maximum and minimum bins. The
bin with the greatest orthogonal distance to the line is chosen as the threshold
value.


## Assumptions
This algorithm assumes that:

* The histogram is unimodal
* There is always at least one bin that has a frequency of 0. If not, the
algorithm will use the last bin as the minimum bin.
* If the histogram includes multiple bins with a frequency of 0, the algorithm
will select the first zero bin as its minimum.
* If there are multiple bins with the greatest orthogonal distance, the leftmost
bin is selected as the threshold.


# Example

Compute the threshold for the "moonsurface" image in the TestImages package.
```julia

using ImageBinarization

img = testimage("moonsurface")
binarize!(UnimodalRosin(),img)
```


# Reference
[1] P. L. Rosin, “Unimodal thresholding,” Pattern Recognition, vol. 34, no. 11, pp. 2083–2096, Nov. 2001.


# See Also
"""
function binarize(algorithm::UnimodalRosin,  img::AbstractArray{T,2}) where T <: AbstractGray
  binarize!(algorithm, copy(img))
end

function binarize!(algorithm::UnimodalRosin,  img::AbstractArray{T,2}) where T <: AbstractGray
  edges, counts = build_histogram(img,  256)
  t = find_threshold(HistogramThresholding.UnimodalRosin(), counts[1:end], edges)
  map!(img,img) do val
    val < t ? Gray(0) : Gray(1)
  end
end
