# This is code to combines each map of NFL teams for every year since 1970, and
# save the plots as a gif/animation
# Libraries ####
library(magick)
library(magrittr)
library(tidyverse)

# Individual maps. Use this to download the individual maps to your device
url <- ("https://github.com/matthewglen/mappingNFL/tree/main/Individual%20Maps")

# Change to your own directory containing the individual maps
list.files(path="/Users/mattglen/Documents/Mapping NFL Teams/Individual Maps", 
           pattern = '*.png', full.names = TRUE) %>% 
  image_read() %>% # reads each path file
  image_join() %>% # joins image
  image_animate(fps=1) %>% # animates, can opt for number of loops
  image_write("nflLocations.gif") # write to current directory
