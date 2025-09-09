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
library(tidyterra)
library(stantargets)
theme_set(theme_pubclean())

# Set target options:
tar_option_set(
  packages = c("tibble")
)

# Run the R scripts in the R/ folder with your custom functions:
tar_source("src/build-vb-db.R")
tar_source("src/generate-stan-data.R")

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
    name = cwi_vb_statistics_file,
    command = "data/raw/cwi_vb_statistics.csv",
    format = "file"
  ),
  tar_target(
    name = cwi_vb_statistics,
    command = read.csv(cwi_vb_statistics_file)
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
  tar_target(
    name = wsa_shapefile,
    command = "data/raw/WSA_Watershed_Planning_Areas/WSA_Watershed_Planning_Areas.shp",
    format = "file"
  ),
  tar_terra_vect(
    name = wsa,
    command = terra::vect(wsa_shapefile) |> terra::project(vb)
  ),
  
  
  
  
  
  
  
  
  
  
  #' Target for creating the overall dataset including geometry.
  tar_terra_vect(
    name = vb_db,
    command = build_vb_db(drains_data = drains_vb_data,
                          cwi_data = cwi_impact_vb_data,
                          vb_statistics = cwi_vb_statistics,
                          vb_shp = vb,
                          wsa_shp = wsa)
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
                      aes(x = (CWI_1 / CWI_Total) * 100)) +
                geom_histogram() +
                xlab("Percent Drained Class 1") +
                ylab("Count") +
                NULL
  ),
  tar_target(
    name = class_5_drainage_plot,
    command = ggplot(data = data.frame(vb_db),
                      aes(x = (CWI_5 / CWI_Total) * 100)) +
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
    name = drains_vs_drainage_plot,
    command = ggplot(data = data.frame(vb_db),
                     aes(x = sum_Length, y = Percent_Drained * 100)) +
      geom_point() +
      xlab("Number of Drains") +
      ylab("Percent Area Drained") +
      NULL
  ),
  
  tar_target(
    name = drains_vs_lcclass_plot,
    command = ggplot(data = data.frame(vb_db),
                     aes(x = LCClassNam, y = Polyline_C)) +
      geom_boxplot() + 
      xlab("Landcover Class") +
      ylab("Number of Drains") +
      theme(axis.text.x = element_text(angle = 90)) +
      NULL
  ),
  
  tar_target(
    name = drainage_vs_lcclass_plot,
    command = ggplot(data = data.frame(vb_db),
                     aes(x = LCClassNam, y = Percent_Drained * 100)) +
      geom_boxplot() + 
      xlab("Landcover Class") +
      ylab("Percent Area Drained") +
      theme(axis.text.x = element_text(angle = 90)) +
      NULL
  ),
  
  tar_target(
    name = combined_boxplots,
    command = ggarrange(drains_vs_lcclass_plot, 
                        drainage_vs_lcclass_plot)
  ),
  
  tar_target(
    name = drains_per_sq_km_plot,
    command = ggplot(data = vb_db, aes(fill = (Polyline_C / WS_AREA_KM))) +
                geom_spatvector() +
                xlab("Longitude") +
                ylab("Latitude") +
                labs(fill = "Drains / km^2") +
               # theme(legend.position = "none") +
                NULL
  ),
  tar_target(
    name = drainage_per_sq_km_plot,
    command = ggplot(data = vb_db, aes(fill = Percent_Drained * 100)) +
                geom_spatvector() +
                xlab("Longitude") +
                ylab("Latitude") +
                labs(fill = "% Wetland Drained / km^2") +
               # theme(legend.position = "none") + 
                NULL
  ),
  
  tar_target(
    name = combined_spatial_plot,
    command = ggarrange(drains_per_sq_km_plot, drainage_per_sq_km_plot)
  ),
  
  tar_target(
    name = stan_data,
    command = generate_stan_data(vb_db)
  ),
  
  tar_stan_mcmc(
    name = model,
    stan_files = c("models/null.stan",
                   "models/n_drains.stan",
                   "models/wsa.stan"),
    data = stan_data
  ),
  
  
  # Final report
  tar_quarto(
    name = report,
    path = "output/reports/report.qmd"
  )
  
)
