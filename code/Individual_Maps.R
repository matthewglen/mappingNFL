# This is code to generate a map of NFL teams for every year since 1970, and
# save the plots as images
# Libraries ####
library(ggplot2)
library(ggmap)
library(ggimage)
library(maps)
library(mapdata)
library(tidyverse)
library(dplyr)

# Data ####
# USA map with state borders data
states <- map_data("state")

# Teams since merger (1970). Some locations adjusted to map without overlapping
teams <- read.csv(url("https://raw.githubusercontent.com/matthewglen/mappingNFL/main/data/teams_adjusted.csv"))

# Generating plots ####
for (y in unique(teams$Year)) {
  # Split the data by season (y = year)
  season <- teams %>%
    filter(Year == y)
  
  ggplot(season, aes(x = Long, y = Lat, color = Division)) +
    # Plot a blank map of the US
    geom_polygon(data = states, aes(x=long, y = lat, group = group), fill = NA, 
                 color = "black") +
    #3 Fix the co-ordinates so it looks the right sort of shape
    coord_fixed(1.3) + 
    # Theme elements to make it look map like
    theme(panel.grid = element_blank(),
          panel.background = element_blank(),
          axis.title = element_blank(),
          axis.text = element_blank(),
          axis.ticks.y = element_blank(),
          axis.ticks = element_blank(),
          plot.title = element_text(hjust = 0.5),
          plot.subtitle = element_text(hjust = 0.5),
          legend.position = c(0.2,0),
          legend.direction = "vertical",
          legend.key = element_rect(fill = NA)) + 
    # Split the legend to two columns
    guides(color=guide_legend(ncol=2)) + 
    # Add lines connecting the location points, group by pos
    geom_line(aes(group = Division)) +
    # Add the team logos
    geom_image(data = season, aes(x = Long, y = Lat, image = Logo, colour = NULL), size = 0.04) +
    # Map labels
    labs(title = paste("Location of NFL Teams - ",y,sep = ""),
         subtitle = "Based on home stadium",
         caption = "Note: some teams are slightly off location to prevent overlap\n@mattglen_\ngithub.com/matthewglen")
  
  # Save as a .png file in the current working directory
  ggsave(paste(y,".png",sep = ""),dpi=300)
}
