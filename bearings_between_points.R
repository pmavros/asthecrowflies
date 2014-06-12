install.package(geosphere)
library(geosphere)

# load a file with locations (points)
points <- read.csv("claudia_soho.csv")
summary(points)
str(points)


# examples of how the calculation works
bearing(c(10,10), c(20,20))
bearing(c(-0.1334453, 51.51499),c(-0.1316214, 51.51216))


# how many points I have?
number.of.points <- nrow(points)

# how many bearings from each point to all others (excluding self)?
# we want this to predict how many elements we will have at the end
number.of.bearings <- number.of.points ^2-number.of.points

# create an empty data frame, preallocate dummy contents, based on the total bearing number
# this method is faster tha adding/appending rows, see http://stackoverflow.com/questions/20689650/how-to-append-rows-to-an-r-data-frame
bearingsToPoints <- data.frame(from=numeric(number.of.bearings), to=numeric(number.of.bearings), fromName=character(number.of.bearings), toName=character(number.of.bearings), bearing=numeric(number.of.bearings), euclideanM=numeric(number.of.bearings), euclideanKM=numeric(number.of.bearings),stringsAsFactors=FALSE)

index  <-  0 # this will take us through each line

# for every location point
for(i in 1:nrow(points)){  
  
  # for every other location point
  for(j in 1:nrow(points)){
    if(j !=i) # exclude the self
    {
      index  <-  index+1
      bearingsToPoints$from[index] <- i 
      bearingsToPoints$to[index] <- j 
      bearingsToPoints$fromName[index] <- as.character(points$Name[i] )
      bearingsToPoints$toName[index] <- as.character(points$Name[j])
      bearingsToPoints$bearing[index]  <- bearing(c(points$X[i], points$Y[i]),c(points$X[j], points$Y[j]))  
      bearingsToPoints$euclideanM[index]  <- format(distm(c(points$X[i], points$Y[i]),c(points$X[j], points$Y[j])),2)
      bearingsToPoints$euclideanKM[index]  <- format(distm(c(points$X[i], points$Y[i]),c(points$X[j], points$Y[j]))/1000, 2)
    }
  }
}

# export to csv
write.csv(bearingsToPoints, "locations.csv")

