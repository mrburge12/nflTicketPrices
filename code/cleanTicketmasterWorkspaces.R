library(jsonlite)
library(data.table)
library(dplyr)

setwd('C:/Users/g1mxb12/Desktop/nflTicketPrices/data/rawDataWorkspaces/ticketmaster/')
path = 'C:/Users/g1mxb12/Desktop/nflTicketPrices/data/rawDataWorkspaces/ticketmaster/'
out.file<-""
file.names <- dir(path, pattern =".RData")

for(i in 1:length(file.names)){
  data <- load(file.names[i])
  eventData<-response$`_embedded`$events
  
  #fix timestamp variable
  timestamp<-gsub(" ", "_", timestamp)
  timestamp<-gsub(":",".", timestamp)
  date<-substr(x = timestamp,1,10)
  
  #dataframes
  sales <- eventData$sales
  dates <- eventData$dates
  promoter <- eventData$promoter
  seatmap <- eventData$seatmap
  ticketLimit <- eventData$ticketLimit
  accessibility <- eventData$accessibility
  embedded <- eventData$`_embedded`
  links <- eventData$`_links`
  
  
  
  dropEventDataCols <- c("sales", "dates", "promoter", "seatmap","ticketLimit", "accessibility", "`_embedded`", "`_links`")
  eventData<- eventData[ , !(names(eventData) %in% dropEventDataCols)]
  #Combine dataframes to export
  finalEventData<-as.data.table(cbind(date,timestamp, eventData, sales, dates, promoter, ticketLimit, accessibility, embedded, links))
  
  outputFileName <- paste("C:/Users/g1mxb12/Desktop/nflTicketPrices/data/ticketmaster/cleanData/eventData/individual/tm_", timestamp, ".csv",sep="") 
  write.csv(finalEventData, file = outputFileName) 
}



data <- load(file.names[1])
eventData<-response$`_embedded`$events

#fix timestamp variable
timestamp<-gsub(" ", "_", timestamp)
timestamp<-gsub(":",".", timestamp)
date<-substr(x = timestamp,1,10)

#dataframes
publicSales <- eventData$sales$public
dates<-eventData$dates
promoter <- eventData$promoter
seatmap <- eventData$seatmap
ticketLimit <- eventData$ticketLimit
accessibility <- eventData$accessibility
embedded <- eventData$`_embedded`
links <- eventData$`_links`
priceRange<- rbindlist(eventData$priceRanges, fill = TRUE)
startDates <- eventData$dates$start
status<-dates$status

dropDatesDataCols <- c("start", "status")
eventData$dates<- eventData$dates[ , !(names(eventData$dates) %in% dropDatesDataCols)]


dropSalesDataCols <- c("presales")
eventData$sales<- eventData$sales[ , !(names(eventData$sales) %in% dropSalesDataCols)]

dropEventDataCols <- c("start","public","_embedded","_links","priceRanges", "products","startDates","promoters", "status", "dates", "classifications", "images","sales", "priceRange", "dates", "promoter", "seatmap","ticketLimit", "accessibility", "`_embedded`", "`_links`")
eventData<- eventData[ , !(names(eventData) %in% dropEventDataCols)]
#Combine dataframes to export
finalEventData<-as.data.table(cbind(date,timestamp, eventData, publicSales, startDates, status, dates, promoter, ticketLimit, accessibility, priceRange, embedded, links))

outputFileName <- paste("C:/Users/g1mxb12/Desktop/nflTicketPrices/data/ticketmaster/cleanData/eventData/individual/tm_", timestamp, ".csv",sep="") 
write.csv(finalEventData, file = outputFileName) 
