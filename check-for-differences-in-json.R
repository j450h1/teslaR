library(waldo)
library(jsonlite)

# Download json files to data folder from cloud storage
json1 <- jsonlite::fromJSON(here::here('data', 'tesla_vehicle_data_20200825.json'))
json2 <- jsonlite::fromJSON(here::here('data', 'tesla_vehicle_data_20201018.json'))


diffs <- compare(json1, json2)
