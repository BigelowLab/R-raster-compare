# Layer names

**Question** - how do you extract the set/get names for layers in a stack?  

```
source("setup.R")
rast <- read_stack(sst_file, form = "raster")
terr <- read_stack(sst_file, form = "terra")
star <- read_stack(sst_file, form = "stars")

dates <- seq.Date(from = as.Date("2014-06-01"), to = as.Date("2014-06-30"), by = "day")
layer_names <- format(dates, "%b_%d")
```

### Raster

See the help for `?raster::names`

```
names(rast) <- layer_names
# rast
# class      : RasterStack 
# dimensions : 72, 71, 5112, 30  (nrow, ncol, ncell, nlayers)
# resolution : 0.009999999, 0.01  (x, y)
# extent     : -69.195, -68.485, 43.785, 44.505  (xmin, xmax, ymin, ymax)
# crs        : +proj=longlat +datum=WGS84 +no_defs 
# names      :  Jun_01,  Jun_02,  Jun_03,  Jun_04,  Jun_05,  Jun_06,  Jun_07,  Jun_08,  Jun_09,  Jun_10,  Jun_11,  Jun_12,  Jun_13,  Jun_14,  Jun_15, ... 
# min values : 281.357, 281.521, 281.771, 282.179, 282.565, 282.340, 282.393, 283.122, 283.225, 283.721, 283.794, 283.819, 283.075, 283.305, 283.380, ... 
# max values : 283.351, 283.012, 283.456, 284.127, 284.153, 284.422, 284.579, 284.651, 285.073, 285.646, 285.831, 285.965, 285.528, 285.436, 284.978, ... 
```


### Terra

See the help for `?terra::names`

```
names(terr) <- layer_names
terr
# class       : SpatRaster 
# dimensions  : 72, 71, 30  (nrow, ncol, nlyr)
# resolution  : 0.009999999, 0.01  (x, y)
# extent      : -69.195, -68.485, 43.785, 44.505  (xmin, xmax, ymin, ymax)
# coord. ref. : +proj=longlat +datum=WGS84 +no_defs 
# source      : 20140601-20140630-sst.tif 
# names       :  Jun_01,  Jun_02,  Jun_03,  Jun_04,  Jun_05,  Jun_06, ... 
# min values  : 281.357, 281.521, 281.771, 282.179, 282.565, 282.340, ... 
# max values  : 283.351, 283.012, 283.456, 284.127, 284.153, 284.422, ... 
```

### Stars

Confusingly, `names()` gets/sets the attributes (variable) names in `stars`.   Our example has only one attribute (variable) but we cna still make it look good.

```
names(star) <- "sst"
```

To get at name/values of dimensions, including the layers, use `stars::st_[get/set]_dimensions()`

```
# set layer values
star <- star %>%
  stars::st_set_dimensions(which = "band", 
                           values = dates, 
                           names = "dates", 
                           point = FALSE)

# get layer values

str(stars::st_get_dimension_values(star, 'dates'))
# Date[1:30], format: "2014-06-01" "2014-06-02" "2014-06-03" "2014-06-04" "2014-06-05" "2014-06-06" ...
```
