modelling_targets <- list(
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
    name = stan_data_dd,
    command = prepare_stan_data_dd(combined_point_data, dd_ua_2023, smith_creek_reduced)
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
    name = sc_gamma_model,
    stan_files = c(
      "models/drainage_model_cwi_icar_only_gamma.stan",
      "models/drainage_model_cwi_icar_impact_gamma.stan",
      "models/drainage_model_icar_only_gamma.stan",
      "models/drainage_model_icar_impact_gamma.stan"
    ),
    data = stan_data_gamma_sc,
    chains = 4,
    parallel_chains = 4,
    threads_per_chain = 3,
    cpp_options = list(stan_threads = TRUE)
  ),

  tar_stan_mcmc(
    name = sc_model,
    stan_files = c(
      "models/drainage_model_cwi_icar_only.stan",
      "models/drainage_model_cwi_icar_drains.stan",
      "models/drainage_model_cwi_icar_drains_area.stan",

      "models/drainage_model_icar_only.stan",
      "models/drainage_model_icar_drains.stan",
      "models/drainage_model_icar_drains_area.stan"
    ),
    data = stan_data_dd,
    chains = 4,
    parallel_chains = 4,
    threads_per_chain = 3,
    adapt_delta = 0.99,
    cpp_options = list(stan_threads = TRUE)
  )
)