# ImageBinarization.jl Documentation

```@contents
Depth = 3
```

# Functions

## Adaptive Threshold
```@docs
binarize(::AdaptiveThreshold, ::AbstractArray{<: Colorant,2})
```

## Balanced
```@docs
binarize(::Balanced,  ::AbstractArray{<: Colorant,2})
```

## Entropy
```@docs
binarize(::Entropy,  ::AbstractArray{T,2}) where T <: Colorant
```

## Intermodes
```@docs
binarize(::Intermodes,  ::AbstractArray{<: Colorant,2})
```

## Minimum Error
```@docs
binarize(::MinimumError,  ::AbstractArray{<: Colorant,2})
```

## Minimum Intermodes
```@docs
binarize(::MinimumIntermodes,  ::AbstractArray{<: Colorant,2})
```

## Niblack
```@docs
binarize(::Niblack,  ::AbstractArray{<: Colorant,2})
```

## Otsu
```@docs
binarize(::Otsu,  ::AbstractArray{<: Colorant,2})
```

## Polysegment
```@docs
binarize(::Polysegment,  ::AbstractArray{<: Colorant,2})
```

## Sauvola
```@docs
binarize(::Sauvola,  ::AbstractArray{<: Colorant,2})
```

## Unimodal Rosin
```@docs
binarize(::UnimodalRosin,  ::AbstractArray{<: Colorant,2})
```

## Yen
```@docs
binarize(::Yen,  ::AbstractArray{<: Colorant,2})
```
