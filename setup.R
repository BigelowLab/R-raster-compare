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
stack_file <- "20140601-20140630.tif"

#' Read in a stack of images
#'
#' @param filename the name of the file to read
#' @param form character, one of 'raster', 'terra' or 'stars'
read_stack <- function(filename = stack_file,
                       form = c("raster", "terra", "stars")[1]){

  stopifnot(file.exists(filename[1]))
  switch(tolower(form[1]),
         "terra" = terra::rast(filename[1]),
         "stars" = stars::read_stars(filename[1]),
         raster::stack(filename[1]))

}
