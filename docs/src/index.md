# ImageBinarization.jl Documentation

```@docs
binarize(::Entropy,  ::AbstractArray{T,2}) where T <: Colorant
binarize(::Otsu,  ::AbstractArray{<: Colorant,2})
binarize(::Yen,  ::AbstractArray{<: Colorant,2})
binarize(::Balanced,  ::AbstractArray{<: Colorant,2})
binarize(::MinimumIntermodes,  ::AbstractArray{<: Colorant,2})
binarize(::Niblack,  ::AbstractArray{<: Colorant,2})
binarize(::Sauvola,  ::AbstractArray{<: Colorant,2})
binarize(::UnimodalRosin,  ::AbstractArray{<: Colorant,2})
binarize(::MinimumError,  ::AbstractArray{<: Colorant,2})
binarize(::Intermodes,  ::AbstractArray{<: Colorant,2})
binarize(::Polysegment,  ::AbstractArray{<: Colorant,2})
binarize(::AdaptiveThreshold, ::AbstractArray{<: Colorant,2}; ::Int, ::Int)
```
