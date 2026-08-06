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
    name = fitted_impact_micar_cwi_cd,
    command = generate_fitted_impact(
      stan_fit = model_cwi_mcmc_micar,
      data = stan_data_cwi,
      micar = TRUE,
      dataset = "cd"
    )
  ),

  tar_target(
    name = fitted_impact_micar_lidar_cd,
    command = generate_fitted_impact(
      stan_fit = model_lidar_mcmc_micar,
      data = stan_data_lidar,
      micar = TRUE,
      dataset = "cd"
    )
  ),

  tar_target(
    name = fitted_impact_full_cwi,
    command = generate_fitted_impact_full(
      stan_fit = model_cwi_mcmc_micar,
      data = stan_data_cwi
    )
  ),

  tar_target(
    name = fitted_impact_full_lidar,
    command = generate_fitted_impact_full(
      stan_fit = model_lidar_mcmc_micar,
      data = stan_data_lidar
    )
  ),

  tar_target(
    name = lppd_full_cwi,
    command = list(
      cwi = dbinom(
        x = stan_data_cwi$impact_cwi_tr,
        size = 1,
        prob = fitted_impact_full_cwi$cwi,
        log = FALSE
      ),
      cd = dbinom(
        x = stan_data_cwi$impact_cd,
        size = 1,
        prob = fitted_impact_full_cwi$cd,
        log = FALSE
      ),
      cwi_p = dbinom(
        x = stan_data_cwi$impact_cwi_p,
        size = 1,
        prob = fitted_impact_full_cwi$cwi_p,
        log = FALSE
      )
    )
  ),

  tar_target(
    name = lppd_full_dataframe,
    command = data.frame(
      lppd_cwi = c(lppd_full_cwi$cwi, lppd_full_cwi$cd, lppd_full_cwi$cwi_p),
      lppd_lidar = c(lppd_full_lidar$cwi, lppd_full_lidar$cd, lppd_full_lidar$cwi_p),
      basin = c(stan_data_cwi$basin_cwi_tr, stan_data_cwi$basin_cd, stan_data_cwi$basin_cwi_p),
      data_source = c(
        rep("CWI", length(stan_data_cwi$basin_cwi_tr)),
        rep("CD", length(stan_data_cwi$basin_cd)),
        rep("CWI_P", length(stan_data_cwi$basin_cwi_p))
      )
    ) |>
      dplyr::mutate(
        lppd_diff = lppd_cwi - lppd_lidar,
        basin_data = paste0(basin, "-", data_source)
      )
  ),

  tar_target(
    name = lppd_full_lidar,
    command = list(
      cwi = dbinom(
        x = stan_data_lidar$impact_cwi_tr,
        size = 1,
        prob = fitted_impact_full_lidar$cwi,
        log = FALSE
      ),
      cd = dbinom(
        x = stan_data_lidar$impact_cd,
        size = 1,
        prob = fitted_impact_full_lidar$cd,
        log = FALSE
      ),
      cwi_p = dbinom(
        x = stan_data_lidar$impact_cwi_p,
        size = 1,
        prob = fitted_impact_full_lidar$cwi_p,
        log = FALSE
      )
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

  tar_target(
    name = lppd_micar_lidar_cd,
    command = 
      dbinom(
        x = stan_data_lidar$impact_cd,
        size = 1,
        prob = fitted_impact_micar_lidar_cd$y_fitted,
        log = FALSE        
      )
  ),


  tar_target(
    name = lppd_micar_cwi_cd,
    command = 
      dbinom(
        x = stan_data_cwi$impact_cd,
        size = 1,
        prob = fitted_impact_micar_cwi_cd$y_fitted,
        log = FALSE        
      )
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
  ),

  #' This target is based on results above. Eventually can look to make this dynamic

  tar_target(
    name = chosen_threshold,
    command = 0.25
  )
)
