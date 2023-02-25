
# Why use R instead of GIS? ##################################################################################

  # Reproducibility
  # Tweak analyses or create new ones
  # Automation (repeat tasks avoiding boredom and mistakes)


# Spatial data in R ##########################################################################################

  # rgdal - import/export raster data
  # sp - analyse spatial (vector) data
  # rgeos - geometric operations
  # raster - import, export, analyse raster data
  # sf - simple features, addition to sp

  # st_layers() - to look at all the layers in a geodatabase or shapefile
  # st_read() - imports vector maps (double check help file)
  # raster() - create and import raster maps

# Assign them to an object
  # countries <- readOGR("countries.shp")
  # elevation <- raster("elevation.tif")
  # plot(elevation); plot(countries, add = "TRUE")

# Structure of vector objects
  # sp::slotNames(object)
    # Returns structure information within the object
    # E.g. data, shape/data type, coordinates, projection, bounding box, etc.
  
  # sp::slot(object, "slotName")
    # returns information associated with each slot

  # sp::spplot(object, zcol = "slot")  # map something for a choropleth map
  # sp::choroLayer() ?


# Coordinate Reference Systems ###############################################################################
  
# Vector Data
  # crs(species) <- crs(countries)    # ONLY USE IF YOU KNOW THEY'RE THE SAME COORDINATE REFERENCE SYSTEM
  # sp::spTransform(object, CRS = "projection")
    # Transform projections to one another for more accurate analysis

# Raster Data
  # projectRaster(object, crs = "projection")
  # Projecting rasters usually leads to distortion (pixels become "bent", usually need some transformation to maintain original information as much as possible)


# [sf] - Simple Features package #############################################################################

# sf objects stored in data frame, with geographic data in geom or geometry column
# generally faster and more efficient

# Plotting composed maps normally requires several additional packages and a different syntax

# st_as_sf(object, coords = , crs = )
  # Most functions begin "st_"

# Plotting with [sf] are used in GGPLOT2 <3


# Manipulation of GIS Data in R ##############################################################################

# Vector Data Manipulation ####
  
  # Select/subset by attribute
    # Non-spatial attributes (name, # of inhabitants)
    # Spatial attributes (Location, Size) 

    # rivers[sp::SpatialLinesLengths(rivers) > 300000,] 

  # Cut/trim/clip/crop
    # e.g. rgeos::intersect(object, subset/indexing)

  # Overlay
    # sp::over(object1, object2)  # retrieve geometry of obj1 at locations of obj2

  # Union
    # geos::union()
    # sf::st_combine()
    # sf::st_union()

  # Aggregate/dissolve
    # sf::aggregate(countries, by = "continent")

  # Attribute (table) join
    # cartography::choroLayer(spdf = , df =,  spdfid = "iso3", dfid = "country_code", var = "income2020")
    # Performing joing on two dfs via id columns

  # Simplify vector geometry
    # rgeos::gSimplify(object, tol = 0.2)

  # Get centroids
    # Center of mass of geometric object
    # rgeos::gCentroid(object, byid = TRUE)
      # Get one centroid by each objectID (each entry in the table)
    # rgeos::gPointonSurface, byid = TRUE)
      # Make sure the centroid is on the polygon

  # EXPORT VECTOR MAP
    # sp::writeOGR(object, dsn = getwd(), layer = "___.shp", driver = "ESRI Shapefile")
    # Can be other drivers for like .gri/.grd or .gpkg, etc.

  # SF Package
    # Make sure to import as sf object
    # st_simplify
    # st_intersection
    # st_centroid
    # st_point_on_surface
    # st_write


