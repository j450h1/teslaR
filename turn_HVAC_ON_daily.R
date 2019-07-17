#environment_variable_file <-  "set_environment_variables.R" #create this file
#source(environment_variable_file)

source('functions.R')

MINIMUM_TEMPERATURE <- 18 #Celsius
TELEGRAM_MESSAGE <- "The HVAC has been turned on!"

# Authenticate
token <- get_access_token()

vehicle_id_s <- get_vehicle_id_s(token)

#get_vehicle_status(token, vehicle_id_s)
#get_charge_state(token, vehicle_id_s)

#wake vehicle first
wake_vehicle_up(token, vehicle_id_s) 

inside_temp <- get_internal_temperature(token, vehicle_id_s)

if (inside_temp > MINIMUM_TEMPERATURE) {
  wake_vehicle_up(token, vehicle_id_s) 
  #wait some time for it to wake up
  Sys.sleep(20)
  start_hvac(token, vehicle_id_s)
  # Remember to set environment variables for telegram as well
  send_telegram_message(TELEGRAM_MESSAGE, 
                        Sys.getenv("TELEGRAM_CHAT_ID"), 
                        Sys.getenv("TELEGRAM_BOT_TOKEN"))
}
