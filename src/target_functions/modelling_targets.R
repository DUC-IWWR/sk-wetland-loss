modelling_targets <- list(

  tar_target(
    name = stan_data,
    command = prepare_stan_data(
      data = combined_point_data,
      lidar_drainage = dd_ua_2023,
      shapefile = smith_creek)
  ),

  tar_stan_mcmc(
    name = model,
    stan_files = c(
      "models/icar.stan",
      "models/icar_drains.stan",
      "models/icar_area.stan",
       "models/icar_drains_area.stan",
      
       "models/micar.stan",
       "models/micar_drains.stan",
       "models/micar_area.stan",
      "models/micar_drains_area.stan"
    ),
    data = stan_data,
    chains = 4,
    parallel_chains = 4,
    threads_per_chain = 3,
    adapt_delta = 0.99,
    cpp_options = list(stan_threads = TRUE),
    output_dir = "output/stan_dump"
  )
)