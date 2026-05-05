projection_targets <- list(

  tar_target(
    name = drainage_projection_high,
    command = calculate_drainage(
      fitted_data = fitted_impact_micar_cwi,
      thres = chosen_threshold,
      raw_data = point_data_subset,
      covariates = covariate_df_cwi,
      wetland_area = wetland_area_cwi,
      years = 50,
      drainage_rate = 1.6/100,
      stan_data = stan_data_cwi,
      stan_fit = model_cwi_mcmc_micar
    ) %>%
      dplyr::mutate(Scenario = rep("High", nrow(.)))
  ),

  tar_target(
    name = drainage_projection_low,
    command = calculate_drainage(
      fitted_data = fitted_impact_micar_cwi,
      thres = chosen_threshold,
      raw_data = point_data_subset,
      covariates = covariate_df_cwi,
      wetland_area = wetland_area_cwi,
      years = 50,
      drainage_rate = 0.82/100,
      stan_data = stan_data_cwi,
      stan_fit = model_cwi_mcmc_micar
    ) %>%
      dplyr::mutate(Scenario = rep("Low", nrow(.)))
  ),

  tar_target(
    name = drainage_scenarios,
    command = rbind(drainage_projection_high, drainage_projection_low)
  )

)