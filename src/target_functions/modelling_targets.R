modelling_targets <- list(

  tar_target(
    name = stan_data,
    command = prepare_stan_data(
      data = combined_point_data,
      cwi_drainage = cwi_drainage_rast,
      lidar_drainage = dd_ua_2023,
      shapefile = smith_creek)
  ),
  # 
  # tar_target(
  #   name = prediction_list_sc,
  #   command = generate_prediction_list(combined_point_data, drains_per_basin_sc, smith_creek)
  # ),
  # # 
  # tar_stan_mcmc(
  #   name = sc_gamma_model,
  #   stan_files = c(
  #     "models/drainage_model_cwi_icar_only_gamma.stan",
  #     "models/drainage_model_cwi_icar_impact_gamma.stan",
  #     "models/drainage_model_icar_only_gamma.stan",
  #     "models/drainage_model_icar_impact_gamma.stan"
  #   ),
  #   data = stan_data_gamma_sc,
  #   chains = 4,
  #   parallel_chains = 4,
  #   threads_per_chain = 3,
  #   cpp_options = list(stan_threads = TRUE)
  # ),

  tar_stan_mcmc(
    name = model,
    stan_files = c(
      "models/drainage_model_cwi_icar_only.stan",
      "models/drainage_model_cwi_icar_drains.stan",
      "models/drainage_model_cwi_icar_area.stan",
      "models/drainage_model_cwi_icar_drains_area.stan",

      "models/drainage_model_icar_only.stan",
      "models/drainage_model_icar_drains.stan",
      "models/drainage_model_icar_area.stan",
      "models/drainage_model_icar_drains_area.stan"
    ),
    data = stan_data,
    chains = 4,
    parallel_chains = 4,
    threads_per_chain = 3,
    adapt_delta = 0.99,
    cpp_options = list(stan_threads = TRUE)
  )
)