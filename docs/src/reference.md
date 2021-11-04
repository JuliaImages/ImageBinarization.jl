# [Function References](@id function_reference)

```@contents
Pages = ["reference.md"]
Depth = 3
```

## General function

```@docs
binarize
binarize!
```

## Algorithms

```@docs
ImageBinarization.BinarizationAPI.AbstractImageBinarizationAlgorithm
```

### Adaptive Threshold
```@docs
AdaptiveThreshold
```

### Niblack
```@docs
Niblack
```

### Polysegment
```@docs
Polysegment
```

### Sauvola
```@docs
Sauvola
```

### Algorithms that utilizes single histogram-threshold

The core functionality of these algorithms are supported by
[HistogramThresholding.jl](https://github.com/JuliaImages/HistogramThresholding.jl)

```@docs
SingleHistogramThreshold
```
