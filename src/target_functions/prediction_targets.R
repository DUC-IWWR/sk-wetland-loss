prediction_targets <- list(

  # Targets for generating score matrix
  tar_target(
    name = score_matrix_icar_cwi,
    command = generate_score_matrix(
      draws = model_cwi_mcmc_icar$draws("score", format = "df")
    )
  ),
  tar_target(
    name = score_matrix_micar_cwi,
    command = generate_score_matrix(
      draws = model_cwi_mcmc_micar$draws("score", format = "df")
    )
  ),
  tar_target(
    name = score_matrix_icar_lidar,
    command = generate_score_matrix(
      draws = model_lidar_mcmc_icar$draws("score", format = "df")
    )
  ),
  tar_target(
    name = score_matrix_micar_lidar,
    command = generate_score_matrix(
      draws = model_lidar_mcmc_micar$draws("score", format = "df")
    )
  ),

  # Targets for generating DF of precision, recall, and F1 versus various thresholds
  tar_target(
    name = prf1_icar_cwi,
    command = generate_prf1_df(
      score_matrix = score_matrix_icar_cwi,
      data = stan_data_cwi,
      increment = 0.05
    )
  ),

  tar_target(
    name = prf1_micar_cwi,
    command = generate_prf1_df(
      score_matrix = score_matrix_micar_cwi,
      data = stan_data_cwi,
      increment = 0.05
    )
  ),
    tar_target(
      name = prf1_icar_lidar,
      command = generate_prf1_df(
        score_matrix = score_matrix_icar_lidar,
        data = stan_data_lidar,
        increment = 0.05
      )
    ),
    
    tar_target(
      name = prf1_micar_lidar,
      command = generate_prf1_df(
        score_matrix = score_matrix_micar_lidar,
        data = stan_data_lidar,
        increment = 0.05
      )
    )

  # tar_target(
  #   name = pred_icar,
  #   command = generate_prediction_matrix(
  #     draws = model_mcmc_icar$draws("score", format = "df"),
  #     threshold = 0.7,
  #     data = stan_data
  #   )
  # ),
  # tar_target(
  #   name = pc_icar,
  #   command = mean(rowSums(pred_icar) / ncol(pred_icar))
  # ),
  
  # tar_target(
  #   name = pred_micar,
  #   command = generate_prediction_matrix(
  #     draws = model_mcmc_micar$draws("score", format = "df"),
  #     threshold = 0.7,
  #     data = stan_data
  #   )
  # ),
  # tar_target(
  #   name = pc_micar,
  #   command = mean(rowSums(pred_micar) / ncol(pred_micar))
  # )
)
