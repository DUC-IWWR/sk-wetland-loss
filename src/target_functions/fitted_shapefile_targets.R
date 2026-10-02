fitted_shapefile_targets <- list(
  tar_terra_vect(
    name = fitted_shapefile_icar_cwi,
    command = generate_fitted_shapefile(
      shapefile = smith_creek,
      model = model_cwi_mcmc_icar
    ) |>
      tidyterra::mutate(Model = "ICAR CWI")
  ),

  
    tar_terra_vect(
    name = fitted_shapefile_icar_lidar,
    command = generate_fitted_shapefile(
      shapefile = smith_creek,
      model = model_lidar_mcmc_icar
    ) |>
      tidyterra::mutate(Model = "ICAR LiDAR")
  ),

  tar_terra_vect(
    name = fitted_shapefile_micar_cwi,
    command = generate_fitted_shapefile(
      shapefile = smith_creek,
      model = model_cwi_mcmc_micar,
      micar = TRUE
    ) |>
      tidyterra::mutate(Model = "MICAR CWI")
  ),

  tar_terra_vect(
    name = fitted_shapefile_micar_lidar,
    command = generate_fitted_shapefile(
      shapefile = smith_creek,
      model = model_lidar_mcmc_micar,
      micar = TRUE
    ) |>
      tidyterra::mutate(Model = "MICAR LiDAR")
  ),

  tar_terra_vect(
    name = combined_fitted_shapefile,
    command = tidyterra::bind_spat_rows(
      fitted_shapefile_icar_cwi,
      fitted_shapefile_micar_cwi,
      fitted_shapefile_icar_lidar,
      fitted_shapefile_micar_lidar
    ) |>
      tidyterra::mutate(dplyr::across(Model, ~factor(., levels=c("ICAR CWI","MICAR CWI","ICAR LiDAR", "MICAR LiDAR"))))
  )
)