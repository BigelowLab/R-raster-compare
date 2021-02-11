# Extracting points

**Question** - how do you extract the values at various points for every layer in a stack?  
See `?raster::extract`, `?terra::extract` and `?stars::st_extract`


```
source("setup.R")
rast <- read_stack(sst_file, form = "raster")
terr <- read_stack(sst_file, form = "terra")
star <- read_stack(sst_file, form = "stars")
pts <- sf::read_sf(data/"penbay-points.gpkg")
```


### Raster

Raster will return a matrix of [npoints, nlayers]

```
vrast <- extract(rast, pts)
str(vrast)
# num [1:100, 1:30] 283 282 283 283 283 ...
# - attr(*, "dimnames")=List of 2
#  ..$ : NULL
#  ..$ : chr [1:30] "X20140601.20140630.sst.1" "X20140601.20140630.sst.2" "X20140601.20140630.sst.3" "X20140601.20140630.sst.4" 
#...
```

### Terra

For this we must convert our points from a sf object to a SpatVector object. See the `sf_to_SpatVector()` function in `setup.R`

terra returns a data.frame of [npoints, nlayers], which we convert to a tibble.

```
vterr <- extract(terr, sf_to_SpatVector(pts)) %>%
  dplyr::as_tibble()
vterr
# # A tibble: 100 x 31
#       ID `201_1` `201_2` `201_3` `201_4` `201_5` `201_6` `201_7` `201_8` `201_9` `201_10` `201_11` `201_12`
#    <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>    <dbl>    <dbl>    <dbl>
#  1     1    283.    283.    283.    283.    283.    284.    284.    284.    284.     285.     285.     285.
#  2     2    282.    282.    282.    282.    283.    283.    283.    284.    284.     284.     284.     284.
#  3     3    283.    283.    283.    283.    283.    283.    284.    284.    284.     285.     285.     285.
#  4     4    283.    283.    283.    284.    284.    284.    284.    284.    285.     285.     286.     286.
#  5     5    283.    283.    283.    283.    284.    284.    284.    284.    284.     285.     285.     285.
#  6     6    283.    283.    283.    283.    283.    283.    283.    284.    284.     285.     285.     285.
#  7     7    282.    282.    283.    283.    283.    284.    284.    284.    284.     285.     285.     285.
#  8     8    282.    282.    282.    282.    283.    283.    283.    283.    284.     284.     284.     284.
#  9     9    282.    282.    283.    283.    284.    284.    284.    284.    285.     285.     285.     285.
# 10    10    283.    283.    283.    283.    284.    284.    284.    284.    284.     285.     285.     286.
# # … with 90 more rows, and 18 more variables: `201_13` <dbl>, `201_14` <dbl>, `201_15` <dbl>, `201_16` <dbl>,
# #   `201_17` <dbl>, `201_18` <dbl>, `201_19` <dbl>, `201_20` <dbl>, `201_21` <dbl>, `201_22` <dbl>,
# #   `201_23` <dbl>, `201_24` <dbl>, `201_25` <dbl>, `201_26` <dbl>, `201_27` <dbl>, `201_28` <dbl>,
# #   `201_29` <dbl>, `201_30` <dbl>
```

### Stars


Stars returns a special extraction object (nto bery useful to us in general) which we convert to a sf object.

```
vstar <- stars::st_extract(star, pts) %>%
  sf::st_as_sf()
vstar
# Simple feature collection with 100 features and 30 fields
# geometry type:  POINT
# dimension:      XY
# bbox:           xmin: -69.18 ymin: 43.79 xmax: -68.49 ymax: 44.41
# geographic CRS: WGS 84
# First 10 features:
#    20140601-20140630-sst.tif.V1 20140601-20140630-sst.tif.V2
# 1                       282.709                      282.545
# 2                       281.737                      281.699
# 3                       282.768                      282.572
# 4                       282.929                      282.789
# 5                       282.935                      282.759
# 6                       282.740                      282.640
# 7                       282.024                      282.120
# 8                       281.721                      282.013
# 9                       282.356                      282.243
# 10                      282.919                      282.723
#  .
#  .
#  .
#    20140601-20140630-sst.tif.V29 20140601-20140630-sst.tif.V30                 geom
# 1                        286.074                       286.741 POINT (-68.89 44.03)
# 2                        285.652                       286.070 POINT (-68.54 43.87)
# 3                        285.983                       286.676 POINT (-68.86 44.04)
# 4                        286.814                       287.033  POINT (-69.04 44.1)
# 5                        286.450                       286.916 POINT (-68.91 44.16)
# 6                        286.623                       286.800 POINT (-68.86 44.26)
# 7                        285.953                       286.742 POINT (-68.89 43.91)
# 8                        285.839                       285.937  POINT (-68.5 44.22)
# 9                        286.247                       286.786 POINT (-68.95 43.94)
# 10                       286.562                       286.878 POINT (-68.95 44.09) 
```

 

