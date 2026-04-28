model_assessment_targets <- list(

  # Targets for generating fitted impacts/scores
  tar_target(
    name = fitted_impact_icar_cwi,
    command = generate_fitted_impact(
      stan_fit = model_cwi_mcmc_icar,
      data = stan_data_cwi
    )
  ),
  tar_target(
    name = fitted_impact_micar_cwi,
    command = generate_fitted_impact(
      stan_fit = model_cwi_mcmc_micar,
      data = stan_data_cwi,
      micar = TRUE
    )
  ),
  tar_target(
    name = fitted_impact_icar_lidar,
    command = generate_fitted_impact(
      stan_fit = model_lidar_mcmc_icar,
      data = stan_data_lidar
    )
  ),
  tar_target(
    name = fitted_impact_micar_lidar,
    command = generate_fitted_impact(
      stan_fit = model_lidar_mcmc_micar,
      data = stan_data_lidar,
      micar = TRUE
    )
  ),

  tar_target(
    name = lppd_icar_cwi,
    command = 
      dbinom(
        x = stan_data_cwi$impact_cwi_tr,
        size = 1,
        prob = fitted_impact_icar_cwi$y_fitted,
        log = FALSE
      )
  ),
  tar_target(
    name = lppd_micar_cwi,
    command = 
      dbinom(
        x = stan_data_cwi$impact_cwi_tr,
        size = 1,
        prob = fitted_impact_micar_cwi$y_fitted,
        log = FALSE
      )
  ),
  tar_target(
    name = lppd_icar_lidar,
    command =
      dbinom(
        x = stan_data_lidar$impact_cwi_tr,
        size = 1,
        prob = fitted_impact_icar_lidar$y_fitted,
        log = FALSE
      )
  ),
  tar_target(
    name = lppd_micar_lidar,
    command = 
      dbinom(
        x = stan_data_lidar$impact_cwi_tr,
        size = 1,
        prob = fitted_impact_micar_lidar$y_fitted,
        log = FALSE
      )
  ),
  tar_target(
    name = lppd_summary,
    command = c(
      sum(lppd_icar_cwi, na.rm = TRUE),
      sum(lppd_micar_cwi, na.rm = TRUE),
      sum(lppd_icar_lidar, na.rm = TRUE),
      sum(lppd_micar_lidar, na.rm = TRUE)
    ) |>
      setNames(c("ICAR CWI", "MICAR CWI",  "ICAR LIDAR", "MICAR LIDAR"))
  ),

  # # Targets for generating score matrix
  # tar_target(
  #   name = score_matrix_icar_cwi,
  #   command = generate_score_matrix(
  #     draws = model_cwi_mcmc_icar$draws("score", format = "df")
  #   )
  # ),
  # tar_target(
  #   name = score_matrix_micar_cwi,
  #   command = generate_score_matrix(
  #     draws = model_cwi_mcmc_micar$draws("score", format = "df")
  #   )
  # ),
  # tar_target(
  #   name = score_matrix_icar_lidar,
  #   command = generate_score_matrix(
  #     draws = model_lidar_mcmc_icar$draws("score", format = "df")
  #   )
  # ),
  # tar_target(
  #   name = score_matrix_micar_lidar,
  #   command = generate_score_matrix(
  #     draws = model_lidar_mcmc_micar$draws("score", format = "df")
  #   )
  # ),

  #Targets for generating DF of precision, recall, and F1 versus various thresholds
  tar_target(
    name = prf1_icar_cwi,
    command = generate_prf1_df(
      score_matrix = matrix(
        data = fitted_impact_icar_cwi$y_fitted,
        nrow = 1
      ),
      data = stan_data_cwi,
      increment = 0.01
    )
  ),
  tar_target(
    name = prf1_micar_cwi,
    command = generate_prf1_df(
      score_matrix = matrix(
        data = fitted_impact_micar_cwi$y_fitted,
        nrow = 1
      ),
      data = stan_data_cwi,
      increment = 0.01
    )
  ),
  tar_target(
    name = prf1_icar_lidar,
    command = generate_prf1_df(
      score_matrix = matrix(
        data = fitted_impact_icar_lidar$y_fitted,
        nrow = 1
      ),
      data = stan_data_lidar,
      increment = 0.01
    )
  ),
  tar_target(
    name = prf1_micar_lidar,
    command = generate_prf1_df(
      score_matrix = matrix(
        data = fitted_impact_micar_lidar$y_fitted,
        nrow = 1
      ),
      data = stan_data_lidar,
      increment = 0.01
    )
  )
)
