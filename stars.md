# [stars](https://CRAN.R-project.org/package=stars)


# Reading a single file (with multiple layers)
```
source("setup.R")
(star <- read_stack(form = "stars"))
# stars object with 3 dimensions and 1 attribute
# attribute(s):
#  20140601-20140630.sst.tif 
#  Min.   :281.4         
#  1st Qu.:283.7         
#  Median :284.5         
#  Mean   :284.4         
#  3rd Qu.:285.2         
#  Max.   :287.6         
#  NA's   :46050         
# dimension(s):
#      from to  offset delta refsys point values x/y
# x       1 71 -69.195  0.01 WGS 84 FALSE   NULL [x]
# y       1 72  44.505 -0.01 WGS 84 FALSE   NULL [y]
# band    1 30      NA    NA     NA    NA   NULL   
```


# Setting dimensions

The stack has only one attribute (the stack of images) which has dimensions `x`, `y` and `band`.  We know `band` is actually `date` so let's try to fix that.

```
dates <- seq(from = as.Date("2014-06-01"), to = as.Date("2014-06-30"), by = "day")

star <- star %>%
  stars::st_set_dimensions(which = "band", 
                           values = dates, 
                           names = "dates", 
                           point = FALSE)
# stars object with 3 dimensions and 1 attribute
# attribute(s):
#  X20140601.20140630.sst.tif 
#  Min.   :281.4          
#  1st Qu.:283.7          
#  Median :284.5          
#  Mean   :284.4          
#  3rd Qu.:285.2          
#  Max.   :287.6          
#  NA's   :46050          
# dimension(s):
#       from to     offset  delta refsys point values x/y
# x        1 71    -69.195   0.01 WGS 84 FALSE   NULL [x]
# y        1 72     44.505  -0.01 WGS 84 FALSE   NULL [y]
# dates    1 30 2014-06-01 1 days   Date FALSE   NULL   
```

# Reading from multiple sources

```
ff <- c(sst_file, slope_file, cum_file)
star <- stars::read_stars(ff) %>%
  stars::st_set_dimensions(which = "band", 
                           values = dates, 
                           names = "dates", 
                           point = FALSE)
# stars object with 3 dimensions and 3 attributes
# attribute(s):
#  X20140601.20140630.sst.tif  X20140601.20140630.sst_slope.tif  X20140601.20140630.sst_cum.tif 
#  Min.   :281.4               Min.   :0                         Min.   :42042                  
#  1st Qu.:283.7               1st Qu.:0                         1st Qu.:44117                  
#  Median :284.5               Median :0                         Median :46298                  
#  Mean   :284.4               Mean   :0                         Mean   :46266                  
#  3rd Qu.:285.2               3rd Qu.:0                         3rd Qu.:48385                  
#  Max.   :287.6               Max.   :0                         Max.   :50570                  
#  NA's   :46050               NA's   :54390                     NA's   :46050                  
# dimension(s):
#       from to     offset  delta refsys point values x/y
# x        1 71    -69.195   0.01 WGS 84 FALSE   NULL [x]
# y        1 72     44.505  -0.01 WGS 84 FALSE   NULL [y]
# dates    1 30 2014-06-01 1 days   Date FALSE   NULL
```

We have a function to do the above.  See `read_mstar()` in `setup.R`. 
