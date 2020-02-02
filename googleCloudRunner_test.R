library(googleCloudRunner)

# this can be an R filepath or lines of R read in from a script
r_lines <- c("list.files()",
             "library(dplyr)",
             "mtcars %>% select(mpg)",
             "sessionInfo()")

# check the script runs ok
cr_deploy_r(r_lines)

# schedule the script once its working  
cr_deploy_r(r_lines, schedule = "15 21 * * *")