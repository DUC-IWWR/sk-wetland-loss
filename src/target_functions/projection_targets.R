projection_targets <- list(

  tar_target(
    name = projection_years,
    command = 100
  ),

  tar_target(
    name = drainage_rate_high,
    command = calculate_percent_change(terra::crop(ua_dd, smith_creek)) / 13
  ),

  tar_target(
    name = drainage_rate_low,
    command = calculate_percent_change(ua_dd) / 13
  ),

  tar_target(
    name = drainage_projection_high,
    command = calculate_drainage(
      fitted_data = fitted_impact_micar_lidar,
      thres = chosen_threshold,
      raw_data = point_data_subset,
      covariates = covariate_df_lidar,
      wetland_area = wetland_area_cwi,
      years = projection_years,
      drainage_rate = drainage_rate_high,
      stan_data = stan_data_lidar,
      stan_fit = model_lidar_mcmc_micar
    ) %>%
      dplyr::mutate(Scenario = rep("High", nrow(.)))
  ),

  tar_target(
    name = drainage_projection_low,
    command = calculate_drainage(
      fitted_data = fitted_impact_micar_lidar,
      thres = chosen_threshold,
      raw_data = point_data_subset,
      covariates = covariate_df_lidar,
      wetland_area = wetland_area_cwi,
      years = projection_years,
      drainage_rate = drainage_rate_low,
      stan_data = stan_data_lidar,
      stan_fit = model_lidar_mcmc_micar
    ) %>%
      dplyr::mutate(Scenario = rep("Low", nrow(.)))
  ),

  tar_target(
    name = drainage_scenarios,
    command = rbind(drainage_projection_high, drainage_projection_low)
  )

)