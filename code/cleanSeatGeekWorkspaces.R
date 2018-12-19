library(jsonlite)
library(data.table)
library(dplyr)

setwd('C:/Users/g1mxb12/Desktop/nflTicketPrices/data/rawDataWorkspaces/seatgeek/')
path = 'C:/Users/g1mxb12/Desktop/nflTicketPrices/data/rawDataWorkspaces/seatgeek/'
out.file<-""
file.names <- dir(path, pattern =".RData")


#Loop through workspaces
for(i in 1:length(file.names)){
  data <- load(file.names[i])
  #Set up all of the individual data frames
  #Start with main event data
  eventData<-response$events
  
  #Pull out nested data frames
  dropStatsCols<- c("dq_bucket_counts")
  
  dupCols<- c("created_at", "employee_only", "id", "score", "url", "method", "popularity")
  stats<-eventData$stats[,!names(eventData$stats) %in% dropStatsCols]
  for (col in dupCols) {
    colnames(stats)[colnames(stats)== col] <- paste(col,"_stats", sep = "")
    
  }
  
  access_method<-eventData$access_method
  for (col in dupCols) {
    colnames(access_method)[colnames(access_method)== col] <- paste(col,"_accessMethod", sep = "")
    
  }
  
  #There's two nested data frames in the venue data frame, which is itself nested in eventData
  #These two data frames are separated from the rest of the venue data frame
  eventLocationLongLat<-eventData$venue$location
  venueAccess_method<-eventData$venue$access_method
  for (col in dupCols) {
    colnames(venueAccess_method)[colnames(venueAccess_method)== col] <- paste(col,"_AccessMethod", sep = "")
    
  }
  #These two lines of code remove columns from a data frame by name
  #the purpose of un-nesting the data is to avoid duplication and to make
  #dat easier to export
  dropVenueDataCols<- c("location", "access_method", "links")
  venue<-eventData$venue[,!names(eventData$venue) %in% dropVenueDataCols]
  for (col in dupCols) {
    colnames(venue)[colnames(venue)== col] <- paste(col,"_venue", sep = "")
    
  }
  
  #At this point, we exclude taxonomies, performers, and links (they don't provide any necessary info for pricing)
  #they are also going to be costly to clean up due to their nested nature.
  #this is something I can revisit later if necessary
  #We remove columns from eventData if they are listed in another dataframe
  dropEventDataCols <- c("stats", "venue", "access_method", "taxonomies","announcements", "performers", "links", "dq_bucket_counts")
  eventData<- eventData[ , !(names(eventData) %in% dropEventDataCols)]

  #fix timestamp variable
  timestamp<-gsub(" ", "_", timestamp)
  timestamp<-gsub(":",".", timestamp)
  date<-substr(x = timestamp,1,10)
  
  #Combine dataframes to export
  finalEventData<-as.data.table(cbind(date,timestamp, eventData, stats, access_method, venue, eventLocationLongLat, venueAccess_method))
  
  outputFileName <- paste("C:/Users/g1mxb12/Desktop/nflTicketPrices/data/seatgeek/cleanData/eventData/individual/sg_", timestamp, ".csv",sep="") 
  #write.csv(finalEventData, file = outputFileName) 
}

