
# convert it to a data.frame
system.time(
  shapeFile.f <- fortify(shapeFile.BNG)
)

# extract the coordinates to a different data.frame, get the ones that are not duplicated and consider that they are 1 node
nodes <- shapeFile.f[!duplicated(shapeFile.f[,c(1,2)]),c(1,2)]

# assign an id to each node
nodes$idNode <- 1:nrow(nodes)
nodes <- nodes[,c(3,1,2)]

#in order to have the id of the node in the data.frame we do a match with the coordinates as a string, that is, first we transform the coordinates into a string and then we see the match between both dataframes.
names.1 <- paste(shapeFile.f[,1],shapeFile.f[,2],sep=";")
names.2 <- paste(nodes[,2],nodes[,3],sep=";")
matched <- match(names.1,names.2)
shapeFile.f$idNode <- nodes[matched,1]

#to make the segments make another data.frame that starts in the second row (the last row will be the first)
shapeFile.f.postOrder <- shapeFile.f[2:nrow(shapeFile.f),c("long","lat","id","idNode")]
shapeFile.f.postOrder <- rbind(shapeFile.f.postOrder,shapeFile.f[1,c("long","lat","id","idNode")])

#combine both data.frames into 1
shapeFile.f.segments <- data.frame(idA=shapeFile.f$idNode,idB=shapeFile.f.postOrder$idNode,idLineA=shapeFile.f$id,idLineB=shapeFile.f.postOrder$id,longA=shapeFile.f$long,latA=shapeFile.f$lat,longB=shapeFile.f.postOrder$long,latB=shapeFile.f.postOrder$lat)

#keep only the ones that have the same Id of the line
segments <- shapeFile.f.segments[shapeFile.f.segments$idLineA==shapeFile.f.segments$idLineB,]

#keep only the columns that are necessary
segments <- segments[,c(1,2,5,6,7,8)]

#rename the column names
colnames(segments)[3:6] <- c("x1","y1","x2","y2")

#calculate the distances between the start and end point of each segment
distance <- ((segments$x2-segments$x1)^2+(segments$y2-segments$y1)^2)^.5

#consider that the weight of the link is the distance between the nodes of the link
segments$weight <- distance

#keep only the ida, idb and weight
ncol.format <- segments[,c(1,2,7)]

#rename the columns of the nodes to have it clearer (and you could save the file somewhere, not done here)
colnames(nodes) <- c("id","x","y")

#create the graph
G <- graph.data.frame(ncol.format,directed=F)
matched <- match(as.numeric(V(G)$name),nodes$id)
V(G)$x <- nodes[matched,2]
V(G)$y <- nodes[matched,3]
G <- simplify(G,remove.multiple = T,remove.loops = T,edge.attr.comb = "min")


# Convert nodes to BNG
nodes.xy <- nodes
coordinates(nodes.xy) <- c(2,3)
proj4string(nodes.xy) <- CRS("+init=epsg:27700")

# Only keep those nodes that are in the main cluster... this avoids infinite distances
nodes.xy.reduced <- nodes.xy[nodes.xy$id %in% names(clusters(G)[[1]][clusters(G)[[1]]==1]),]


#### Calculation of distance matrices

### Worship sites

worship.buffer <- gBuffer(worship.BNG, byid=TRUE, width=150)
nodesOnWorshipBuffer <- over(worship.buffer, nodes.xy.reduced, returnList = T)
listLengths <- sapply(nodesOnWorshipBuffer, function(item) length(item[[1]]))

worshipNodesList <- array(0, length(worship.BNG))
for(i in 1:length(worship.BNG)){
  # Loop over and store distances, find minimum pairings
  distance1 <- gDistance(worship.BNG[i,], nodes.xy.reduced[nodes.xy.reduced$id %in% nodesOnWorshipBuffer[[i]]$id,], byid=T)
  min.index <- apply(distance1, 2, function(col) which.min(col))
  worshipNodesList[i] <- row.names(distance1)[min.index]
}

worshipNodeIds2 <- nodes.xy.reduced@data[worshipNodesList,"id"]

### TTrust sites

ttrust.buffer <- gBuffer(london.ttrustLocs, byid=TRUE, width=80)
nodesOnTTRUSTBuffer <- over(ttrust.buffer, nodes.xy.reduced, returnList = T)

ttrustNodesList <- array(0, length(london.ttrustLocs))
for(i in 1:length(london.ttrustLocs)){
  # Loop over and store distances, find minimum pairings
  distance1 <- gDistance(london.ttrustLocs[i,], nodes.xy.reduced[nodes.xy.reduced$id %in% nodesOnTTRUSTBuffer[[i]]$id,], byid=T)
  min.index <- apply(distance1, 2, function(col) which.min(col))
  ttrustNodesList[i] <- row.names(distance1)[min.index]
}

ttrustNodeIds2 <- nodes.xy.reduced@data[ttrustNodesList,"id"]

### LSOA sites

lsoa.buffer <- gBuffer(lsoa.BNG, byid=TRUE, width=450)
nodesOnLSOABuffer <- over(lsoa.buffer, nodes.xy.reduced, returnList = T)

