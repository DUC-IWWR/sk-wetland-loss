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
  ),
  
  tar_target(
    name = pred_cwi_icar_area,
    command = generate_prediction_matrix(
      draws = model_mcmc_drainage_model_cwi_icar_area$draws("score", format = "df"),
      threshold = 0.7,
      data = stan_data
    )
  ),
  tar_target(
    name = pc_cwi_icar_area,
    command = mean(rowSums(pred_cwi_icar_area) / ncol(pred_cwi_icar_area))
  ),
  
  tar_target(
    name = pred_cwi_icar_drains,
    command = generate_prediction_matrix(
      draws = model_mcmc_drainage_model_cwi_icar_drains$draws("score", format = "df"),
      threshold = 0.7,
      data = stan_data
    )
  ),
  tar_target(
    name = pc_cwi_icar_drains,
    command = mean(rowSums(pred_cwi_icar_drains) / ncol(pred_cwi_icar_drains))
  ),
  
  tar_target(
    name = pred_cwi_icar_drains_area,
    command = generate_prediction_matrix(
      draws = model_mcmc_drainage_model_cwi_icar_drains_area$draws("score", format = "df"),
      threshold = 0.7,
      data = stan_data
    )
  ),
  tar_target(
    name = pc_cwi_icar_drains_area,
    command = mean(rowSums(pred_cwi_icar_drains_area) / ncol(pred_cwi_icar_drains_area))
  ),
  
  
  
  
  tar_target(
    name = pred_icar_only,
    command = generate_prediction_matrix(
      draws = model_mcmc_drainage_model_icar_only$draws("score", format = "df"),
      threshold = 0.7,
      data = stan_data
    )
  ),
  tar_target(
    name = pc_icar_only,
    command = mean(rowSums(pred_icar_only) / ncol(pred_icar_only))
  ),
  
  tar_target(
    name = pred_icar_area,
    command = generate_prediction_matrix(
      draws = model_mcmc_drainage_model_icar_area$draws("score", format = "df"),
      threshold = 0.7,
      data = stan_data
    )
  ),
  tar_target(
    name = pc_icar_area,
    command = mean(rowSums(pred_icar_area) / ncol(pred_icar_area))
  ),
  
  tar_target(
    name = pred_icar_drains,
    command = generate_prediction_matrix(
      draws = model_mcmc_drainage_model_icar_drains$draws("score", format = "df"),
      threshold = 0.7,
      data = stan_data
    )
  ),
  tar_target(
    name = pc_icar_drains,
    command = mean(rowSums(pred_icar_drains) / ncol(pred_icar_drains))
  ),
  
  tar_target(
    name = pred_icar_drains_area,
    command = generate_prediction_matrix(
      draws = model_mcmc_drainage_model_icar_drains_area$draws("score", format = "df"),
      threshold = 0.7,
      data = stan_data
    )
  ),
  tar_target(
    name = pc_icar_drains_area,
    command = mean(rowSums(pred_icar_drains_area) / ncol(pred_icar_drains_area))
  ),
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  tar_target(
    name = pred_cwi_icar_only_0.9,
    command = generate_prediction_matrix(
      draws = model_mcmc_drainage_model_cwi_icar_only$draws("score", format = "df"),
      threshold = 0.9,
      data = stan_data
    )
  ),
  tar_target(
    name = pc_cwi_icar_only_0.9,
    command = mean(rowSums(pred_cwi_icar_only) / ncol(pred_cwi_icar_only))
  ),
  
  tar_target(
    name = pred_cwi_icar_area_0.9,
    command = generate_prediction_matrix(
      draws = model_mcmc_drainage_model_cwi_icar_area$draws("score", format = "df"),
      threshold = 0.9,
      data = stan_data
    )
  ),
  tar_target(
    name = pc_cwi_icar_area_0.9,
    command = mean(rowSums(pred_cwi_icar_area) / ncol(pred_cwi_icar_area))
  ),
  
  tar_target(
    name = pred_cwi_icar_drains_0.9,
    command = generate_prediction_matrix(
      draws = model_mcmc_drainage_model_cwi_icar_drains$draws("score", format = "df"),
      threshold = 0.9,
      data = stan_data
    )
  ),
  tar_target(
    name = pc_cwi_icar_drains_0.9,
    command = mean(rowSums(pred_cwi_icar_drains) / ncol(pred_cwi_icar_drains))
  ),
  
  tar_target(
    name = pred_cwi_icar_drains_area_0.9,
    command = generate_prediction_matrix(
      draws = model_mcmc_drainage_model_cwi_icar_drains_area$draws("score", format = "df"),
      threshold = 0.9,
      data = stan_data
    )
  ),
  tar_target(
    name = pc_cwi_icar_drains_area_0.9,
    command = mean(rowSums(pred_cwi_icar_drains_area) / ncol(pred_cwi_icar_drains_area))
  ),
  
  
  
  
  tar_target(
    name = pred_icar_only_0.9,
    command = generate_prediction_matrix(
      draws = model_mcmc_drainage_model_icar_only$draws("score", format = "df"),
      threshold = 0.9,
      data = stan_data
    )
  ),
  tar_target(
    name = pc_icar_only_0.9,
    command = mean(rowSums(pred_icar_only) / ncol(pred_icar_only))
  ),
  
  tar_target(
    name = pred_icar_area_0.9,
    command = generate_prediction_matrix(
      draws = model_mcmc_drainage_model_icar_area$draws("score", format = "df"),
      threshold = 0.9,
      data = stan_data
    )
  ),
  tar_target(
    name = pc_icar_area_0.9,
    command = mean(rowSums(pred_icar_area) / ncol(pred_icar_area))
  ),
  
  tar_target(
    name = pred_icar_drains_0.9,
    command = generate_prediction_matrix(
      draws = model_mcmc_drainage_model_icar_drains$draws("score", format = "df"),
      threshold = 0.9,
      data = stan_data
    )
  ),
  tar_target(
    name = pc_icar_drains_0.9,
    command = mean(rowSums(pred_icar_drains) / ncol(pred_icar_drains))
  ),
  
  tar_target(
    name = pred_icar_drains_area_0.9,
    command = generate_prediction_matrix(
      draws = model_mcmc_drainage_model_icar_drains_area$draws("score", format = "df"),
      threshold = 0.9,
      data = stan_data
    )
  ),
  tar_target(
    name = pc_icar_drains_area_0.9,
    command = mean(rowSums(pred_icar_drains_area) / ncol(pred_icar_drains_area))
  )
)