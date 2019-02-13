# ImageBinarization
[![Build Status](https://travis-ci.com/zygmuntszpak/ImageBinarization.jl.svg?branch=master)](https://travis-ci.com/zygmuntszpak/ImageBinarization.jl)
[![Build Status](https://ci.appveyor.com/api/projects/status/github/zygmuntszpak/ImageBinarization.jl?svg=true)](https://ci.appveyor.com/project/zygmuntszpak/ImageBinarization-jl)
[![Codecov](https://codecov.io/gh/zygmuntszpak/ImageBinarization.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/zygmuntszpak/ImageBinarization.jl)
[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://zygmuntszpak.github.io/ImageBinarization.jl/stable)
[![](https://img.shields.io/badge/docs-dev-blue.svg)](https://zygmuntszpak.github.io/ImageBinarization.jl/dev)

A Julia package containing a number of algorithms for analyzing images and
automatically binarizing them into background and foreground.

A full list of algorithms can be found in the [documentation](https://zygmuntszpak.github.io/ImageBinarization.jl/stable).

The general usage pattern is:
```julia
imgb = binarize(algorithm::ThresholdAlgorithm, img)
```

<h2>Examples of ImageBinarization in action:</h2>
<h>Image of cells:</h>
<table width="500" border="0" cellpadding="5">

<tr>
<td align="center" valign="center">
<img src="docs/src/images/cells.jpg" width="100px" alt="Original image" />
<br />
Original image
</td>
</tr>

<tr>
<td align="center" valign="center">
<img src="docs/src/images/cells_Intermodes.jpg" width="100px" alt="Intermodes" />
<br />
Intermodes
</td>

<td align="center" valign="center">
<img src="docs/src/images/cells_MinimumError.jpg" width="100px" alt="Minimum Error" />
<br />
Minimum Error
</td>

<td align="center" valign="center">
<img src="docs/src/images/cells_MinimumIntermodes.jpg" width="100px" alt="Minimum" />
<br />
Minimum
</td>
</tr>

<tr>
<td align="center" valign="center">
<img src="docs/src/images/cells_Moments.jpg" width="100px" alt="Moments" />
<br />
Moments
</td>

<td align="center" valign="center">
<img src="docs/src/images/cells_otsu.jpg" width="100px" alt="Otsu" />
<br />
Otsu
</td>

<td align="center" valign="center">
<img src="docs/src/images/cells_Polysegment.jpg" width="100px" alt="Polysegment" />
<br />
Polysegment
</td>
</tr>

<tr>
<td align="center" valign="center">
<img src="docs/src/images/cells_UnimodalRosin.jpg" width="100px" alt="Rosin" />
<br />
Rosin
</td>

<td align="center" valign="center">
<img src="docs/src/images/cells_sauvola.png" width="100px" alt="Sauvola" />
<br />
Sauvola
</td>

<td align="center" valign="center">
<img src="docs/src/images/cells_niblack.png" width="100px" alt="Niblack" />
<br />
Niblack
</td>
</tr>
</table>

<h>Image of moon surface: (Unimodal)</h>
<table width="500" border="0" cellpadding="5">

<tr>
<td align="center" valign="center">
<img src="docs/src/images/moon.jpg" width="100px" alt="Original image" />
<br />
Original image
</td>
</tr>

<tr>
<td align="center" valign="center">
<img src="docs/src/images/moon_Intermodes.jpg" width="100px" alt="Intermodes" />
<br />
Intermodes
</td>

<td align="center" valign="center">
<img src="docs/src/images/moon_MinimumError.jpg" width="100px" alt="Minimum Error" />
<br />
Minimum Error
</td>

<td align="center" valign="center">
<img src="docs/src/images/moon_MinimumIntermodes.jpg" width="100px" alt="Minimum" />
<br />
Minimum
</td>
</tr>

<tr>
<td align="center" valign="center">
<img src="docs/src/images/moon_Moments.jpg" width="100px" alt="Moments" />
<br />
Moments
</td>

<td align="center" valign="center">
<img src="docs/src/images/moon_otsu.jpg" width="100px" alt="Otsu" />
<br />
Otsu
</td>

<td align="center" valign="center">
<img src="docs/src/images/moon_Polysegment.jpg" width="100px" alt="Polysegment" />
<br />
Polysegment
</td>
</tr>

<tr>
<td align="center" valign="center">
<img src="docs/src/images/moon_UnimodalRosin.jpg" width="100px" alt="Rosin" />
<br />
Rosin
</td>

<td align="center" valign="center">
<img src="docs/src/images/moon_sauvola.png" width="100px" alt="Sauvola" />
<br />
Sauvola
</td>

<td align="center" valign="center">
<img src="docs/src/images/moon_niblack.png" width="100px" alt="Niblack" />
<br />
Niblack
</td>
</tr>
</table>

<h>Image of text:</h>
<table width="500" border="0" cellpadding="5">

<tr>
<td align="center" valign="center">
<img src="docs/src/images/page.jpg" width="100px" alt="Original image" />
<br />
Original image
</td>
</tr>

<tr>
<td align="center" valign="center">
<img src="docs/src/images/page_Intermodes.jpg" width="100px" alt="Intermodes" />
<br />
Intermodes
</td>

<td align="center" valign="center">
<img src="docs/src/images/page_MinimumError.jpg" width="100px" alt="Minimum Error" />
<br />
Minimum Error
</td>

<td align="center" valign="center">
<img src="docs/src/images/page_MinimumIntermodes.jpg" width="100px" alt="Minimum" />
<br />
Minimum
</td>
</tr>

<tr>
<td align="center" valign="center">
<img src="docs/src/images/page_Moments.jpg" width="100px" alt="Moments" />
<br />
Moments
</td>

<td align="center" valign="center">
<img src="docs/src/images/page_otsu.jpg" width="100px" alt="Otsu" />
<br />
Otsu
</td>

<td align="center" valign="center">
<img src="docs/src/images/page_Polysegment.jpg" width="100px" alt="Polysegment" />
<br />
Polysegment
</td>
</tr>

<tr>
<td align="center" valign="center">
<img src="docs/src/images/page_UnimodalRosin.jpg" width="100px" alt="Rosin" />
<br />
Rosin
</td>

<td align="center" valign="center">
<img src="docs/src/images/page_sauvola.png" width="100px" alt="Sauvola" />
<br />
Sauvola
</td>

<td align="center" valign="center">
<img src="docs/src/images/page_niblack.png" width="100px" alt="Niblack" />
<br />
Niblack
</td>
</tr>
</table>

## Example
Suppose one wants to binarize an image. This can be achieved by simply choosing
an appropriate algorithm and calling `binarize` in the image. The background
and foreground will be automatically binarized.

```julia
using ImageBinarization
using TestImages # For the cameraman image.

#load cameraman image
img = testimage("cameraman")

#binarize the image
imgb = binarize(Otsu(), img)
```
