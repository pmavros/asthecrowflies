# Calculates heading angle in degress and euclidean distance between locations.
# Author: Panos Mavros // UrbanCortex.org


# install required libraries
install.package(geosphere)
install.package(plotrix)
install.package(ggplot2)

# initialise required libraries
library(plotrix)
library(geosphere)
library(ggplot2)

# load a file with locations (points)
points <- read.csv("MyFile.csv")
summary(points)
str(points)


# examples of how the calculation works
# bearing(c(10,10), c(20,20))
# bearing(c(-0.1334453, 51.51499),c(-0.1316214, 51.51216))

number.of.bearings <- nrow(points)
number.of.bearings

# create an empty data frame, preallocate dummy contents, based on the total bearing number
# this method is faster tha adding/appending rows, see http://stackoverflow.com/questions/20689650/how-to-append-rows-to-an-r-data-frame
bearingsToPoints <- data.frame(counter=numeric(number.of.bearings), fromName=character(number.of.bearings), fromLon=numeric(number.of.bearings),fromLat=numeric(number.of.bearings), toName=character(number.of.bearings),toLon=numeric(number.of.bearings),toLat=numeric(number.of.bearings), bearing=numeric(number.of.bearings), euclideanM=numeric(number.of.bearings), euclideanKM=numeric(number.of.bearings),stringsAsFactors=FALSE)



# for every location point
for(i in 1:nrow(points)){  
  i
  bearingsToPoints$counter[i] <- points[i,1]
  bearingsToPoints$fromName[i] <- as.character(points$fromName[i])
  bearingsToPoints$fromLon[i] <- points$fromLon[i]
  bearingsToPoints$fromLat[i]<- points$fromLat[i]
  bearingsToPoints$toName[i] <- as.character(points$toName[i])
  bearingsToPoints$toLon[i] <- points$toLon[i]
  bearingsToPoints$toLat[i] <- points$toLat[i]
  bearingsToPoints$bearing[i]  <- bearing(c(points$fromLon[i], points$fromLat[i]),c(points$toLon[i], points$toLat[i]))   
  bearingsToPoints$euclideanM[i]  <- as.numeric(format(distm(c(points$fromLon[i], points$fromLat[i]),c(points$toLon[i], points$toLat[i])),2))
  bearingsToPoints$euclideanKM[i]  <- as.numeric(format(distm(c(points$fromLon[i], points$fromLat[i]),c(points$toLon[i], points$toLat[i]))/1000, 2))
}


# export to csv
write.csv(bearingsToPoints, "morelocations.csv")

plot(bearingsToPoints$euclideanM, type="l")
plot(bearingsToPoints$bearing, type="l")

ggplot() + geom_segment(data=bearingsToPoints,aes(x = centre[1], y = centre[2], xend = toLon, yend = toLat, size=euclideanM), color=2)+coord_map(project="mercator")

p <- ggplot()
for(i in 1:nrow(bearingsToPoints)){
 p + geom_segment(data=bearingsToPoints,aes(x = centre[1], y = centre[2], xend = toLon[i], yend = toLat[i], size=euclideanM), color=2)+coord_map(project="mercator")
}

ggplot(bearingsToPoints) + geom_point(aes(x = fromLon, y = fromLat, size=euclideanM), color=2)+coord_map(project="mercator")





for(i in 1:nrow(bearingsToPoints)){  
  if(bearingsToPoints$bearing[i] < 90){
    bearingsToPoints$col[i] <- 1
  }  else if(bearingsToPoints$bearing[i] >= 90 && bearingsToPoints$bearing[i] <180){
    bearingsToPoints$col[i] <- 2
  } else if(bearingsToPoints$bearing[i] >= 180 && bearingsToPoints$bearing[i] <270){
    bearingsToPoints$col[i] <- 3
  } else if(bearingsToPoints$bearing[i] >= 270 ){
    bearingsToPoints$col[i] <- 4
  } 
}


ggplot(bearingsToPoints, aes(x=bearing))+geom_bar(width=1) +coord_polar()

polar.plot(bearingsToPoints$euclideanM, bearingsToPoints$bearing, clockwise=TRUE, start=90,lwd=3,line.col=bearingsToPoints$col, main="Soho: DP bearings",grid.bg="transparent",show.radial.grid=FALSE,show.grid.labels=2,grid.unit='m')
