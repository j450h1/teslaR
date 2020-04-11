library(here)
here()

#set_here()
#dr_here()
# https://www.teslaapi.io/vehicles/state-and-settings
source(here("functions.R"))

TELEGRAM_MESSAGE <- "The charge port is unlocked and the heat/or ac is turned on!"
#TEMP <- 22.2 #Celsius
#TEMP <- 72 #If it was Fahrenheit

# Authenticate
token <- get_access_token()

vehicle_id_s <- get_vehicle_id_s(token)

# Wake car up
wake_vehicle_up(token, vehicle_id_s)

# Turn heat on to 22.2 Celsius (72 F)
#set_temperature(token, vehicle_id_s, driver_temp = TEMP, passenger_temp = TEMP)
#Above doesn't work - rather it turns on AC and temperature gets very cold
start_hvac(token, vehicle_id_s)

# Unlock charge port
# Not working...
unlock_charge_port(token, vehicle_id_s)

# Not working...
#close_charge_port(token, vehicle_id_s)
send_telegram_message(
  TELEGRAM_MESSAGE,
  Sys.getenv("TELEGRAM_CHAT_ID"),
  Sys.getenv("TELEGRAM_BOT_TOKEN")
)