
# SETUP -------------------------------------------------------------------

# Libraries
if (!("tidyverse" %in% installed.packages())) install.packages('tidyverse'); library(tidyverse)
if (!("sf" %in% installed.packages())) install.packages('sf'); library(sf)
if (!("riverdist" %in% installed.packages())) install.packages('riverdist'); library(riverdist)

# 'riverdist' online documentation
shell.exec('https://cran.r-project.org/web/packages/riverdist/vignettes/riverdist_vignette.html')
# Hyperlink: Basic distance calculation in a non-messy river network
# Hyperlink: Computing network distances between sequential observations of individuals


# FLINT RIVER REACHES -----------------------------------------------------

# May need to set your working directory to the folder this file is in
# setwd('computer/location')
load('lower_flint.RData')

# Remove 3D coordinates
flint_data <- st_zm(flint_data)

# Graph dat bitch
ggplot(flint_data) + geom_sf()

# Check CRS for the USGS data
st_crs(flint_data)  # NAD 83, need to change to WGS84, UTM Zone 16

# Transform the CRS
flint_projected <- flint_data %>% st_transform("+proj=utm +zone=16 +datum=WGS84")
st_crs(flint_projected)  # Just check the console to see if the DATUM and CONVERSION are right

# CREATE REACHES

# This is where you'll need to decide what reaches you want/remove the
# tributaries. You can look at the HUC-14 and decide which HUC-12 groupings work
# best/make the most sense. You can do this by changing the ReachCode column
# directly or by making a new ReachCode column (e.g. ReachCode2) so you can
# compare the reaches before and after combining them. This may end up requiring
# you to dissolve the reaches manually instead of in the riverdist::cleanup()
# function. This isn't too hard. Once you have the reaches as you want them in a
# column, you can use sf::st_union(by_feature = TRUE) to combine geometries.
# Lemme know if it's being dumb :)


# Export everything as a shapefile that 'riverdist' can use
st_write(flint_projected, dsn = 'lower_flint.gdb',
         layer = "flint", driver = 'ESRI Shapefile')


# PRE-ANALYSIS GEOPROCESSING ----------------------------------------------

# Run the Flint data through 'riverdist' stuff so that it's "clean" and usable
# by the algorithms in the library

# Import the shapefile that we just made
flint_network <- line2network(path = 'lower_flint.gdb',
                              layer = 'flint')

# Run the cleanup function to make the network easier to work with
flint_cleaned <- cleanup(flint_network)
# It's interactive, as of this run I said:
#       - Dissolve? Yes, if you've already made your reaches, then select NO
#       - Insert vertices? Yes (makes the fish locations more accurate along the river)
#       - Minimum distance (meters) to use: 200  # Change this to be 10 or 50 if you want more accurate snapping when adding fish location data
#       - River mouth segment: 3
#       - River mouth vertex: 19
#       - Remove additional segments? No
#       - Build segment routes? Yes

# Save the data so you don't have to keep running the cleanup for future analysis
save(flint_cleaned, file = 'flint_cleaned.RData')
# load('flint_cleaned.RData')  # After you've saved it, comment out all the above stuff in this section and uncomment this to import the data

# Check Connectedness
topologydots(rivers = flint_cleaned)  # All inner vertices are green, so distance calculations are good to go


# BRING IN THE FISH BBZ ---------------------------------------------------

# Import shoalies
# shoalies <- read_csv('filepath/data.csv')

# Columns you want:
#   - ID column/fish number: fish_ID
#   - Date
#   - Latitude (y)
#   - Longitude (x)
#   - Sampling Event column: number indicating which telemetry event it was (the first time, second time, third time, etc.)

# Snap the points onto the river network
# flint_shoalies <- xy2segvert(x = shoalies$x, y = shoalies$y, rivers = flint_cleaned)
# head(flint_shoalies)  # Should see a segment (seg) and vertex(vert) column now, these will be used to calculate distances, etc.


# DISTANCE CALCULATIONS ---------------------------------------------------

# For fish missing during individual sampling events: keep the same location data as its most recent appearance

# The distances in the output are in meters
# Rows: fish_ID
# Columns: Distance between event 1 and 2, 2 and 3, etc.

# riverdistanceseq(unique = flint_shoalies$fish_ID, survey = sampling_event, 
#                  seg = flint_shoalies$seg, vert = flint_shoalies$vert, 
#                  rivers = flint_cleaned)


