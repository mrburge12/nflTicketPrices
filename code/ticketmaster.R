
#install.packages(c("tidyverse", "stringr", "knitr", "curl", "jsonlite", "XML", "httr", "rvest", "ggmap"))
library(tidyverse)
library(stringr)
library(knitr)
library(curl)
library(jsonlite)
library(XML)
library(httr)
library(rvest)
library(ggmap)
library(dplyr)
library(rlist)
library(gsubfn)

timestamp<-Sys.time()
date<-Sys.Date()

###################
## Pull Event Data
###################

apiKey<-"BDMDMNv2wXwAZMRAlavHs371eUadxLbq"
consumerSecret<-"o8eJaby9afZL45s3"
keyword<-"NFL"
segmentID<-"KZFzniwnSyZfZ7v7nE"
sementName<-"Sports"
genreID<-"KnvZfZ7vAdE"
genreName<-"Football"
subgenreID<-"KZazBEonSMnZfZ7vFE1"
subgenreName<-"NFL"
typeName<-"Group"
subtypeID<-"KZFzBErXgnZfZ7vA7d"
subtypeName<-"Team"
size<-200


# Function for API Query

ticketMasterLink <- function(apiKey, keyword, size){
  rootURL<-"https://app.ticketmaster.com/discovery/v2/events.json?"
  params<-c( "apikey=", "keyword=","size=")
  values<- c(apiKey, keyword, size)
  args<- str_c(params, values, collapse = "&")
  str_c(rootURL, args)
}


# requestNFLGames
nflGames<-ticketMasterLink(apiKey,keyword,size)
con<-curl(nflGames)
answer_json<-readLines(con)

response<- 
  answer_json %>%
  prettify() %>%
  fromJSON()


eventData<-response$`_embedded`$events
eventData<-eventData[!(eventData$dates$status$code %in% c("offsale")), ] 
eventData<-eventData[(eventData$promoter$id %in% c("705")), ]


#############################
## Pull Inventory Status Data
#############################

inventoryInfo <- vector("numeric", nrow(eventData)) 
inventory<- vector("numeric", nrow(eventData))
answer_json<- vector("numeric", nrow(eventData))

for (i in 1:nrow(eventData)) {
  inventoryStatusLink <- function(apiKey, eventID){
    eventID <- eventData[i,3]

    rootURL<-"https://app.ticketmaster.com/inventory-status/v1/availability?"
    params<-c("events=", "apikey=")
    values<- c(eventID, apiKey)
    args<- str_c(params, values, collapse = "&")
    str_c(rootURL, args)
  }
  inventoryInfo[i]<-inventoryStatusLink(apiKey,eventID)
  con<-curl(inventoryInfo[i])
  answer_json[i]<-readLines(con)
  

  inventory[i]<- 
  answer_json[i] %>%
  prettify() %>%
  fromJSON()
}



inventoryStatus<-str_replace_all(answer_json, '\\}', "")
inventoryStatus<-str_replace_all(inventoryStatus, '\\]', "") 
inventoryStatus<-str_replace_all(inventoryStatus, '""', "")
inventoryStatus<-str_replace_all(inventoryStatus, '\"', "")
inventoryStatus<-str_replace_all(inventoryStatus, '\\[', "")
inventoryStatus<-str_replace_all(inventoryStatus, '\\:', "")
inventoryStatus<-str_replace_all(inventoryStatus, '\\,', "")
inventoryStatus<-str_replace_all(inventoryStatus, '\\{', "")
inventoryStatus<-str_replace_all(inventoryStatus, "eventId","") 
inventoryStatus<-str_replace_all(inventoryStatus, "status","") 
inventoryStatus<-str_replace_all(inventoryStatus,"FEW_TICKETS_LEFT", "")
inventoryStatus<-str_replace_all(inventoryStatus,"FEWTICKETSLEFT", "")
inventoryStatus<-str_replace_all(inventoryStatus,"TICKETS_AVAILABLE", "")
inventoryStatus<-str_replace_all(inventoryStatus,"TICKETSAVAILABLE", "")
inventoryStatus<-inventoryStatus[!grepl("TICKETSNOTAVAILABLE", inventoryStatus)]
inventoryStatus<-inventoryStatus[!grepl("TICKETS_NOT_AVAILABLE", inventoryStatus)]


inventoryStatus<-inventoryStatus[!inventoryStatus == "k7vGF4krY_byt"]
inventoryStatus<-inventoryStatus[!inventoryStatus == "vvG1zZ46eEGtzP"]
inventoryStatus<-inventoryStatus[!inventoryStatus == "k7vGF4krY3IzP"]
inventoryStatus<-inventoryStatus[!inventoryStatus == "k7vGF4krY9Iyx"]
inventoryStatus<-inventoryStatus[!inventoryStatus == "k7vGF4krY4Iy8"]
inventoryStatus<-inventoryStatus[!inventoryStatus == "k7vGF4krYfIyG"]
inventoryStatus<-inventoryStatus[!inventoryStatus == "k7vGF4krYobzq"]
inventoryStatus<-inventoryStatus[!inventoryStatus == "k7vGF4krYbbyJ"]
inventoryStatus<-inventoryStatus[!inventoryStatus == "vvG1zZ46e154S9"]


############################
## Pull Commerce/Price Data
############################

priceInfo <-vector("numeric", length(inventoryStatus))
prices<-vector("numeric", length(inventoryStatus))
answer_json<- vector("numeric", length(inventoryStatus))

for(i in 1:length(inventoryStatus)) {
  eventID <- inventoryStatus[i]
  commerceLink <- function(apiKey, eventID){
    rootURL<-"https://app.ticketmaster.com/commerce/v2/events"
    params<-c("/", "/offers.json?apikey=")
    values<- c(eventID, apiKey)
    args<- str_c(params, values, collapse = "")
    str_c(rootURL, args)
  }

  priceInfo[i]<-commerceLink(apiKey,eventID)
  con<-curl(priceInfo[i])
  answer_json[i]<-readLines(con)


  
  
  prices[i]<- 
      answer_json[i] %>%
      minify()
      
}


save.image("C:/Users/mrbur/Desktop/nflTicketPrices/data/rawDataWorkspaces/ticketmaster/tm_2018-12-21.RData")
