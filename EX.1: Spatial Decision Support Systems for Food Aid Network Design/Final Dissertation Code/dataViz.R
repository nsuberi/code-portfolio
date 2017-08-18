
colours <- brewer.pal(9,"Greens")

#### Show study area

plot(LondonMapBoroughs)
labPts <- data.frame(getSpPPolygonsLabptSlots(LondonMapBoroughs))
coordinates(labPts) <- c(1,2)
proj4string(labPts) <- proj4string(LondonMapBoroughs)
labPts$X1

text(labPts$X1, labPts$X2, LondonMapBoroughs@data$NAME, col="Black", cex=.6)
title(main="London Boroughs")

LondonMap <- spTransform(LondonMap, CRS("+init=epsg:27700"))

plot(LondonMapBoroughs)
plotColors <- sapply(LondonMap@data$Income_Decile, function(dec){
  dec <- as.numeric(as.character(dec))
  if(dec<10){
    colours[10-dec]
  } else {
    colours[1] 
  }
})

plot(LondonMap, add=T, col=plotColors)
title(main="London Least Super Output Areas (LSOAs), Colored by Income Deprivation", xlab="Income Deciles 1, 2, and 3 only")

legendNums <- seq(10,1,-1)

legendText <<- c()
for(i in 1:length(legendNums)) {
  legendText <<- c(legendText, paste("Income Decile: ",legendNums[i]))
}

legend("bottomleft", # position
       legend = legendText,
       title = "Income Deprivation by Indices of Multiple Deprivation",
       fill = c("#FFFFFF",colours),
       cex = 0.56,
       bty = "o",
       bg = "white")



plot(LondonMapBoroughs)
LondonMapBottom3 <- LondonMap[as.numeric(as.character(LondonMap@data$Income_Decile)) <= 3,]
plotColors <- sapply(LondonMapBottom3@data$Income_Decile, function(dec){
  dec <- as.numeric(as.character(dec))
  if(dec<10){
    colours[10-dec]
  } else {
    colours[1] 
  }
})

plot(LondonMapBottom3, add=T, col=plotColors)
title(main="London Least Super Output Areas (LSOAs), Colored by Income Deprivation", xlab="Income Deciles 1, 2, and 3 only")

legendNums <- seq(3,1,-1)

legendText <<- c()
for(i in 1:length(legendNums)) {
  legendText <<- c(legendText, paste("Income Decile: ",legendNums[i]))
}

legend("bottomleft", # position
       legend = legendText,
       title = "Income Deprivation by Indices of Multiple Deprivation",
       fill = c(colours[7:9]),
       cex = 0.56,
       bty = "o",
       bg = "white")

plot(LondonMapBoroughs)
plot(LondonMap[LondonMap@data$Income_Decile==1,], col=colours[19], add=T)
title(main="London Least Super Output Areas (LSOAs) in Income Decile 1")

plot(LondonMapBoroughs)
plot(LondonMap[LondonMap@data$Income_Decile==2,], col=colours[8], add=T)
title(main="London Least Super Output Areas (LSOAs) in Income Decile 2")

plot(LondonMapBoroughs)
plot(LondonMap[LondonMap@data$Income_Decile==3,], col=colours[7], add=T)
title(main="London Least Super Output Areas (LSOAs) in Income Decile 3")

# With complete TT data

plot(LondonMapBoroughs)
plot(ttComplete, add=T, col="Blue")


#### Visualize all LSOAs, and those just below a certain level of income

plot(LondonLSOACentroids, add=TRUE, col=colours[10-LondonLSOACentroids@data$Income_Decile])
plot(LondonHighNeedCentroids, add=TRUE, col=colours[10-LondonHighNeedCentroids@data$Income_Decile])

#### Show all trussell trust sites, and those in London
plot(gbBdy)
plot(ttrustLocs, add=T, col="Blue")
title(main="Trussell Trust Locations throughout Great Britain", xlab="Food Bank sites in Blue")

plot(LondonMapBoroughs, add=T, col="Blue")

