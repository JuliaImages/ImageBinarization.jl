# ImageBinarization.jl Documentation

A Julia package containing a number of algorithms for analyzing images and automatically binarizing them into background and foreground.

```@contents
Depth = 2
```

## Basic usage

Each binarization algorithm in `ImageBinarization.jl` is an [`AbstractImageBinarizationAlgorithm`](@ref ImageBinarization.BinarizationAPI.AbstractImageBinarizationAlgorithm).

Suppose one wants to binarize an image. This can be achieved by simply choosing
an appropriate algorithm and calling [`binarize`](@ref) or [`binarize!`](@ref) in the
image. The background and foreground will be automatically binarized.

Let's see a simple demo:

```@example
using TestImages, ImageBinarization, FileIO # hide
img = testimage("cameraman")
alg = Otsu()
img₀₁ = binarize(img, alg)
save("images/demo.jpg", hcat(img, img₀₁)) # hide
```

```@raw html
<img src="images/demo.jpg" width="400px" alt="demo image" />
```

This usage reads as "`binarize` the image `img` with algorithm `alg`"

For more advanced usage, please check [function reference](@ref function_reference) page.

## Examples of ImageBinarization in action

```@raw html
<h>Image of cells:</h>
<table width="500" border="0" cellpadding="5">

<tr>
<td align="center" valign="center">
<img src="images/cells.jpg" width="100px" alt="Original image" />
<br />
Original image
</td>
</tr>

<tr>
<td align="center" valign="center">
<img src="images/cells_Intermodes.jpg" width="100px" alt="Intermodes" />
<br />
Intermodes
</td>

<td align="center" valign="center">
<img src="images/cells_MinimumError.jpg" width="100px" alt="Minimum Error" />
<br />
Minimum Error
</td>

<td align="center" valign="center">
<img src="images/cells_MinimumIntermodes.jpg" width="100px" alt="Minimum" />
<br />
Minimum
</td>
</tr>

<tr>
<td align="center" valign="center">
<img src="images/cells_Moments.jpg" width="100px" alt="Moments" />
<br />
Moments
</td>

<td align="center" valign="center">
<img src="images/cells_otsu.jpg" width="100px" alt="Otsu" />
<br />
Otsu
</td>

<td align="center" valign="center">
<img src="images/cells_Polysegment.jpg" width="100px" alt="Polysegment" />
<br />
Polysegment
</td>
</tr>

<tr>
<td align="center" valign="center">
<img src="images/cells_UnimodalRosin.jpg" width="100px" alt="Rosin" />
<br />
Rosin
</td>

<td align="center" valign="center">
<img src="images/cells_sauvola.png" width="100px" alt="Sauvola" />
<br />
Sauvola
</td>

<td align="center" valign="center">
<img src="images/cells_niblack.png" width="100px" alt="Niblack" />
<br />
Niblack
</td>
</tr>

<tr>
<td align="center" valign="center">
<img src="images/cells_Adaptive.jpg" width="100px" alt="Adaptive" />
<br />
Adaptive
</td>

<td align="center" valign="center">
<img src="images/cells_Yen.jpg" width="100px" alt="Yen" />
<br />
Yen
</td>

<td align="center" valign="center">
<img src="images/cells_Balanced.jpg" width="100px" alt="Balanced" />
<br />
Balanced
</td>
</tr>
</table>

<h>Image of moon surface: (Unimodal)</h>
<table width="500" border="0" cellpadding="5">

<tr>
<td align="center" valign="center">
<img src="images/moon.jpg" width="100px" alt="Original image" />
<br />
Original image
</td>
</tr>

<tr>
<td align="center" valign="center">
<img src="images/moon_Intermodes.jpg" width="100px" alt="Intermodes" />
<br />
Intermodes
</td>

<td align="center" valign="center">
<img src="images/moon_MinimumError.jpg" width="100px" alt="Minimum Error" />
<br />
Minimum Error
</td>

<td align="center" valign="center">
<img src="images/moon_MinimumIntermodes.jpg" width="100px" alt="Minimum" />
<br />
Minimum
</td>
</tr>

<tr>
<td align="center" valign="center">
<img src="images/moon_Moments.jpg" width="100px" alt="Moments" />
<br />
Moments
</td>

<td align="center" valign="center">
<img src="images/moon_otsu.jpg" width="100px" alt="Otsu" />
<br />
Otsu
</td>

<td align="center" valign="center">
<img src="images/moon_Polysegment.jpg" width="100px" alt="Polysegment" />
<br />
Polysegment
</td>
</tr>

<tr>
<td align="center" valign="center">
<img src="images/moon_UnimodalRosin.jpg" width="100px" alt="Rosin" />
<br />
Rosin
</td>

<td align="center" valign="center">
<img src="images/moon_sauvola.png" width="100px" alt="Sauvola" />
<br />
Sauvola
</td>

<td align="center" valign="center">
<img src="images/moon_niblack.png" width="100px" alt="Niblack" />
<br />
Niblack
</td>
</tr>

<tr>
<td align="center" valign="center">
<img src="images/moon_Adaptive.jpg" width="100px" alt="Adaptive" />
<br />
Adaptive
</td>

<td align="center" valign="center">
<img src="images/moon_Yen.jpg" width="100px" alt="Yen" />
<br />
Yen
</td>

<td align="center" valign="center">
<img src="images/moon_Balanced.jpg" width="100px" alt="Balanced" />
<br />
Balanced
</td>
</tr>
</table>

<h>Image of text:</h>
<table width="500" border="0" cellpadding="5">

<tr>
<td align="center" valign="center">
<img src="images/page.jpg" width="100px" alt="Original image" />
<br />
Original image
</td>
</tr>

<tr>
<td align="center" valign="center">
<img src="images/page_Intermodes.jpg" width="100px" alt="Intermodes" />
<br />
Intermodes
</td>

<td align="center" valign="center">
<img src="images/page_MinimumError.jpg" width="100px" alt="Minimum Error" />
<br />
Minimum Error
</td>

<td align="center" valign="center">
<img src="images/page_MinimumIntermodes.jpg" width="100px" alt="Minimum" />
<br />
Minimum
</td>
</tr>

<tr>
<td align="center" valign="center">
<img src="images/page_Moments.jpg" width="100px" alt="Moments" />
<br />
Moments
</td>

<td align="center" valign="center">
<img src="images/page_otsu.jpg" width="100px" alt="Otsu" />
<br />
Otsu
</td>

<td align="center" valign="center">
<img src="images/page_Polysegment.jpg" width="100px" alt="Polysegment" />
<br />
Polysegment
</td>
</tr>

<tr>
<td align="center" valign="center">
<img src="images/page_UnimodalRosin.jpg" width="100px" alt="Rosin" />
<br />
Rosin
</td>

<td align="center" valign="center">
<img src="images/page_sauvola.png" width="100px" alt="Sauvola" />
<br />
Sauvola
</td>

<td align="center" valign="center">
<img src="images/page_niblack.png" width="100px" alt="Niblack" />
<br />
Niblack
</td>
</tr>

<tr>
<td align="center" valign="center">
<img src="images/page_Adaptive.jpg" width="100px" alt="Adaptive" />
<br />
Adaptive
</td>

<td align="center" valign="center">
<img src="images/page_Yen.jpg" width="100px" alt="yen" />
<br />
Yen
</td>

<td align="center" valign="center">
<img src="images/page_Balanced.jpg" width="100px" alt="Balanced" />
<br />
Balanced
</td>
</tr>
</table>
```
