library(dplyr)
library(tmaptools)
library(maptools)
library(RColorBrewer)
library(classInt)
library(sp)
library(rgeos)
library(tmap)
library(sf)
library(rgdal)
library(geojsonio)
library(janitor)
library(plotly)
library(here)
library(tidyverse)
library(rJava)
library(OpenStreetMap)
EW <- st_read(here::here("Local_Authority_Districts_(December_2015)_Boundaries", "Local_Authority_Districts_(December_2015)_Boundaries.shp"))
LondonData <- read_csv("https://data.london.gov.uk/download/ward-profiles-and-atlas/772d2d64-e8c6-46cb-86f9-e52b4c7851bc/ward-profiles-excel-version.csv", locale = locale(encoding = "latin1"))
LondonData<-clean_names(LondonData)
BoroughDataMap <- EW %>%
  clean_names()%>%
  filter(str_detect(lad15cd, "^E09"))%>%
  merge(.,
        LondonData, 
        by.x="lad15cd", 
        by.y="new_code",
        no.dups = TRUE)%>%
  distinct(.,lad15cd,
           .keep_all = TRUE)
tmaplondon<-BoroughDataMap%>%
  st_bbox(.)%>%
  tmaptools::read_osm(.,type = "osm",zoom = NULL)
tmap_mode("plot")

tm_shape(tmaplondon)+
  tm_rgb()+
  tm_shape(BoroughDataMap) + 
  tm_polygons("rate_of_job_seekers_allowance_jsa_claimants_2015", 
              style="jenks",
              palette="YlOrBr",
              midpoint=NA,
              title="Rate per 1,000 people",
              alpha = 0.5) + 
  tm_compass(position = c("left", "bottom"),type = "arrow") + 
  tm_scale_bar(position = c("left", "bottom")) +
  tm_layout(title = "Job seekers' Allowance Claimants", legend.position = c("right", "bottom"))


