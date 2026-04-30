projection_targets <- list(
  tar_target(
    name = current_drainage,
    command = calculate_drainage(
      fitted_data = fitted_impact_micar_cwi,
      thres = chosen_threshold,
      raw_data = point_data_subset,
      covariates = covariate_df_cwi
    )
  ),

  tar_target(
    name = current_drainage_proportion,
    command = calculate_drainage(
      fitted_data = fitted_impact_micar_cwi,
      thres = chosen_threshold,
      raw_data = point_data_subset,
      covariates = covariate_df_cwi,
      calculate_proportion = TRUE,
      by_basin = FALSE
    )
  ),

  tar_target(
    name = drainage_projection_high,
    command = calculate_drainage(
      fitted_data = fitted_impact_micar_cwi,
      thres = chosen_threshold,
      raw_data = point_data_subset,
      covariates = covariate_df_cwi,
      years = 20,
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
      years = 20,
      drainage_rate = 0.82/100,
      stan_data = stan_data_cwi,
      stan_fit = model_cwi_mcmc_micar
    ) %>%
      dplyr::mutate(Scenario = rep("Low", nrow(.)))
  ),

  tar_target(
    name = drainage_projection_high_prop,
    command = calculate_drainage(
      fitted_data = fitted_impact_micar_cwi,
      thres = chosen_threshold,
      raw_data = point_data_subset,
      covariates = covariate_df_cwi,
      years = 20,
      drainage_rate = 1.6/100,
      calculate_proportion = TRUE,
      by_basin = FALSE,
      stan_data = stan_data_cwi,
      stan_fit = model_cwi_mcmc_micar
    ) %>%
      dplyr::mutate(Scenario = rep("High", nrow(.)))
  ),

  tar_target(
    name = drainage_projection_low_prop,
    command = calculate_drainage(
      fitted_data = fitted_impact_micar_cwi,
      thres = chosen_threshold,
      raw_data = point_data_subset,
      covariates = covariate_df_cwi,
      years = 20,
      drainage_rate = 0.82/100,
      calculate_proportion = TRUE,
      by_basin = FALSE,
      stan_data = stan_data_cwi,
      stan_fit = model_cwi_mcmc_micar
    ) %>%
      dplyr::mutate(Scenario = rep("Low", nrow(.)))
  ),

  tar_target(
    name = drainage_scenarios,
    command = rbind(drainage_projection_high, drainage_projection_low)
  ),

  tar_target(
    name = drainage_scenarios_prop,
    command = rbind(drainage_projection_high_prop, drainage_projection_low_prop)
  )
)