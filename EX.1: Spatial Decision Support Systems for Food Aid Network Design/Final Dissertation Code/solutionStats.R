#### Statistics

calcAllStats <- function(){
  # Site stats
  if(currentMapType=="orig" | currentMapType=="2k"){
    # Site number, day number, number assigned sites, average distance, sd distance, average income decile
    final_site_stats <- matrix(0,length(obj_list),5)
    
    distance_store_orig <- vector("list", length(obj_list))
    
    for(i in 1:length(obj_list)){
      for(j in 1:ncol(obj_mat)){
        if(obj_mat[obj_list[i],j]==1){
          
          this_dist_orig <- ttrust.worship.dist.to.LSOAs[obj_list[i], j]
          
          distance_store_orig[[i]] <- c(distance_store_orig[[i]], this_dist_orig)
          
        } # end if
      } # end for j
    } # end for i
    
    final_site_stats[,2] <-  sapply(obj_list, mapTtrustWorship)
    final_site_stats[,1] <- as.character(over(ttrust.plus.worship[final_site_stats[,2],], LondonMapBoroughs)$NAME)
    
    # Store number of neighborhoods attached to each site, and average/sd of distances they are to fb site
    final_site_stats[,3] <- apply(obj_mat[obj_list,],1,sum)
    final_site_stats[,4] <- round(sapply(distance_store_orig, mean),2)
    final_site_stats[,5] <- round(sapply(distance_store_orig, sd),2)
    
    final_site_stats <- data.frame(final_site_stats)
    colnames(final_site_stats) <- c("Borough", "SiteNum", "NumAssignedLSOAs", "AvgDist", "SdDist")
    final_site_stats <- final_site_stats[order(as.numeric(as.character(final_site_stats$SiteNum))),]
    
    print(paste("Site stats finished at ", Sys.time()))
    
    # LSOA stats
    final_indiv_stats <- matrix(0,length(lsoa.BNG),5)
    sapply(1:ncol(obj_mat), function(j){
      assigned <- which(obj_mat[,j]==1)
      final_indiv_stats[j,2] <<- mapLSOA3(j)
      final_indiv_stats[j,3] <<- lsoa.BNG[as.numeric(as.character(final_indiv_stats[j,2])),]@data$Income_Decile
      final_indiv_stats[j,4] <<- mapTtrustWorship(assigned)
      final_indiv_stats[j,5] <<- round(ttrust.worship.dist.to.LSOAs[assigned, j],2)
    })
    final_indiv_stats[,1] <- as.character(over(lsoa.BNG[final_indiv_stats[,2],], LondonMapBoroughs)$NAME)
    
    final_indiv_stats <- data.frame(final_indiv_stats)
    colnames(final_indiv_stats) <- c("Borough", "LsoaNum", "IncomeDecile", "AssignedSite", "DistToSite")
    final_indiv_stats <- final_indiv_stats[order(as.numeric(as.character(final_indiv_stats$AssignedSite))),]
    
    print(paste("LSOA stats finished at", Sys.time()))
    
    print(head(final_site_stats,100))
    print(head(final_indiv_stats,100))

    final_site_stats <- calcFoodBankStats(final_site_stats, final_indiv_stats)
    
    return(list(final_site_stats, final_indiv_stats))
    
  } else if(currentMapType=="Comp") {
    
    
    # Site number, day number, number assigned sites, average distance, sd distance, average income decile
    final_site_stats <- matrix(0,length(obj_list),5)
    
    distance_store_orig <- vector("list", length(obj_list))
    
    for(i in 1:length(obj_list)){
      for(j in 1:ncol(obj_mat)){
        if(obj_mat[obj_list[i],j]==1){
          
          this_dist_orig <- ttComp.worship.dist.to.LSOAs[obj_list[i], j]
          
          distance_store_orig[[i]] <- c(distance_store_orig[[i]], this_dist_orig)
          
        } # end if
      } # end for j
    } # end for i
    
    final_site_stats[,2] <-  dictionaryComp[obj_list]
    final_site_stats[,1] <- as.character(over(ttComp.plus.worship[final_site_stats[,2],], LondonMapBoroughs)$NAME)
    
    # Store number of neighborhoods attached to each site, and average/sd of distances they are to fb site
    final_site_stats[,3] <- apply(obj_mat[obj_list,],1,sum)
    final_site_stats[,4] <- round(sapply(distance_store_orig, mean),2)
    final_site_stats[,5] <- round(sapply(distance_store_orig, sd),2)
    
    final_site_stats <- data.frame(final_site_stats)
    colnames(final_site_stats) <- c("Borough", "SiteNum", "NumAssignedLSOAs", "AvgDist", "SdDist")
    final_site_stats <- final_site_stats[order(as.numeric(as.character(final_site_stats$SiteNum))),]
    
    print(paste("Site stats finished at ", Sys.time()))
    
    # LSOA stats
    final_indiv_stats <- matrix(0,length(lsoa.BNG),5)
    sapply(1:ncol(obj_mat), function(j){
      assigned <- which(obj_mat[,j]==1)
      final_indiv_stats[j,2] <<- mapLSOA3(j)
      final_indiv_stats[j,3] <<- lsoa.BNG[as.numeric(as.character(final_indiv_stats[j,2])),]@data$Income_Decile
      final_indiv_stats[j,4] <<- dictionaryComp[assigned]
      final_indiv_stats[j,5] <<- round(ttComp.worship.dist.to.LSOAs[assigned, j],2)
    })
    final_indiv_stats[,1] <- as.character(over(lsoa.BNG[final_indiv_stats[,2],], LondonMapBoroughs)$NAME)
    
    final_indiv_stats <- data.frame(final_indiv_stats)
    colnames(final_indiv_stats) <- c("Borough", "LsoaNum", "IncomeDecile", "AssignedSite", "DistToSite")
    final_indiv_stats <- final_indiv_stats[order(as.numeric(as.character(final_indiv_stats$AssignedSite))),]
    
    print(paste("LSOA stats finished at", Sys.time()))
    
    print(head(final_site_stats,100))
    print(head(final_indiv_stats,100))
    
    final_site_stats <- calcFoodBankStats(final_site_stats, final_indiv_stats)
    
    return(list(final_site_stats, final_indiv_stats))
  }
}




