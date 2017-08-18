
# Part 1: optimization results

plotMap(1, "orig", "London")
index_1_stats <- calcAllStats()
write.csv(index_1_stats[[1]], "./DataPres/Index_1_Food_Bank_Sites.csv")
write.csv(index_1_stats[[2]], "./DataPres/Index_1_LSOAs.csv")

plotMap(6, "orig", "London")
index_6_stats <- calcAllStats()
write.csv(index_6_stats[[1]], "./DataPres/Index_6_Food_Bank_Sites.csv")
write.csv(index_6_stats[[2]], "./DataPres/Index_6_LSOAs.csv")

plotMap(43, "orig", "London")
index_43_stats <- calcAllStats()
write.csv(index_43_stats[[1]], "./DataPres/Index_43_Food_Bank_Sites.csv")
write.csv(index_43_stats[[2]], "./DataPres/Index_43_LSOAs.csv")

plotMap(48, "orig", "London")
index_48_stats <- calcAllStats()
write.csv(index_48_stats[[1]], "./DataPres/Index_48_Food_Bank_Sites.csv")
write.csv(index_48_stats[[2]], "./DataPres/Index_48_LSOAs.csv")

plotMap(16, "orig", "London")
index_16_stats <- calcAllStats()
write.csv(index_16_stats[[1]], "./DataPres/Index_16_Food_Bank_Sites.csv")
write.csv(index_16_stats[[2]], "./DataPres/Index_16_LSOAs.csv")

# Part 2: manual interaction

plotMap(16, "orig", "Brent")
brent_stats_1 <- boroughStats(index_16_stats,"Brent")
write.csv(brent_stats_1[[1]], "./DataPres/Brent_Food_Bank_Sites.csv")
write.csv(brent_stats_1[[2]], "./DataPres/Brent_LSOAs.csv")
brent_stats_1[[1]]

removeSiteFromMap(18)
plotFinalMap()
brent_removed_sites_stats <- calcAllStats()
brent_stats_2 <- boroughStats(brent_removed_sites_stats,"Brent")
write.csv(brent_stats_2[[1]], "./DataPres/Brent_Food_Bank_Sites2.csv")
write.csv(brent_stats_2[[2]], "./DataPres/Brent_LSOAs2.csv")

showAddOptions()
backToMapWithAddition(c(805, 175))
plotFinalMap()
brent_added_sites_stats <- calcAllStats()
brent_stats_3 <- boroughStats(brent_added_sites_stats,"Brent")
write.csv(brent_stats_3[[1]], "./DataPres/Brent_Food_Bank_Sites3.csv")
write.csv(brent_stats_3[[2]], "./DataPres/Brent_LSOAs3.csv")

# Part 3: social goals included

# For index 1,6,16,43,48 re-run optimizaton

plotMap(1, "2k", "London")
index_1_stats_2k <- calcAllStats()
write.csv(index_1_stats_2k[[1]], "./DataPres/Index_1_Food_Bank_Sites_2k.csv")
write.csv(index_1_stats_2k[[2]], "./DataPres/Index_1_LSOAs_2k.csv")

plotMap(6, "2k", "London")
index_6_stats_2k <- calcAllStats()
write.csv(index_6_stats_2k[[1]], "./DataPres/Index_6_Food_Bank_Sites_2k.csv")
write.csv(index_6_stats_2k[[2]], "./DataPres/Index_6_LSOAs_2k.csv")

plotMap(43, "2k", "London")
index_43_stats_2k <- calcAllStats()
write.csv(index_43_stats_2k[[1]], "./DataPres/Index_43_Food_Bank_Sites_2k.csv")
write.csv(index_43_stats_2k[[2]], "./DataPres/Index_43_LSOAs_2k.csv")

plotMap(48, "2k", "London")
index_48_stats_2k <- calcAllStats()
write.csv(index_48_stats_2k[[1]], "./DataPres/Index_48_Food_Bank_Sites_2k.csv")
write.csv(index_48_stats_2k[[2]], "./DataPres/Index_48_LSOAs_2k.csv")

