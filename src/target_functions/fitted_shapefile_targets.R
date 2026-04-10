fitted_shapefile_targets <- list(
  tar_terra_vect(
    name = fitted_shapefile_icar,
    command = generate_fitted_shapefile(
      shapefile = smith_creek,
      model = model_mcmc_icar
    )
  ),

  tar_terra_vect(
    name = fitted_shapefile_micar,
    command = generate_fitted_shapefile(
      shapefile = smith_creek,
      model = model_mcmc_micar,
      micar = TRUE
    )
  )
)