library(targets)

tar_option_set(
  packages = c("dplyr", "tibble")
)

source("R/targets/pipeline_smoke.R")

list(
  tar_smoke_targets()
)