plotMap(16, "2k", "London")
index_16_stats_2k <- calcAllStats()
write.csv(index_16_stats_2k[[1]], "./DataPres/Index_16_Food_Bank_Sites_2k.csv")
write.csv(index_16_stats_2k[[2]], "./DataPres/Index_16_LSOAs_2k.csv")

# Part 4: evaluating against uncertainty

plotMap(16, "orig", "London")

checkPerformance(index_16_stats, 1)
checkPerformance(index_16_stats, 2)
checkPerformance(index_16_stats, 3)
checkPerformance(index_16_stats, 4)

plotMap(16, "Scen1", "London")
index_16_perf_check_1 <- scenarioStats(1)
index_16_perf_check_1[[1]]
write.csv(index_16_perf_check_1[[1]], "./DataPres/Index_16_Scen1_Food_Bank_Sites.csv")
write.csv(index_16_perf_check_1[[2]], "./DataPres/Index_16_Scen1_LSOAs.csv")

plotMap(16, "Scen2", "London")
index_16_perf_check_2 <- scenarioStats(2)
write.csv(index_16_perf_check_2[[1]], "./DataPres/Index_16_Scen2_Food_Bank_Sites.csv")
write.csv(index_16_perf_check_2[[2]], "./DataPres/Index_16_Scen2_LSOAs.csv")

plotMap(16, "Scen3", "London")
index_16_perf_check_3 <- scenarioStats(3)
write.csv(index_16_perf_check_3[[1]], "./DataPres/Index_16_Scen3_Food_Bank_Sites.csv")
write.csv(index_16_perf_check_3[[2]], "./DataPres/Index_16_Scen3_LSOAs.csv")

plotMap(16, "Scen4", "London")
index_16_perf_check_4 <- scenarioStats(4)
write.csv(index_16_perf_check_4[[1]], "./DataPres/Index_16_Scen4_Food_Bank_Sites.csv")
write.csv(index_16_perf_check_4[[2]], "./DataPres/Index_16_Scen4_LSOAs.csv")


#### Data:

Index1_FBs <- read.csv("./DataPres/Index_1_Food_Bank_Sites.csv")[,-1]
Index1_LSOAs <- read.csv("./DataPres/Index_1_LSOAs.csv")[,-1]
Index6_FBs <- read.csv("./DataPres/Index_6_Food_Bank_Sites.csv")[,-1]
Index6_LSOAs <- read.csv("./DataPres/Index_6_LSOAs.csv")[,-1]
Index43_FBs <- read.csv("./DataPres/Index_43_Food_Bank_Sites.csv")[,-1]
Index43_LSOAs <- read.csv("./DataPres/Index_43_LSOAs.csv")[,-1]
Index48_FBs <- read.csv("./DataPres/Index_48_Food_Bank_Sites.csv")[,-1]
Index48_LSOAs <- read.csv("./DataPres/Index_48_LSOAs.csv")[,-1]
Index16_FBs <- read.csv("./DataPres/Index_16_Food_Bank_Sites.csv")[,-1]
Index16_LSOAs <- read.csv("./DataPres/Index_16_LSOAs.csv")[,-1]

Brent1_FBs <- read.csv("./DataPres/Brent_Food_Bank_Sites.csv")[,-1]
Brent1_LSOAs <- read.csv("./DataPres/Brent_LSOAs.csv")[,-1]
Brent2_FBs <- read.csv("./DataPres/Brent_Food_Bank_Sites2.csv")[,-1]
Brent2_LSOAs <- read.csv("./DataPres/Brent_LSOAs2.csv")[,-1]
Brent3_FBs <- read.csv("./DataPres/Brent_Food_Bank_Sites3.csv")[,-1]
Brent3_LSOAs <- read.csv("./DataPres/Brent_LSOAs3.csv")[,-1]

