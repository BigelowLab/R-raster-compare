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

Subsetting (slicing) with stars use a single `[`.  You can provide specificity on each dimension which take the form of `[attributes, x, y, band]`.  Leaving  a dimension empty select all of that dimension.  Let's start with bands...

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

Ugg, the dimension info wrapped.

**Note** that the `values` portion of dimensions now has, well, a value.  `values` in the printout only has values when the delta (step between bands) is irregular, in which case `delta` is NA as there is not constant step size.  Also, because we have `point = FALSE` each band interval is a range that spans the beginning of the date (inclusive) to the end of the interval (midnight the next day, exclusive). That's how to read `[2014-06-05,2014-06-06)` etc "from the beginning of the 5th until the moment before the 6th".


We can also subset by attribute, but for that we would need to a multi-attribute stars object.  Tgis time I am going to give the bands character names (Jun_1, Jun_2, ...) and I will provide pretty names for the attributes.


```
mstar <- stars::read_stars(c(sst_file, slope_file, cum_file)) %>%
  stars::st_set_dimensions(which = "band", 
                             values = layer_names, 
                             names = "dates", 
                             point = FALSE)
names(mstar) <- c("sst", "slope", "cum")
mstar
#stars object with 3 dimensions and 3 attributes
#attribute(s):
#      sst            slope            cum       
# Min.   :281.4   Min.   :0       Min.   :42042  
# 1st Qu.:283.7   1st Qu.:0       1st Qu.:44117  
# Median :284.5   Median :0       Median :46298  
# Mean   :284.4   Mean   :0       Mean   :46266  
# 3rd Qu.:285.2   3rd Qu.:0       3rd Qu.:48385  
# Max.   :287.6   Max.   :0       Max.   :50570  
# NA's   :46050   NA's   :54390   NA's   :46050  
#dimension(s):
#      from to  offset delta refsys point            values x/y
#x        1 71 -69.195  0.01 WGS 84 FALSE              NULL [x]
#y        1 72  44.505 -0.01 WGS 84 FALSE              NULL [y]
#dates    1 30      NA    NA     NA FALSE Jun_01,...,Jun_30  
```

Pay attention now... (1) the attributes now have pretty names and (2) the band (last) dimension now has a name ('dates), no offset, delta or refsys but it does have values printed (since they aren't regularily spaced.)  

OK, now let's slice or subset the `cum` attribute and just the `sub_layer_names`. Note that indexing in this case has to be by integer position so we have convert those date names to integer index.

```
mstar['cum', , , match(sub_layer_names, layer_names)]
# stars object with 3 dimensions and 1 attribute
# attribute(s):
#       cum       
#  Min.   :43174  
#  1st Qu.:43320  
#  Median :43550  
#  Mean   :45080  
#  3rd Qu.:48349  
#  Max.   :48573  
#  NA's   :4605   
# dimension(s):
#       from to  offset delta refsys point                 values x/y
# x        1 71 -69.195  0.01 WGS 84 FALSE                   NULL [x]
# y        1 72  44.505 -0.01 WGS 84 FALSE                   NULL [y]
# dates    1  3      NA    NA     NA FALSE Jun_05, Jun_06, Jun_23   
```


