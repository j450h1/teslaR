environment_variable_file <-  "set_environment_variables.R" #create this file
source(environment_variable_file)

source('functions.R')

MINIMUM_TEMPERATURE <- 24 #Celsius
TELEGRAM_MESSAGE <- "The HVAC has been turned on!"

# Authenticate
token <- get_access_token()

vehicle_id_s <- get_vehicle_id_s(token)

#get_vehicle_status(token, vehicle_id_s)

inside_temp <- get_internal_temperature(token, vehicle_id_s)

send_telegram_message <- function(text, chat_id, bot_token){ 
  require(telegram) 
  bot <- TGBot$new(token = bot_token) 
  bot$sendMessage(text = text, chat_id = chat_id)
}

if (inside_temp > MINIMUM_TEMPERATURE) {
  start_hvac(token, vehicle_id_s)
  # Remember to set environment variables for telegram as well
  send_telegram_message(TELEGRAM_MESSAGE, 
                        Sys.getenv("TELEGRAM_CHAT_ID"), 
                        Sys.getenv("TELEGRAM_BOT_TOKEN"))
}