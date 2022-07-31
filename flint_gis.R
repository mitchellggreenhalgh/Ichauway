
# SETUP -------------------------------------------------------------------

# Libraries
library(tidyverse)
library(sf)

# Working Directory
setwd('C:\\Users\\mitch\\Documents\\GitHub\\Ichauway')


# Flint Data --------------------------------------------------------------

# Import
data <- st_read('data/hydrusm010g/hydrusm010g.gdb', layer = 'Stream') 

# Remove three dimensional data points (e.g. XYZ)
data2 <- st_zm(data)


# Finding the Flint River -------------------------------------------------

# Apalachicola-Chattahoochee-Flint River Basin's HUC-4 == 0313
acf_data <- data2 %>%
    filter(str_sub(ReachCode, 1, 4) == '0313')

# Graph dat bitch
ggplot(acf_data) + 
    geom_sf()


# Flichaway Data (and Kinchafoonee)
flicha_data <- acf_data %>%
    filter(as.numeric(str_sub(ReachCode, 5, 8)) %in% 5:9)

# Peep at the baby
ggplot(flicha_data) + 
    geom_sf()


# Flint River only
flint_data <- flicha_data %>%
    filter(as.numeric(str_sub(ReachCode, 5, 8)) %in% c(5, 6, 8))

ggplot(flint_data %>% filter(Feature == 'Artificial Path')) + 
    geom_sf(aes(color = From_node)) + 
    scale_color_viridis_c() + 
    theme_bw()

flint_data %>% count(GM_hyc)
flint_data %>% count(GM_nam)
flint_data %>% count(Feature)


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