Index1_2k_FBs <- read.csv("./DataPres/Index_1_Food_Bank_Sites_2k.csv")[,-1]
Index1_2k_LSOAs <- read.csv("./DataPres/Index_1_LSOAs_2k.csv")[,-1]
Index6_2k_FBs <- read.csv("./DataPres/Index_6_Food_Bank_Sites_2k.csv")[,-1]
Index6_2k_LSOAs <- read.csv("./DataPres/Index_6_LSOAs_2k.csv")[,-1]
Index43_2k_FBs <- read.csv("./DataPres/Index_43_Food_Bank_Sites_2k.csv")[,-1]
Index43_2k_LSOAs <- read.csv("./DataPres/Index_43_LSOAs_2k.csv")[,-1]
Index48_2k_FBs <- read.csv("./DataPres/Index_48_Food_Bank_Sites_2k.csv")[,-1]
Index48_2k_LSOAs <- read.csv("./DataPres/Index_48_LSOAs_2k.csv")[,-1]
Index16_2k_FBs <- read.csv("./DataPres/Index_16_Food_Bank_Sites_2k.csv")[,-1]
Index16_2k_LSOAs <- read.csv("./DataPres/Index_16_LSOAs_2k.csv")[,-1]

Index16_Scen1_FBs <- read.csv("./DataPres/Index_16_Scen1_Food_Bank_Sites.csv")[,-1]
Index16_Scen1_LSOAs <- read.csv("./DataPres/Index_16_Scen1_LSOAs.csv")[,-1]
Index16_Scen2_FBs <- read.csv("./DataPres/Index_16_Scen2_Food_Bank_Sites.csv")[,-1]
Index16_Scen2_LSOAs <- read.csv("./DataPres/Index_16_Scen2_LSOAs.csv")[,-1]
Index16_Scen3_FBs <- read.csv("./DataPres/Index_16_Scen3_Food_Bank_Sites.csv")[,-1]
Index16_Scen3_LSOAs <- read.csv("./DataPres/Index_16_Scen3_LSOAs.csv")[,-1]
Index16_Scen4_FBs <- read.csv("./DataPres/Index_16_Scen4_Food_Bank_Sites.csv")[,-1]
Index16_Scen4_LSOAs <- read.csv("./DataPres/Index_16_Scen4_LSOAs.csv")[,-1]

####

# Food Bank Sites

# Q1: How many neighborhoods that a food bank serves are in the same Borough?

# Q2; What is the distribution of income levels that each food bank serves?

# Q3: What percentage of assigned neighborhoods are within 400m? 800m? 1200m? 1600m? 2000m? 2000m+?

## Follow up:
## Sarah needs information on Haringey, Hackney, Islington, Barnet, Camden

plotMap(1, "Comp", "London")
londonCompStats <- calcAllStats()
write.csv(londonCompStats[[1]], "./DataPres/londonFBs.csv")
write.csv(londonCompStats[[2]], "./DataPres/londonLSOAs.csv")
londonOver2000 <- as.numeric(as.character(londonCompStats[[2]][as.numeric(as.character(londonCompStats[[2]]$DistToSite))>2000,]$LsoaNum))
plot(lsoa.BNG[londonOver2000,], col="Red", add=T)

plotMap(1, "Comp", "Haringey")
haringeyCompStats <- boroughStats(londonCompStats, "Haringey")
haringeyCompStats[[1]]
haringeyCompStats[[2]]
haringeyOver2000 <- haringeyCompStats[[2]][as.numeric(as.character(haringeyCompStats[[2]]$DistToSite))>2000,]$LsoaNum
plot(lsoa.BNG[haringeyOver2000,], col="Red", add=T)
write.csv(haringeyCompStats[[1]], "./DataPres/haringeyFBs.csv")
write.csv(haringeyCompStats[[2]], "./DataPres/haringeyLSOAs.csv")

