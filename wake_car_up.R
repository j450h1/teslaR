source("functions.R")

TELEGRAM_MESSAGE <- "The car is now awake!"

# Authenticate
token <- get_access_token()

vehicle_id_s <- get_vehicle_id_s(token)

wake_vehicle_up(token, vehicle_id_s)

send_telegram_message(
  TELEGRAM_MESSAGE,
  Sys.getenv("TELEGRAM_CHAT_ID"),
  Sys.getenv("TELEGRAM_BOT_TOKEN")
)