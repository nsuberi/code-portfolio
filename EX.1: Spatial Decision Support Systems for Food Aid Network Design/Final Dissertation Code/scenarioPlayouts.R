
#### Stochastic change to the environment - rising and falling fortunes
## Set seed here so results are repeatable!
set.seed(1)

# 30% chance status drops
New_Income_Decile1 <- sapply(LondonLSOACentroids@data$Income_Decile, function(item){
  rand <- runif(1,0,1)
  if(rand < .3){
    if(item > 1) item - 1 else item
  }
  else if(rand <.4){
    if(item < 10) item + 1 else item
  }
  else{
    item
  }
})

set.seed(2)

# 70% chance status drops
New_Income_Decile2 <- sapply(LondonLSOACentroids@data$Income_Decile, function(item){
  rand <- runif(1,0,1)
  if(rand < .7){
    if(item > 1) item - 1 else item
  }
  else if(rand <.8){
    if(item < 10) item + 1 else item
  }
  else{
    item
  }
})

set.seed(3)

# All places set to 1, 2, or 3 (aka all of london needs)
New_Income_Decile3 <- sapply(1:length(LondonLSOACentroids), function(item){
  rand <- runif(1,0,1)
  if(rand < .3){
    1
  }
  else if(rand <.6){
    2
  }
  else{
    3
  }
})

set.seed(4)

# redistribute the sites
Dec1 <- length(LondonLSOACentroids[LondonLSOACentroids@data$Income_Decile==1,])/length(LondonLSOACentroids)
Dec2 <- length(LondonLSOACentroids[LondonLSOACentroids@data$Income_Decile==2,])/length(LondonLSOACentroids)
Dec3 <- length(LondonLSOACentroids[LondonLSOACentroids@data$Income_Decile==3,])/length(LondonLSOACentroids)


New_Income_Decile4 <- sapply(1:length(LondonLSOACentroids), function(item){
  rand <- runif(1,0,1)
  if(rand < Dec1){
    1
  }
  else if(rand < (Dec1 + Dec2)){
    2
  }
  else if(rand < (Dec1 + Dec2 + Dec3)){
    3
  } else{
    4
  }
})

LondonHighNeedCentroids1 <- LondonLSOACentroids[New_Income_Decile1 <= 3,]
LondonHighNeedCentroids2 <- LondonLSOACentroids[New_Income_Decile2 <= 3,]
LondonHighNeedCentroids3 <- LondonLSOACentroids[New_Income_Decile3 <= 3,]
LondonHighNeedCentroids4 <- LondonLSOACentroids[New_Income_Decile4 <= 3,]

New_Income_Decile1 <- New_Income_Decile1[New_Income_Decile1 <= 3]
New_Income_Decile2 <- New_Income_Decile2[New_Income_Decile2 <= 3]
New_Income_Decile3 <- New_Income_Decile3[New_Income_Decile3 <= 3]
New_Income_Decile4 <- New_Income_Decile4[New_Income_Decile4 <= 3]

LondonHighNeedCentroids1@data <- cbind(LondonHighNeedCentroids1@data,New_Income_Decile1)
LondonHighNeedCentroids2@data <- cbind(LondonHighNeedCentroids2@data,New_Income_Decile2)
LondonHighNeedCentroids3@data <- cbind(LondonHighNeedCentroids3@data,New_Income_Decile3)
LondonHighNeedCentroids4@data <- cbind(LondonHighNeedCentroids4@data,New_Income_Decile4)

lsoa.BNG1 <- spTransform(LondonHighNeedCentroids1, CRS("+init=epsg:27700")) # converts to UK Grid system
lsoa.BNG2 <- spTransform(LondonHighNeedCentroids2, CRS("+init=epsg:27700")) # converts to UK Grid system
lsoa.BNG3 <- spTransform(LondonHighNeedCentroids3, CRS("+init=epsg:27700")) # converts to UK Grid system
lsoa.BNG4 <- spTransform(LondonHighNeedCentroids4, CRS("+init=epsg:27700")) # converts to UK Grid system

lsoa.buffer1 <- gBuffer(lsoa.BNG1, byid=TRUE, width=450)
nodesOnLSOABuffer1 <- over(lsoa.buffer1, nodes.xy.reduced, returnList = T)
listLengths1 <- sapply(nodesOnLSOABuffer1, function(item) length(item[[1]]))
table(listLengths1)

lsoa.buffer2 <- gBuffer(lsoa.BNG2, byid=TRUE, width=450)
nodesOnLSOABuffer2 <- over(lsoa.buffer2, nodes.xy.reduced, returnList = T)
listLengths2 <- sapply(nodesOnLSOABuffer2, function(item) length(item[[1]]))
table(listLengths2)

lsoa.buffer3 <- gBuffer(lsoa.BNG3, byid=TRUE, width=450)
nodesOnLSOABuffer3 <- over(lsoa.buffer3, nodes.xy.reduced, returnList = T)
listLengths3 <- sapply(nodesOnLSOABuffer3, function(item) length(item[[1]]))
table(listLengths3)

lsoa.buffer4 <- gBuffer(lsoa.BNG4, byid=TRUE, width=450)
nodesOnLSOABuffer4 <- over(lsoa.buffer4, nodes.xy.reduced, returnList = T)
listLengths4 <- sapply(nodesOnLSOABuffer4, function(item) length(item[[1]]))
table(listLengths4)



