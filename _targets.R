####### Script Information ########################
# Brandon P.M. Edwards
# SK Wetlands Loss
# Created June 2025
# Last Updated June 2025

# Load packages required to define the pipeline:
library(targets)
library(tarchetypes)
library(geotargets)
library(ggplot2)
library(ggpubr)
theme_set(theme_pubclean())

# Set target options:
tar_option_set(
  packages = c("tibble")
)

# Run the R scripts in the R/ folder with your custom functions:
tar_source("src/merge-vb-datasets.R")

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
  tar_target(
    name = vb_shapefile,
    command = "data/raw/Drains_VirtualBasin_summary/Drains_VirtualBasin_summary.shp",
    format = "file"
  ),
  tar_terra_vect(
    name = vb,
    command = terra::vect(vb_shapefile)
  ),
  
  #' Target for creating the overall dataset including geometry. I.e., let's merge the datasets
  #' back together.
  tar_terra_vect(
    name = vb_db,
    command = merge_vb_datasets(drains_vb_data,
                                cwi_impact_vb_data,
                                vb)
  ),
  
  tar_target(
    name = wsa_data_wide,
    command = reshape2::dcast(data = cwi_impact_wsa_data,
                              formula = Join_ID + Name ~ IMPACT,
                              value.var = "Sum_area_km2")
  ),
  
  
  # Targets for exploratory plots of data
  tar_target(
    name = drain_length_plot,
    command = ggplot(data = data.frame(vb_db[which(vb_db$sum_Length > 0),]), 
                     aes(x = sum_Length)) + 
                geom_histogram() +
                xlab("KM of Drains") +
                ylab("Count") + 
                NULL
  ),
  tar_target(
    name = n_drains_plot,
    command = ggplot(data = data.frame(vb_db[which(vb_db$Polyline_C > 0),]), 
                     aes(x = Polyline_C)) +
                geom_histogram() +
                xlab("Number of Drains") +
                ylab("Count") +
                NULL
  ),
  tar_target(
    name = length_vs_n_plot,
    command = ggplot(data = data.frame(vb_db[which(vb_db$Polyline_C > 0 &
                                                    vb_db$sum_Length > 0), ]),
                    aes(x = Polyline_C, y = sum_Length)) +
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
    command = ggplot(data = data.frame(vb_db),
                      aes(x = CWI_1 / CWI_Total)) +
                geom_histogram() +
                xlab("Percent Drained Class 1") +
                ylab("Count") +
                NULL
  ),
  tar_target(
    name = class_5_drainage_plot,
    command = ggplot(data = data.frame(vb_db),
                      aes(x = CWI_5 / CWI_Total)) +
                geom_histogram() +
                xlab("Percent Drained Class 5") +
                ylab("Count") +
                NULL
  ),
  tar_target(
   name = combined_class_drainage_plot,
   command = ggarrange(class_1_drainage_plot, class_5_drainage_plot)
  ),
  
  tar_target(
    name = drains_per_sq_km_plot,
    command = ggplot(data = data.frame(vb_db), 
                      aes(x = Long, y = Lat, colour = as.numeric(Polyline_C) / as.numeric(WS_AREA_KM))) +
                geom_point() +
                xlab("Longitude") +
                ylab("Latitude") +
                labs(colour= "Drains / km^2") +
               # theme(legend.position = "none") +
                NULL
  ),
  tar_target(
    name = drainage_per_sq_km_plot,
    command = ggplot(data = data.frame(vb_db),
                      aes(x = Long, y = Lat, colour = (CWI_1 + CWI_5) / CWI_Total)) +
                geom_point() +
                xlab("Longitude") +
                ylab("Latitude") +
                labs(colour="% Wetland Drained") +
               # theme(legend.position = "none") + 
                NULL
  ),
  
  
  # Final report
  tar_quarto(
    name = report,
    path = "output/reports/report.qmd"
  )
  
)
