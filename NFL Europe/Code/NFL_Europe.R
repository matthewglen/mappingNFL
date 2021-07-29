# This is code looks to replicate the NFL teams if they were in Europe
# Libraries ####
library(tidyverse)
library(ggplot2)
library(ggmap)
library(maps)
library(mapdata)
library(rnaturalearth)
library(rgeos)
library(geosphere)
library(ggrepel)
library(jpeg)
library(grid)
library(ggimage)

# Data ####
# Teams data
teams <- read.csv(url("https://raw.githubusercontent.com/matthewglen/mappingNFL/main/data/teams.csv"))
teams = subset(teams, select = -X )
# 2020
teams2020 <- teams %>%
  filter(Year == 2020)
# Cities
cities <- read.csv("worldcities.csv")

# Base Plots ####
## USA ####
# USA map with state borders data
states <- map_data("state")
# Plot teams in USA
usa_plot <- ggplot(teams2020, aes(x = Long, y = Lat, colour = Division)) + 
  # Plot a blank map of the US
  geom_polygon(data = states, aes(x=long, y = lat, group = group), fill = NA, 
               color = "black") +
  # Fix the co-ordinates so it looks the right sort of shape
  coord_fixed(1.3) +
  # Points
  geom_point() +
  # Theme elements to make it look map like
  theme(panel.grid = element_blank(),
        panel.background = element_blank(),
        axis.title = element_blank(),
        axis.text = element_blank(),
        axis.ticks.y = element_blank(),
        axis.ticks = element_blank(),
        plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5)) +
  geom_label_repel(aes(label = Team), size = 3, show.legend = FALSE) +
  # Map labels
  labs(title = "Location of NFL Teams - 2020",
       subtitle = "Largest distance: Dolphins<->Seahawks: ~4381.89km/~2722.79 mi",
       caption = "@mattglen_\ngithub.com/matthewglen")

usa_plot

## Europe ####
world <- rnaturalearth::countries110
europe <- world[world$region_un=="Europe",]
# A box to define continental Europe
europe.bbox <- SpatialPolygons(list(Polygons(list(Polygon(
  matrix(c(25,29,45,29,45,75,-25,75,-25,29),byrow = T,ncol = 2)
)), ID = 1)), proj4string = CRS(proj4string(europe)))
# Get polygons that are only in continental Europe.
europe.clipped <-
  {{rgeos::gIntersection(europe, europe.bbox, byid = TRUE, id=europe$id)}}

# Plot NFL teams over Europe
europe_pre_flip <- ggplot(teams2020, aes(x = Long, y = Lat, color = Division)) +
  # Plot a blank map of the US
  geom_polygon(data = europe.clipped, aes(x=long, y = lat, group = group), fill = NA, 
               color = "black") +
  # Fix the co-ordinates so it looks the right sort of shape
  coord_fixed(1.3) +
  # Theme elements to make it look map like
  theme(panel.grid = element_blank(),
        panel.background = element_blank(),
        axis.title = element_blank(),
        axis.text = element_blank(),
        axis.ticks.y = element_blank(),
        axis.ticks = element_blank(),
        plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5)) +
  geom_point(data = teams2020, aes(x = (Long+115), y = (Lat + 12), color = Division), size = 3) +
  # Map labels
  labs(title = "Location of NFL Teams Overlaid on Europe",
       subtitle = "Latitude and longitude adjusted slightly to overlap map",
       caption = "@mattglen_\ngithub.com/matthewglen")

europe_pre_flip

# Adjust locations ####
# Flip the points, to swap the coasts
adjusted <- teams2020
adjusted$city = ""
# Adjusted the lat and long to get over Europe
adjusted$Lat <- (adjusted$Lat + 12)
adjusted$Long <- (-(adjusted$Long + 80))

