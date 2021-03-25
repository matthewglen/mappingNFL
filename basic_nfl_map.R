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
  theme(panel.grid = element_blank(),
        panel.background = element_blank(),
        axis.title = element_blank(),
        axis.text = element_blank(),
        axis.ticks.y = element_blank(),
        axis.ticks = element_blank(),
        plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5),
        legend.position = "none")
        # legend.position = c(0.2,0.1),
        # legend.direction = "vertical",
        # legend.key = element_rect(fill = NA))


# Teams
teams <- read.csv(url("https://raw.githubusercontent.com/matthewglen/mappingNFL/main/teams.csv"))

teams <- read_csv("/Users/mattglen/Documents/Mapping NFL Teams/teams.csv")

testYear <- teams %>%
  filter(Year == "2020")

distinct(teams,Division,Colour)

# Plot teams
basicOutline +
  # With divisional lines
  geom_line(data= testYear, aes(x = Long, y = Lat, group = Division), color = teams$Division) +
  # With team logos
  geom_image(data = testYear, aes(x = Long, y = Lat, image = Logo), size = 0.04) +
  labs(title = "Location of NFL Teams - ??Year??",
      subtitle = "Based on home stadium",
      caption = "Note: some teams are slightly off location to prevent overlap\n@mattglen_\ngithub.com/matthewglen")

ggplot(testYear, aes(x = Long, y = Lat)) +
  geom_polygon(data = states, aes(x=long, y = lat, group = group), fill = NA, 
               color = "black") +
  coord_fixed(1.3) + 
  theme(panel.grid = element_blank(),
        panel.background = element_blank(),
        axis.title = element_blank(),
        axis.text = element_blank(),
        axis.ticks.y = element_blank(),
        axis.ticks = element_blank(),
        plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5),
        legend.position = c(0.2,0.1),
        legend.direction = "vertical",
        legend.key = element_rect(fill = NA)) + 
  geom_line(aes(group = Division), color = testYear$Colour) +
  geom_point(data = testYear, aes(x = Long, y = Lat), size = 0.04) +
  geom_image(data = testYear, aes(x = Long, y = Lat, image = Logo), size = 0.04) +
  labs(title = "Location of NFL Teams - ??Year??",
       subtitle = "Based on home stadium",
       caption = "Note: some teams are slightly off location to prevent overlap\n@mattglen_\ngithub.com/matthewglen") +
  scale_color_manual(labels = c("AFC East","AFC Central","AFC West","NFC East",
                     "NFC Central","NFC West","AFC North","AFC South",
                     "NFC North","NFC South"),
                     values = c("Blue","Orange","Green","Red","Yellow","Purple",
                               "Orange","Pink","Yellow","Grey"))
      