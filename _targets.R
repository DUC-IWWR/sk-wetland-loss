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
library(magrittr)
theme_set(theme_pubclean())

# Set target options:
tar_option_set(
  packages = c("tibble")
)

# Run the R scripts in the R/ folder with your custom functions:
#tar_source("src/build-vb-db.R")
tar_source("src/prepare-stan-data.R")

list(
  ########### Targets for checking file existence/updates and loading in files #######################
  # The main ones we will probably
  tar_target(
    name = cwi_drainage_file,
    command = "data/raw/CWI_Drained_UnDrained.txt",
    format = "file"
  ),
  tar_target(
    name = cwi_drainage,
    command = read.csv(cwi_drainage_file)
  ),
  tar_target(
    name = cd_drainage_file,
    command = "data/raw/ImpactModels_Drained_UnDrained.txt",
    format = "file"
  ),
  tar_target(
    name = cd_drainage,
    command = read.csv(cd_drainage_file)
  ),
  tar_target(
    name = cwi_points_file,
    command = "data/raw/Points_CWI_Drained_UnDrained.txt",
    format = "file"
  ),
  tar_target(
    name = cwi_points,
    command = read.csv(cwi_points_file)
  ),

  # Shapefiles
  tar_target(
    name = drains_vb_shapefile,
    command = "data/raw/Drains_VirtualBasin_summary/Drains_VirtualBasin_summary.shp",
    format = "file"
  ),
  tar_terra_vect(
    name = drains_vb,
    command = terra::vect(drains_vb_shapefile) |> 
      tidyterra::mutate(dplyr::across(HYBAS_ID, as.character)) |>
      tidyterra::filter(HYBAS_ID != "0")
  ),
  tar_target(
    name = hydro_basins_shapefile,
    command = "data/raw/hydro_basins/hybas_na_lev12_v1c.shp",
    format = "file"
  ),
  tar_terra_vect(
    name = hydro_basins,
    command = terra::vect(hydro_basins_shapefile) |>
      tidyterra::mutate(dplyr::across(HYBAS_ID, as.character))
  ),
  tar_target(
    name = wsa_shapefile,
    command = "data/raw/WSA_Watershed_Planning_Areas/WSA_Watershed_Planning_Areas.shp",
    format = "file"
  ),
  tar_terra_vect(
    name = wsa,
    command = terra::vect(wsa_shapefile) |> terra::project(drains_vb)
  ),
  
  ####### Target for creating the overall dataset including geometry #######################

  # combined_point_data
  tar_terra_vect(
    name = combined_point_data,
    command = dplyr::bind_rows(
      # Change detection drainage dataset
      (
        cd_drainage |>
          dplyr::select(
            c("Impact", "Impact_Lat", "Impact_Long", "ClassNum", "ClassName", "WS_AREA_KM", "WS_PERI_KM", "Shape_Length", "Shape_Area")
          ) |>
          dplyr::rename(
            tidyselect::all_of(
              c(
                Latitude = "Impact_Lat",
                Longitude = "Impact_Long",
                Length = "Shape_Length",
                Area = "Shape_Area"
              )
            )
          ) |>
          dplyr::mutate(
            Model = rep("CD", nrow(cd_drainage))
          )
      ),
      # CWI drainage dataset
      (
        cwi_drainage |>
          dplyr::select(
            c("Impact", "CWI_Lat", "CWI_Long", "ClassNum", "ClassName", "WS_AREA_KM", "WS_PERI_KM", "CWI_Shape_Length", "CWI_Shape_Area")
          ) |>
          dplyr::rename(
            tidyselect::all_of(
              c(
                Latitude = "CWI_Lat",
                Longitude = "CWI_Long",
                Length = "CWI_Shape_Length",
                Area = "CWI_Shape_Area"
              )
            )
          ) |>
          dplyr::mutate(
            Model = rep("CWI", nrow(cwi_drainage))
          )
      ),
      # CWI drainage dataset, points only
      (
        cwi_points |>
          dplyr::select(
            c("Impact", "Point_Lat", "Point_Long", "ClassNum", "ClassName", "WS_AREA_KM", "WS_PERI_KM", "Point_m2")
          ) |>
          dplyr::rename(
            tidyselect::all_of(
              c(
                Latitude = "Point_Lat",
                Longitude = "Point_Long",
                Area = "Point_m2"
              )
            )
          ) |>
          dplyr::mutate(
            Length = rep(NA, nrow(cwi_points)),
            .before = "Area"
          ) |>
          dplyr::mutate(
            Model = rep("CWI_Point", nrow(cwi_points))
          )
      )
    ) |> #end dplyr::bind_rows call
    terra::vect(
      geom = c("Longitude", "Latitude"),
      crs <- terra::crs(hydro_basins)
    ) %>%
    tidyterra::bind_spat_cols(
      .,
      terra::extract(
        tidyterra::select(
          hydro_basins, HYBAS_ID
        ),
        .
      )
    ) |>
    dplyr::mutate(
      HYBAS_ID_Factor = as.integer(as.factor(HYBAS_ID))
    )

  ),
  
  ############ Targets for exploratory analysis #####################

  tar_target(
    name = drains_by_vb_plot,
    command = ggplot() +
      geom_spatvector(data = drains_vb, aes(fill = Polyline_C))
  ),

  tar_target(
    name = drainage_distribution_plot,
    command = ggplot() +
      geom_spatvector(
        data = tidyterra::filter(
          .data = combined_point_data,
          Impact == "Drained" & Model == "CWI"
        ),
        aes(
          color = "CWI"
        ),
        size = 0.2
      ) + 
      geom_spatvector(
        data = tidyterra::filter(
          .data = combined_point_data,
          Impact == "Drained" & Model == "CD"
        ),
        aes(
          color = "CD"
        ),
        size = 0.2
      ) +  
      geom_spatvector(
        data = tidyterra::filter(
          .data = combined_point_data,
          Impact == "Drained" & Model == "CWI_Point"
        ),
        aes(
          color = "CWI_Point"
        ),
        size = 0.2
      ) +  
      geom_spatvector(data = hydro_basins, fill = NA) +
      xlim(terra::ext(combined_point_data)[1], terra::ext(combined_point_data)[2]) +
      ylim(terra::ext(combined_point_data)[3], terra::ext(combined_point_data)[4])
  ),


 
  
  ########## Modelling-related targets ###############
  tar_target(
    name = stan_data,
    command = prepare_stan_data(combined_point_data)
  ),

  tar_stan_mcmc(
    name = model,
    stan_files = c("models/drainage_model.stan"),
    data = stan_data
  )
  
)
