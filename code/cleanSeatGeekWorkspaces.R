library(jsonlite)
library(data.table)
setwd('C:/Users/mrbur/Desktop/nflTicketPrices/data/rawDataWorkspaces/seatgeek')
path = 'C:/Users/mrbur/Desktop/nflTicketPrices/data/rawDataWorkspaces/seatgeek'
out.file<-""
file.names <- dir(path, pattern =".RData")


#initialize data tables
finalData<- data.table()
finalPriceData<-data.table()

#Loop through workspaces
for(i in 1:length(file.names)){
  data <- load(file.names[i])
  #Set up all of the individual data frames
  #Start with main event data
  eventData<-response$events
  
  #Pull out nested data frames
  dropStatsCols<- c("dq_bucket_counts")
  stats<-eventData$stats[,!names(eventData$stats) %in% dropStatsCols]
  
  access_method<-eventData$access_method
  
  #There's two nested data frames in the venue data frame, which is itself nested in eventData
  #These two data frames are separated from the rest of the venue data frame
  eventLocationLongLat<-eventData$venue$location
  venueAccess_method<-eventData$venue$access_method
  
  #These two lines of code remove columns from a data frame by name
  #the purpose of un-nesting the data is to avoid duplication and to make
  #dat easier to export
  dropVenueDataCols<- c("location", "access_method", "links")
  venue<-eventData$venue[,!names(eventData$venue) %in% dropVenueDataCols]
  
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
  finalData<- rbind(finalEventData, finalData, fill = TRUE) 


  pricesOutputFileName<- paste("C:/Users/mrbur/Desktop/nflTicketPrices/data/seatgeek/cleanData/priceData/sg_",timestamp,".json",sep="")
  write_json(prices, path = pricesOutputFileName)
}




outputFileName <- paste("C:/Users/mrbur/Desktop/nflTicketPrices/data/seatgeek/cleanData/eventData/finalData",".csv",sep="") 
write.csv(finalData, file = outputFileName) 
  

