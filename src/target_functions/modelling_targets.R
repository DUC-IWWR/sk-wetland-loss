modelling_targets <- list(
  tar_stan_mcmc(
    name = model,
    stan_files = c(
      "models/icar.stan",
      "models/micar.stan"
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