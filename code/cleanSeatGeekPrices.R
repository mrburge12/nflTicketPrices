library(jsonlite)
library(data.table)
library(dplyr)

setwd('C:/Users/g1mxb12/Desktop/nflTicketPrices/data/rawDataWorkspaces/seatgeek/')
path = 'C:/Users/g1mxb12/Desktop/nflTicketPrices/data/rawDataWorkspaces/seatgeek/'
out.file<-""
file.names <- dir(path, pattern =".RData")



for(i in 1:length(file.names)) {
  finalPriceData<-data.frame()
  load(file.names[i])
  for(j in 1:length(prices)) {
   priceData<-rbind(prices[[j]])
  finalPriceData<-merge(priceData,finalPriceData)
  }
}

