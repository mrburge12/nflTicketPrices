library(jsonlite)
library(data.table)
library(dplyr)

setwd('C:/Users/g1mxb12/Desktop/nflTicketPrices/data/rawDataWorkspaces/ticketmaster/')
path = 'C:/Users/g1mxb12/Desktop/nflTicketPrices/data/rawDataWorkspaces/ticketmaster/'
file.names <- dir(path, pattern =".RData")

for(i in 1:length(file.names)){
  data <- load(file.names[i])
  eventData<-response$`_embedded`$events
  
  #fix timestamp variable
  timestamp<-gsub(" ", "_", timestamp)
  timestamp<-gsub(":",".", timestamp)
  date<-substr(x = timestamp,1,10)
  
  #dataframes
  #sales
  publicSales<- eventData$sales$public
  presales<-eventData$sales$presales
  presales<-rbindlist(presales, fill = TRUE)
  
  #dates
  startDates<-eventData$dates$start
  status<- eventData$dates$status
  dropDatesDataCols <- c("start","status", "access", "end")
  dates<- eventData$dates[ , !(names(eventData$dates) %in% dropDatesDataCols)]
  
  #promoter
  promoter<-eventData$promoter
  
  #priceranges
  priceRanges<-rbindlist(eventData$priceRanges, fill = TRUE)
  
  #seatmap
  seatmap <- eventData$seatmap
  
  #
  ticketLimit <- eventData$ticketLimit
  
  
  #accessibility
  accessibility <- eventData$accessibility
  embedded <- eventData$`_embedded`
  links <- eventData$`_links`
  
  
  
  dropEventDataCols <- c("access","end","place","outlets","info", "priceRanges", "presales", "pleaseNote","images", "sales", "classifications", "products", "promoters", "_links", "_embedded", "publicSales", "presales", "startDates", "status", "dates", "promoter", "priceRanges", "seatmap", "ticketLimit", "accessibility")
  eventData<- eventData[ , !(names(eventData) %in% dropEventDataCols)]
  
  #Combine dataframes to export
  finalEventData<-as.data.table(cbind(date, timestamp, eventData, publicSales, startDates, status, dates, promoter, seatmap, ticketLimit, accessibility))
  
  outputFileName <- paste("C:/Users/g1mxb12/Desktop/nflTicketPrices/data/ticketmaster/cleanData/eventData/individual/tm_", timestamp, ".csv",sep="") 
  write.csv(finalEventData, file = outputFileName) 
  
}

