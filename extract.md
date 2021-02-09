# Extracting points

```
source("setup.R")
terr <- read_stack(sst_file, form = "terra")
pts <- sf::read_sf("penbay-points.gpkg")

pt1 <- pts %>% slice(1)
```

# Question - how do yo extract the values at pt1 for every layer in terr?  See `?terra::extract`