lsoaNodesList1 <- array(0, length(lsoa.BNG1))
for(i in 1:length(lsoa.BNG1)){
  # Loop over and store distances, find minimum pairings
  distance1 <- gDistance(lsoa.BNG1[i,], nodes.xy.reduced[nodes.xy.reduced$id %in% nodesOnLSOABuffer1[[i]]$id,], byid=T)
  min.index <- apply(distance1, 2, function(col) which.min(col))
  lsoaNodesList1[i] <- row.names(distance1)[min.index]
}

lsoaNodesList2 <- array(0, length(lsoa.BNG2))
for(i in 1:length(lsoa.BNG2)){
  # Loop over and store distances, find minimum pairings
  distance1 <- gDistance(lsoa.BNG2[i,], nodes.xy.reduced[nodes.xy.reduced$id %in% nodesOnLSOABuffer2[[i]]$id,], byid=T)
  min.index <- apply(distance1, 2, function(col) which.min(col))
  lsoaNodesList2[i] <- row.names(distance1)[min.index]
}

lsoaNodesList3 <- array(0, length(lsoa.BNG3))
for(i in 1:length(lsoa.BNG3)){
  # Loop over and store distances, find minimum pairings
  distance1 <- gDistance(lsoa.BNG3[i,], nodes.xy.reduced[nodes.xy.reduced$id %in% nodesOnLSOABuffer3[[i]]$id,], byid=T)
  min.index <- apply(distance1, 2, function(col) which.min(col))
  lsoaNodesList3[i] <- row.names(distance1)[min.index]
}

lsoaNodesList4 <- array(0, length(lsoa.BNG4))
for(i in 1:length(lsoa.BNG4)){
  # Loop over and store distances, find minimum pairings
  distance1 <- gDistance(lsoa.BNG4[i,], nodes.xy.reduced[nodes.xy.reduced$id %in% nodesOnLSOABuffer4[[i]]$id,], byid=T)
  min.index <- apply(distance1, 2, function(col) which.min(col))
  lsoaNodesList4[i] <- row.names(distance1)[min.index]
}


lsoaNodeIdsScen1 <- nodes.xy.reduced@data[lsoaNodesList1,"id"]
lsoaNodeIdsScen2 <- nodes.xy.reduced@data[lsoaNodesList2,"id"]
lsoaNodeIdsScen3 <- nodes.xy.reduced@data[lsoaNodesList3,"id"]
lsoaNodeIdsScen4 <- nodes.xy.reduced@data[lsoaNodesList4,"id"]

LSOA.graph.nodes1 <- V(G)[as.numeric(V(G)$name) %in% as.numeric(lsoaNodeIdsScen1)]
LSOA.graph.nodes2 <- V(G)[as.numeric(V(G)$name) %in% as.numeric(lsoaNodeIdsScen2)]
LSOA.graph.nodes3 <- V(G)[as.numeric(V(G)$name) %in% as.numeric(lsoaNodeIdsScen3)]
LSOA.graph.nodes4 <- V(G)[as.numeric(V(G)$name) %in% as.numeric(lsoaNodeIdsScen4)]


# Distance Matrix for optimization
system.time(
  ttrust.worship.dist.to.LSOAs.Scen1 <- data.frame(shortest.paths(G, v=Ttrust.plus.Worship.graph.nodes, to=LSOA.graph.nodes1))
)

system.time(
  ttrust.worship.dist.to.LSOAs.Scen2 <- data.frame(shortest.paths(G, v=Ttrust.plus.Worship.graph.nodes, to=LSOA.graph.nodes2))
)

system.time(
  ttrust.worship.dist.to.LSOAs.Scen3 <- data.frame(shortest.paths(G, v=Ttrust.plus.Worship.graph.nodes, to=LSOA.graph.nodes3))
)

system.time(
  ttrust.worship.dist.to.LSOAs.Scen4 <- data.frame(shortest.paths(G, v=Ttrust.plus.Worship.graph.nodes, to=LSOA.graph.nodes4))
)

mapLSOA.Scen1 <- function(node){
  return(which(as.numeric(lsoaNodeIdsScen1) %in% as.numeric(LSOA.graph.nodes1[node]$name)==TRUE))
}
mapLSOA.Scen2 <- function(node){
  return(which(as.numeric(lsoaNodeIdsScen2) %in% as.numeric(LSOA.graph.nodes2[node]$name)==TRUE))
}
mapLSOA.Scen3 <- function(node){
  return(which(as.numeric(lsoaNodeIdsScen3) %in% as.numeric(LSOA.graph.nodes3[node]$name)==TRUE))
}
mapLSOA.Scen4 <- function(node){
  return(which(as.numeric(lsoaNodeIdsScen4) %in% as.numeric(LSOA.graph.nodes4[node]$name)==TRUE))
}



write.csv(ttrust.worship.dist.to.LSOAs.Scen1,"scenario1.csv")
write.csv(ttrust.worship.dist.to.LSOAs.Scen2,"scenario2.csv")
write.csv(ttrust.worship.dist.to.LSOAs.Scen3,"scenario3.csv")
write.csv(ttrust.worship.dist.to.LSOAs.Scen4,"scenario4.csv")

ttrust.worship.dist.to.LSOAs.Scen1 <- read.csv("scenario1.csv")[,-1]
ttrust.worship.dist.to.LSOAs.Scen2 <- read.csv("scenario2.csv")[,-1]
ttrust.worship.dist.to.LSOAs.Scen3 <- read.csv("scenario3.csv")[,-1]
ttrust.worship.dist.to.LSOAs.Scen4 <- read.csv("scenario4.csv")[,-1]