lsoaNodesList <- array(0, length(lsoa.BNG))
for(i in 1:length(lsoa.BNG)){
  # Loop over and store distances, find minimum pairings
  distance1 <- gDistance(lsoa.BNG[i,], nodes.xy.reduced[nodes.xy.reduced$id %in% nodesOnLSOABuffer[[i]]$id,], byid=T)
  min.index <- apply(distance1, 2, function(col) which.min(col))
  lsoaNodesList[i] <- row.names(distance1)[min.index]
}

lsoaNodeIds2 <- nodes.xy.reduced@data[lsoaNodesList,"id"]

### Ttrust Plus Worship SpatialPoints

temp1 <- SpatialPoints(london.ttrustLocs)
head(temp1)

toDelete <- duplicated(worshipNodesList)
toDelete[which(worshipNodeIds2 == worshipNodeIds2[worshipNodeIds2 %in% ttrustNodeIds2])] <- TRUE
noDups <- worship.BNG[!toDelete,]
temp2 <- SpatialPoints(noDups)

ttrust.plus.worship <- spRbind(temp1, temp2)
head(ttrust.plus.worship,100)

proj4string(ttrust.plus.worship) <- proj4string(london.ttrustLocs)

### Ttrust Plus Worship Sites

ttrust.plus.worship.buffer <- gBuffer(ttrust.plus.worship, byid=TRUE, width=120)
nodesOnTtrustPlusWorshipBuffer <- over(ttrust.plus.worship.buffer, nodes.xy.reduced, returnList = T)

ttrustPlusWorshipNodesList <- array(0, length(ttrust.plus.worship))
for(i in 1:length(ttrust.plus.worship)){
  # Loop over and store distances, find minimum pairings
  distance1 <- gDistance(ttrust.plus.worship[i,], nodes.xy.reduced[nodes.xy.reduced$id %in% nodesOnTtrustPlusWorshipBuffer[[i]]$id,], byid=T)
  min.index <- apply(distance1, 2, function(col) which.min(col))
  ttrustPlusWorshipNodesList[i] <- row.names(distance1)[min.index]
}

ttrustPlusWorshipNodeIds2 <- nodes.xy.reduced@data[ttrustPlusWorshipNodesList,"id"]








### Ttrust complete sites

ttComp.buffer <- gBuffer(ttComplete, byid=TRUE, width=80)
nodesOnttCompBuffer <- over(ttComp.buffer, nodes.xy.reduced, returnList = T)
lengths <- sapply(nodesOnttCompBuffer, nrow)
table(lengths)

ttCompNodesList <- array(0, length(ttComplete))
for(i in 1:length(ttComplete)){
  # Loop over and store distances, find minimum pairings
  distance1 <- gDistance(ttComplete[i,], nodes.xy.reduced[nodes.xy.reduced$id %in% nodesOnttCompBuffer[[i]]$id,], byid=T)
  min.index <- apply(distance1, 2, function(col) which.min(col))
  ttCompNodesList[i] <- row.names(distance1)[min.index]
}

ttCompNodeIds <- nodes.xy.reduced@data[ttCompNodesList,"id"]
length(ttCompNodeIds)

### Ttrust Plus Worship SpatialPoints - Complete

temp12 <- SpatialPoints(ttComplete)
head(temp12)
typeof(temp12)

toDelete2 <- duplicated(worshipNodesList)
toDelete2[which(worshipNodeIds2 %in% ttCompNodeIds)] <- TRUE
noDups <- worship.BNG[!toDelete2,]
temp22 <- SpatialPoints(noDups)
head(temp22)

ttComp.plus.worship <- spRbind(temp12, temp22)

proj4string(ttComp.plus.worship) <- proj4string(ttComplete)

### Ttrust Plus Worship Sites - Complete

ttComp.plus.worship.buffer <- gBuffer(ttComp.plus.worship, byid=TRUE, width=120)
plot(ttComp.plus.worship.buffer)
nodesOnttCompPlusWorshipBuffer <- over(ttComp.plus.worship.buffer, nodes.xy.reduced, returnList = T)

length(nodesOnttCompPlusWorshipBuffer)
lengths <- sapply(nodesOnttCompPlusWorshipBuffer, nrow)
table(lengths)

ttCompPlusWorshipNodesList <- array(0, length(ttComp.plus.worship))
for(i in 1:length(ttComp.plus.worship)){
  # Loop over and store distances, find minimum pairings
  distance1 <- gDistance(ttComp.plus.worship[i,], nodes.xy.reduced[nodes.xy.reduced$id %in% nodesOnttCompPlusWorshipBuffer[[i]]$id,], byid=T)
  min.index <- apply(distance1, 2, function(col) which.min(col))
  ttCompPlusWorshipNodesList[i] <- row.names(distance1)[min.index]
}

ttCompPlusWorshipNodeIds <- nodes.xy.reduced@data[ttCompPlusWorshipNodesList,"id"]


#### Creating Graph node sets