# Plot the NFL teams mirrored
europe_flipped <- ggplot(adjusted, aes(x = Long, y = Lat, color = Division)) +
  # Plot a blank map of the US
  geom_polygon(data = europe.clipped, aes(x=long, y = lat, group = group), fill = NA, 
               color = "black") +
  # Fix the co-ordinates so it looks the right sort of shape
  coord_fixed(1.3) +
  # Theme elements to make it look map like
  theme(panel.grid = element_blank(),
        panel.background = element_blank(),
        axis.title = element_blank(),
        axis.text = element_blank(),
        axis.ticks.y = element_blank(),
        axis.ticks = element_blank(),
        plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5)) +
  geom_point(data = adjusted, aes(x = Long, y = Lat, colour = Division), size = 3) +
  # Map labels
  labs(title = "Location of NFL Teams Overlaid on Europe",
       subtitle = "Flipped to bring USA East Coast teams to Western Europe",
       caption = "@mattglen_\ngithub.com/matthewglen")

europe_flipped

# European cities ####
# Remove all cities with fewer than 750,000 people
# Particular exception for Belfast and Cardiff because they don't fit the first
# two arguments and they'll be needed later
big_cities <- cities %>%
  filter(
    population > 750000 |
    capital == "primary" |
    city == "Belfast" |
    city == "Caerdydd"
  )
# Keep only the countries where there's likely to be dots.
# Bit of a manual trial and error job
euro_cities <- big_cities %>%
  filter(
    country == "Ireland" |
    country == "United Kingdom" |
    country == "France" |
    country == "Spain" |
    country == "Netherlands" |
    country == "Belgium" |
    country == "Denmark" |
    country == "Sweden" |
    country == "Germany" |
    country == "Italy" |
    country == "Bosnia and Herzegovina" |
    country == "Albania" |
    country == "Croatia" |
    country == "Poland" |
    country == "Ukraine" |
    country == "Russia" |
    country == "Belarus" |
    country == "Czech Republic" |
    country == "Wales"
  )

# Cities and teams ####
# Plot the adjusted teams and major cities
euro_teams_cities <- ggplot(adjusted, aes(x = Long, y = Lat)) +
  # Plot a blank map of the US
  geom_polygon(data = europe.clipped, aes(x=long, y = lat, group = group), fill = NA, 
               color = "black") +
  # Fix the co-ordinates so it looks the right sort of shape
  coord_fixed(1.3) +
  # Theme elements to make it look map like
  theme(panel.grid = element_blank(),
        panel.background = element_blank(),
        axis.title = element_blank(),
        axis.text = element_blank(),
        axis.ticks.y = element_blank(),
        axis.ticks = element_blank(),
        plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5)) +
  geom_point(data = adjusted, aes(x = Long, y = Lat, colour = Division), size = 3) +
  geom_point(data = euro_cities, aes(x = lng, y = lat), size = 1) +
  # Map labels
  labs(title = "Hypothetical European NFL and Major European Cities (Pop ≥ 0.5m)",
       subtitle = "Exceptions made for Cardiff and Belfast",
       caption = "@mattglen_\ngithub.com/matthewglen")

euro_teams_cities

# Closest cities ####
# Add a column to adjusted for the distance. Set to something large for logic later
adjusted$distance = 99999999
adjusted$newLat <- 0
adjusted$newLong <- 0
adjusted$pop <- 0
adjusted$country <- ""

# Work out distances between 32 teams and closest city
for (row in 1:nrow(adjusted)) {
  lon1 <- adjusted[row, "Long"]
  lat1 <- adjusted[row, "Lat"]
  currentDist <- adjusted[row, "distance"]
  num <- row
  
  for (row in 1:nrow(euro_cities)) {
    lon2 <- euro_cities[row, "lng"]
    lat2 <- euro_cities[row, "lat"]
    city <- euro_cities[row, "city"]
    
    distance <- distm(c(lon1, lat1), c(lon2, lat2), fun = distHaversine)
    
    if (distance[1,1] < currentDist) {
      adjusted[num, 9] = city
      currentDist <- distance[1,1]
      adjusted[num, 10] = currentDist
    }
  }
}

