# Subsetting by slicing

The intended meaning of slicing from multidimensional arrays is to extract one or more complete subarrays.  The extracted subarray will have the same data type and class as the original.  Like removing a slice of bread from an entire loaf. 

Here we start afresh, but this time we ask the stack reader to apply names to each band (layer).
```
source("setup.R")
rast <- read_stack(sst_file, form = "raster", apply_names = TRUE)
terr <- read_stack(sst_file, form = "terra", apply_names = TRUE)
star <- read_stack(sst_file, form = "stars", apply_names = TRUE)

dates <- seq.Date(from = as.Date("2014-06-01"), to = as.Date("2014-06-30"), by = "day")
layer_names <- format(dates, "%b_%d")
sub_index <- c(5, 6, 23)
sub_layer_names <- layer_names[sub_index]
```

## Raster and Terra

Use `[[` or `subset()` to slice out layers. I always use `[[` (I'm not sure why).  You can use integer indices...

```
sub_rast <- rast[[sub_index]]
sub_rast
# class      : RasterStack 
# dimensions : 72, 71, 5112, 3  (nrow, ncol, ncell, nlayers)
# resolution : 0.009999999, 0.01  (x, y)
# extent     : -69.195, -68.485, 43.785, 44.505  (xmin, xmax, ymin, ymax)
# crs        : +proj=longlat +datum=WGS84 +no_defs 
# names      :  Jun_05,  Jun_06,  Jun_23 
# min values : 282.565, 282.340, 284.280 
# max values : 284.153, 284.422, 286.381 
```

... or names ...

```
sub_rast <- rast[[sub_layer_names]]
sub_rast
# class      : RasterStack 
# dimensions : 72, 71, 5112, 3  (nrow, ncol, ncell, nlayers)
# resolution : 0.009999999, 0.01  (x, y)
# extent     : -69.195, -68.485, 43.785, 44.505  (xmin, xmax, ymin, ymax)
# crs        : +proj=longlat +datum=WGS84 +no_defs 
# names      :  Jun_05,  Jun_06,  Jun_23 
# min values : 282.565, 282.340, 284.280 
# max values : 284.153, 284.422, 286.381 
```

The above works identically using `terra`.

```
sub_terr <- terr[[sub_layer_names]]
sub_terr
```

## Stars

Subsetting (slicing) with stars use a single `[`.  But you have to provide for more dimensions.

```
sub_star <- star[ , , , sub_index]
# stars object with 3 dimensions and 1 attribute
# attribute(s):
#  X20140601.20140630.sst.tif 
#  Min.   :282.3              
#  1st Qu.:283.1              
#  Median :283.6              
#  Mean   :283.9              
#  3rd Qu.:284.8              
#  Max.   :286.4              
#  NA's   :4605               
# dimension(s):
#       from to  offset delta refsys point
# x        1 71 -69.195  0.01 WGS 84 FALSE
# y        1 72  44.505 -0.01 WGS 84 FALSE
# dates    1  3      NA    NA   Date FALSE
#                                                                          values x/y
# x                                                                          NULL [x]
# y                                                                          NULL [y]
# dates [2014-06-05,2014-06-06), [2014-06-06,2014-06-07), [2014-06-23,2014-06-24)    
```

**Note** that the `values` portion of dimensions now has, well, a value.  `values` only has values when the delta (step between bands) is irregular, in which case `delta` is NA as there is not constant step size.  Also, because we have `point = FALSE` each band interval is a range that spans the beginning of the date (inclusive) to the end of the interval (midnight the next day, exclusive).
That's how to read `[2014-06-05,2014-06-06)` etc.


# Subsetting by cropping

Cropping is intended to extract a subset of a multidimensional array a smaller portion of it.  Unlike slicing there is some expectation that the requested portion will not exactly match the actual portion. Some interpolation must be applied to match arbitrary bounding cooridnates to crop with whole grid cell increments.
