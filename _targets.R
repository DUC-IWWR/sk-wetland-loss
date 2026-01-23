####### Script Information ########################
# Brandon P.M. Edwards
# SK Wetlands Loss
# Created June 2025
# Last Updated January 2026

# Load packages required to define the pipeline:
library(targets)
library(tarchetypes)
library(geotargets)
library(ggplot2)
library(ggpubr)
library(tidyterra)
library(stantargets)
library(magrittr)
library(tibble)
theme_set(theme_pubclean())

# Set target options:
tar_option_set(
  packages = c("tibble", "foreach", "doParallel", "loo")
)

# Run the R scripts in the R/ folder with your custom functions:
#tar_source("src/build-vb-db.R")
tar_source("src/prepare-stan-data.R")
tar_source("src/generate-icar-matrix.R")
tar_source("src/mungeCARdata4stan.R")
tar_source("src/generate-prediction-list.R")
tar_source("src/generate-spatial-effects-map.R")
tar_source("src/generate-fitted-shapefile.R")
tar_source("src/generate-prediction-matrix.R")
#tar_source("src/log_lik.R")

# Functions to generate grouped targets
tar_source("src/target_functions/file_io_targets.R")
tar_source("src/target_functions/data_wrangling_targets.R")
tar_source("src/target_functions/exploratory_analysis_targets.R")
tar_source("src/target_functions/modelling_targets.R")
tar_source("src/target_functions/prediction_targets.R")
#tar_source("src/target_functions/loo_targets.R")
tar_source("src/target_functions/fitted_shapefile_targets.R")
tar_source("src/target_functions/post_hoc_plotting_targets.R")

list(

  file_io_targets,

  data_wrangling_targets,

  exploratory_analysis_targets,
 
  modelling_targets,
  prediction_targets,
  #loo_targets,
  
  fitted_shapefile_targets,
  
  post_hoc_plotting_targets,
  tar_target(
    name = percent_correct_summary,
    command = tibble(
      Model = c("CWI_ICAR", "CWI_ICAR_Area", "CWI_ICAR_Drains", "CWI_ICAR_Drains_Area", "ICAR", "ICAR_Area", "ICAR_Drains", "ICAR_Drains_Area"),
      Percent_Correct = c(
        pc_cwi_icar_only,
        pc_cwi_icar_drains,
        pc_cwi_icar_area,
        pc_cwi_icar_drains_area,
        pc_icar_only,
        pc_icar_drains,
        pc_icar_area,
        pc_icar_drains_area
      )
    )
  )
)