plot(LondonMapBoroughs)
plot(london.ttrustLocs, add=T, col="Blue")
title(main="Trussell Trust Locations in Greater London",xlab="Food Bank sites in Blue")


#### Plot point sets
plot(LondonMapBoroughs)
plot(london.ttrustLocs, add=T, col="Blue")
plot(worship.BNG, add=T, col="Green")
title(main="Possible Food Bank Locations in Greater London",xlab="TT in Blue, POW in Green")


#### Plot the graph

plot(G,vertex.size=.001,vertex.label=NA)
title(main="Graph of the Road Network of Greater London")

plot(plotG,vertex.size=ifelse(as.numeric(as.character(V(G)$name)) %in% fromList2$name,3,.001),vertex.label=ifelse(as.numeric(as.character(V(G)$name)) %in% fromList2$name,V(G)$name, NA))



#### Calculate visual display and statistics of the optimization results


mult <- c(0, 0, 0, 0, 0, 0, 10, 10, 10, 10, 10, 10, 20, 20, 20, 20, 20, 20, 30, 30, 30, 30, 30, 30, 40, 40, 40, 40, 40, 40, 50, 50, 50, 50, 50, 50, 60, 60, 60, 60, 60, 60, 70, 70, 70, 70, 70, 70)
add <- c(0, 10000, 20000, 30000, 40000, 50000,
         0, 10000, 20000, 30000, 40000, 50000,
         0, 10000, 20000, 30000, 40000, 50000,
         0, 10000, 20000, 30000, 40000, 50000,
         0, 10000, 20000, 30000, 40000, 50000,
         0, 10000, 20000, 30000, 40000, 50000,
         0, 10000, 20000, 30000, 40000, 50000,
         0, 10000, 20000, 30000, 40000, 50000)


## Mapping Inputs

plot_indices_orig <- vector("list", length(mult))

for(index in c(1,6,16,43,48)){
  
  current_list_orig <- read.csv(paste("../Final/expandSitesScaleBy",mult[index],"Add",add[index],".csv",sep=""), header=F)[[1]]
  current_mat_orig <- read.csv(paste("../Final/expandAssignmentsScaleBy",mult[index],"Add",add[index],".csv",sep=""))
  
  distance_store_orig <- vector("list", length(current_list_orig))
  indiv_distance_orig <- vector("numeric", ncol(current_mat_orig))
  
  for(i in 1:length(current_list_orig)){
    for(j in 1:ncol(current_mat_orig)){
      if(current_mat_orig[current_list_orig[i],j]==1){
        
        this_dist_orig <- ttrust.worship.dist.to.LSOAs[current_list_orig[i], j]
        
        distance_store_orig[[i]] <- c(distance_store_orig[[i]], this_dist_orig)
        indiv_distance_orig[[j]] <- this_dist_orig
        
      } # end if
    } # end for j
  } # end for i
  
  brks_orig <- classIntervals(unlist(distance_store_orig), n=10, style="quantile")
  brks_orig <- brks_orig$brks
  
  plot_colours_orig <- colours2[findInterval(indiv_distance_orig, brks_orig, all.inside=TRUE)]
  plot_colours_orig <- sapply(plot_colours_orig, function(item){
    if(is.na(item)){
      "#000000"
    } else {
      item
    }
  })
  
  plot_order_orig <- sapply(1:ncol(current_mat_orig), mapLSOA3)
  
  selections <- mapTtrustWorship(current_list_orig)
  
  plot_indices_orig[[index]] <- vector("list", 4)
  
  plot_indices_orig[[index]][[1]] <- sapply(plot_order_orig, function(i) which(LondonMap@data$LSOA11CD %in% LondonHighNeedCentroids[as.numeric(i),]$LSOA11CD))
  plot_indices_orig[[index]][[2]] <- plot_colours_orig
  plot_indices_orig[[index]][[3]] <- selections
  plot_indices_orig[[index]][[4]] <- brks_orig
  
  print(index)
} # end for num

save(plot_indices_orig,file='plot_indices_orig.Rdata')



