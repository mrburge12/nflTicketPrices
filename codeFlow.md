# Code Flow

# Pre-Processing

## Data Gathering - Seat Geek and Ticketmaster

1. `seatgeek.R`: 
 - Pulls data from Seat Geek API 
 - Takes in client_id number, client_secret number
 - Searches for all events under "nfl", uses the resulting event IDs to pull pricing info

2. `ticketmaster.R`
 - Pulls data from Ticketmaster API
 - Takes in API key, Consumer Secret, keyword, segment ID, segment Name, genre ID,genre Name, subgenre ID, subgenre Name, type Name, subtype ID, subtype Name, and size
 - Searches for all game listings, checks ticket inventory status, uses resulting event IDs to pull pricing info

3. `main.R` - calls `cleanWorkspaces.R`, `mergeEventData.R`,`mergePriceData.R`
 - Takes seatgeek and ticketmaster workspaces and restructures into data frames


## Data Gathering - 538 Data

1. `clean538SpreadsData.do`
 - Takes data from 538 excel spreadsheet
 - Generates hometeam/away team variables, week number variables, game date/game time variables

2. `cleanStandingsData.do`
 - Takes data from 538 excel spreadsheet
 - Generates pull_date variable

3. `cleanTMPrices.do`
 - Splits long json string into different variables
 - Calculates summary stats for ticket listings: `min_val`, `max_val`, `average_val`, `median_val`, `bottom_quartile`, `top_quartile`, `count`

4. `mergeData.do`
 - Cleans team names and replaces city names with mascot names
 - Tag whether team is home or away
 - Order variables

## Plots

1. `plots.do`
