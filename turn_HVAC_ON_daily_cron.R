environment_variable_file <-  "set_environment_variables.R" #create this file
source(environment_variable_file)

source('functions.R')

MINIMUM_TEMPERATURE <- 20 #Celsius

# Authenticate
token <- get_access_token()

vehicle_id_s <- get_vehicle_id_s(token)

inside_temp <- get_internal_temperature(token, vehicle_id_s)

if (inside_temp > MINIMUM_TEMPERATURE) {
  start_hvac(token, vehicle_id_s)
}