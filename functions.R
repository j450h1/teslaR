library(dplyr)
library(glue)
library(purrr)
library(httr)

# THIS TIME THE PASSWORD IS COMING FROM THIS FILE AS OPPOSED TO USER ENTERING DURING EXECUTION
environment_variable_file <-  "set_environment_variables.R" #create this file
source(environment_variable_file)

get_access_token <- function() {
  
  url <- "https://owner-api.teslamotors.com/oauth/token"
  parameters <- list(
    grant_type = "password",
    client_id = Sys.getenv("OWNERAPI_CLIENT_ID"), #https://pastebin.com/YiLPDggh
    client_secret = Sys.getenv("OWNERAPI_CLIENT_SECRET"),
    email = Sys.getenv("TESLA_EMAIL"),
    password = Sys.getenv("TESLA_PWD")
  )
  
  response <- httr::POST(url = url, query = parameters, verbose = TRUE)
  authentication <- content(response)  
  return(authentication$access_token)
}

get_vehicle_id_s <- function(token){
  url <- "https://owner-api.teslamotors.com/api/1/vehicles"
  req <- httr::GET(url = url, 
                   add_headers(Authorization=glue("Bearer {token}"))
  )
  stop_for_status(req)
  vehicles <- content(req)
  
  vehicle <- vehicles$response %>% 
    first() %>% 
    unlist() %>%
    bind_rows(.)
  
  return(vehicle$id_s)
}

start_hvac <- function(token, vehicle_id_s) {
  url <- glue("https://owner-api.teslamotors.com/api/1/vehicles/{vehicle_id_s}/command/auto_conditioning_start")
  req <- httr::POST(url = url, 
                    add_headers(Authorization=glue("Bearer {token}"))
  )
  stop_for_status(req)
  cat("The HVAC system has been turned ON!")  
}

stop_hvac <- function(token, vehicle_id_s) {
  url <- glue("https://owner-api.teslamotors.com/api/1/vehicles/{vehicle_id_s}/command/auto_conditioning_stop")
  req <- httr::POST(url = url, 
                    add_headers(Authorization=glue("Bearer {token}"))
  )
  stop_for_status(req)
  cat("The HVAC system has been turned OFF!")  
}

# EXECUTE

token <- get_access_token()
vehicle_id_s <- get_vehicle_id_s(token)

start_hvac(token, vehicle_id_s)

#stop_hvac(token, vehicle_id_s)