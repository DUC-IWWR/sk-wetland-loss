loo_targets <- list(
  tar_target(
    name = ll_cwi_icar_only,
    command = log_lik(
      draws = model_draws_drainage_model_cwi_icar_only,
      stan_data = stan_data,
      drains_cwi = FALSE,
      drains_lidar = FALSE,
      area = FALSE
    )
  )
)