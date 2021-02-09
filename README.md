# R-raster-compare

A comparison of R packages for working with geospatial raster data.

We test drive the following packages...

 + [raster](https://CRAN.R-project.org/package=raster)
 
 + [terra](https://CRAN.R-project.org/package=terra)
 
 + [stars](https://CRAN.R-project.org/package=stars)


It may be worthwhile checking out these resources...

 + [rspatial.org](https://rspatial.org/)
 
 + [https://r-spatial.github.io](https://r-spatial.github.io/stars/)

# Provided data

One month of daily MUR SST rasters (as one GeoTIFF) from 2014 covering Penobscot Bay, Maine. The bounding box `[west, east, south, north]` is `[-69.2, -68.49, 43.78, 44.5]`. Dates provided are 2014-06-01 through 2014-06-30.  Also provided are daily sst slope and daily cumulative sst (origin January 1).  These are named `20140601-20140630-sst.tif`, `20140601-20140630-sst_slope.tif` amd `20140601-20140630-sst_cum.tif`.

> JPL MUR MEaSUREs Project. 2015. GHRSST Level 4 MUR Global Foundation Sea Surface Temperature Analysis. Ver. 4.1. PO.DAAC, CA, USA. Dataset accessed [2021-02-08] at https://doi.org/10.5067/GHGMR-4FJ04

100 points within Penobscot Bay, selected at random, stored in [geopackage](https://www.geopackage.org/) format. Use `sf::read_sf("penbay-points.gpkg")` to read them in.

A single polygon within Penobscot Bay stored in [geopackage](https://www.geopackage.org/) format.  Use `sf::read_sf(p, "penbay-polygon.gpkg")` to read it in.

# Provided functionality

`setup.R` can be sourced to (possibly) install the needed packages.  It also exposes a function for reading the provided stack of images.  Note that if you change your working directory to the repository it will work with minimal effort.

```
setwd("/path/to/repos/R-raster-compare")
source("setup.R")

rast <- read_stack(form = 'raster')
terr <- read_stack(form = 'terra')
star <- read_stack(form = 'stars')
```

