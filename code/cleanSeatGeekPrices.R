library(jsonlite)
library(data.table)
library(dplyr)

setwd('C:/Users/g1mxb12/Desktop/nflTicketPrices/data/rawDataWorkspaces/seatgeek/')
path = 'C:/Users/g1mxb12/Desktop/nflTicketPrices/data/rawDataWorkspaces/seatgeek/'
out.file<-""
file.names <- dir(path, pattern =".RData")


data<- load(file.names[1])

for(i in length(prices)) {
  if(length(prices[[i]]) == 1) {
    rm(prices[[i]])
  }
}

