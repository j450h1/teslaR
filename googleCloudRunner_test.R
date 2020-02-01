library(googleCloudRunner)

# this can be an R filepath or lines of R read in from a script
r_lines <- c("list.files()",
             "library(dplyr)",
             "mtcars %>% select(mpg)",
             "sessionInfo()")

# example code runs against a source that is a mirrored GitHub repo
source <- cr_build_source(RepoSource("googleCloudStorageR",
                                     branchName = "master"))

# check the script runs ok
cr_deploy_r(r_lines, source = source)

# schedule the script once its working
cr_deploy_r(r_lines, schedule = "15 21 * * *", source = source)