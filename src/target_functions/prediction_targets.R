prediction_targets <- list(
  tar_target(
    name = pred_cwi_icar_only,
    command = generate_prediction_matrix(
      draws = model_mcmc_drainage_model_cwi_icar_only$draws("score", format = "df"),
      threshold = 0.7,
      data = stan_data
    )
  ),
  tar_target(
    name = pc_cwi_icar_only,
    command = mean(rowSums(pred_cwi_icar_only) / ncol(pred_cwi_icar_only))
  )
)