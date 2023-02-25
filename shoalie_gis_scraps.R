
# SETUP -------------------------------------------------------------------

# Libraries
if (!("tidyverse" %in% installed.packages())) install.packages('tidyverse'); library(tidyverse)
if (!("sf" %in% installed.packages())) install.packages('sf'); library(sf)
if (!("riverdist" %in% installed.packages())) install.packages('riverdist'); library(riverdist)

# 'riverdist' online documentation
shell.exec('https://cran.r-project.org/web/packages/riverdist/vignettes/riverdist_vignette.html')
# Hyperlink: Basic distance calculation in a non-messy river network
# Hyperlink: Computing network distances between sequential observations of individuals

# Finding the Flint River -------------------------------------------------

# Import: Apalachicola-Chattahoochee-Flint River Basin's HUC-4 == 0313 (Lower flint == 03130008)
# data <- st_read('data/hydrusm010g/hydrusm010g.gdb', layer = 'Stream', 
#                 query = "SELECT * FROM Stream WHERE ReachCode LIKE '03130008%'") 
# save(data, file = "lower_flint.RData")

# # Check CRS for the USGS data
# st_crs(data)  # NAD 83, need to change to WGS84, UTM Zone 16
# 
# # Transform the CRS
# flint_projected <- data %>% st_transform("+proj=utm +zone=16 +datum=WGS84")
# st_crs(flint_projected)
# 
# st_write(flint_projected, dsn = 'lower_flint.gdb',
#          layer = "flint", driver = 'ESRI Shapefile',
#          delete_dsn = TRUE)

# Remove 3D coordinates
# flint_data <- st_zm(data)

# Load Lower Flint RData (you may have to set a working directory)
load('lower_flint.RData')

# Graph dat bitch
ggplot(data) + 
    geom_sf(aes(color = ReachCode),
            size = 2)

# Remove Big Slough?
# flint_data2 <- flint_data %>% filter(Name != 'Big Slough')

# Group by HUC-16 Codes? 



# PRE-ANALYSIS GEOPROCESSING ----------------------------------------------

# Run the Flint data through riverdist stuff so that it's 'clean' and usable by
# the algorithms in the library

# Import the shapefile that we just made
flint_network <- line2network(path = 'lower_flint.gdb',
                              layer = 'flint')

# Run the cleanup function to make the network easier to work with
# It's interactive, as of this run I said:
#       - Dissolve? Yes
#       - Insert vertices? Yes
#       - Minimum distance to use: 200  # Change this to be 10 or 50 if you want more accurate snapping when adding fish location data
#       - River mouth segment: 3
#       - River mouth vertex: 337
#       - Remove additional segments? No
#       - Build segment routes? Yes

flint_cleaned <- cleanup(flint_network)
# save(flint_cleaned, file = 'flint_cleaned.RData')
# load('flint_cleaned.RData')

# Check Connetedness
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




# # NHD HUC4 Data (Higher Resolution Data) --------------------------------
# 
# # Import Data
# nhd_data <- st_read('data/NHD_Shape/Shape/NHDFlowline.shp')
# 
# # Get rid of 3 dimensional data
# nhd_data <- st_zm(nhd_data)
# 
# # Look at structure
# glimpse(nhd_data)
# # IT HAS BUILT IN REACHES??
# 
# # Isolate the Flint + Ichawaynochaway
# nhd_flichaway <- nhd_data %>%
#     filter(as.numeric(str_sub(reachcode, 8, 8)) %in% c(5, 6, 8, 9))
# 
# # Look at the data
# ggplot(nhd_flichaway %>%
#            filter(lengthkm > 1.5)) + 
#     geom_sf() + 
#     theme(aspect.ratio = 1)
# 
# 
