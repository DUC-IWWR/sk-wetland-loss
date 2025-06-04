####### Script Information ########################
# Brandon P.M. Edwards
# SK Wetlands Loss
# Created June 2025
# Last Updated June 2025

# Load packages required to define the pipeline:
library(targets)

# Set target options:
tar_option_set(
  packages = c("tibble")
)

# Run the R scripts in the R/ folder with your custom functions:
tar_source("src/model-drained-vb.R")

list(
  # Targets for checking file existence/updates and loading in files
  tar_target(
    name = drains_vb_data_file,
    command = "data/raw/drains_vb.csv",
    format = "file"
  ),
  tar_target(
    name = drains_vb_data,
    command = read.csv(drains_vb_data_file)
  ),
  tar_target(
    name = cwi_impact_vb_data_file,
    command = "data/raw/cwi_impact_vb.csv",
    format = "file"
  ),
  tar_target(
    name = cwi_impact_vb_data,
    command = read.csv(cwi_impact_vb_data_file),
  ),
  tar_target(
    name = cwi_impact_wsa_data_file,
    command = "data/raw/cwi_impact_wsa.csv",
    format = "file"
  ),
  tar_target(
    name = cwi_impact_wsa_data,
    command = read.csv(cwi_impact_wsa_data_file)
  ),
  
  # Targets for data wrangling
  tar_target(
    name = drained_vb,
    command = merge(x = cwi_impact_vb_data[which(cwi_impact_vb_data$CWI_Impact %in% c(1,5)),], 
                    y = drains_vb_data[, c("BasinID", "Drains_km", "Drains_count")],
                    by = "BasinID")
  ),
  
  # Targets for modelling
  tar_target(
    name = drained_vb_model,
    command = model_drained_vb()
  )
  
)
