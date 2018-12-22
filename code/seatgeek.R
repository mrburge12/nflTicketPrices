
#install.packages(c("tidyverse", "stringr", "knitr", "curl", "jsonlite", "XML", "httr", "rvest", "ggmap"))

setwd('C:/Users/mrbur/Desktop/nflTicketPrices/code')

library(stringr)
library(knitr)
library(curl)
library(jsonlite)
library(httr)
library(rvest)

timestamp<-Sys.time()


client_id<-"MTI0MTQ5NzR8MTUzMjYxOTczNC4wMw"
client_secret<-"6a9738d0c19f46825345dc5f47527b906a42c176a643b86adca2fd2ecbea65ad"
q<-"nfl"
perpage<-1000


seatGeekListings <- vector("numeric") 
response<- vector("numeric")
answer_json<- vector("numeric")

# Function for API Query


seatGeekLink <- function(client_id, client_secret, q){
  rootURL<-"https://api.seatgeek.com/2/events?"
  params<-c( "per_page=" , "client_id=", "client_secret=","q=")
  values<- c(perpage, client_id, client_secret, q)
  args<- str_c(params, values, collapse = "&")
  str_c(rootURL, args)
  }

seatGeekListings<-seatGeekLink(client_id,client_secret,q)
con<-curl(seatGeekListings)
answer_json<-readLines(con)

response<- 
  answer_json %>%
  prettify() %>%
  fromJSON()


game<-response$events$title
eventData<-response$events

data<-response$events

## GET PRICING DATA
priceInfo <- vector("numeric", nrow(data)) 
prices<- matrix("numeric", nrow=length(data[,1]), ncol=length(data[,1]))
answer_json<- vector("numeric", nrow(data))

for(i in 1:nrow(data)) {
  eventID <- data$id[i]
  priceLink <- function(client_id, client_secret){
    rootURL<-"https://api.seatgeek.com/2/events?"
    params<-c("id=", "client_id=", "client_secret=")
    values<- c(eventID, client_id, client_secret )
    args<- str_c(params, values, collapse = "&")
    str_c(rootURL, args)
  }
  
  priceInfo[i]<-priceLink(client_id, client_secret)
  con<-curl(priceInfo[i])
  answer_json[i]<-readLines(con)
  
  prices[i]<- answer_json[i]
  #prices[i]<-gsubfn(".",list("\\{"= "", "\\}" = "", ":" = "", "\"" = "", "," = "|", "\\}\\]\\}" = "","{{" = "", "}}" = "", "\\}\\]" = "", "\\[\\{" = "" , "\\{in_hand\\{\\}" = "" , "\\[\\]" = ""), prices[i])
  #prices[i]<-prettify(prices[i])
        }



#for(i in 1:nrow(data)) {
 # prices[i]<-strsplit(prices[i],"|", fixed=TRUE)
#}


save.image("C:/Users/mrbur/Desktop/nflTicketPrices/data/rawDataWorkspaces/seatgeek/sg_2018-12-22.RData")
#install.packages(c("tidyverse", "stringr", "knitr", "curl", "jsonlite", "XML", "httr", "rvest", "ggmap"))