plot_indices_2k <- vector("list", length(mult))

for(index in c(1,6,16,43,48)){
  
  current_list_2k <- read.csv(paste("../Final/2kexpandSitesScaleBy",mult[index],"Add",add[index],".csv",sep=""), header=F)[[1]]
  current_mat_2k <- read.csv(paste("../Final/2kexpandAssignmentsScaleBy",mult[index],"Add",add[index],".csv",sep=""))
  
  distance_store_2k <- vector("list", length(current_list_2k))
  indiv_distance_2k <- vector("numeric", ncol(current_mat_2k))
  
  for(i in 1:length(current_list_2k)){
    for(j in 1:ncol(current_mat_2k)){
      if(current_mat_2k[current_list_2k[i],j]==1){
        
        this_dist_2k <- ttrust.worship.dist.to.LSOAs[current_list_2k[i], j]
        
        distance_store_2k[[i]] <- c(distance_store_2k[[i]], this_dist_2k)
        indiv_distance_2k[[j]] <- this_dist_2k
        
      } # end if
    } # end for j
  } # end for i
  
  brks_2k <- classIntervals(unlist(distance_store_2k), n=10, style="quantile")
  brks_2k <- brks_2k$brks
  
  plot_colours_2k <- colours2[findInterval(indiv_distance_2k, brks_2k, all.inside=TRUE)]
  plot_colours_2k <- sapply(plot_colours_2k, function(item){
    if(is.na(item)){
      "#000000"
    } else {
      item
    }
  })
  
  plot_order_2k <- sapply(1:ncol(current_mat_2k), mapLSOA3)
  
  selections <- mapTtrustWorship(current_list_2k)
  
  plot_indices_2k[[index]] <- vector("list", 4)
  
  plot_indices_2k[[index]][[1]] <- sapply(plot_order_2k, function(i) which(LondonMap@data$LSOA11CD %in% LondonHighNeedCentroids[as.numeric(i),]$LSOA11CD))
  plot_indices_2k[[index]][[2]] <- plot_colours_2k
  plot_indices_2k[[index]][[3]] <- selections
  plot_indices_2k[[index]][[4]] <- brks_2k
  
  print(index)
} # end for num

save(plot_indices_2k,file='plot_indices_2k.Rdata')




plot_indices_scens <- vector("list", 4)
obj_mat_scens <- vector("list", 4)

# To accomodate complete TT
plot_indices_scens2 <- vector("list", 5)
obj_mat_scens2 <- vector("list", 5)

