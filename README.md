# mappingNFL
A repository to plot NFL teams, and their movements, since the 1970 merger.

## Data
[`teams.csv`](https://github.com/matthewglen/mappingNFL/blob/main/data/teams.csv) contains the following data for each season:
* Conference
* Division
* Team name
* Stadium name
* Latitude
* Longitude
* Link to logo
  * Big thanks to [Sports Logo History](https://sportslogohistory.com/) for informative and up to date logos

[`teams_adjusted.csv`](https://github.com/matthewglen/mappingNFL/blob/main/data/teams_adjusted.csv) contains the same information, but with adjusted locations for some teams (see below).

> Note: All the information is changed season to season, if there were any changes. There is one excpetion; in most cases, the name of the stadium is as it was when the team moved there. Stadium names haven't been updated during the team's tenancy (e.g. sponsorship name changes). Adjustments made to a team's home stadium for individual games within a season (due to hurricane, fire, covid etc.) are not accounted for.

## Results
* [`Individual Maps`](https://github.com/matthewglen/mappingNFL/tree/main/Individual%20Maps)
  * Contains individual `.png` files for each season 
* [`nflLocations.gif`](https://github.com/matthewglen/mappingNFL/blob/main/nflLocations.gif)
  * Is a .gif demonstrating the teams movements, logo changes, and division changes

## Code
* [`basic_nfl_map.R`](https://github.com/matthewglen/mappingNFL/blob/main/code/basic_nfl_map.R)
  * Code to generate a plot of NFL teams for a given season
* [`Individual_Maps.R`](https://github.com/matthewglen/mappingNFL/blob/main/code/Individual_Maps.R)
  * Code to generate a plot of NFL teams for every season, and save these plots as `.png` files to the current working directory.
* [`animated_maps.R`](https://github.com/matthewglen/mappingNFL/blob/main/code/animated_maps.R)
  * Code  to generate `.gif` version

## Future Work
* Calculating the distances between teams within a division
* Modelling potential realignments
* Modelling potential international franchise moves, or new franchises

## Notes regarding lat/long figures
In the `.csv` file used for creating plots ([`teams_adjusted.csv`](https://github.com/matthewglen/mappingNFL/blob/main/data/teams_adjusted.csv)) the latitude and longitude figures given for some teams, in some years, are shifted slightly in order to prevent logos overlapping too much. If you need more accurate locations, use [`teams.csv`](https://github.com/matthewglen/mappingNFL/blob/main/data/teams.csv). If you spot any other issues, let me know! The teams that have adjustments in `team_adjusted` are:

* 49ers
* Chargers
* Giants
* Raiders
* Rams
* Washington

As always, thanks for checking this out, all feedback is greatly appreciated.

Matt
