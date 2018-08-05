library(dplyr)
library(glue)
library(purrr)
library(httr)

# Load your Tesla email and client_id and client_secret - #https://pastebin.com/YiLPDggh
#https://teslamotorsclub.com/tmc/threads/tesla-owner-api-tutorial-all-you-need-is-your-browser.100852/

environment_variable_file <-  "set_environment_variables.R" #create this file
source(environment_variable_file)

# Authenticate and get access token
#POST https://owner-api.teslamotors.com/oauth/token

url <- "https://owner-api.teslamotors.com/oauth/token"
parameters <- list(
  grant_type = "password",
  client_id = Sys.getenv("OWNERAPI_CLIENT_ID"), #https://pastebin.com/YiLPDggh
  client_secret = Sys.getenv("OWNERAPI_CLIENT_SECRET"),
  email = Sys.getenv("TESLA_EMAIL"),
  password = rstudioapi::askForPassword()
)

response <- httr::POST(url = url, query = parameters, verbose = TRUE)
authentication <- content(response)

authentication$access_token

# List vehicles

# curl --include \
# --header "Authorization: Bearer {access_token}" \
# 'https://owner-api.teslamotors.com/api/1/vehicles'

url <- "https://owner-api.teslamotors.com/api/1/vehicles"
req <- httr::GET(url = url, 
                 add_headers(Authorization=glue("Bearer {authentication$access_token}")),
                 verbose = TRUE
)
stop_for_status(req)
vehicles <- content(req)

vehicle <- vehicles$response %>% 
  first() %>% 
  unlist() %>%
  bind_rows(.)

# Wake up car

url <- glue("https://owner-api.teslamotors.com/api/1/vehicles/{vehicle$id_s}/wake_up")
req <- httr::POST(url = url, 
                  add_headers(Authorization=glue("Bearer {authentication$access_token}"))
)
stop_for_status(req)

# Start HVAC system

# curl --include \
# --request POST \
# --header "Authorization: Bearer {access_token}" \
# 'https://owner-api.teslamotors.com/api/1/vehicles/{vehicle_id}/command/auto_conditioning_start'

url <- glue("https://owner-api.teslamotors.com/api/1/vehicles/{vehicle$id_s}/command/auto_conditioning_start")
req <- httr::POST(url = url, 
                  add_headers(Authorization=glue("Bearer {authentication$access_token}"))
)
stop_for_status(req)

# Get charge state

# curl --include \
# --header "Authorization: Bearer {access_token}" \
# 'https://owner-api.teslamotors.com/api/1/vehicles/{vehicle_id}/data_request/charge_state'

url <- glue("https://owner-api.teslamotors.com/api/1/vehicles/{vehicle$id_s}/data_request/charge_state")
req <- httr::GET(url = url, 
                 add_headers(Authorization=glue("Bearer {authentication$access_token}"))
)
stop_for_status(req)
charger.status <- content(req)

charger.status  <- charger.status$response %>% 
  unlist() %>%
  bind_rows(.)

# Stop the HVAC
# curl --include \
# --request POST \
# --header "Authorization: Bearer {access_token}" \
# 'https://owner-api.teslamotors.com/api/1/vehicles/{vehicle_id}/command/auto_conditioning_stop'

url <- glue("https://owner-api.teslamotors.com/api/1/vehicles/{vehicle$id_s}/command/auto_conditioning_stop")
req <- httr::POST(url = url, 
                  add_headers(Authorization=glue("Bearer {authentication$access_token}"))
)
stop_for_status(req)