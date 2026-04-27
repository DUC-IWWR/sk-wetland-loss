modelling_targets <- list(
  tar_stan_mcmc(
    name = model_cwi,
    stan_files = c(
     "models/icar.stan",
      "models/micar.stan"
    ),
    data = stan_data_cwi,
    chains = 4,
    parallel_chains = 4,
    threads_per_chain = 2,
    adapt_delta = 0.99,
    cpp_options = list(stan_threads = TRUE),
    output_dir = "output/stan_dump"
  ),

  tar_stan_mcmc(
    name = model_lidar,
    stan_files = c(
     "models/icar.stan",
      "models/micar.stan"
    ),
    data = stan_data_lidar,
    chains = 4,
    parallel_chains = 4,
    threads_per_chain = 2,
    adapt_delta = 0.99,
    cpp_options = list(stan_threads = TRUE),
    output_dir = "output/stan_dump"
  )

  # tar_stan_mcmc(
  #   name = model_full,
  #   stan_files = "models/micar.stan",
  #   data = stan_data_full,
  #   chains = 4,
  #   parallel_chains = 4,
  #   threads_per_chain = 2,
  #   adapt_delta = 0.99,
  #   cpp_options = list(stan_threads = TRUE),
  #   output_dir = "output/stan_dump"
  # )
)