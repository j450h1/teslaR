source(here::here('functions.R'))

# Load libraries
library(tidyverse)
library(googleCloudStorageR)
library(bigrquery)
library(httr)

# Authenticate
gcs_auth(Sys.getenv("GCP_KEYPATH"))
bq_auth(email = Sys.getenv("BQ_EMAIL"))

# Authenticate with Tesla
#token <- get_access_token()

# Get vehicle id
#vehicle_id_s <- get_vehicle_id_s(token)

# Wake vehicle up
#wake_vehicle_up(token, vehicle_id_s)

# Get data
#Sys.sleep(60)
#tesla_data <- get_vehicle_data(token, vehicle_id_s)
URL <- "https://python-app-j4f32r553a-uw.a.run.app"

tesla_data <- URL %>%
  httr::GET() %>%
  content()

# Push vehicle state data to GCS
today <- as.character(Sys.Date(), format = "%Y%m%d")
filename <- glue("vehicle_data_{today}.json")

gcs_upload(tesla_data$vehicle_state,
           bucket = Sys.getenv('BUCKET_NAME'),
           name = glue("tesla/{filename}"),
           predefinedAcl = "bucketOwnerRead"
)