boroughStats <- function(stats, borough){
  
  site_stats <- stats[[1]]
  indiv_stats <- stats[[2]]
  
  print(head(site_stats))
  print(head(indiv_stats))
  
  site_stats$SiteNum <- as.numeric(as.character(site_stats$SiteNum))
  indiv_stats$LsoaNum <- as.numeric(as.character(indiv_stats$LsoaNum))
  
  # Selected borough geometry
  boroughBdy <- LondonMapBoroughs[LondonMapBoroughs@data$NAME == borough,]
  
  if(currentMapType == "orig" | currentMapType == "2k"){
    sites <- ttrust.plus.worship[site_stats$SiteNum,]
  } else if(currentMapType == "Comp"){
    sites <- ttComp.plus.worship[site_stats$SiteNum,]
  } else {
    return()
  }
  # Site Stats
  
  sitesInBdy <- over(sites,boroughBdy)
  sitesInBdy <- sitesInBdy[!is.na(as.character(sitesInBdy$NAME)),]
  site_indices <- as.numeric(as.character(rownames(sitesInBdy)))

  borough_site_stats <- site_stats[site_indices, ]
  
  # LSOA Stats
  
  lsoasInBdy <- over(lsoa.BNG, boroughBdy)
  
  borough_lsoa_stats <- indiv_stats[which(indiv_stats$LsoaNum %in% which(!is.na(lsoasInBdy$NAME))),]
  
  ## Further work - extend to work with scenarios
  return(list(borough_site_stats, borough_lsoa_stats))
}







