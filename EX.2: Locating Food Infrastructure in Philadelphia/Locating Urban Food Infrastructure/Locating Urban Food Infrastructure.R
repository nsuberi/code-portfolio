install.packages("sp")
install.packages("rgdal")
install.packages("TSP")
install.packages("dbscan")
install.packages("SpatialTools")

library(rgdal)
library(sp)
library(TSP)
library(dbscan)
library(SpatialTools)

pprAssets <- readOGR("PPR_Assets","PPR_Assets")
neighborhoodBounds <- readOGR("Neighborhoods", "Neighborhoods")

landLower = 1
landUpper = 1.5
buildCutoff = 1
clustMinPts = 1
clustEps = .04
selections = c("Land", "Building")

land <- subset(pprAssets, pprAssets@data$TYPE == selections[1])

bigLand <- subset(land, land@data$ACREAGE > landLower & land@data$ACREAGE < landUpper)

centroids <- data.frame(getSpPPolygonsLabptSlots(bigLand))
coordinates(centroids) <- c(1,2)

distMatrix <- dist1(as.matrix(centroids@coords))

res1 <- dbscan(as.matrix(centroids@coords), eps=clustEps, minPts = clustMinPts)
res1$cluster
# Assign non-grouped points to own group
count = max(res1$cluster) + 1
if(sum(res1$cluster==0)!=0){
  for(i in 1:sum(res1$cluster==0)){
    res1$cluster[[min(which(res1$cluster==0))]] = count
    count = count + 1
  }
}
bigLand@data$cluster <- res1$cluster

buildings <- subset(pprAssets, pprAssets@data$TYPE == selections[2])
bigBuild <- subset(buildings, buildings@data$ACREAGE > buildCutoff)

plot(neighborhoodBounds, border="Grey", lwd=1)
plot(bigBuild, add=TRUE)
plot(bigLand, add=TRUE)
plot(centroids, add=TRUE)


for(j in 1:length(unique(bigLand@data$cluster))){
  print(paste("Cluster",j))
  # create centroids for clusters
  cluster <- data.frame(getSpPPolygonsLabptSlots(bigLand[bigLand@data$cluster == j,]))
  
  clusterCentX <- mean(cluster$X1)
  clusterCentY <- mean(cluster$X2)
  clusterCoords <- c(clusterCentX,clusterCentY)
  clusterCoords
  # assign building that is closest to a cluster centroid
  # to be the servicing site
  
  buildCoords <- data.frame(getSpPPolygonsLabptSlots(bigBuild))
  distToClust <- dist2(as.matrix(buildCoords),as.matrix(t(clusterCoords)))
  distToClust
  
  clustSites <- bigLand[bigLand@data$cluster==j,]
  clustService <- bigBuild[which.min(distToClust),]
  clustService
  plotHelp <- data.frame(getSpPPolygonsLabptSlots(clustService))
  coordinates(plotHelp) <- c(1,2)
  plot(plotHelp, pch=19, add=TRUE,col='Red')
  #plot(clustSites)
  #plot(clustService, add=TRUE)
  
  # create a list including sites and service
  clustSitesServiceCoords <- rbind(as.matrix(getSpPPolygonsLabptSlots(clustSites)),as.matrix(getSpPPolygonsLabptSlots(clustService)))
  
  # create the TSP paths for each servicing site
  distMatrixCluster <- dist1(clustSitesServiceCoords)
  atsp <- ATSP(distMatrixCluster)
  tour <- solve_TSP(atsp, method="nn")
  
  # plot lines showing order of service
  # find index of site 
  start <- which.max(labels(tour))
  start
  labels(tour)[start+1]
  labels(tour)
  # create lines 
  res1$cluster
  loop <- length(labels(tour))
  loop
  for(i in 1:loop){
    if((start + i)%%loop == (loop-1)){
      lineStart <- labels(tour)[loop-1]
      lineStop <- labels(tour)[loop]
      lineSeg <- Line(rbind(
        t(clustSitesServiceCoords[as.integer(lineStart),]),
        t(clustSitesServiceCoords[as.integer(lineStop),])
      ))
      Line <- SpatialLines(list(Lines(lineSeg, ID=lineStart)))
      plot(Line, add=T)
      print("here")
    }else if((start + i)%%loop== 0){
      lineStart <- labels(tour)[loop]
      lineStop <- labels(tour)[1]
      lineSeg <- Line(rbind(
        t(clustSitesServiceCoords[as.integer(lineStart),]),
        t(clustSitesServiceCoords[as.integer(lineStop),])
      ))
      Line <- SpatialLines(list(Lines(lineSeg, ID=lineStart)))
      plot(Line, add=T)
      print("there")
    }else{
      lineStart <- labels(tour)[(start+i)%%loop]
      lineStop <- labels(tour)[(start+i+1)%%loop]
      lineSeg <- Line(rbind(
        t(clustSitesServiceCoords[as.integer(lineStart),]),
        t(clustSitesServiceCoords[as.integer(lineStop),])
      ))
      Line <- SpatialLines(list(Lines(lineSeg, ID=lineStart)))
      plot(Line, add=T)
      print("everywhere")
      print(i)
    }
  }
  labels(tour)
}

title(main = "Potential Gardens, Service Sites, and Service Routes", sub="Properties Drawn from PPR Assets in Philadelphia")
title(xlab="+ = Garden Site, o = Service Site")
