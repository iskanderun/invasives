#Lantana camara

#install.packages("BIEN")
library(BIEN)


#the following is set up as package, three colons, internal function
# the three colons allow you to see the internal package commands
lc <- BIEN:::.BIEN_sql("SELECT * FROM view_full_occurrence_individual
                 WHERE scrubbed_species_binomial in ('Lantana camara') ; ")

# in the above, the SELECT * returns all the columns and metadata info,
# so it may take a long time


# now we filter only the ones that pass the is_geovalid test, 
# which necessarily means that there are lat/long coords

lc_geovalid <- lc[which(lc$is_geovalid == 1),]
head(lc_geovalid)

lc_inwild <-lc_geovalid[which(lc_geovalid$is_cultivated_observation==0),]

head(lc_inwild)

#then filter out centroids

lc_inwild_no_cent <-lc_inwild[which(lc_inwild$is_centroid!=1 | is.na(lc_inwild$is_centroid)),]


#here, we look at date collected
lc_inwild_no_cent$date_collected

#need to pull out the year collected
#strsplit(x = lc_inwild$date_collected,split = "-")
hist(as.Date(x = lc_inwild_no_cent$date_collected),breaks = 100)

hist(as.Date(x = lc_inwild_no_cent$date_collected[which(lc_inwild_no_cent$is_introduced==1)]),breaks = 100,freq = T)

#centroid relative is assigned to be the lowest score to the closest centroid
hist(x = lc_inwild_no_cent$centroid_dist_relative,breaks = 100,freq = T)