checkPerformance <- function(stats, scenNum){
  
  if(scenNum < 5){
    # Get obj_list from stats
    obj_list <<- sapply(as.numeric(as.character(stats[[1]]$SiteNum)), function(item){
      which(dictionary==item)
    })
  } else{
    
    # Here, pass orig sites in as the list 1:105
    obj_list <<- sapply(stats, function(item){
      which(dictionaryComp==item)
    })
  }
  
  
  
  # Check which scenario you are checking
  if(scenNum==1){
    # Make new obj_mat
    obj_mat <- matrix(0, length(ttrust.plus.worship), length(LSOA.graph.nodes1))
    
    # Assign LSOAs to their closest available site
    assignments <- sapply(1:length(LSOA.graph.nodes1), function(j){
      obj_list[which.min(ttrust.worship.dist.to.LSOAs.Scen1[obj_list,j])]
    })
    
    # Update obj_mat with assignments
    for(j in 1:length(assignments)){
      obj_mat[assignments[j], j] <- 1
    }
    
    obj_mat_scens[[1]] <<- obj_mat
    
    # Loop over new obj_mat and create site and lsoa stats
    
    distance_store_scen <- vector("list", length(obj_list))
    indiv_distance_scen <- vector("numeric", ncol(obj_mat))
    
    for(i in 1:length(obj_list)){
      for(j in 1:ncol(obj_mat)){
        if(obj_mat[obj_list[i],j]==1){
          
          this_dist_scen <- ttrust.worship.dist.to.LSOAs.Scen1[obj_list[i], j]
          
          distance_store_scen[[i]] <- c(distance_store_scen[[i]], this_dist_scen)
          indiv_distance_scen[[j]] <- this_dist_scen
          
        } # end if
      } # end for j
    } # end for i
    
    plot_indices_scens[[scenNum]] <<- vector("list", 5)
    plot_order_scen <- sapply(1:ncol(obj_mat), mapLSOA.Scen1)
    plot_indices_scens[[scenNum]][[1]] <<- sapply(plot_order_scen, function(i) which(LondonMap@data$LSOA11CD %in% LondonHighNeedCentroids1[as.numeric(i),]$LSOA11CD))
    
    
  }else if(scenNum==2){
    # Make new obj_mat
    obj_mat <- matrix(0, length(ttrust.plus.worship), length(LSOA.graph.nodes2))
    
    # Assign LSOAs to their closest available site
    assignments <- sapply(1:length(LSOA.graph.nodes2), function(j){
      obj_list[which.min(ttrust.worship.dist.to.LSOAs.Scen2[obj_list,j])]
    })
    
    # Update obj_mat with assignments
    for(j in 1:length(assignments)){
      obj_mat[assignments[j], j] <- 1
    }
    
    obj_mat_scens[[2]] <<- obj_mat
    
    # Loop over new obj_mat and create site and lsoa stats
    
    distance_store_scen <- vector("list", length(obj_list))
    indiv_distance_scen <- vector("numeric", ncol(obj_mat))
    
    for(i in 1:length(obj_list)){
      for(j in 1:ncol(obj_mat)){
        if(obj_mat[obj_list[i],j]==1){
          
          this_dist_scen <- ttrust.worship.dist.to.LSOAs.Scen2[obj_list[i], j]
          
          distance_store_scen[[i]] <- c(distance_store_scen[[i]], this_dist_scen)
          indiv_distance_scen[[j]] <- this_dist_scen
          
        } # end if
      } # end for j
    } # end for i
    
    plot_indices_scens[[scenNum]] <<- vector("list", 5)
    plot_order_scen <- sapply(1:ncol(obj_mat), mapLSOA.Scen2)
    plot_indices_scens[[scenNum]][[1]] <<- sapply(plot_order_scen, function(i) which(LondonMap@data$LSOA11CD %in% LondonHighNeedCentroids2[as.numeric(i),]$LSOA11CD))
    
  } else if(scenNum==3){
    # Make new obj_mat
    obj_mat <- matrix(0, length(ttrust.plus.worship), length(LSOA.graph.nodes3))
    
    # Assign LSOAs to their closest available site
    assignments <- sapply(1:length(LSOA.graph.nodes3), function(j){
      obj_list[which.min(ttrust.worship.dist.to.LSOAs.Scen3[obj_list,j])]
    })
    
    # Update obj_mat with assignments
    for(j in 1:length(assignments)){
      obj_mat[assignments[j], j] <- 1
    }
    
    obj_mat_scens[[3]] <<- obj_mat
    
    # Loop over new obj_mat and create site and lsoa stats
    
    distance_store_scen <- vector("list", length(obj_list))
    indiv_distance_scen <- vector("numeric", ncol(obj_mat))
    
    for(i in 1:length(obj_list)){
      for(j in 1:ncol(obj_mat)){
        if(obj_mat[obj_list[i],j]==1){
          
          this_dist_scen <- ttrust.worship.dist.to.LSOAs.Scen3[obj_list[i], j]
          
          distance_store_scen[[i]] <- c(distance_store_scen[[i]], this_dist_scen)
          indiv_distance_scen[[j]] <- this_dist_scen
          
        } # end if
      } # end for j
    } # end for i
    
    plot_indices_scens[[scenNum]] <<- vector("list", 5)
    plot_order_scen <- sapply(1:ncol(obj_mat), mapLSOA.Scen3)
    plot_indices_scens[[scenNum]][[1]] <<- sapply(plot_order_scen, function(i) which(LondonMap@data$LSOA11CD %in% LondonHighNeedCentroids3[as.numeric(i),]$LSOA11CD))
    
    
  } else if(scenNum==4){
    # Make new obj_mat
    obj_mat <- matrix(0, length(ttrust.plus.worship), length(LSOA.graph.nodes4))
    
    # Assign LSOAs to their closest available site
    assignments <- sapply(1:length(LSOA.graph.nodes4), function(j){
      obj_list[which.min(ttrust.worship.dist.to.LSOAs.Scen4[obj_list,j])]
    })
    
    # Update obj_mat with assignments
    for(j in 1:length(assignments)){
      obj_mat[assignments[j], j] <- 1
    }
    
    obj_mat_scens[[4]] <<- obj_mat
    
    # Loop over new obj_mat and create site and lsoa stats
    
    distance_store_scen <- vector("list", length(obj_list))
    indiv_distance_scen <- vector("numeric", ncol(obj_mat))
    
    for(i in 1:length(obj_list)){
      for(j in 1:ncol(obj_mat)){
        if(obj_mat[obj_list[i],j]==1){
          
          this_dist_scen <- ttrust.worship.dist.to.LSOAs.Scen4[obj_list[i], j]
          
          distance_store_scen[[i]] <- c(distance_store_scen[[i]], this_dist_scen)
          indiv_distance_scen[[j]] <- this_dist_scen
          
        } # end if
      } # end for j
    } # end for i
    
    plot_indices_scens[[scenNum]] <<- vector("list", 4)
    plot_order_scen <- sapply(1:ncol(obj_mat), mapLSOA.Scen4)
    plot_indices_scens[[scenNum]][[1]] <<- sapply(plot_order_scen, function(i) which(LondonMap@data$LSOA11CD %in% LondonHighNeedCentroids4[as.numeric(i),]$LSOA11CD))
    
    
  } else if(scenNum==5){
    
    ## For Complete TT
    
    # Make new obj_mat
    obj_mat <- matrix(0, length(ttComp.plus.worship), length(LSOA.graph.nodes))
    
    # Assign LSOAs to their closest available site
    assignments <- sapply(1:length(LSOA.graph.nodes), function(j){
      obj_list[which.min(ttComp.worship.dist.to.LSOAs[obj_list,j])]
    })
    
    # Update obj_mat with assignments
    for(j in 1:length(assignments)){
      obj_mat[assignments[j], j] <- 1
    }
    
    obj_mat_scens2[[5]] <<- obj_mat
    
    # Loop over new obj_mat and create site and lsoa stats
    
    distance_store_scen <- vector("list", length(obj_list))
    indiv_distance_scen <- vector("numeric", ncol(obj_mat))
    
    for(i in 1:length(obj_list)){
      for(j in 1:ncol(obj_mat)){
        if(obj_mat[obj_list[i],j]==1){
          
          this_dist_scen <- ttComp.worship.dist.to.LSOAs[obj_list[i], j]
          
          distance_store_scen[[i]] <- c(distance_store_scen[[i]], this_dist_scen)
          indiv_distance_scen[[j]] <- this_dist_scen
          
        } # end if
      } # end for j
    } # end for i
    
    plot_indices_scens2[[scenNum]] <<- vector("list", 4)
    plot_order_scen2 <- sapply(1:ncol(obj_mat), mapLSOA3)
    plot_indices_scens2[[scenNum]][[1]] <<- sapply(plot_order_scen2, function(i) which(LondonMap@data$LSOA11CD %in% LondonHighNeedCentroids[as.numeric(i),]$LSOA11CD))
    
    
  } else {
    print("Scenario not valid")
    return()
  }
  
  
  brks_scen <- classIntervals(unlist(distance_store_scen), n=10, style="quantile")
  brks_scen <- brks_scen$brks
  
  plot_colours_scen <- colours2[findInterval(indiv_distance_scen, brks_scen, all.inside=TRUE)]
  plot_colours_scen <- sapply(plot_colours_scen, function(item){
    if(is.na(item)){
      "#000000"
    } else {
      item
    }
  })
  
  if(scenNum < 5){
    selections <- mapTtrustWorship(obj_list)
    
    plot_indices_scens[[scenNum]][[2]] <<- plot_colours_scen
    plot_indices_scens[[scenNum]][[3]] <<- selections
    plot_indices_scens[[scenNum]][[4]] <<- brks_scen
    
  } else {
    selections <- mapTtCompWorship(obj_list)
    
    plot_indices_scens2[[scenNum]][[2]] <<- plot_colours_scen
    plot_indices_scens2[[scenNum]][[3]] <<- selections
    plot_indices_scens2[[scenNum]][[4]] <<- brks_scen
  }
  
  
  
  
}