scenarioStats <- function(scenNum){
  
  # Select dist table

  if(scenNum == 1){
    distTable <- ttrust.worship.dist.to.LSOAs.Scen1
  } else if(scenNum == 2){
    distTable <- ttrust.worship.dist.to.LSOAs.Scen2
  } else if(scenNum == 3){
    distTable <- ttrust.worship.dist.to.LSOAs.Scen3
  } else if(scenNum == 4){
    distTable <- ttrust.worship.dist.to.LSOAs.Scen4
  } else {
    print("Invalid scenario")
    return()
  }
  
  # Site Stats
  final_site_stats <- matrix(0,length(obj_list),5)
  
  distance_store_orig <- vector("list", length(obj_list))
  
  for(i in 1:length(obj_list)){
    for(j in 1:ncol(obj_mat)){
      if(obj_mat[obj_list[i],j]==1){
        
        this_dist_orig <- distTable[obj_list[i], j]
        
        distance_store_orig[[i]] <- c(distance_store_orig[[i]], this_dist_orig)
        
      } # end if
    } # end for j
  } # end for i
  
  final_site_stats[,2] <- sapply(obj_list, mapTtrustWorship)
  # Find the Borough of each site
  final_site_stats[,1] <- as.character(over(ttrust.plus.worship[final_site_stats[,2],], LondonMapBoroughs)$NAME)
  
  # Store number of neighborhoods attached to each site, and average/sd of distances they are to fb site
  final_site_stats[,3] <- apply(obj_mat[obj_list,],1,sum)
  final_site_stats[,4] <- round(sapply(distance_store_orig, mean),2)
  final_site_stats[,5] <- round(sapply(distance_store_orig, sd),2)
  
  final_site_stats <- data.frame(final_site_stats)
  colnames(final_site_stats) <- c("Borough", "SiteNum", "NumAssignedLSOAs", "AvgDist", "SdDist")
  final_site_stats <- final_site_stats[order(as.numeric(as.character(final_site_stats$SiteNum))),]
  
  print(paste("Site stats finished at ", Sys.time()))
  
  # LSOA stats
  if(scenNum==1){
    final_indiv_stats <- matrix(0,length(lsoa.BNG1),5)
    sapply(1:ncol(obj_mat), function(j){
      assigned <- which(obj_mat[,j]==1)
      final_indiv_stats[j,2] <<- mapLSOA.Scen1(j)
      final_indiv_stats[j,3] <<- lsoa.BNG1[as.numeric(final_indiv_stats[j,2]),]@data$New_Income_Decile1
      final_indiv_stats[j,4] <<- mapTtrustWorship(assigned)
      final_indiv_stats[j,5] <<- round(distTable[assigned, j],2)
    })
    
    final_indiv_stats[,1] <- as.character(over(lsoa.BNG1[final_indiv_stats[,2],], LondonMapBoroughs)$NAME)
    
  } else if(scenNum==2){
    final_indiv_stats <- matrix(0,length(lsoa.BNG2),5)
    sapply(1:ncol(obj_mat), function(j){
      assigned <- which(obj_mat[,j]==1)
      final_indiv_stats[j,2] <<- mapLSOA.Scen2(j)
      final_indiv_stats[j,3] <<- lsoa.BNG2[as.numeric(final_indiv_stats[j,2]),]@data$New_Income_Decile2
      final_indiv_stats[j,4] <<- mapTtrustWorship(assigned)
      final_indiv_stats[j,5] <<- round(distTable[assigned, j],2)
    })
    final_indiv_stats[,1] <- as.character(over(lsoa.BNG2[final_indiv_stats[,2],], LondonMapBoroughs)$NAME)
  } else if(scenNum==3){
    final_indiv_stats <- matrix(0,length(lsoa.BNG3),5)
    sapply(1:ncol(obj_mat), function(j){
      assigned <- which(obj_mat[,j]==1)
      final_indiv_stats[j,2] <<- mapLSOA.Scen3(j)
      final_indiv_stats[j,3] <<- lsoa.BNG3[as.numeric(final_indiv_stats[j,2]),]@data$New_Income_Decile3
      final_indiv_stats[j,4] <<- mapTtrustWorship(assigned)
      final_indiv_stats[j,5] <<- round(distTable[assigned, j],2)
    })
    final_indiv_stats[,1] <- as.character(over(lsoa.BNG3[final_indiv_stats[,2],], LondonMapBoroughs)$NAME)
  } else if(scenNum==4){
    final_indiv_stats <- matrix(0,length(lsoa.BNG4),5)
    sapply(1:ncol(obj_mat), function(j){
      assigned <- which(obj_mat[,j]==1)
      final_indiv_stats[j,2] <<- mapLSOA.Scen4(j)
      final_indiv_stats[j,3] <<- lsoa.BNG4[as.numeric(final_indiv_stats[j,2]),]@data$New_Income_Decile4
      final_indiv_stats[j,4] <<- mapTtrustWorship(assigned)
      final_indiv_stats[j,5] <<- round(distTable[assigned, j],2)
    })
    final_indiv_stats[,1] <- as.character(over(lsoa.BNG4[final_indiv_stats[,2],], LondonMapBoroughs)$NAME)
  }
  
  
  final_indiv_stats <- data.frame(final_indiv_stats)
  colnames(final_indiv_stats) <- c("Borough", "LsoaNum", "IncomeDecile", "AssignedSite", "DistToSite")
  final_indiv_stats <- final_indiv_stats[order(as.numeric(as.character(final_indiv_stats$AssignedSite))),]
  
  
  print(paste("LSOA stats finished at", Sys.time()))
  
  final_site_stats <- calcFoodBankStats(final_site_stats, final_indiv_stats)
  
  return(list(final_site_stats, final_indiv_stats))
  
}