plotMap(1, "Comp", "Hackney")
hackneyCompStats <- boroughStats(londonCompStats, "Hackney")
hackneyCompStats[[1]]
hackneyCompStats[[2]]
hackneyOver2000 <- hackneyCompStats[[2]][as.numeric(as.character(hackneyCompStats[[2]]$DistToSite))>2000,]$LsoaNum
plot(lsoa.BNG[hackneyOver2000,], col="Red", add=T)
write.csv(hackneyCompStats[[1]], "./DataPres/hackneyFBs.csv")
write.csv(hackneyCompStats[[2]], "./DataPres/hackneyLSOAs.csv")

plotMap(1, "Comp", "Islington")
islingtonCompStats <- boroughStats(londonCompStats, "Islington")
islingtonCompStats[[1]]
islingtonCompStats[[2]]
islingtonOver2000 <- islingtonCompStats[[2]][as.numeric(as.character(islingtonCompStats[[2]]$DistToSite))>2000,]$LsoaNum
plot(lsoa.BNG[islingtonOver2000,], col="Red", add=T)
write.csv(islingtonCompStats[[1]], "./DataPres/islingtonFBs.csv")
write.csv(islingtonCompStats[[2]], "./DataPres/islingtonLSOAs.csv")

plotMap(1, "Comp", "Barnet")
barnetCompStats <- boroughStats(londonCompStats, "Barnet")
barnetCompStats[[1]]
barnetCompStats[[2]]
barnetOver2000 <- barnetCompStats[[2]][as.numeric(as.character(barnetCompStats[[2]]$DistToSite))>2000,]$LsoaNum
plot(lsoa.BNG[barnetOver2000,], col="Red", add=T)
write.csv(barnetCompStats[[1]], "./DataPres/barnetFBs.csv")
write.csv(barnetCompStats[[2]], "./DataPres/barnetLSOAs.csv")

plotMap(1, "Comp", "Camden")
camdenCompStats <- boroughStats(londonCompStats, "Camden")
camdenCompStats[[1]]
camdenCompStats[[2]]
camdenOver2000 <- camdenCompStats[[2]][as.numeric(as.character(camdenCompStats[[2]]$DistToSite))>2000,]$LsoaNum
plot(lsoa.BNG[camdenOver2000,], col="Red", add=T)
write.csv(camdenCompStats[[1]], "./DataPres/camdenFBs.csv")
write.csv(camdenCompStats[[2]], "./DataPres/camdenLSOAs.csv")

plotMap(1, "Comp", "Enfield")
enfieldCompStats <- boroughStats(londonCompStats, "Enfield")
enfieldCompStats[[1]]
enfieldCompStats[[2]]
enfieldOver2000 <- enfieldCompStats[[2]][as.numeric(as.character(enfieldCompStats[[2]]$DistToSite))>2000,]$LsoaNum
plot(lsoa.BNG[enfieldOver2000,], col="Red", add=T)
write.csv(enfieldCompStats[[1]], "./DataPres/enfieldFBs.csv")
write.csv(enfieldCompStats[[2]], "./DataPres/enfieldLSOAs.csv")



# Curiosity

plotMap(1, "Comp", "Bexley")
sing <- ttComp.plus.worship[5,]
# Turn to lat long to map with google
sing <- spTransform(sing, CRS("+init=epsg:4326"))
# Next to 35 is dark - remember we are going to the centroid of the LSOA and this one is quite large
# The closest road point could be far away.



plotMap(1, "Comp", "Croydon")
croydonCompStats <- boroughStats(londonCompStats, "Croydon")
croydonCompStats[[1]]
croydonCompStats[[2]]
croydonOver2000 <- croydonCompStats[[2]][as.numeric(as.character(croydonCompStats[[2]]$DistToSite))>2000,]$LsoaNum
plot(lsoa.BNG[croydonOver2000,], col="Red", add=T)
write.csv(croydonCompStats[[1]], "./DataPres/croydonFBs.csv")
write.csv(croydonCompStats[[2]], "./DataPres/croydonLSOAs.csv")