# Raster Data Manipulation ####

  # Crop
    # raster::crop(layer, object/polygon)
    # It essentially just zooms in/crops to the specific polygon or layer

  # Mask
    # raster::mask(layer, object to mask to)
    # cuts out all of raster not in the polygon
  
  # Crop/mask together
    # mask(crop(layer, object/polygon))

  # Aggregate
    # raster::aggregate(raster, fact = , fun[ction] = )
    # aggregate pixels to a factor of ___ and using function (how it aggregates/chooses how to display the factor aggregation) ____
    # aggregate(elevation, fact = 10, fun = mean)
    # aggregate(population, fact = 10, fun = sum)

  # Disaggregate
    # raster::disaggregate(layer, fact = , method = "")
    # Interpolates larger pixels into smaller pixels

  # Reclassify
    # Use regular indexing to clean data
    # elevation[elevation < 0] <- 0

  # Stack / brick
    # Stack identical raster maps together to streamline operations
    # raster::stack links to raster files on a disk
    # raster::brick stores the rasters in an R object, which occupies memory, but is often faster to process
    # Basically a list of rasters
    # Need to use raster::projectRaster() to make them overlap perfectly

  # Rename layers in a stack or brick
    # names(var_stack) <- c("", "", "")

  # Remove layer from stack or brick
    # raster::dropLayer(stack, "layer")
    # Can identify by name or position of layer
    # raster::dropLayer(stack, c(2:3))

  # Raster Algebra
    # Can add, subtract, multiply, or divide raster maps
    # Raster$bio1 / 10
    # Divide stack by a stack or layers within a stack to get a ratio??
    # Raster$bio5 - Raster$bio6 (or sum(bio5, -bio6))
    # Use raster::calc(layer, fun = function(x){}) to use custom functions
    # Use raster::overlay(map1, map2, map3, fun = function(x){}) for functions on more than one layer
    
  # EXPORT RASTER MAP
    # raster::writeRaster(layer, filename = "____.tif" (or other raster file name), format = "GTiff")


# Spatial Analysis on Vectors ################################################################################

# Clean Geometries
  # library(cleangeo)
  # clgeo_Clean() # This works
  # spgrass6::execGRASS(cmd = v.clean) # This will clean anything that cleangeo doesn't do

# Distance
  # spDists()
  # distHaversine() <- used in PWS 305 Final Project

# Buffer
  # buffer()

# Voronoi Polygons / Delauney triangulation
  # voronoi()

# Random Sample
  # spsample()

# Vector Grids
  # Create raster of certain resolution
  # rasterToPolygons
  # Import an official grid (UTM, EEA, etc.)
  # Triangles, diamonds, and hexagons

# Points on a polygon
  # over() to combine points to spdf of grid

# Line Distance
  # spLines()
  # SpatialLinesLengths()

# Area used
  # adehabitatHR::mcp(track points, percent = 95)
  # kernelUD(track_points, h = "href")
  # getverticeshr(kern, percent = 95)


# Spatial Analysis with Raster Data ##########################################################################

# Rasterize
  # Turn vectors into rasters
  # raster::rasterize()

# Distance surface
  # raster::distance
  # Raster of a distance from a certain 

# Countour Lines
  # rasterToContour()

# Random Points
  # sampleRandom()

# Extract raster values to points, lines, and polygons
  # extract()
  # Use combination of extract() and sapply for lines
  # Can also do these actions on raster stacks and bricks (much faster on bricks)

# Interpolation
  # [gstat]
  # gstat::gstat(formula, locations)
  # Sometimes better to aggregate your results (make resolution less fine) to get a general idea instead


# Miscellaneous Matters / Other Resources ####################################################################

# Data sources (for species distributions and more)
  # gbif.org
  # inaturalist.org/observations
  # observation.org
  # vertnet.org
  # SEE POWERPOINT FOR MORE

# Multi-band rasters
  # Import normally, it'll only give first layer
  # Inspect object (e.g., # RasterLayer, band 1 of 24)

  # Import with stack()
  # Inspect object (e.g. # RasterStack with 24 variables)

# Library(mapmisc)
  # Gives scaleBar(), insetMap()< and others

# Packages with species occurence data
  # ICNredlist.org
  # rgbif
  # ecoengine
  # rvertnet
  # rbison
  # ridigbio
  # rebird
  # spocc (interface to different data sources found in most of these packages)

# Packages for cleaning species occurence data
  # biogeo
  # bdclean
  # CoordinateCleaner
  # scrubr

# Packages for obtaining environmental data
  # raster::getData
  # dismo::biovars
  # neonUtilities::loadByProduct
  # sdmpredictors (includes marine data)

# Interactive Maps
  # leaflet
  # tmap
  # Use Shiny
  # 3D Maps - rayshader
    # High resolution, small focus area

# Animated Maps
  # gganimate
  # tmap



  














