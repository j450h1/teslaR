library(here)
here()

#set_here()
#dr_here()
# https://www.teslaapi.io/vehicles/state-and-settings
source(here("functions.R"))

TELEGRAM_MESSAGE <- "The heat is turned on!"
#TEMP <- 22.2 #Celsius

# Authenticate
token <- get_access_token()

vehicle_id_s <- get_vehicle_id_s(token)

# Wake car up
wake_vehicle_up(token, vehicle_id_s)

# Turn heat on to 22.2 Celsius (72 F)
#set_temperature(token, vehicle_id_s, driver_temp = TEMP, passenger_temp = TEMP)
# Above doesn't work as intended

# Turn heat on or ac on based on desired temperature preset (in car or app?)
start_hvac(token, vehicle_id_s)

send_telegram_message(
  TELEGRAM_MESSAGE,
  Sys.getenv("TELEGRAM_CHAT_ID"),
  Sys.getenv("TELEGRAM_BOT_TOKEN")
)