save(plot_indices_scens,file='plot_indices_scens.Rdata')
save(obj_mat_scens,file='obj_mat_scens.Rdata')






#### Display maps

plotMap <- function(index, currentMapType, boroughOrAll = "London"){
  
  index <<- index
  currentMapType <<- currentMapType
  boroughOrAll <<- boroughOrAll
  
  nodes_added <<- vector("integer", 0)
  nodes_removed <<- vector("integer", 0)
  nodes_added_and_removed <<- vector("integer", 0)
  
  # Set plot color for changed LSOAs
  colours2 <- brewer.pal(9,"Greens")
  colours_change_add <- brewer.pal(9, "Blues")
  colours_change <- brewer.pal(9, "YlOrRd")
  
  
  if(currentMapType == "orig"){
    obj_list <<- read.csv(paste("../Final/expandSitesScaleBy",mult[index],"Add",add[index],".csv",sep=""), header=F)[[1]]
    obj_mat <<- read.csv(paste("../Final/expandAssignmentsScaleBy",mult[index],"Add",add[index],".csv",sep=""))
    plot_indices <<- plot_indices_orig[[index]]
    
    orig_obj_mat <<- obj_mat
    orig_obj_list <<- obj_list
    
  } else if(currentMapType == "2k"){
    obj_list <<- read.csv(paste("../Final/2kexpandSitesScaleBy",mult[index],"Add",add[index],".csv",sep=""), header=F)[[1]]
    obj_mat <<- read.csv(paste("../Final/2kexpandAssignmentsScaleBy",mult[index],"Add",add[index],".csv",sep=""))
    plot_indices <<- plot_indices_2k[[index]]
    
    orig_obj_mat <<- obj_mat
    orig_obj_list <<- obj_list
    
  } else if(currentMapType == "Scen1") {
    obj_list <<- read.csv(paste("../Final/expandSitesScaleBy",mult[index],"Add",add[index],".csv",sep=""), header=F)[[1]]
    obj_mat <<- obj_mat_scens[[1]]
    plot_indices <<- plot_indices_scens[[1]]
    
    orig_obj_mat <<- obj_mat
    orig_obj_list <<- obj_list
    
  } else if(currentMapType == "Scen2") {
    obj_list <<- read.csv(paste("../Final/expandSitesScaleBy",mult[index],"Add",add[index],".csv",sep=""), header=F)[[1]]
    obj_mat <<- obj_mat_scens[[2]]
    plot_indices <<- plot_indices_scens[[2]]
    
    orig_obj_mat <<- obj_mat
    orig_obj_list <<- obj_list
    
  } else if(currentMapType == "Scen3") {
    obj_list <<- read.csv(paste("../Final/expandSitesScaleBy",mult[index],"Add",add[index],".csv",sep=""), header=F)[[1]]
    obj_mat <<- obj_mat_scens[[3]]
    plot_indices <<- plot_indices_scens[[3]]
    
    orig_obj_mat <<- obj_mat
    orig_obj_list <<- obj_list
    
  } else if(currentMapType == "Scen4") {
    obj_list <<- read.csv(paste("../Final/expandSitesScaleBy",mult[index],"Add",add[index],".csv",sep=""), header=F)[[1]]
    obj_mat <<- obj_mat_scens[[4]]
    plot_indices <<- plot_indices_scens[[4]]
    
    orig_obj_mat <<- obj_mat
    orig_obj_list <<- obj_list
    
  } else if(currentMapType == "Comp") {
    obj_list <<- sapply(1:105, function(item){
      which(dictionaryComp==item)
    })
    obj_mat <<- obj_mat_scens2[[5]]
    plot_indices <<- plot_indices_scens2[[5]]
    
    orig_obj_mat <<- obj_mat
    orig_obj_list <<- obj_list
    
  }else{
    
    
    print("Incorrect Map Type")
    print("Options are: orig, 2k, Scen1, Scen2, Scen3, Scen4")
    return()
  }
  
  if(currentMapType == "Comp"){
    plotMapHelp(plot_indices, boroughOrAll, "Yellow", "Black", T)
  } else {
    plotMapHelp(plot_indices, boroughOrAll, "Yellow", "Black", F)
  }
  
  brks <<- plot_indices[[4]]
  
}

