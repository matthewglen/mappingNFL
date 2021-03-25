# Librarys ####
library(ggplot2)
library(ggmap)
library(ggimage)
library(maps)
library(mapdata)
library(tidyverse)
library(dplyr)
library(svglite)

# Base map ####
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

# Team data ####
# teams <- read.csv(url("https://raw.githubusercontent.com/matthewglen/mappingNFL/main/teams.csv"))
teams <- read_csv("/Users/mattglen/Documents/Mapping NFL Teams/teams.csv")

y = 1970

# Generating plots ####
for (y in unique(teams$Year)) {
  season <- teams %>%
    filter(Year == y)
  
  plot(basicOutline +
    # With divisional lines
    geom_line(data= season, aes(x = Long, y = Lat, group = Division, color = Colour)) +
    # With team logos
    geom_image(data = season, aes(x = Long, y = Lat, image = Logo), size = 0.04) +
    labs(title = paste("Location of NFL Teams - ",y,sep = ""),
            subtitle = "Subtitle"))
  ggsave(paste(y,".png",sep = ""),dpi=300)
}
