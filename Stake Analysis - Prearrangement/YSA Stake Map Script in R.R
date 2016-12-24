###########################################################################
############## D.C. Area Map by ward and gender in R ######################
###########################################################################

## Retrieve Data and Download Package

# Use import data set dropdown menu to import data correctly
# Stake Map.csv 

# install packages
library(dplyr)
library(ggmap)
library(leaflet)
library(viridis)
install.packages("RColorBrewer")
library(RColorBrewer)

# Define new data set
ysa <- Stake.Map

## Generate dataset with coordinate variables 

# Averages 10 minutes to render
# My dataset already has lat/long so no need to render new coordinates
# ysa %>% 
  # mutate(address=paste(gender, sep=", ", ward)) %>%
  # select(address) %>% 
  # lapply(function(x){geocode(x, output="latlon")})  %>% 
  # as.data.frame %>% 
  # cbind(ysa) -> ysa1

ysa %>%  
  mutate(popup_info=paste(sep = "<br/>", paste0("<b>","<i>", ward,"<i>", "</b>"), name)) %>% 
  mutate(lon=ifelse(is.na(longitude), address.lon, longitude),
         lat=ifelse(is.na(latitude),  address.lat, latitude)) %>%
  filter(!is.na(lon) & !grepl("CLOSED", ward)) -> ysa1


## Plot the Maps
# Ward Map
wardpal <- colorFactor(plasma(7), ysa1$ward) 
leaflet(ysa1) %>%
  addProviderTiles("CartoDB.Positron") %>%
  addCircleMarkers(lng = ~longitude, 
                   lat = ~latitude, 
                   radius = 2.5, 
                   fillColor = ~wardpal(ward),
                   stroke=FALSE,
                   fillOpacity = 1,
                   popup = ~popup_info) %>%
  addLegend("bottomright", pal = wardpal, values = ~ward, labels = "Ward", title = "YSA Bounderies by Ward")

# Gender Map
genpal <- colorFactor(viridis(2), ysa1$gender) 
leaflet(ysa1) %>%
  addProviderTiles("CartoDB.Positron") %>%
  addCircleMarkers(lng = ~longitude, 
                   lat = ~latitude, 
                   radius = 2.5, 
                   fillColor = ~genpal(gender),
                   stroke=FALSE,
                   fillOpacity = 0.8,
                   popup = ~popup_info) %>%
  addLegend("bottomright", pal = genpal, values = ~gender, labels = "Gender", title = "YSA Bounderies by Gender")
