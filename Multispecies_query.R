# multispecies query

# We'll pull out 4 species: Lantana camara, Falcataria moluccana, Opuntia stricta, Miconia calvescens

# first we need the correct names

BIEN_occurrence_species("Falcataria moluccana")

#vector of species to examine
# test with:
# invasives <- c("Opuntia stricta", "Miconia calvescens")

# our project; 100 worst list

invasives <- c(
"Acacia mearnsii",
"Ardisia elliptica",
"Arundo donax",
"Cecropia peltata",
"Chromolaena odorata",
"Cinchona pubescens",
"Clidemia hirta",
"Euphorbia esula",
"Fallopia japonica",
"Hedychium gardnerianum",
"Hiptage benghalensis",
"Imperata cylindrica",
"Lantana camara",
"Leucaena leucocephala",
"Ligustrum robustum",
"Lythrum salicaria",
"Melaleuca quinquenervia",
"Miconia calvescens",
"Mikania micrantha",
"Mimosa pigra",
"Myrica faya",
"Opuntia stricta",
"Pinus pinaster",
"Prosopis glandulosa",
"Psidium cattleianum",
"Pueraria montana",
"Rubus ellipticus",
"Schinus terebinthifolia" , #"Schinus terebinthifolius",
"Spathodea campanulata",
"Sphagneticola trilobata",
"Tamarix ramosissima",
"Ulex europaeus")


invasive_tax<-BIEN_taxonomy_species(species = invasives)

g <- unique(invasive_tax$scrubbed_species_binomial)
h <- sort(g)
h

# the below compares our list to the list of species names in BIEN
# if they are the same, then we'll get out character(0)

setdiff(invasives, h)

# this will give all of the records for the above species 
# and will take a long time; maybe do as later step
#bien_out <- BIEN_occurrence_species(species = invasives,natives.only = F)

#invasives[which(invasives %in% bien_out$scrubbed_species_binomial)]

bquery<-BIEN_occurrence_species(species = invasives,natives.only = F,return.query=T)


pol.names <- BIEN_metadata_list_political_names()

#################
# this section is for writing all observations out to separate files
# incluing native range stuff

#this changes the directory to the file to populate
setwd("~/Desktop/R_scripts/BIEN_invasives.R/all_geoloc_records")


invasives


for( i in invasives){
  
  
  query <- paste("SELECT * FROM view_full_occurrence_individual
                 WHERE scrubbed_species_binomial in ('",i,"') ; ", sep ="")

    lc <- BIEN:::.BIEN_sql(query)
  
  # in the above, the SELECT * returns all the columns and metadata info,
  # so it may tak a long time
  
  
  # now we filter only the ones that pass the is_geovalid test, 
  # which necessarily means that there are lat/long coords
  
  lc_geovalid <- lc[which(lc$is_geovalid == 1),]
  #head(lc_geovalid)
  
  lc_inwild <- lc_geovalid[which(lc_geovalid$is_cultivated_observation==0),]
  #head(lc_inwild)
  
  #then filter out centroids
  
  lc_inwild_no_cent <- lc_inwild[which(lc_inwild$is_centroid!=1 | is.na(lc_inwild$is_centroid)),]
  
  write.csv(x = lc_inwild_no_cent,file = paste(gsub(i,pattern = " ",replacement = "_"),".csv",sep=""))
      
print(i)  
  
}