calcFoodBankStats <- function(fbStats, lsoaStats){
  
  # Num assigned sites inside own Borough

  fbStats$SiteNum <- as.numeric(as.character(fbStats$SiteNum))
  lsoaStats$AssignedSite <- as.numeric(as.character(lsoaStats$AssignedSite))
  fbStats$Borough <- as.character(fbStats$Borough)
  lsoaStats$Borough <- as.character(lsoaStats$Borough)
  fbStats$NumAssignedLSOAs <- as.numeric(as.character(fbStats$NumAssignedLSOAs))
  lsoaStats$DistToSite <- as.numeric(as.character(lsoaStats$DistToSite))
  
  
  
    inBorough <- sapply(1:nrow(fbStats), function(row){
      if(fbStats[row,"Borough"] %in% LondonMapBoroughs@data$NAME & fbStats[row,"NumAssignedLSOAs"]){
        TFNA <- lsoaStats[lsoaStats$AssignedSite == fbStats[row,"SiteNum"],"Borough"] == fbStats[row,"Borough"]
        TF <- sapply(TFNA, function(item){
          if(is.na(item)){
            FALSE
          } else {
            item
          }
        })
        sum(TF)
      } else {
        0
      }
    })

  # Num assigned sites outside own Borough
  
  outBorough <- fbStats$NumAssignedLSOAs - inBorough
  
  # Number of neighborhoods at each decile assigned to this food bank
  decile1 <- sapply(1:nrow(fbStats), function(row){
    sum(lsoaStats[lsoaStats$AssignedSite==fbStats[row,"SiteNum"],"IncomeDecile"]==1)
  })
  decile2 <- sapply(1:nrow(fbStats), function(row){
    sum(lsoaStats[lsoaStats$AssignedSite==fbStats[row,"SiteNum"],"IncomeDecile"]==2)
  })
  decile3 <- sapply(1:nrow(fbStats), function(row){
    sum(lsoaStats[lsoaStats$AssignedSite==fbStats[row,"SiteNum"],"IncomeDecile"]==3)
  })
  
  in400 <- sapply(1:nrow(fbStats), function(row){
    sum(lsoaStats[lsoaStats$AssignedSite==fbStats[row,"SiteNum"],"DistToSite"]<=400)
  })
  in800 <- sapply(1:nrow(fbStats), function(row){
    sum(lsoaStats[lsoaStats$AssignedSite==fbStats[row,"SiteNum"],"DistToSite"]<=800)
  })
  in1200 <- sapply(1:nrow(fbStats), function(row){
    sum(lsoaStats[lsoaStats$AssignedSite==fbStats[row,"SiteNum"],"DistToSite"]<=1200)
  })
  in1600 <- sapply(1:nrow(fbStats), function(row){
    sum(lsoaStats[lsoaStats$AssignedSite==fbStats[row,"SiteNum"],"DistToSite"]<=1600)
  })
  in2000 <- sapply(1:nrow(fbStats), function(row){
    sum(lsoaStats[lsoaStats$AssignedSite==fbStats[row,"SiteNum"],"DistToSite"]<=2000)
  })
  above2000 <- sapply(1:nrow(fbStats), function(row){
    sum(lsoaStats[lsoaStats$AssignedSite==fbStats[row,"SiteNum"],"DistToSite"]<=1000000)
  })
  
  fbStats <- cbind(fbStats, inBorough, outBorough, decile1, decile2, decile3,
                   in400,in800,in1200,in1600,in2000,above2000)
  
  return(fbStats)
  
  
}