# Manually adjust some. E.g. Packers and Bears same city, doesn't work.
# Pats, NYG, NYJ doesn't work. Etc.
adjusted[4,9] = "Belfast"
adjusted[6,9] = "London"
adjusted[7,9] = "Leeds"
adjusted[13,9] = "Donetsk"
adjusted[20,9] = "Caerdydd"
adjusted[21,9] = "Stockholm"
adjusted[25,9] = "Madrid"

# Add lat, long, population
for (row in 1:nrow(adjusted)) {
  newCity <- adjusted[row, "city"]
  num <- row
  
  for (i in 1:nrow(euro_cities)) {
    newLon <- euro_cities[i, "lng"]
    newLat <- euro_cities[i, "lat"]
    city <- euro_cities[i, "city"]
    pop <- euro_cities[i, "population"]
    country <- euro_cities[i, "country"]
    
    if (newCity == city) {
      adjusted[num, 11] = (newLat)
      adjusted[num, 12] = (newLon)
      adjusted[num, 13] = pop
      adjusted[num, 14] = country
    }
  }
}

# Plot the new locations
euro_nfl_plot <- ggplot(adjusted, aes(x = newLong, y = newLat, colour = Division)) + 
  geom_polygon(data = europe.clipped, aes(x=long, y = lat, group = group), fill = NA, 
               color = "black") +
  # Fix the co-ordinates so it looks the right sort of shape
  coord_fixed(1.3) +
  # Cities
  geom_point() +
  # Theme elements to make it look map like
  theme(panel.grid = element_blank(),
        panel.background = element_blank(),
        axis.title = element_blank(),
        axis.text = element_blank(),
        axis.ticks.y = element_blank(),
        axis.ticks = element_blank(),
        plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5)) +
  geom_label_repel(aes(label = city), size = 3, show.legend = FALSE) +
  # Map labels
  labs(title = "Location of NFL Teams Adjusted to Close European Cities",
       caption = "@mattglen_\ngithub.com/matthewglen")

euro_nfl_plot

# Team names ####
# Manually adjust the team names to remove the city bit
unique(adjusted$Team)
rename <- adjusted
rename[1,4] = "Dolphins"
rename[2,4] = "Jets"
rename[3,4] = "Bills"           
rename[4,4] = "Patriots"
rename[5,4] = "Bengals"
rename[6,4] = "Ravens"
rename[7,4] = "Steelers"
rename[8,4] = "Browns"
rename[9,4] = "Texans"
rename[10,4] = "Colts"
rename[11,4] = "Titans"
rename[12,4] = "Jaguars"
rename[13,4] = "Raiders"
rename[14,4] = "Chiefs"
rename[15,4] = "Chargers" 
rename[16,4] = "Broncos"
rename[17,4] = "Cowboys"
rename[18,4] = "Giants"
rename[19,4] = "Football Team"
rename[20,4] = "Eagles"
rename[21,4] = "Vikings"
rename[22,4] = "Lions"
rename[23,4] = "Packers"
rename[24,4] = "Bears"
rename[25,4] = "Buccaneers"
rename[26,4] = "Falcons"
rename[27,4] = "Saints"
rename[28,4] = "Panthers"
rename[29,4] = "Seahawks"
rename[30,4] = "Cardinals"
rename[31,4] = "49ers"
rename[32,4] = "Rams"

