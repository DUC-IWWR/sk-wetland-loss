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
tar_source("src/prepare-stan-data-gamma.R")
tar_source("src/generate-icar-matrix.R")
tar_source("src/mungeCARdata4stan.R")
tar_source("src/generate-prediction-list.R")
tar_source("src/generate-spatial-effects-map.R")
tar_source("src/generate-fitted-shapefile.R")

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
      tidyterra::mutate(dplyr::across(HYBAS_ID, as.character)) %>%
      data.frame(.) |>
      terra::vect(
        geom = c("Long", "Lat"),
        crs = "GEOGCRS[\"NAD83\",DATUM[\"North American Datum 1983\",ELLIPSOID[\"GRS 1980\",6378137,298.257222101,LENGTHUNIT[\"metre\",1]]],PRIMEM[\"Greenwich\",0,ANGLEUNIT[\"degree\",0.0174532925199433]],CS[ellipsoidal,2],AXIS[\"geodetic latitude (Lat)\",north,ORDER[1],ANGLEUNIT[\"degree\",0.0174532925199433]],AXIS[\"geodetic longitude (Lon)\",east,ORDER[2],ANGLEUNIT[\"degree\",0.0174532925199433]],USAGE[SCOPE[\"Geodesy.\"],AREA[\"North America - onshore and offshore: Canada - Alberta; British Columbia; Manitoba; New Brunswick; Newfoundland and Labrador; Northwest Territories; Nova Scotia; Nunavut; Ontario; Prince Edward Island; Quebec; Saskatchewan; Yukon. Puerto Rico. United States (USA) - Alabama; Alaska; Arizona; Arkansas; California; Colorado; Connecticut; Delaware; Florida; Georgia; Hawaii; Idaho; Illinois; Indiana; Iowa; Kansas; Kentucky; Louisiana; Maine; Maryland; Massachusetts; Michigan; Minnesota; Mississippi; Missouri; Montana; Nebraska; Nevada; New Hampshire; New Jersey; New Mexico; New York; North Carolina; North Dakota; Ohio; Oklahoma; Oregon; Pennsylvania; Rhode Island; South Carolina; South Dakota; Tennessee; Texas; Utah; Vermont; Virginia; Washington; West Virginia; Wisconsin; Wyoming. US Virgin Islands. British Virgin Islands.\"],BBOX[14.92,167.65,86.45,-40.73]],ID[\"EPSG\",4269]]"
      ) |>
      terra::project(terra::vect(drains_vb_shapefile)) |>
      terra::mask(x = _, mask = terra::hull(combined_point_data))
  ),
  tar_target(
    name = hydro_basins_shapefile,
    command = "data/raw/hydro_basins/hybas_na_lev12_v1c.shp",
    format = "file"
  ),
  tar_terra_vect(
    name = hydro_basins,
    command = terra::vect(hydro_basins_shapefile) |>
      terra::project(drains_vb) |>
      tidyterra::mutate(dplyr::across(HYBAS_ID, as.character)) |>
      terra::mask(x = _, mask = terra::hull(combined_point_data))
  ),
  tar_target(
    name = hydro_basins_reduced_shapefile,
    command = "data/raw/hydro_basins_reduced/hydro_basins_reduced.shp",
    format = "file"
  ),
  tar_terra_vect(
    name = hydro_basins_reduced,
    command = terra::vect(hydro_basins_reduced_shapefile)
  ),
  tar_target(
    name = smith_creek_shapefile,
    command = "data/raw/smith_creek/smith_creek.shp",
    format = "file"
  ),
  tar_terra_vect(
    name = smith_creek,
    command = terra::vect(smith_creek_shapefile)
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
    dplyr::mutate(
      Area_Scaled = scale(Area)[,1]
    ) |>
    terra::vect(
      geom = c("Longitude", "Latitude"),
      crs = "GEOGCRS[\"NAD83\",DATUM[\"North American Datum 1983\",ELLIPSOID[\"GRS 1980\",6378137,298.257222101,LENGTHUNIT[\"metre\",1]]],PRIMEM[\"Greenwich\",0,ANGLEUNIT[\"degree\",0.0174532925199433]],CS[ellipsoidal,2],AXIS[\"geodetic latitude (Lat)\",north,ORDER[1],ANGLEUNIT[\"degree\",0.0174532925199433]],AXIS[\"geodetic longitude (Lon)\",east,ORDER[2],ANGLEUNIT[\"degree\",0.0174532925199433]],USAGE[SCOPE[\"Geodesy.\"],AREA[\"North America - onshore and offshore: Canada - Alberta; British Columbia; Manitoba; New Brunswick; Newfoundland and Labrador; Northwest Territories; Nova Scotia; Nunavut; Ontario; Prince Edward Island; Quebec; Saskatchewan; Yukon. Puerto Rico. United States (USA) - Alabama; Alaska; Arizona; Arkansas; California; Colorado; Connecticut; Delaware; Florida; Georgia; Hawaii; Idaho; Illinois; Indiana; Iowa; Kansas; Kentucky; Louisiana; Maine; Maryland; Massachusetts; Michigan; Minnesota; Mississippi; Missouri; Montana; Nebraska; Nevada; New Hampshire; New Jersey; New Mexico; New York; North Carolina; North Dakota; Ohio; Oklahoma; Oregon; Pennsylvania; Rhode Island; South Carolina; South Dakota; Tennessee; Texas; Utah; Vermont; Virginia; Washington; West Virginia; Wisconsin; Wyoming. US Virgin Islands. British Virgin Islands.\"],BBOX[14.92,167.65,86.45,-40.73]],ID[\"EPSG\",4269]]"
    ) |>
    terra::project(terra::vect(drains_vb_shapefile))
  ),

  tar_target(
    name = drains_per_basin,
    command = terra::extract(hydro_basins, drains_vb) |>
    dplyr::bind_cols(dplyr::select(data.frame(drains_vb), Polyline_C)) |>
    dplyr::select(HYBAS_ID, Polyline_C) |>
    dplyr::group_by(HYBAS_ID) |>
    dplyr::summarise(n_drains = sum(Polyline_C)) |>
    dplyr::filter(!is.na(HYBAS_ID))
  ),
  tar_target(
    name = drains_per_basin_reduced,
    command = terra::extract(hydro_basins_reduced, drains_vb) |>
    dplyr::bind_cols(dplyr::select(data.frame(drains_vb), Polyline_C)) |>
    dplyr::select(HYBAS_ID, Polyline_C) |>
    dplyr::group_by(HYBAS_ID) |>
    dplyr::summarise(n_drains = sum(Polyline_C)) |>
    dplyr::filter(!is.na(HYBAS_ID))
  ),
    tar_target(
    name = drains_per_basin_sc,
    command = terra::extract(smith_creek, drains_vb) |>
    dplyr::bind_cols(dplyr::select(data.frame(drains_vb), Polyline_C)) |>
    dplyr::select(HYBAS_ID, Polyline_C) |>
    dplyr::group_by(HYBAS_ID) |>
    dplyr::summarise(n_drains = sum(Polyline_C)) |>
    dplyr::filter(!is.na(HYBAS_ID))
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
      geom_spatvector(data = hydro_basins, fill = NA) 
  ),


 
  
  ########## Modelling-related targets ###############

  tar_target(
    name = icar_matrix,
    command = generate_icar_matrix(hydro_basins)
  ),
  tar_target(
    name = stan_data,
    command = prepare_stan_data(combined_point_data, drains_per_basin, hydro_basins)
  ),
  tar_target(
    name = stan_data_reduced,
    command = prepare_stan_data(combined_point_data, drains_per_basin_reduced, hydro_basins_reduced)
  ),

  tar_target(
    name = stan_data_sc,
    command = prepare_stan_data(combined_point_data, drains_per_basin_reduced, smith_creek)
  ),
  
  tar_target(
    name = stan_data_gamma_sc,
    command = prepare_stan_data_gamma(combined_point_data, drains_per_basin_sc, smith_creek)
  ),

  tar_target(
    name = prediction_list,
    command = generate_prediction_list(combined_point_data, drains_per_basin, hydro_basins)
  ),

  tar_target(
    name = prediction_list_reduced,
    command = generate_prediction_list(combined_point_data, drains_per_basin_reduced, hydro_basins_reduced)
  ),

  tar_target(
    name = prediction_list_sc,
    command = generate_prediction_list(combined_point_data, drains_per_basin_sc, smith_creek)
  ),

  tar_stan_mcmc(
    name = model,
    stan_files = c("models/drainage_model.stan", "models/drainage_model_cwi.stan"),
    data = stan_data,
    chains = 4,
    parallel_chains = 4,
    threads_per_chain = 3,
    cpp_options = list(stan_threads = TRUE)
  ),

  tar_stan_mcmc(
    name = test_model,
    stan_files = c(
      "models/drainage_model_cwi_icar_only.stan",
      "models/drainage_model_icar_only.stan"
    ),
    data = stan_data_reduced,
    chains = 4,
    parallel_chains = 4,
    threads_per_chain = 3,
    iter_warmup = 500,
    iter_sampling = 500,
    cpp_options = list(stan_threads = TRUE)
  ),

  tar_stan_mcmc(
    name = sc_model,
    stan_files = c(
      "models/drainage_model_cwi_icar_only.stan",
      "models/drainage_model_icar_only.stan"
    ),
    data = stan_data_sc,
    chains = 4,
    parallel_chains = 4,
    threads_per_chain = 3,
    iter_warmup = 500,
    iter_sampling = 500,
    cpp_options = list(stan_threads = TRUE)
  ),
  
  tar_stan_mcmc(
    name = sc_gamma_model,
    stan_files = c(
      "models/drainage_model_cwi_icar_only_gamma.stan",
      "models/drainage_model_icar_only_gamma.stan"
    ),
    data = stan_data_gamma_sc,
    chains = 4,
    parallel_chains = 4,
    threads_per_chain = 3,
    iter_warmup = 500,
    iter_sampling = 500,
    cpp_options = list(stan_threads = TRUE)
  ),
  
  tar_terra_vect(
    name = fitted_drainage_shp_reduced_icar_only,
    command = generate_fitted_shapefile(
      hydro_basins = hydro_basins_reduced, 
      prediction_list = prediction_list_reduced, 
      model_summary = test_model_summary_drainage_model_icar_only, 
      model_draws = test_model_draws_drainage_model_icar_only,
      all_data = TRUE
    )
  ),
  tar_terra_vect(
    name = fitted_drainage_shp_reduced_cwi_icar_only,
    command = generate_fitted_shapefile(
      hydro_basins = hydro_basins_reduced, 
      prediction_list = prediction_list_reduced, 
      model_summary = test_model_summary_drainage_model_cwi_icar_only, 
      model_draws = test_model_draws_drainage_model_cwi_icar_only,
      all_data = FALSE)
  ),

  tar_terra_vect(
    name = fitted_sc_drainage_shp_reduced_icar_only,
    command = generate_fitted_shapefile(
      hydro_basins = smith_creek, 
      prediction_list = prediction_list_sc, 
      model_summary = sc_model_summary_drainage_model_icar_only, 
      model_draws = sc_model_draws_drainage_model_icar_only,
      all_data = TRUE
    )
  ),

  tar_terra_vect(
    name = fitted_sc_drainage_shp_reduced_cwi_icar_only,
    command = generate_fitted_shapefile(
      hydro_basins = smith_creek, 
      prediction_list = prediction_list_sc, 
      model_summary = sc_model_summary_drainage_model_cwi_icar_only, 
      model_draws = sc_model_draws_drainage_model_cwi_icar_only,
      all_data = FALSE)
  ),
  
  ########## Plotting ###############

  tar_target(
    name = spatial_effects_fig_reduced_icar_only,
    command = ggplot() + 
      geom_spatvector(
        data = fitted_drainage_shp_reduced_icar_only, 
        aes(fill = p_drainage_mean)
      )
  ),

  tar_target(
    name = spatial_effects_fig_reduced_cwi_icar_only,
    command = ggplot() + 
      geom_spatvector(
        data = fitted_drainage_shp_reduced_cwi_icar_only, 
        aes(fill = p_drainage_mean)
      )
  ),
  
  tar_target(
    name = spatial_effects_fig_combined,
    command = ggarrange(
      spatial_effects_fig_reduced_cwi_icar_only,
      spatial_effects_fig_reduced_icar_only,
      labels = c("CWI Only", "Combined"),
      nrow = 1,
      common.legend = TRUE)
  ),
  
  tar_target(
    name = spatial_effects_sd_fig_reduced_icar_only,
    command = ggplot() + 
      geom_spatvector(
        data = fitted_drainage_shp_reduced_icar_only, 
        aes(fill = p_drainage_sd)
      )
  ),

    tar_target(
    name = spatial_effects_sd_fig_reduced_cwi_icar_only,
    command = ggplot() + 
      geom_spatvector(
        data = fitted_drainage_shp_reduced_cwi_icar_only, 
        aes(fill = p_drainage_sd)
      )
  ),
  
  tar_target(
    name = spatial_effects_sd_fig_combined,
    command = ggarrange(
      spatial_effects_sd_fig_reduced_cwi_icar_only,
      spatial_effects_sd_fig_reduced_icar_only,
      labels = c("CWI Only", "Combined"),
      nrow = 1,
      common.legend = TRUE)
  ),
  
  
  tar_target(
    name = spatial_effects_sc_fig_reduced_icar_only,
    command = ggplot() + 
      geom_spatvector(
        data = fitted_sc_drainage_shp_reduced_icar_only, 
        aes(fill = p_drainage_mean)
      )
  ),
  
  tar_target(
    name = spatial_effects_sc_fig_reduced_cwi_icar_only,
    command = ggplot() + 
      geom_spatvector(
        data = fitted_sc_drainage_shp_reduced_cwi_icar_only, 
        aes(fill = p_drainage_mean)
      )
  ),
  
  tar_target(
    name = spatial_effects_sc_fig_combined,
    command = ggarrange(
      spatial_effects_sc_fig_reduced_cwi_icar_only,
      spatial_effects_sc_fig_reduced_icar_only,
      labels = c("CWI Only", "Combined"),
      nrow = 1,
      common.legend = TRUE)
  ),
  
  
  tar_target(
    name = spatial_effects_sc_sd_fig_reduced_icar_only,
    command = ggplot() + 
      geom_spatvector(
        data = fitted_sc_drainage_shp_reduced_icar_only, 
        aes(fill = p_drainage_sd)
      )
  ),
  
  tar_target(
    name = spatial_effects_sc_sd_fig_reduced_cwi_icar_only,
    command = ggplot() + 
      geom_spatvector(
        data = fitted_sc_drainage_shp_reduced_cwi_icar_only, 
        aes(fill = p_drainage_sd)
      )
  ),
  
  tar_target(
    name = spatial_effects_sc_sd_fig_combined,
    command = ggarrange(
      spatial_effects_sc_sd_fig_reduced_cwi_icar_only,
      spatial_effects_sc_sd_fig_reduced_icar_only,
      labels = c("CWI Only", "Combined"),
      nrow = 1,
      common.legend = TRUE)
  ),
  
  tar_target(
    name = sc_spatial_coverage_map,
    command = ggplot() + 
      geom_spatvector(
        data = tidyterra::filter(
          .data = terra::mask(combined_point_data, smith_creek),
          Impact == "Drained"), 
        aes(color = Model), 
        size = 0.5) + geom_spatvector(data = smith_creek, fill = NA)
  ),
  
  tar_target(
    name = sc_spatial_coverage_map_cwi,
    command = ggplot() + 
      geom_spatvector(
        data = tidyterra::filter(
          .data = terra::mask(combined_point_data, smith_creek),
          Impact == "Drained",
          Model == "CWI"), 
        color = "darkgreen", 
        size = 0.5) + geom_spatvector(data = smith_creek, fill = NA)
  )
  
)
