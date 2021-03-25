# mappingNFL
A repository to plot NFL teams, and their movements, since the 1970 merger.

## Data
[`teams.csv`](https://github.com/matthewglen/mappingNFL/blob/main/teams.csv) contains the following data for each season:
* Conference
* Division
* Team name
* Stadium name
* Latitude
* Longitude
  * See notes below for accuracy info
* Link to logo
  * Big thanks to [Sports Logo History](https://sportslogohistory.com/) for informative and up to date logos

> Note: All the information is changed season to season, if there were any changes. There is one excpetion; in most cases, the name of the stadium is as it was when the team moved there. Stadium names haven't been updated during the team's tenancy (e.g. sponsorship name changes). Adjustments made to the home stadium for individual games within a stadium (due to hurricane, fire, covid etc.) are not accounted for.

## Results
* [`Individual Maps`](https://github.com/matthewglen/mappingNFL/tree/main/Individual%20Maps)
  * Contains individual `.png` files for each season
* Currently working on `.gif` and animated/video versions

## Code
* [`basic_nfl_map.R`](https://github.com/matthewglen/mappingNFL/blob/main/code/basic_nfl_map.R)
  * Code to generate a plot of NFL teams for a given season
* [`Individual_Maps.R`](https://github.com/matthewglen/mappingNFL/blob/main/code/Individual_Maps.R)
  * Code to generate a plot of NFL teams for every season, and save these plots as `.png` files to the current working directory.
* Currently working on code to generate `.gif` and animated/video versions

## Future Work
As well as generating different file types of the maps to upload wherever, I'm working on:
* Calculating the distances between teams within a division
* Modelling potential realignments
* Modelling potential international franchise moves, or new franchises

## Notes regarding lat/long figures
The latitude and longitude figures given for some teams, in some years, are shifted slightly in order to prevent logos overlapping too much. If you need more accurate locations, use this list to adjust them back. The years shown are the first years the adjustments are made (unless shown otherwise). The location remains adjusted until either of the conflicitng teams move. If you spot any other issues, let me know!

* 49ers
  * 1970  - (37.767,-122.456)
  * 71-81 - (37.713611,-122.386111)
  * 95-13 - (37.713611,-122.386111)
  * 14-20 - (37.403,-121.97)
* Chargers
  * 2017 - (33.864,-118.261)
* Giants
  * 73-74 - (41.313,-72.96)
  * 1975  - (40.75556,-73.848056)
  * 76-08 - (40.812222,-74.076944)
  * 09-on - (40.813528,-74.074361)
* Raiders
  * 1970  - (37.751667,-122.200566)
  * 1982  - (34.014167,-118.287778)
  * 1995  - (37.751667,-122.200566)
* Rams
  * 82-94 - (33.800278,-117.882778)
  * 2017  - (34.014167,-118.287778)
* Washington
  * 1970  - (38.89,-76.972)
  * 1997  - (39.907778,-76.864444)

As always, thanks for checking this out, all feedback is greatly appreciated.

Matt
