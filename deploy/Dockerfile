FROM rocker/r-ver:3.6.1
LABEL maintainer="jas"
RUN export DEBIAN_FRONTEND=noninteractive; apt-get -y update \
  && apt-get install -y git-core \
	libcurl4-openssl-dev \
	libssl-dev \
	libxml2-dev \
	make \
	pandoc \
	pandoc-citeproc
RUN ["install2.r", "askpass", "assertthat", "backports", "bigrquery", "bit", "bit64", "broom", "cellranger", "cli", "colorspace", "crayon", "curl", "DBI", "dbplyr", "digest", "dplyr", "fansi", "forcats", "fs", "gargle", "generics", "ggplot2", "glue", "googleAuthR", "googleCloudStorageR", "gtable", "haven", "hms", "httr", "jsonlite", "lattice", "lazyeval", "lifecycle", "lubridate", "magrittr", "memoise", "mime", "modelr", "munsell", "nlme", "openssl", "pillar", "pkgconfig", "purrr", "R6", "Rcpp", "readr", "readxl", "remotes", "reprex", "rlang", "rprojroot", "rstudioapi", "rvest", "scales", "stringi", "stringr", "tibble", "tidyr", "tidyselect", "tidyverse", "vctrs", "withr", "xml2", "yaml", "zip"]
RUN ["installGithub.r", "krlmlr/here@d0feb09ec89dba81fabea11ee44385cda5f9c82f"]
WORKDIR /payload/
CMD ["R"]
