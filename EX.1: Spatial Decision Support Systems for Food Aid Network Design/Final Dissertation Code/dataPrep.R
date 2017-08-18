library(rgdal)
library(RColorBrewer)
library(rgeos)
library(igraph)
library(maptools)
library(classInt)

setwd(".")

#### Load places of worship that can also be considered as food bank sites

london_points <- readOGR("../greater-london-latest.shp", "points")
londonPlacesOfWorship <- london_points[london_points$type=="place_of_worship",]
londonPlacesOfWorship <- spTransform(londonPlacesOfWorship, CRS("+init=epsg:27700"))

# Load street network for London
london_roads <- readOGR("../greater-london-latest.shp", "roads")
#project it to planar coordinates (necessary if you want to measure distances in meters)
shapeFile.BNG <- spTransform(london_roads, CRS("+init=epsg:27700")) # converts to UK Grid system
#see http://spatialreference.org/ref/epsg/osgb-1936-british-national-grid/

#### Loading Borough and LSOA boundaries

bdyList <- c("Barking_and_Dagenham", "Barnet", "Bexley", "Brent", "Bromley", "Camden", "City_of_London",
             "Croydon", "Ealing", "Enfield", "Greenwich", "Hackney", "Hammersmith_and_Fulham", "Haringey",
             "Harrow", "Havering", "Hillingdon", "Hounslow", "Islington", "Kensington_and_Chelsea",
             "Kingston_upon_Thames", "Lambeth", "Lewisham", "Merton", "Newham", "Redbridge",
             "Richmond_upon_Thames", "Southwark", "Sutton", "Tower_Hamlets", "Waltham_Forest",
             "Wandsworth", "Westminster")

LondonLSOAs <- lapply(bdyList, function(name){
  readOGR("../2011_london_boundaries/LSOA_2011_BGC_London", paste("LSOA_2011_BGC_", name, sep=""))
})

LondonLSOAsProj <- lapply(LondonLSOAs, function(name){
  spTransform(name, CRS("+init=epsg:27700"))
})

uid <- 1
LondonMap <- LondonLSOAsProj[[1]]
n <- length(slot(LondonMap, "polygons"))
LondonMap <- spChFIDs(LondonMap, as.character(uid:(uid+n-1)))
uid <- uid + n

for(i in 2:length(LondonLSOAsProj)){
  n <- length(slot(LondonLSOAsProj[[i]], "polygons"))
  LondonLSOAsProj[[i]] <- spChFIDs( LondonLSOAsProj[[i]], as.character(uid:(uid+n-1)))
  uid <- uid + n
  LondonMap <- spRbind(LondonMap, LondonLSOAsProj[[i]])
}

LondonMap <- spTransform(LondonMap, CRS("+init=epsg:27700"))

# Keep as British Grid for mapping purposes
LondonMapBoroughs <- readOGR("../2011_london_boundaries", "London_Borough_Excluding_MHW")

#### Get indices of multiple deprivation for each LSOA.

deprivationData <- read.csv("../2015_Domains_of_deprivation.csv", header=TRUE,sep=",")
deprivationDataShort <- deprivationData[,c(1,2,5,6,7,8,9,10)]
colnames(deprivationDataShort) <- c("LSOA_Code","LSOA_Name","IMD_Rank",
                                    "IMD_Decile","Income_Rank","Income_Decile",
                                    "Employment_Rank","Employment_Decile")

LondonMap@data <- cbind(LondonMap@data, data.frame(deprivationDataShort[match(LondonMap@data[,"LSOA11CD"], deprivationDataShort[,"LSOA_Code"]),])  )


#### Great Britain Outline

gbBdy <- readOGR("./Mean High Water Springs Polygon", "high_water_polygon")
proj4string(gbBdy)
gbBdy <- spTransform(gbBdy, CRS("+init=epsg:27700"))

#### Select LSOAs that are in the bottom 3 deciles

LondonLSOACentroids <- data.frame(getSpPPolygonsLabptSlots(LondonMap))
coordinates(LondonLSOACentroids) <- c(1,2)
LondonLSOACentroids<- SpatialPointsDataFrame(LondonLSOACentroids,LondonMap@data)

#LondonLSOACentroids <- spTransform(LondonLSOACentroids, CRS("+init=epsg:27700"))
proj4string(LondonLSOACentroids) <- proj4string(LondonMap)

LondonHighNeedCentroids <- LondonLSOACentroids[LondonLSOACentroids@data$Income_Decile<=3,]

# Convert to BNG for distance calculations - requires planar projection
worship.BNG <- spTransform(londonPlacesOfWorship, CRS("+init=epsg:27700")) # converts to UK Grid system
lsoa.BNG <- spTransform(LondonHighNeedCentroids, CRS("+init=epsg:27700")) # converts to UK Grid system
london.BNG <- spTransform(LondonMap, CRS("+init=epsg:27700"))

#### Load existing Trussell Trust site

ttrustLocs <- read.csv('C:\\Users\\FreshConnects\\Downloads\\Trussell Trust Food Banks Geocoded.csv')
head(ttrustLocs)
coordinates(ttrustLocs) <- c(6,7)
proj4string(ttrustLocs)<- proj4string(london.BNG)

london.ttrustLocs <- ttrustLocs[london.BNG, ]
nrow(london.ttrustLocs) # 39

#### Load complete Trussel Trusts
ttComplete <- read.csv('ttComplete2.csv')
coordinates(ttComplete) <- c(1,2)
proj4string(ttComplete) <- CRS("+init=epsg:27700")




