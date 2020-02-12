options(googleAuthR.verbose=2) 

library(googleCloudRunner)
library(assertthat)
library(containerit)

#https://o2r.info/containerit/ - create container from R session or R file
#my_dockerfile <- containerit::dockerfile(from = utils::sessionInfo())
my_dockerfile <- containerit::dockerfile(from = here::here("push_vehicle_status_to_gcs.R"))
print(my_dockerfile)


write_to <- file.path(here::here("deploy"), "Dockerfile")
write(my_dockerfile, file = write_to)

assert_that(
  is.readable(write_to)
)

# Deploy a custom docker container with the R packages I need
cr_deploy_docker(#"my_folder_with_dockerfile", 
                 here::here("deploy"),
                 #image_name = "gcr.io/my-project/my-image",
                 image_name = "gcr.io/jas-test/my-r-image",
                 tag = "dev",
                 launch_browser = TRUE)

# check the script runs ok
cr_deploy_r(
  r = here::here("push_vehicle_status_to_gcs.R"),
  #r_image = "rocker/tidyverse",
  r_image = "gcr.io/jas-test/my-r-imag:dev",
  launch_browser = TRUE
)