plotMapHelp <- function(plot_indices, boroughOrAll, siteColor, textColor, isComp){
  
  if(boroughOrAll == "London"){
    plot(LondonMapBoroughs)
  } else if(boroughOrAll %in% LondonMapBoroughs@data$NAME){
    plot(LondonMapBoroughs[LondonMapBoroughs@data$NAME == boroughOrAll,])
  } else {
    print("Incorrect Borough selection. Options are 'London' for all of London or one of the following:")
    print(LondonMapBoroughs@data$NAME)
    return()
  }
  
  plot(london.BNG[plot_indices[[1]],], col=plot_indices[[2]], add=T)
  
  if(boroughOrAll != "London"){
    plot(LondonMapBoroughs[LondonMapBoroughs@data$NAME == boroughOrAll,], add = T, lwd=2, border="blue")
  }
  
  if(isComp){
    
    plot(ttComp.plus.worship[plot_indices[[3]],], col=siteColor, pch=16, add = T, cex=3)
    
    text(ttComp.plus.worship[plot_indices[[3]],]$easting, ttComp.plus.worship[plot_indices[[3]],]$northing, plot_indices[[3]], col=textColor, cex=.6)
    
    title(main=paste("Food Banks in ", boroughOrAll),xlab="Actual Trussell Trust sites")
    
    
  }else{
    plot(ttrust.plus.worship[plot_indices[[3]],], col=siteColor, pch=16, add = T, cex=3)
    
    text(ttrust.plus.worship[plot_indices[[3]],]$oseast1m, ttrust.plus.worship[plot_indices[[3]],]$osnrth1m, plot_indices[[3]], col=textColor, cex=.6)
    
    title(main=paste("Food Banks in ", boroughOrAll),xlab=paste("Optimization parameters: Penalty multiplier for moving a site =", mult[index], ", Fixed cost for operating a site =", add[index]))
  }
  

  legendNums <- plot_indices[[4]][order(-plot_indices[[4]])]
  
  legendText <<- c()
  for(i in 1:(length(legendNums)-1)) {
    legendText <<- c(legendText, paste(round(legendNums[i+1],2), "\u2264 d \u2264", round(legendNums[i],2)))
  }
  
  legend("bottomleft", # position
         legend = legendText,
         title = "Walking Distance (d) to Nearest Food Bank in Meters",
         fill = palette( c( "#000000", names( table(plot_indices[[2]]) )) ),
         cex = 0.56,
         bty = "o",
         bg = "white")
  
}
# Haringey, Hackney, Islington, Camden, Enfield and Barnet


