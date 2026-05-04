projection_targets <- list(
  # CWI Dataset
  tar_target(
    name = current_drainage_cwi,
    command = calculate_drainage(
      fitted_data = fitted_impact_micar_cwi,
      thres = chosen_threshold,
      raw_data = point_data_subset,
      covariates = covariate_df_cwi
    )
  ),

  tar_target(
    name = current_drainage_proportion_cwi,
    command = calculate_drainage(
      fitted_data = fitted_impact_micar_cwi,
      thres = chosen_threshold,
      raw_data = point_data_subset,
      covariates = covariate_df_cwi,
      calculate_proportion = TRUE,
      by_basin = TRUE
    )
  ),

  tar_target(
    name = drainage_projection_high_cwi,
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
    name = drainage_projection_low_cwi,
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
    name = drainage_projection_high_prop_cwi,
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
    name = drainage_projection_high_prop_cwi_basin,
    command = calculate_drainage(
      fitted_data = fitted_impact_micar_cwi,
      thres = chosen_threshold,
      raw_data = point_data_subset,
      covariates = covariate_df_cwi,
      years = 20,
      drainage_rate = 1.6/100,
      calculate_proportion = TRUE,
      by_basin = TRUE,
      stan_data = stan_data_cwi,
      stan_fit = model_cwi_mcmc_micar
    ) %>%
      dplyr::mutate(Scenario = rep("High", nrow(.)))
  ),

  tar_target(
    name = drainage_projection_low_prop_cwi,
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
    name = drainage_scenarios_cwi,
    command = rbind(drainage_projection_high_cwi, drainage_projection_low_cwi)
  ),

  tar_target(
    name = drainage_scenarios_prop_cwi,
    command = rbind(drainage_projection_high_prop_cwi, drainage_projection_low_prop_cwi)
  ),

 #CD Dataset
  tar_target(
    name = current_drainage_cd,
    command = calculate_drainage(
      fitted_data = fitted_impact_micar_cwi_cd,
      thres = chosen_threshold,
      raw_data = point_data_subset,
      covariates = covariate_df_cwi,
      dataset = "CD"
    )
  ),

  tar_target(
    name = current_drainage_proportion_cd,
    command = calculate_drainage(
      fitted_data = fitted_impact_micar_cwi_cd,
      thres = chosen_threshold,
      raw_data = point_data_subset,
      covariates = covariate_df_cwi,
      calculate_proportion = TRUE,
      by_basin = FALSE,
      dataset = "CD"
    )
  ),

  tar_target(
    name = drainage_projection_high_cd,
    command = calculate_drainage(
      fitted_data = fitted_impact_micar_cwi_cd,
      thres = chosen_threshold,
      raw_data = point_data_subset,
      covariates = covariate_df_cwi,
      years = 20,
      drainage_rate = 1.6/100,
      stan_data = stan_data_cwi,
      stan_fit = model_cwi_mcmc_micar,
      dataset = "CD"
    ) %>%
      dplyr::mutate(Scenario = rep("High", nrow(.)))
  ),

  tar_target(
    name = drainage_projection_low_cd,
    command = calculate_drainage(
      fitted_data = fitted_impact_micar_cwi_cd,
      thres = chosen_threshold,
      raw_data = point_data_subset,
      covariates = covariate_df_cwi,
      years = 20,
      drainage_rate = 0.82/100,
      stan_data = stan_data_cwi,
      stan_fit = model_cwi_mcmc_micar,
      dataset = "CD"
    ) %>%
      dplyr::mutate(Scenario = rep("Low", nrow(.)))
  ),

  tar_target(
    name = drainage_projection_high_prop_cd,
    command = calculate_drainage(
      fitted_data = fitted_impact_micar_cwi_cd,
      thres = chosen_threshold,
      raw_data = point_data_subset,
      covariates = covariate_df_cwi,
      years = 20,
      drainage_rate = 1.6/100,
      calculate_proportion = TRUE,
      by_basin = FALSE,
      stan_data = stan_data_cwi,
      stan_fit = model_cwi_mcmc_micar,
      dataset = "CD"
    ) %>%
      dplyr::mutate(Scenario = rep("High", nrow(.)))
  ),

  tar_target(
    name = drainage_projection_low_prop_cd,
    command = calculate_drainage(
      fitted_data = fitted_impact_micar_cwi_cd,
      thres = chosen_threshold,
      raw_data = point_data_subset,
      covariates = covariate_df_cwi,
      years = 20,
      drainage_rate = 0.82/100,
      calculate_proportion = TRUE,
      by_basin = FALSE,
      stan_data = stan_data_cwi,
      stan_fit = model_cwi_mcmc_micar,
      dataset = "CD"
    ) %>%
      dplyr::mutate(Scenario = rep("Low", nrow(.)))
  ),

  tar_target(
    name = drainage_scenarios_cd,
    command = rbind(drainage_projection_high_cd, drainage_projection_low_cd)
  ),

  tar_target(
    name = drainage_scenarios_prop_cd,
    command = rbind(drainage_projection_high_prop_cd, drainage_projection_low_prop_cd)
  )
)