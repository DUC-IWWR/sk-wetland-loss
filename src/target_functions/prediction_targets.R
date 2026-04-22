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
      increment = 0.01,
      thin = 4
    )
  ),

  tar_target(
    name = prf1_micar_cwi,
    command = generate_prf1_df(
      score_matrix = score_matrix_micar_cwi,
      data = stan_data_cwi,
      increment = 0.01,
      thin = 4
    )
  ),
    tar_target(
      name = prf1_icar_lidar,
      command = generate_prf1_df(
        score_matrix = score_matrix_icar_lidar,
        data = stan_data_lidar,
        increment = 0.01,
        thin = 4
      )
    ),
    
    tar_target(
      name = prf1_micar_lidar,
      command = generate_prf1_df(
        score_matrix = score_matrix_micar_lidar,
        data = stan_data_lidar,
        increment = 0.01,
        thin = 4
      )
    ),

    tar_target(
      name = loglik_holdout_icar_cwi,
      command = model_cwi_mcmc_icar$summary(variables = "score") |>
        dplyr::pull(mean) |> 
        inv_logit() |>
        calculate_holdout_loglik(outcomes = stan_data_cwi$impact_cwi_te)
    ),
    tar_target(
      name = loglik_holdout_micar_cwi,
      command = model_cwi_mcmc_micar$summary(variables = "score") |>
        dplyr::pull(mean) |> 
        inv_logit() |>
        calculate_holdout_loglik(outcomes = stan_data_cwi$impact_cwi_te)
    ),
    tar_target(
      name = loglik_holdout_icar_lidar,
      command = model_lidar_mcmc_icar$summary(variables = "score") |>
        dplyr::pull(mean) |> 
        inv_logit() |>
        calculate_holdout_loglik(outcomes = stan_data_lidar$impact_cwi_te)
    ),
    tar_target(
      name = loglik_holdout_micar_lidar,
      command = model_lidar_mcmc_micar$summary(variables = "score") |>
        dplyr::pull(mean) |> 
        inv_logit() |>
        calculate_holdout_loglik(outcomes = stan_data_lidar$impact_cwi_te)
    ),

    tar_target(
      name = holdout_likelihood,
      command = c(
        loglik_holdout_icar_cwi,
        loglik_holdout_micar_cwi,
        loglik_holdout_icar_lidar,
        loglik_holdout_micar_lidar
      ) |>
        setNames(c("ICAR CWI", "MICAR CWI",  "ICAR LIDAR", "MICAR LIDAR"))
    )


)