# Stadiums ####
# Manually adjust the stadiums (biggest capacity in the city)
# Add capacity
unique(rename$city)
rename$capacity <- 0
rename[1,5] = "Nou Mestalla"
rename[1,15] = 54000
rename[2,5] = "Aviva Stadium"
rename[2,15] = 49000
rename[3,5] = "St James' Park"
rename[3,15] = 52305  
rename[4,5] = "Windsor Park"
rename[4,15] = 22000
rename[5,5] = "King Baudouin Stadium"
rename[5,15] = 50093
rename[6,5] = "Tottenham Hotspur Stadium"
rename[6,15] = 62850
rename[7,5] = "Headingley Stadium"
rename[7,15] = 21500
rename[8,5] = "City Ground"
rename[8,15] = 30445
rename[9,5] = "Stadio San Paolo"
rename[9,15] = 54726
rename[10,5] = "RheinEnergieStadion"
rename[10,15] = 49698
rename[11,5] = "Waldstadion"
rename[11,15] = 48000
rename[12,5] = "Camp Nou"
rename[12,15] = 99354
rename[13,5] = "Donbass Arena"
rename[13,15] = 52187
rename[14,5] = "Olympiastadion"
rename[14,15] = 74475
rename[15,5] = "Krasnodar Stadium"
rename[15,15] = 35074
rename[16,5] = "National Stadium"
rename[16,15] = 58580
rename[17,5] = "Stadion Maksimir"
rename[17,15] = 35123
rename[18,5] = "Aviva Stadium"
rename[18,15] = 49000
rename[19,5] = "St Mary's Stadium"
rename[19,15] = 32384
rename[20,5] = "Millennium Stadium"
rename[20,15] = 73931
rename[21,5] = "Friends Arena"
rename[21,15] = 54329
rename[22,5] = "Johan Cruyff Arena"
rename[22,15] = 55500
rename[23,5] = "Parken Stadium"
rename[23,15] = 38065
rename[24,5] = "Volksparkstadion"
rename[24,15] = 57000
rename[25,5] = "Santiago Bernabéu"
rename[25,15] = 81044
rename[26,5] = "Juventus Stadium"
rename[26,15] = 41507
rename[27,5] = "Stadio Olimpico"
rename[27,15] = 70634
rename[28,5] = "Stade de France"
rename[28,15] = 80698
rename[29,5] = "Nizhny Novgorod Stadium"
rename[29,15] = 44899
rename[30,5] = "Chornomorets Stadium"
rename[30,15] = 34164
rename[31,5] = "Volgograd Arena"
rename[31,15] = 45568
rename[32,5] = "Krasnodar Stadium"
rename[32,15] = 35074

# New data ####
# Clean up the data to keep only necessary stuff
europe = subset(rename, select = -c(Year,Lat,Long,Logo,distance))

# Clean plot
euro_nfl_labs <- ggplot(europe, aes(x = newLong, y = newLat, colour = Division)) + 
  geom_polygon(data = europe.clipped, aes(x=long, y = lat, group = group), fill = NA, 
               color = "black") +
  # Fix the co-ordinates so it looks the right sort of shape
  coord_fixed(1.3) +
  # Cities
  geom_point() +
  # Theme elements to make it look map like
  theme(panel.grid = element_blank(),
        panel.background = element_blank(),
        axis.title = element_blank(),
        axis.text = element_blank(),
        axis.ticks.y = element_blank(),
        axis.ticks = element_blank(),
        plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5)) +
  geom_label_repel(aes(label = paste(Team,", ",city,sep="")), size = 3, show.legend = FALSE) +
  # Map labels
  labs(title = "What Would the NFL Look Like if It Was in Europe?",
       subtitle = "Largest distance: Madrid<->Volgograd: ~3862.43km/~2400.00 mi",
       caption = "@mattglen_\ngithub.com/matthewglen")

euro_nfl_labs

# Plots per division ####
# List of divisions
divs <- unique(europe$Division)
i <- 1