LSOA.graph.nodes <- V(G)[as.numeric(V(G)$name) %in% as.numeric(lsoaNodeIds2)]
Ttrust.graph.nodes <- V(G)[as.numeric(V(G)$name) %in% as.numeric(ttrustNodeIds2)]
Worship.graph.nodes <- V(G)[as.numeric(V(G)$name) %in% as.numeric(worshipNodeIds2)]
Ttrust.plus.Worship.graph.nodes <- V(G)[as.numeric(V(G)$name) %in% ttrustPlusWorshipNodeIds2]

ttComp.graph.nodes <- V(G)[as.numeric(V(G)$name) %in% as.numeric(ttCompNodeIds)]
ttComp.plus.Worship.graph.nodes <- V(G)[as.numeric(V(G)$name) %in% ttCompPlusWorshipNodeIds]


# Run calculations for showing all addition options to make it easier to display them later
all.nodes <<- 1:length(ttrust.plus.worship)
all.selections <- mapTtrustWorship(all.nodes)
all.order <- sapply(all.nodes, function(item) which(mapTtrustWorship(item)==all.selections))
all.ordered <<- sapply(1:length(all.order), function(item) which(all.order==item))

#### Create Distance Matrices for Optimization


system.time(
  ttrust.worship.dist.to.LSOAs <- data.frame(shortest.paths(G, v=Ttrust.plus.Worship.graph.nodes, to=LSOA.graph.nodes))
)
# user  system elapsed
# 329.70    0.22  331.76

# Cost matrix for moving a Ttrust to a POW
# Interesting difference:
system.time(
  ttrust.dist.to.pows <- data.frame(shortest.paths(G, v=Ttrust.graph.nodes, to=Ttrust.plus.Worship.graph.nodes))
)
# user  system elapsed
# 13.48    0.19   13.70

# With complete TT
system.time(
  ttComp.worship.dist.to.LSOAs <- data.frame(shortest.paths(G, v=ttComp.plus.Worship.graph.nodes, to=LSOA.graph.nodes))
)

system.time(
  ttComp.dist.to.pows <- data.frame(shortest.paths(G, v=ttComp.graph.nodes, to=ttComp.plus.Worship.graph.nodes))
)

# system.time(
#   pows.dist.to.ttrust <- data.frame(shortest.paths(G, v=Ttrust.plus.Worship.graph.nodes, to=Ttrust.graph.nodes))
# )
# user  system elapsed
# 358.97    0.53  365.50

# Find closest Ttrust site to every worship site
# fixed.cost.for.worship.sites <- apply(pows.dist.to.ttrust, 1, function(row) min(row))
fixed.cost.for.worship.sites <- apply(ttrust.dist.to.pows, 2, function(col) min(col))
fixed.cost.for.worship.sites.Comp <- apply(ttComp.dist.to.pows, 2, function(col) min(col))

## Now, with these shortest paths between ttrust points and worship points

ncol(ttrust.worship.dist.to.LSOAs)

twoklimit <- apply(ttrust.worship.dist.to.LSOAs, 2, function(col){
  sapply(col, function(item){
    if(item>2000){
      1000000
    }else{
      item
    }
  })
})

write.csv(twoklimit, "twoklimitDistances.csv")
write.csv(ttrust.worship.dist.to.LSOAs,"networkDistanceTtrustIncludedLondon.csv")
write.csv(fixed.cost.for.worship.sites,"networkDistanceTtrustToPOWLondon.csv")

twoklimit <- read.csv("twoklimitDistances.csv")[,-1]
ttrust.worship.dist.to.LSOAs <- read.csv("networkDistanceTtrustIncludedLondon.csv")[,-1]
fixed.cost.for.worship.sites <- read.csv("networkDistanceTtrustToPOWLondon.csv")[,-1]


# Functions

mapLSOA32 <- function(node) {
  return(which(as.numeric(lsoaNodeIds3) %in% as.numeric(LSOA.graph.nodes2[node]$name)==TRUE))
}
mapLSOA3 <- function(node) {
  return(which(as.numeric(lsoaNodeIds2) %in% as.numeric(LSOA.graph.nodes[node]$name)==TRUE))
}
mapWorship3 <- function(node) {
  return(which(as.numeric(worshipNodeIds2) %in% as.numeric(Worship.graph.nodes[node]$name)==TRUE))
}
mapTtrust3 <- function(node) {
  return(which(as.numeric(ttrustNodeIds2) %in% as.numeric(Ttrust.graph.nodes[node]$name)==TRUE))
}
mapTtrustWorship <- function(node) {
  return(which(as.numeric(ttrustPlusWorshipNodeIds2) %in% as.numeric(Ttrust.plus.Worship.graph.nodes[node]$name)==TRUE))
}
mapTtCompWorship <- function(node) {
  return(which(as.numeric(ttCompPlusWorshipNodeIds) %in% as.numeric(ttComp.plus.Worship.graph.nodes[node]$name)==TRUE))
}

dictionary <- sapply(1:length(ttrust.plus.worship), mapTtrustWorship)
dictionaryComp <- sapply(1:length(ttComp.plus.worship), mapTtCompWorship)