updateMap <- function(){
  
  # Only plot changes if changes actually occured... i.e. at least one node was actually added
  if(length(changed_col_better) > 0){
    colors_chosen_better <- sapply(changed_col_better , function(i) {
      colours_change_add[findInterval(-diff_vals_col[i], brks, all.inside=TRUE)]
    })
    colors_chosen_better <- sapply(colors_chosen_better, function(item){
      if(is.na(item)){
        "#FFFFFF"
      } else {
        item
      }
    })
    plot(london.BNG[plot_indices_change_better,], col=colors_chosen_better, add=T)
  }
  
  if(length(changed_col_worse) > 0){
    colors_chosen_worse <- sapply(changed_col_worse , function(i){
      colours_change[findInterval(diff_vals_col[i], brks, all.inside=TRUE)]
    })
    colors_chosen_worse <- sapply(colors_chosen_worse, function(item){
      if(is.na(item)){
        "#000000"
      } else {
        item
      }
    })
    plot(london.BNG[plot_indices_change_worse,], col=colors_chosen_worse, add=T)
  }
  
  if(length(changed_col_back) > 0){
    plot(london.BNG[plot_indices_change_back,], col=plot_indices[[2]][changed_col_back], add=T)
  }
  
  # Plot Borough boundaries again
  
  if(boroughOrAll != "London"){
    plot(LondonMapBoroughs[LondonMapBoroughs@data$NAME == boroughOrAll,], add = T, lwd=2, border="blue")
  } else {
    plot(LondonMapBoroughs, add = T)
  }
  
  # Plot all nodes
  
  plot(ttrust.plus.worship[plot_indices[[3]],], col="Yellow", pch=16, add = T, cex=3)
  text(ttrust.plus.worship[plot_indices[[3]],]$oseast1m, ttrust.plus.worship[plot_indices[[3]],]$osnrth1m, plot_indices[[3]], col="Black", cex=.6)
  
  if(length(nodes_added)>0){
    # Plot added nodes
    plot(ttrust.plus.worship[nodes_added,], col="Blue", pch=16, add = T, cex=3)
    text(ttrust.plus.worship[nodes_added,]$oseast1m, ttrust.plus.worship[nodes_added,]$osnrth1m, nodes_added, col="Light Blue", cex=.6)
  }
  
  if(length(nodes_removed)>0){
    # Plot removed nodes
    plot(ttrust.plus.worship[nodes_removed,], col="Black", pch=16, add = T, cex=3)
    text(ttrust.plus.worship[nodes_removed,]$oseast1m, ttrust.plus.worship[nodes_removed,]$osnrth1m, nodes_removed, col="Yellow", cex=.6)
  }
  
  
}




