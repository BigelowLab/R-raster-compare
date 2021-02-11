packages <- c("dplyr", "sf", "raster", "terra", "stars")
all_packages <- rownames(installed.packages())
ok <- lapply(packages, 
             function(package){
               if (!(package %in% all_packages)) install.packages(package, repos = "https://cloud.r-project.org")
             })


library(dplyr)
library(sf)
library(raster)
library(terra)
library(stars)

#JPL MUR MEaSUREs Project. 2015. GHRSST Level 4 MUR Global Foundation Sea Surface Temperature Analysis. Ver. 4.1. PO.DAAC, CA, USA. Dataset accessed [2021-02-08] at https://doi.org/10.5067/GHGMR-4FJ04

penbay_bb <- c(-69.2, -68.49, 43.78, 44.5)
sst_file <- "data/20140601-20140630-sst.tif"
slope_file <- "data/20140601-20140630-sst_slope.tif"
cum_file <- "data/20140601-20140630-sst_cum.tif"

#' Read in a stack of images
#'
#' @param filename the name of the file to read
#' @param form character, one of 'raster', 'terra' or 'stars'
#' @param apply_names logical, if TRUE apply names to each band (layer)
#' @return RasterStack, terra or stars object
read_stack <- function(filename = sst_file,
                       form = c("raster", "terra", "stars")[1],
                       apply_names = FALSE){

  if (apply_names){
    dates <- seq.Date(from = as.Date("2014-06-01"), to = as.Date("2014-06-30"), by = "day")
    layer_names <- format(dates, "%b_%d")
  }
  stopifnot(file.exists(filename[1]))
  switch(tolower(form[1]),
         "terra" = 
           {
             x <- terra::rast(filename[1])
            if (apply_names) names(x) <- layer_names
            x
           },
         "stars" =  
           {
             x <- stars::read_stars(filename[1]) 
             if (apply_names) x <- stars::st_set_dimensions(x,
                                                               which = "band", 
                                                               values = dates, 
                                                               names = "dates", 
                                                               point = FALSE)
             x
           },
         { 
           x <- raster::stack(filename[1])
           if (apply_names) names(x) <- layer_names
           x 
         })
}



#' Read a multi-attribute stars object
#' 
#' @return a multi-attribute multi-band stars object
read_mstar <- function(){
  dates <- seq.Date(from = as.Date("2014-06-01"), to = as.Date("2014-06-30"), by = "day")
  mstar <- stars::read_stars(c(sst_file, slope_file, cum_file)) %>%
    stars::st_set_dimensions(which = "band", 
                             values = dates, 
                             names = "dates", 
                             point = FALSE)
  names(mstar) <- c("sst", "slope", "cum")
  mstar
}

 
#' Convert sf::sf object to terra::SpatVector
#' 
#' You will need this to use terra::extract()
#' 
#' @param x sf object
#' @return SpatVector object
sf_to_SpatVector <- function(x){
  as(x, "Spatial") %>% 
    terra::vect()
}
