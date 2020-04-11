library(dplyr)
library(glue)
library(purrr)
library(httr)

# THIS TIME THE PASSWORD IS COMING FROM THIS FILE AS OPPOSED TO USER ENTERING DURING EXECUTION
#environment_variable_file <-  "set_environment_variables.R" #create this file
#source(environment_variable_file)

# Adapted from https://timdorr.docs.apiary.io/#

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

#### Now in alphabetical order
close_charge_port <- function(token, vehicle_id_s){
  url <- glue("https://owner-api.teslamotors.com/api/1/vehicles/{vehicle_id_s}/command/charge_port_door_close")
  #cat(url)
  req <- httr::POST(
    url = url,
    add_headers(Authorization = glue("Bearer {token}"))
  )
  stop_for_status(req)
  cat(glue("\nThe charge port door is closed!\n"))
}

get_charge_state <- function(token, vehicle_id_s){
  url <- glue("https://owner-api.teslamotors.com/api/1/vehicles/{vehicle_id_s}/data_request/charge_state")
  req <- httr::GET(url = url, 
                   add_headers(Authorization=glue("Bearer {token}"))
  )
  stop_for_status(req)
  charge_state <- content(req)
  charge_state
}

get_internal_temperature <- function(token, vehicle_id_s) {
  url <- glue("https://owner-api.teslamotors.com/api/1/vehicles/{vehicle_id_s}/data_request/climate_state")
  req <- httr::GET(url = url, 
                   add_headers(Authorization=glue("Bearer {token}"))
  )
  stop_for_status(req)
  temperature <- content(req)
  internal_temperature <- temperature %>%
    first %>%
    unlist() %>%
    bind_rows(.) %>%
    pull(inside_temp)
  cat(glue("\nThe current internal temperature is: {internal_temperature} Celsius.\n"))
  return(internal_temperature)
}

get_vehicle_data <- function(token, vehicle_id_s){
  #https://tesla-api.timdorr.com/vehicle/state/data
  url <- glue("https://owner-api.teslamotors.com/api/1/vehicles/{vehicle_id_s}/vehicle_data")
  req <- httr::GET(url = url, 
                   add_headers(Authorization=glue("Bearer {token}"))
  )
  stop_for_status(req)
  vehicle_data <- content(req)
  return(vehicle_data$response)
}

get_vehicle_status <- function(token, vehicle_id_s) {
  # Need to determine how to display or what object to return
  url <- glue("https://owner-api.teslamotors.com/api/1/vehicles/{vehicle_id_s}/data_request/vehicle_state")
  req <- httr::GET(url = url, 
                   add_headers(Authorization=glue("Bearer {token}"))
  )
  stop_for_status(req)
  vehicle_status <- content(req)
  vehicle_status
}

set_temperature <- function(token, vehicle_id_s, driver_temp, passenger_temp){
  url <- glue("https://owner-api.teslamotors.com/api/1/vehicles/{vehicle_id_s}/command/set_temps?driver_temp={driver_temp}&passenger_temp={passenger_temp}")
  req <- httr::POST(
    url = url,
    add_headers(Authorization = glue("Bearer {token}"))
  )
  stop_for_status(req)
  cat(glue("\nThe temperature has been set to {driver_temp}!\n"))
}

start_hvac <- function(token, vehicle_id_s) {
  url <- glue("https://owner-api.teslamotors.com/api/1/vehicles/{vehicle_id_s}/command/auto_conditioning_start")
  req <- httr::POST(url = url, 
                    add_headers(Authorization=glue("Bearer {token}"))
  )
  stop_for_status(req)
  cat("\nThe HVAC system has been turned ON!\n")  
}

stop_hvac <- function(token, vehicle_id_s) {
  url <- glue("https://owner-api.teslamotors.com/api/1/vehicles/{vehicle_id_s}/command/auto_conditioning_stop")
  req <- httr::POST(url = url, 
                    add_headers(Authorization=glue("Bearer {token}"))
  )
  stop_for_status(req)
  cat("\nThe HVAC system has been turned OFF!\n")  
}

unlock_charge_port <- function(token, vehicle_id_s){
  url <- glue("https://owner-api.teslamotors.com/api/1/vehicles/{vehicle_id_s}/command/charge_port_door_open")
  #cat(url)
  req <- httr::POST(
    url = url,
    add_headers(Authorization = glue("Bearer {token}"))
  )
  stop_for_status(req)
  cat("\nThe charge port is unlocked!\n")
}

wake_vehicle_up <- function(token, vehicle_id_s) {
  url <- glue("https://owner-api.teslamotors.com/api/1/vehicles/{vehicle_id_s}/wake_up")
  req <- httr::POST(
    url = url,
    add_headers(Authorization = glue("Bearer {token}"))
  )
  stop_for_status(req)
  cat("\nThe vehicle is waking up!\n")
}

#########
#Telegram
#########

send_telegram_message <- function(text, chat_id, bot_token){ 
  require(telegram) 
  bot <- TGBot$new(token = bot_token) 
  bot$sendMessage(text = text, chat_id = chat_id)
}
