library(ggplot2)
library(ggmap)
library(ggimage)
library(maps)
library(mapdata)
library(nflfastR)
library(geosphere)
library(tidyverse)
library(dplyr)

# USA map with state borders
states <- map_data("state")
basicOutline <- ggplot() + 
  geom_polygon(data = states, aes(x=long, y = lat, group = group), fill = NA, 
               color = "black") + 
  coord_fixed(1.3) + 
  theme(legend.position = "none",
        panel.grid = element_blank(),
        panel.background = element_blank(),
        axis.title = element_blank(),
        axis.text = element_blank(),
        axis.ticks.y = element_blank(),
        axis.ticks = element_blank(),
        plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5))

# Teams
teams <- read.csv(url("https://raw.githubusercontent.com/matthewglen/mappingNFL/main/teams.csv"))

testYear <- teams %>%
  filter(Year == "2020")

# Plot teams
basicOutline +
  # With divisional lines
  geom_line(data= testYear, aes(x = Long, y = Lat, group = Division, color = Colour)) +
  # With team logos
  geom_image(data = testYear, aes(x = Long, y = Lat, image = Logo), size = 0.04) +
  ggtitle(label = "Location of NFL Teams - ??Year??",
          subtitle = "Subtitle")