## Plot per div ####
for (i in 1:8) {
  
  div_to_show <- europe %>%
    filter (
      Division == paste(as.list(strsplit(divs, "' '")[[i]]))
    )
      
  
  print(ggplot(div_to_show, aes(x = newLong, y = newLat, colour = Division)) + 
          geom_polygon(data = europe.clipped, aes(x=long, y = lat, group = group), fill = NA, 
                       color = "black") +
          # Fix the co-ordinates so it looks the right sort of shape
          coord_fixed(1.3) +
          # Cities
          geom_point() +
          # Theme elements to make it look map like
          theme(panel.grid = element_blank(),
                panel.background = element_blank(),
                axis.title = element_blank(),
                axis.text = element_blank(),
                axis.ticks.y = element_blank(),
                axis.ticks = element_blank(),
                plot.title = element_text(hjust = 0.5),
                plot.subtitle = element_text(hjust = 0.5),
                legend.position = "none") +
          geom_label_repel(aes(label = paste(Team,", ",city,sep = "")), size = 3, show.legend = FALSE) +
          # Annotation
          annotate("text", x = -41, y = 52, size = 5, hjust = 0, label = 
                     paste(div_to_show[1,3],":\n",div_to_show[1,4]," (",format(div_to_show[1,10], big.mark=",", scientific=FALSE),"), ",div_to_show[1,5],", ",div_to_show[1,9],"\n",
                           div_to_show[2,3],":\n",div_to_show[2,4]," (",format(div_to_show[2,10], big.mark=",", scientific=FALSE),"), ",div_to_show[2,5],", ",div_to_show[2,9],"\n",
                           div_to_show[3,3],":\n",div_to_show[3,4]," (",format(div_to_show[3,10], big.mark=",", scientific=FALSE),"), ",div_to_show[3,5],", ",div_to_show[3,9],"\n",
                           div_to_show[4,3],":\n",div_to_show[4,4]," (",format(div_to_show[4,10], big.mark=",", scientific=FALSE),"), ",div_to_show[4,5],", ",div_to_show[4,9],"\n",
                           sep="")) +
          # Map labels
          labs(title = paste("The European",as.list(strsplit(divs, "' '")[[i]])),
               caption = "@mattglen_\ngithub.com/matthewglen"))
}

## Divisions with stadium pics ####
for (i in 1:8) {
  
  div_to_show <- europe %>%
    filter (
      Division == paste(as.list(strsplit(divs, "' '")[[i]]))
    )
  
  division <- div_to_show[1, "Division"]
  
  img1 <- readJPEG(paste("Stadiums/",div_to_show[1,4],".jpeg",sep = ""))
  img2 <- readJPEG(paste("Stadiums/",div_to_show[2,4],".jpeg",sep = ""))
  img3 <- readJPEG(paste("Stadiums/",div_to_show[3,4],".jpeg",sep = ""))
  img4 <- readJPEG(paste("Stadiums/",div_to_show[4,4],".jpeg",sep = ""))
  
  print(ggplot(div_to_show, aes(x = newLong, y = newLat, colour = Division)) + 
          geom_polygon(data = europe.clipped, aes(x=long, y = lat, group = group), fill = NA, 
                       color = "black") +
          # Fix the co-ordinates so it looks the right sort of shape
          coord_fixed(1.3) +
          # Cities
          geom_point() +
          # Theme elements to make it look map like
          theme(panel.grid = element_blank(),
                panel.background = element_blank(),
                axis.title = element_blank(),
                axis.text = element_blank(),
                axis.ticks.y = element_blank(),
                axis.ticks = element_blank(),
                plot.title = element_text(hjust = 0.5),
                plot.subtitle = element_text(hjust = 0.5),
                legend.position = "none") +
          geom_label_repel(aes(label = paste(Team,", ",city,sep = "")), size = 3, show.legend = FALSE) +
          # Annotation
          annotate("text", x = -41, y = 52, size = 4, hjust = 0, label = 
                     paste(div_to_show[1,3],":\n",div_to_show[1,4]," (",format(div_to_show[1,10], big.mark=",", scientific=FALSE),"), ",div_to_show[1,5],", ",div_to_show[1,9],"\n",
                           div_to_show[2,3],":\n",div_to_show[2,4]," (",format(div_to_show[2,10], big.mark=",", scientific=FALSE),"), ",div_to_show[2,5],", ",div_to_show[2,9],"\n",
                           div_to_show[3,3],":\n",div_to_show[3,4]," (",format(div_to_show[3,10], big.mark=",", scientific=FALSE),"), ",div_to_show[3,5],", ",div_to_show[3,9],"\n",
                           div_to_show[4,3],":\n",div_to_show[4,4]," (",format(div_to_show[4,10], big.mark=",", scientific=FALSE),"), ",div_to_show[4,5],", ",div_to_show[4,9],"\n",
                           sep="")) +
          # Map labels
          labs(title = paste("The European",as.list(strsplit(divs, "' '")[[i]])),
               caption = "@mattglen_\ngithub.com/matthewglen") +
          annotation_raster(img1, -45, -20, 61, 73) + # Top left corner
          annotation_raster(img2, 24, 49, 61, 73) + # Top right corner
          annotation_raster(img3, 24, 49, 33, 44) + # Bottom right corner
          annotation_raster(img4, -45, -20, 33, 44)) # Bottom left corner
}

