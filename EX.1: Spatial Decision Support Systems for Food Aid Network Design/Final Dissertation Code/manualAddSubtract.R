
#### Function to remove a site from the map


removeSiteFromMap <- function(nodeList){
  res <- removeSiteFromMapHelp(nodeList, obj_mat, obj_list, currentMapType, brks, index)
  obj_list <<- res[[1]]
  obj_mat <<- res[[2]]
  
}

removeSiteFromMapHelp <- function(node_list, obj_mat, obj_list, currentMapType, brks, index){
  
  #### Delete all nodes in a set, calculate obj function of new and old and compare
  temp_list <- obj_list
  temp_mat <- obj_mat
  
  nodes_to_delete <<- which(dictionary %in% node_list)
  nodeList <<- nodes_to_delete
  
  if(currentMapType == "orig" | currentMapType == "2k"){
    
    for(i in nodes_to_delete){
      if(i %in% temp_list){
        
        for(j in 1:ncol(temp_mat)){
          
          if(temp_mat[i,j]==1){
            temp_mat[i,j] <- 0
            temp_mat[ temp_list[ which( ttrust.worship.dist.to.LSOAs[ temp_list, j ] == sort(ttrust.worship.dist.to.LSOAs[ temp_list, j ])[2] ) ], j ] <- 1
          }
          
        }
        temp_list <- temp_list[-which(temp_list==i)]
        
      } else {
        nodeList <<- nodeList[-which(nodeList==i)]
        print(paste("Node ", dictionary[i], " is not active to be deleted." ))
      }
      
    }
    
    # If LSOA assignment doesn't change, column cancels out
    # If LSOA assignment changes, the
    diff_mat_obj_func <- temp_mat - obj_mat
    
    maxs <- apply(diff_mat_obj_func, 2, which.max)
    mins <- apply(diff_mat_obj_func, 2, which.min)
    max_vals <- sapply(1:ncol(diff_mat_obj_func), function(j) ttrust.worship.dist.to.LSOAs[maxs[j],j])
    min_vals <- sapply(1:ncol(diff_mat_obj_func), function(j) ttrust.worship.dist.to.LSOAs[mins[j],j])
    
    diff_vals_obj_func <- max_vals - min_vals
    
    #
    
    diff_mat_col <- temp_mat - orig_obj_mat
    
    maxs <- apply(diff_mat_col, 2, which.max)
    mins <- apply(diff_mat_col, 2, which.min)
    max_vals <- sapply(1:ncol(diff_mat_col), function(j) ttrust.worship.dist.to.LSOAs[maxs[j],j])
    min_vals <- sapply(1:ncol(diff_mat_col), function(j) ttrust.worship.dist.to.LSOAs[mins[j],j])
    
    diff_vals_col <<- max_vals - min_vals
    
    # Set plot indices for changed LSOAs
    changed_obj_func <<- which(diff_vals_obj_func > 0 )
    changed_col_better <<- which(diff_vals_col < 0)
    changed_col_worse <<- which(diff_vals_col > 0)
    changed_col_same <<- which(diff_vals_col == 0)
    
    # changes back are where changed_obj_func < 0 but changed_col == 0
    changed_col_back <<- changed_obj_func[which(changed_obj_func %in% changed_col_same)]
    
    plot_indices_change_better <<-  sapply(changed_col_better, function(i) which(LondonMap@data$LSOA11CD %in% LondonHighNeedCentroids[mapLSOA3(as.numeric(i)),]$LSOA11CD))
    plot_indices_change_worse <<-  sapply(changed_col_worse, function(i) which(LondonMap@data$LSOA11CD %in% LondonHighNeedCentroids[mapLSOA3(as.numeric(i)),]$LSOA11CD))
    plot_indices_change_back <<-  sapply(changed_col_back, function(i) which(LondonMap@data$LSOA11CD %in% LondonHighNeedCentroids[mapLSOA3(as.numeric(i)),]$LSOA11CD))
    
  } else {
    
    print("Incorrect Map Type")
    return()
  }
  
  nodes_removed <<- c(nodes_removed, dictionary[ nodeList[nodeList %in% orig_obj_list & !(dictionary[nodeList] %in% nodes_removed)] ])
  nodes_added_and_removed <<- c(nodes_added_and_removed, dictionary[nodeList[!(nodeList %in% orig_obj_list) & !(dictionary[nodeList] %in% nodes_added_and_removed)]])
  added_then_removed <- which(nodes_added %in% node_list)
  if(length(added_then_removed) > 0){
    nodes_added <<- nodes_added[-added_then_removed]
  }
  
  if(length(nodes_added_and_removed)>0){
    # Plot removed nodes
    plot(ttrust.plus.worship[nodes_added_and_removed,], col="White", pch=16, add = T, cex=3)
    text(ttrust.plus.worship[nodes_added_and_removed,]$oseast1m, ttrust.plus.worship[nodes_added_and_removed,]$osnrth1m, nodes_added_and_removed, col="White", cex=.6)
  }
  
  updateMap()
  
  # Return change in objective function
  diff_walking <- sum(diff_vals_obj_func[changed_obj_func])
  diff_operating <- -length(nodeList)*add[index]
  diff_moving <- (sum(fixed.cost.for.worship.sites[temp_list])-sum(fixed.cost.for.worship.sites[obj_list]))*mult[index]
  print(paste("Change in objective function from moving cost: ",diff_moving))
  print(paste("Change in objective function from operating cost: ",diff_operating))
  print(paste("Change in objective function from walking cost: ",diff_walking))
  
  change_in_obj <- diff_walking + diff_operating + diff_moving
  print(paste("Total change in objective function value: ", change_in_obj))
  
  legend("bottomleft", # position
         legend = legendText,
         title = "Walking Distance (d) to Nearest Food Bank in Meters",
         fill = palette( c( "#000000", names( table(plot_indices[[2]]) )) ),
         cex = 0.56,
         bty = "o",
         bg = "white")
  
  return(list(temp_list, temp_mat))
  
}







