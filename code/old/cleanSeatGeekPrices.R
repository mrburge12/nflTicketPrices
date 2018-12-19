library(jsonlite)
library(data.table)
library(dplyr)

setwd('C:/Users/g1mxb12/Desktop/nflTicketPrices/data/rawDataWorkspaces/seatgeek/')
path = 'C:/Users/g1mxb12/Desktop/nflTicketPrices/data/rawDataWorkspaces/seatgeek/'
out.file<-""
file.names <- dir(path, pattern =".RData")


#finalPriceData<-data.table()

for(i in 1:length(file.names)) {
  load(file.names[i])
  for(j in 1:length(prices)) {
    if(length(prices[[j]]) > 5) {
      test <- lapply(prices[[j]], data.table)
    }
  }
  test<- as.data.frame(test)
}

