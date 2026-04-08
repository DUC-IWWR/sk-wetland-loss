prediction_targets <- list(
  tar_target(
    name = pred_icar,
    command = generate_prediction_matrix(
      draws = model_mcmc_icar$draws("score", format = "df"),
      threshold = 0.7,
      data = stan_data
    )
  ),
  tar_target(
    name = pc_icar,
    command = mean(rowSums(pred_icar) / ncol(pred_icar))
  ),
  
  tar_target(
    name = pred_micar,
    command = generate_prediction_matrix(
      draws = model_mcmc_micar$draws("score", format = "df"),
      threshold = 0.7,
      data = stan_data
    )
  ),
  tar_target(
    name = pc_micar,
    command = mean(rowSums(pred_micar) / ncol(pred_micar))
  )
)
