generate_fitted_impact <- function(stan_fit, data, micar = FALSE, dataset = "cwi") {
  area_params <- stan_fit$summary(variables = "beta_area")
  drainage_params <- stan_fit$summary(variables = "beta_drainage")
  Theta_params <- stan_fit$summary(variables = "Theta")
  if (micar) {
    if (dataset == "cwi") {
      Theta_params <- Theta_params[seq_len(nrow(Theta_params)) %% 3 == 1, ]
      y_fitted <- inv_logit(Theta_params$mean[data$basin_cwi_tr] +
      area_params$mean[data$basin_cwi_tr] * data$area_cwi_tr +
      drainage_params$mean[data$basin_cwi_tr] * data$dd_cwi_tr)

      y_q5 <- inv_logit(Theta_params$q5[data$basin_cwi_tr] +
      area_params$q5[data$basin_cwi_tr] * data$area_cwi_tr +
      drainage_params$q5[data$basin_cwi_tr] * data$dd_cwi_tr)

      y_q95 <- inv_logit(Theta_params$q95[data$basin_cwi_tr] +
      area_params$q95[data$basin_cwi_tr] * data$area_cwi_tr +
      drainage_params$q95[data$basin_cwi_tr] * data$dd_cwi_tr)
    } else if (dataset == "cd") {
      Theta_params <- Theta_params[seq_len(nrow(Theta_params)) %% 3 == 2, ]
      y_fitted <- inv_logit(Theta_params$mean[data$basin_cd] +
      area_params$mean[data$basin_cd] * data$area_cd +
      drainage_params$mean[data$basin_cd] * data$dd_cd)

      y_q5 <- inv_logit(Theta_params$q5[data$basin_cd] +
      area_params$q5[data$basin_cd] * data$area_cd +
      drainage_params$q5[data$basin_cd] * data$dd_cd)

      y_q95 <- inv_logit(Theta_params$q95[data$basin_cd] +
      area_params$q95[data$basin_cd] * data$area_cd +
      drainage_params$q95[data$basin_cd] * data$dd_cd)      
    }
    
  } else {
    y_fitted <- inv_logit(Theta_params$mean[data$basin_cwi_tr] +
    area_params$mean[data$basin_cwi_tr] * data$area_cwi_tr +
    drainage_params$mean[data$basin_cwi_tr] * data$dd_cwi_tr)

    y_q5 <- inv_logit(Theta_params$q5[data$basin_cwi_tr] +
    area_params$q5[data$basin_cwi_tr] * data$area_cwi_tr +
    drainage_params$q5[data$basin_cwi_tr] * data$dd_cwi_tr)

    y_q95 <- inv_logit(Theta_params$q95[data$basin_cwi_tr] +
    area_params$q95[data$basin_cwi_tr] * data$area_cwi_tr +
    drainage_params$q95[data$basin_cwi_tr] * data$dd_cwi_tr)    
  }

  return(data.frame(y_fitted = y_fitted, y_q5 = y_q5, y_q95 = y_q95))
}

generate_fitted_impact_full <- function(stan_fit, data) {
  area_params <- stan_fit$summary(variables = "beta_area")
  drainage_params <- stan_fit$summary(variables = "beta_drainage")
  Theta_params <- stan_fit$summary(variables = "Theta")
  
  # CWI 
  Theta_params_dataset <- Theta_params[seq_len(nrow(Theta_params)) %% 3 == 1, ]
  y_fitted_cwi <- inv_logit(Theta_params_dataset$mean[data$basin_cwi_tr] +
  area_params$mean[data$basin_cwi_tr] * data$area_cwi_tr +
  drainage_params$mean[data$basin_cwi_tr] * data$dd_cwi_tr)

  y_q5_cwi <- inv_logit(Theta_params_dataset$q5[data$basin_cwi_tr] +
  area_params$q5[data$basin_cwi_tr] * data$area_cwi_tr +
  drainage_params$q5[data$basin_cwi_tr] * data$dd_cwi_tr)

  y_q95_cwi <- inv_logit(Theta_params_dataset$q95[data$basin_cwi_tr] +
  area_params$q95[data$basin_cwi_tr] * data$area_cwi_tr +
  drainage_params$q95[data$basin_cwi_tr] * data$dd_cwi_tr)
  
  # CD
  Theta_params_dataset <- Theta_params[seq_len(nrow(Theta_params)) %% 3 == 2, ]
  y_fitted_cd <- inv_logit(Theta_params_dataset$mean[data$basin_cd] +
  area_params$mean[data$basin_cd] * data$area_cd +
  drainage_params$mean[data$basin_cd] * data$dd_cd)

  y_q5_cd <- inv_logit(Theta_params_dataset$q5[data$basin_cd] +
  area_params$q5[data$basin_cd] * data$area_cd +
  drainage_params$q5[data$basin_cd] * data$dd_cd)

  y_q95_cd <- inv_logit(Theta_params_dataset$q95[data$basin_cd] +
  area_params$q95[data$basin_cd] * data$area_cd +
  drainage_params$q95[data$basin_cd] * data$dd_cd)
  
  # CWI Point
  Theta_params_dataset <- Theta_params[seq_len(nrow(Theta_params)) %% 3 == 0, ]
  y_fitted_cwi_p <- inv_logit(Theta_params_dataset$mean[data$basin_cwi_p] +
  drainage_params$mean[data$basin_cwi_p] * data$dd_cwi_p)

  y_q5_cwi_p <- inv_logit(Theta_params_dataset$q5[data$basin_cwi_p] +
  drainage_params$q5[data$basin_cwi_p] * data$dd_cwi_p)

  y_q95_cwi_p <- inv_logit(Theta_params_dataset$q95[data$basin_cwi_p] +
  drainage_params$q95[data$basin_cwi_p] * data$dd_cwi_p)
  
  y_fitted <- list(
    cwi = y_fitted_cwi,
    cd = y_fitted_cd,
    cwi_p = y_fitted_cwi_p,

    cwi_q5 = y_q5_cwi,
    cd_q5 = y_q5_cd,
    cwi_p_q5 = y_q5_cwi_p,

    cwi_q95 = y_q95_cwi,
    cd_q95 = y_q95_cd,
    cwi_p_q95 = y_q95_cwi_p
  )
}
