# ImageBinarization.jl Documentation

```@contents
Depth = 3
```

## Overview

TODO: some description on how to use this package

```@docs
BinarizationAlgorithm
```

The core function `binarize` can be used in a generic way:

```@docs
binarize
```

## Binarization Algorithms

### Adaptive Threshold
```@docs
binarize(::AdaptiveThreshold,  ::AbstractArray{<: Colorant,2})
AdaptiveThreshold
recommend_size
```

### Balanced
```@docs
binarize(::Balanced,  ::AbstractArray{<: Colorant,2})
Balanced
```

### Entropy
```@docs
binarize(::Entropy,  ::AbstractArray{<: Colorant,2})
Entropy
```

### Intermodes
```@docs
binarize(::Intermodes,  ::AbstractArray{<: Colorant,2})
Intermodes
```

### Minimum Error
```@docs
binarize(::MinimumError,  ::AbstractArray{<: Colorant,2})
MinimumError
```

### Minimum Intermodes
```@docs
binarize(::MinimumIntermodes,  ::AbstractArray{<: Colorant,2})
MinimumIntermodes
```

### Moments
```@docs
binarize(::Moments,  ::AbstractArray{<: Colorant,2})
Moments
```

### Niblack
```@docs
binarize(::Niblack,  ::AbstractArray{<: Colorant,2})
Niblack
```

### Otsu
```@docs
binarize(::Otsu,  ::AbstractArray{<: Colorant,2})
Otsu
```

### Polysegment
```@docs
binarize(::Polysegment,  ::AbstractArray{<: Colorant,2})
Polysegment
```

### Sauvola
```@docs
binarize(::Sauvola,  ::AbstractArray{<: Colorant,2})
Sauvola
```

### Unimodal Rosin
```@docs
binarize(::UnimodalRosin,  ::AbstractArray{<: Colorant,2})
UnimodalRosin
```

### Yen
```@docs
binarize(::Yen,  ::AbstractArray{<: Colorant,2})
Yen
```