plotFinalMap <- function(){
  
  print(paste("Final map printing started at ", Sys.time()))
  
  plot_indices_final <- vector("list", 4)
  
  # Which LSOAs to plot
  plot_indices_final[[1]] <- plot_indices[[1]]
  
  # Colors for these LSOAs
  
  indiv_distance_orig <- vector("numeric", ncol(obj_mat))
  
  for(i in 1:length(obj_list)){
    for(j in 1:ncol(obj_mat)){
      if(obj_mat[obj_list[i],j]==1){
        
        indiv_distance_orig[[j]] <- ttrust.worship.dist.to.LSOAs[obj_list[i], j]
        
      } # end if
    } # end for j
  } # end for i
  
  plot_indices_final[[2]] <- colours2[findInterval(indiv_distance_orig, brks, all.inside=TRUE)]
  
  plot_indices_final[[2]]<- sapply(plot_indices_final[[2]], function(item){
    if(is.na(item)){
      "#000000"
    } else {
      item
    }
  })
  
  # Which worship sites to print
  plot_indices_final[[3]] <- mapTtrustWorship(obj_list)
  
  # List of site colors
  siteColors <- sapply(plot_indices_final[[3]], function(site){
    if(site %in% nodes_added){
      "Blue"
    } else {
      "Yellow"
    }
  })
  
  # Text for these worship sites
  
  # List of text colors
  textColors <- sapply(plot_indices_final[[3]], function(site){
    if(site %in% nodes_added){
      "Light Blue"
    } else {
      "Black"
    }
  })
  
  plot_indices_final[[4]] <- brks
  
  plotMapHelp(plot_indices_final, boroughOrAll, siteColors, textColors, F)
  
  print(paste("Map printed at ", Sys.time()))
  
  # Calculate final stats
  
}