#### Function to add a site to a map
addSiteToMap <- function(nodeList){
  res <- addSiteToMapHelp(nodeList, obj_mat, obj_list, currentMapType, brks, index)
  
  obj_list <<- res[[1]]
  obj_mat <<- res[[2]]
  
  # When adding back a place... need to convert back to green to show original situation
  
}


addSiteToMapHelp <- function(node_list, obj_mat, obj_list, currentMapType, brks, index){
  
  #### Add nodes from the unused nodes set
  
  # These are all inherited from the original map layout
  temp_list <- obj_list
  temp_mat <- obj_mat
  
  # nodes_to_add IN 1:ncol(ttrust.plus.worship)
  nodes_to_add <- which(dictionary %in% node_list)
  nodeList <- nodes_to_add
  
  if(currentMapType == "orig" | currentMapType == "2k"){
    
    for(i in nodes_to_add){
      
      if(i %in% temp_list){
        
        nodeList <<- nodeList[-which(nodeList==i)]
        print(paste("Node ", dictionary[i], " already included" ))
        
      } else {
        
        ## Check distance between this node and all LSOAs
        dist_this_node <- ttrust.worship.dist.to.LSOAs[i,]
        ## compare to vector of current distances LSOAs are to their targets
        assigned <- apply(temp_mat, 2, function(col) which(col==1))
        dist_assigned <- sapply(1:ncol(temp_mat), function(i) ttrust.worship.dist.to.LSOAs[assigned[i], i])
        diff_dist <- dist_this_node - dist_assigned
        
        # LSOAs that would benefit from adding this site
        mat_indices_to_change <- which(diff_dist < 0)
        
        # Update temp matrix to reflect changes
        for(j in mat_indices_to_change){
          temp_mat[ assigned[ j ] , j ] <- 0
          temp_mat[ i, j ] <- 1
        } # end for j
        
        temp_list <- c(temp_list, i)
        
      } # end else
      
    } # end for i
    
    ### Compare differences
    
    diff_mat_obj_func <- temp_mat - obj_mat
    
    # Max in temp means that the value is now smaller
    mins <- apply(diff_mat_obj_func, 2, which.max)
    # Min in temp means that the value was bigger
    maxs <- apply(diff_mat_obj_func, 2, which.min)
    min_vals <- sapply(1:ncol(diff_mat_obj_func), function(j) ttrust.worship.dist.to.LSOAs[mins[j],j])
    max_vals <- sapply(1:ncol(diff_mat_obj_func), function(j) ttrust.worship.dist.to.LSOAs[maxs[j],j])
    
    # Bigger - smaller = positive
    diff_vals_obj_func <- min_vals - max_vals
    
    #
    
    diff_mat_col <- temp_mat - orig_obj_mat
    
    # Max in temp means that the value is now smaller
    mins <- apply(diff_mat_col, 2, which.max)
    # Min in temp means that the value was bigger
    maxs <- apply(diff_mat_col, 2, which.min)
    min_vals <- sapply(1:ncol(diff_mat_col), function(j) ttrust.worship.dist.to.LSOAs[mins[j],j])
    max_vals <- sapply(1:ncol(diff_mat_col), function(j) ttrust.worship.dist.to.LSOAs[maxs[j],j])
    
    # Bigger - smaller = positive
    diff_vals_col <<- min_vals - max_vals
    
    # Which ones became smaller?
    changed_obj_func <<- which(diff_vals_obj_func < 0)
    changed_col_better <<- which(diff_vals_col < 0)
    changed_col_worse <<- which(diff_vals_col > 0)
    changed_col_same <<- which(diff_vals_col == 0)
    
    # changes back are where changed_obj_func < 0 but changed_col == 0
    changed_col_back <<- changed_obj_func[which(changed_obj_func %in% changed_col_same)]
    
    plot_indices_change_better <<-  sapply(changed_col_better, function(i) which(LondonMap@data$LSOA11CD %in% LondonHighNeedCentroids[mapLSOA3(as.numeric(i)),]$LSOA11CD))
    plot_indices_change_worse <<-  sapply(changed_col_worse, function(i) which(LondonMap@data$LSOA11CD %in% LondonHighNeedCentroids[mapLSOA3(as.numeric(i)),]$LSOA11CD))
    plot_indices_change_back <<-  sapply(changed_col_back, function(i) which(LondonMap@data$LSOA11CD %in% LondonHighNeedCentroids[mapLSOA3(as.numeric(i)),]$LSOA11CD))
    
    
  } else {
    print("Incorrect Map Type")
    return()
  }
  
  # Update node change list
  
  
  nodes_added <<- c(nodes_added, dictionary[nodeList[ !(dictionary[nodeList] %in% nodes_removed) & !(dictionary[nodeList] %in% nodes_added)]])
  
  added_back <- which(nodes_removed %in% node_list)
  # If nodes were added that used to be removed, take out of nodes_removed and put in nodes_back
  if(length(added_back) > 0){
    nodes_removed <<- nodes_removed[-added_back]
  }
  added_then_removed <- which(nodes_added_and_removed %in% node_list)
  if(length(added_then_removed) > 0){
    nodes_added_and_removed <<- nodes_added_and_removed[-added_then_removed]
  }
  
  ## Display differences
  updateMap()
  
  # Return change in objective function
  diff_walking <- sum(diff_vals_obj_func[changed_obj_func])
  diff_operating <- length(nodeList)*add[index]
  diff_moving <- (sum(fixed.cost.for.worship.sites[temp_list])-sum(fixed.cost.for.worship.sites[obj_list]))*mult[index]
  print(paste("Change in objective function from moving cost: ",diff_moving))
  print(paste("Change in objective function from operating cost: ",diff_operating))
  print(paste("Change in objective function from walking cost: ",diff_walking))
  
  change_in_obj <- diff_walking + diff_operating + diff_moving
  print(paste("Total change in objective function value: ", change_in_obj))
  
  legend("bottomleft", # position
         legend = legendText,
         title = "Walking Distance (d) to Nearest Food Bank in Meters",
         fill = palette( c( "#000000", names( table(plot_indices[[2]]) )) ),
         cex = 0.56,
         bty = "o",
         bg = "white")
  
  return(list(temp_list, temp_mat))
  
}


showAddOptions <- function(){
  
  plot(ttrust.plus.worship, col="Light Blue", pch=16, add = T, cex=3)
  text(ttrust.plus.worship$oseast1m, ttrust.plus.worship$osnrth1m, all.nodes , col="Blue", cex=.6)
}

backToMapWithAddition <- function(nodeList){
  
  plotMapHelp(plot_indices, boroughOrAll, "Yellow", "Black")
  
  # Add nodes from nodeList
  addSiteToMap(nodeList)
  
  
}

