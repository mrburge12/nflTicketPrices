############################################################################################
## Preliminaries
############################################################################################

library(jsonlite)
library(data.table)
library(dplyr)


##############

## SET FLAGS!

##############

sgFlag <- 1
tmFlag <- 1



############################################################################################
## Merge the Data
############################################################################################

if(sgFlag == 1) {
  path = 'C:/Users/g1mxb12/Desktop/nflTicketPrices/data/seatgeek/cleanData/eventData/individual'
  setwd(path)
  file.names <- dir(path, pattern =".csv")
  
  
  #Initialize data to merge with by pulling in the first available data frame
  finalData <- read.csv(file.names[1])
  finalData<-as.data.table(finalData)
  
  
  for(i in 2:length(file.names)){
    data <- read.csv(file.names[i])
    data <- as.data.table(data)
    finalData<- rbind(data, finalData, fill = TRUE) 
    finalData<- finalData %>%
      select(noquote(order(colnames(finalData))))
    finalData<- finalData[!duplicated(finalData),]
  }
  
  outputFileName <- paste("C:/Users/g1mxb12/Desktop/nflTicketPrices/data/seatgeek/cleanData/eventData/finalData",Sys.Date(),".csv",sep="") 
  write.csv(finalData, file = outputFileName) 
    
}


if(tmFlag == 1) {
  path = 'C:/Users/g1mxb12/Desktop/nflTicketPrices/data/ticketmaster/cleanData/eventData/individual'
  setwd(path)
  file.names <- dir(path, pattern =".csv")
  
  #Initialize data to merge with by pulling in the first available data frame
  finalData <- read.csv(file.names[1])
  finalData<-as.data.table(finalData)
  
  
  
  for(i in 2:length(file.names)){
    data <- read.csv(file.names[i])
    data <- as.data.table(data)
    finalData<- rbind(data, finalData, fill = TRUE) 
    finalData<- finalData %>%
      select(noquote(order(colnames(finalData))))
    finalData<- finalData[!duplicated(finalData),]
  }
  
  outputFileName <- paste("C:/Users/g1mxb12/Desktop/nflTicketPrices/data/ticketmaster/cleanData/eventData/finalData",Sys.Date(),".csv",sep="") 
  write.csv(finalData, file = outputFileName) 
}
