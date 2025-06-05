####### Script Information ########################
# Brandon P.M. Edwards
# SK Wetlands Loss
# Created June 2025
# Last Updated June 2025

# Load packages required to define the pipeline:
library(targets)
library(tarchetypes)
library(ggplot2)
library(ggpubr)
theme_set(theme_pubclean())

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
  
  # Targets for exploratory plots of data
  tar_target(
    name = drain_length_plot,
    command = ggplot(data = drains_vb_data[which(drains_vb_data$Drains_km > 0), ], 
                     aes(x = Drains_km)) + 
                geom_histogram() +
                xlab("KM of Drains") +
                ylab("Count") + 
                NULL
  ),
  tar_target(
    name = n_drains_plot,
    command = ggplot(data = drains_vb_data[which(drains_vb_data$Drains_count > 0),], 
                     aes(x = Drains_count)) +
                geom_histogram() +
                xlab("Number of Drains") +
                ylab("Count") +
                NULL
  ),
  tar_target(
    name = length_vs_n_plot,
    command = ggplot(data = drains_vb_data[which(drains_vb_data$Drains_count > 0 &
                                                 drains_vb_data$Drains_km > 0), ],
                    aes(x = Drains_count, y = Drains_km)) +
                geom_point() +
                xlab("Number of Drains") +
                ylab("Length of Drains") +
                NULL
  ),
  tar_target(
    name = combined_drains_plot,
    command = ggarrange(ggarrange(drain_length_plot, n_drains_plot),
                        length_vs_n_plot,
                        nrow = 2)
  ),
  
  tar_target(
    name = class_1_drainage_plot,
    command = ggplot(data = cwi_impact_vb_data[which(cwi_impact_vb_data$CWI_Impact == 1), ],
                      aes(x = Area_km2 / WS_AREA_KM2)) +
                geom_histogram() +
                xlab("Percent Drained Class 1") +
                ylab("Count") +
                NULL
  ),
  tar_target(
    name = class_5_drainage_plot,
    command = ggplot(data = cwi_impact_vb_data[which(cwi_impact_vb_data$CWI_Impact == 5), ],
                      aes(x = Area_km2 / WS_AREA_KM2)) +
                geom_histogram() +
                xlab("Percent Drained Class 5") +
                ylab("Count") +
                NULL
  ),
  tar_target(
   name = combined_class_drainage_plot,
   command = ggarrange(class_1_drainage_plot, class_5_drainage_plot)
  ),
  
  
  
  
  # Final report
  tar_quarto(
    name = report,
    path = "output/reports/report.qmd"
  )
  
)