# Distances ####
# USA. Dolphins to Seahawks, 4381888.76m, 4381.89km, 2722.79 mi
currentMax <- 0
for (row in 1:nrow(teams2020)) {
  lon1 <- teams2020[row, "Long"]
  lat1 <- teams2020[row, "Lat"]
  city1 <- teams2020[row, "Team"]
  num <- row
  
  for (row in 1:nrow(teams2020)) {
    lon2 <- teams2020[row, "Long"]
    lat2 <- teams2020[row, "Lat"]
    city2 <- teams2020[row, "Team"]
    
    distance <- distm(c(lon1, lat1), c(lon2, lat2), fun = distHaversine)
    
    if (distance[1,1] > currentMax) {
      from <- city1
      to <- city2
      currentMax <- distance[1,1]
    }
  }
}

# New dolphins to new seahawks. 3717571m, 3717.571 km, 2309.99 mi
test <- distm(c(-0.3750, 39.4667), c(44.0075, 56.3269), fun = distHaversine)
  
# Europe. Madrid to Volgograd, 3862425.78m, 3862.43km, 2400.00 mi
currentMax <- 0
for (row in 1:nrow(europe)) {
  lon1 <- europe[row, "newLong"]
  lat1 <- europe[row, "newLat"]
  city1 <- europe[row, "city"]
  num <- row
  
  for (row in 1:nrow(europe)) {
    lon2 <- europe[row, "newLong"]
    lat2 <- europe[row, "newLat"]
    city2 <- europe[row, "city"]
    
    distance <- distm(c(lon1, lat1), c(lon2, lat2), fun = distHaversine)
    
    if (distance[1,1] > currentMax) {
      from <- city1
      to <- city2
      currentMax <- distance[1,1]
    }
  }
}

# Timezones ####
(europe$city)
europe$timezone <- ""
europe[1,11] = "UTC+1"
europe[2,11] = "UTC"
europe[3,11] = "UTC"           
europe[4,11] = "UTC"
europe[5,11] = "UTC+1"
europe[6,11] = "UTC"
europe[7,11] = "UTC"
europe[8,11] = "UTC"
europe[9,11] = "UTC+1"
europe[10,11] = "UTC+1"
europe[11,11] = "UTC+1"
europe[12,11] = "UTC+1"
europe[13,11] = "UTC+2"
europe[14,11] = "UTC+1"
europe[15,11] = "UTC+3" 
europe[16,11] = "UTC+1"
europe[17,11] = "UTC+1"
europe[18,11] = "UTC"
europe[19,11] = "UTC"
europe[20,11] = "UTC"
europe[21,11] = "UTC+1"
europe[22,11] = "UTC+1"
europe[23,11] = "UTC+1"
europe[24,11] = "UTC+1"
europe[25,11] = "UTC+1"
europe[26,11] = "UTC+1"
europe[27,11] = "UTC+1"
europe[28,11] = "UTC+1"
europe[29,11] = "UTC+3"
europe[30,11] = "UTC+2"
europe[31,11] = "UTC+3"
europe[32,11] = "UTC+3" 

