fitted_shapefile_targets <- list(
  tar_terra_vect(
    name = fitted_shapefile_icar_cwi,
    command = generate_fitted_shapefile(
      shapefile = smith_creek,
      model = model_cwi_mcmc_icar
    )
  ),

  tar_terra_vect(
    name = fitted_shapefile_micar_cwi,
    command = generate_fitted_shapefile(
      shapefile = smith_creek,
      model = model_cwi_mcmc_micar,
      micar = TRUE
    )
  ),

    tar_terra_vect(
    name = fitted_shapefile_icar_lidar,
    command = generate_fitted_shapefile(
      shapefile = smith_creek,
      model = model_lidar_mcmc_icar
    )
  ),

  tar_terra_vect(
    name = fitted_shapefile_micar_lidar,
    command = generate_fitted_shapefile(
      shapefile = smith_creek,
      model = model_lidar_mcmc_micar,
      micar = TRUE
    )
  )
)