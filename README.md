asthecrowflies
==============

R script to calculate bearings and distance between series of points

This is a script that takes a number of locations (latitude - longitude) and returns a csv file with all the bearings and euclidean distances between the points/locations.

This repo contains two scripts:

1. **bearings_between_points.R**
calculates headings and distances between a series of locations. The locations have to be on the same column and then the script iterates throught the list and calculates ALL the possible headings between ALL points. **If you have many points this can get heavy...** Expected csv file header: counter,	Name,	Lon,	Lat;



2. **origin_destination_plot.R** This script takes an origin-destination pair and calculates the heading from A to B and the euclidean distance between. Expected csv file header: counter,	fromName,	fromLon,	fromLat,	toName,	toLon,	toLat,	bearing,	euclideanM,	euclideanKM;