(teams2020$Team)
teams2020$timezone <- ""
teams2020[1,9] = "UTC-5"
teams2020[2,9] = "UTC-5"
teams2020[3,9] = "UTC-5"          
teams2020[4,9] = "UTC-5"
teams2020[5,9] = "UTC-5"
teams2020[6,9] = "UTC-5"
teams2020[7,9] = "UTC-5"
teams2020[8,9] = "UTC-5"
teams2020[9,9] = "UTC-6"
teams2020[10,9] = "UTC-5"
teams2020[11,9] = "UTC-6"
teams2020[12,9] = "UTC-5"
teams2020[13,9] = "UTC-8"
teams2020[14,9] = "UTC-6"
teams2020[15,9] = "UTC-8" 
teams2020[16,9] = "UTC-7"
teams2020[17,9] = "UTC-6"
teams2020[18,9] = "UTC-5"
teams2020[19,9] = "UTC-5"
teams2020[20,9] = "UTC-5"
teams2020[21,9] = "UTC-6"
teams2020[22,9] = "UTC-5"
teams2020[23,9] = "UTC-6"
teams2020[24,9] = "UTC-6"
teams2020[25,9] = "UTC-5"
teams2020[26,9] = "UTC-5"
teams2020[27,9] = "UTC-6"
teams2020[28,9] = "UTC-5"
teams2020[29,9] = "UTC-8"
teams2020[30,9] = "UTC-7"
teams2020[31,9] = "UTC-8"
teams2020[32,9] = "UTC-8"   

usa_timezones <- ggplot(teams2020, aes(x = Long, y = Lat, colour = timezone)) + 
  # Plot a blank map of the US
  geom_polygon(data = states, aes(x=long, y = lat, group = group), fill = NA, 
               color = "black") +
  # Fix the co-ordinates so it looks the right sort of shape
  coord_fixed(1.3) +
  # Points
  geom_point() +
  # Theme elements to make it look map like
  theme(panel.grid = element_blank(),
        panel.background = element_blank(),
        axis.title = element_blank(),
        axis.text = element_blank(),
        axis.ticks.y = element_blank(),
        axis.ticks = element_blank(),
        plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5)) +
  geom_label_repel(aes(label = Team), size = 3, show.legend = FALSE) +
  # Map labels
  labs(title = "Timezones of NFL teams",
       subtitle = "Largest distance: Dolphins<->Seahawks: ~4381.89km/~2722.79 mi",
       caption = "@mattglen_\ngithub.com/matthewglen")

europe_timezones <- ggplot(europe, aes(x = newLong, y = newLat, colour = timezone)) + 
  # Plot a blank map of the US
  geom_polygon(data = europe.clipped, aes(x=long, y = lat, group = group), fill = NA, 
               color = "black") +
  # Fix the co-ordinates so it looks the right sort of shape
  coord_fixed(1.3) +
  # Points
  geom_point() +
  # Theme elements to make it look map like
  theme(panel.grid = element_blank(),
        panel.background = element_blank(),
        axis.title = element_blank(),
        axis.text = element_blank(),
        axis.ticks.y = element_blank(),
        axis.ticks = element_blank(),
        plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5)) +
  geom_label_repel(aes(label = Team), size = 3, show.legend = FALSE) +
  # Map labels
  labs(title = "Timezones of the Hypothetical European NFL",
       subtitle = "Largest distance: Madrid<->Volgograd: ~3862.43km/~2400.00 mi",
       caption = "@mattglen_\ngithub.com/matthewglen")

usa_timezones
europe_timezones
