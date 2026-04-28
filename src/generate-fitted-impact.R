generate_fitted_impact <- function(stan_fit, data, micar = FALSE) {
  area_params <- stan_fit$summary(variables = "beta_area")
  drainage_params <- stan_fit$summary(variables = "beta_drainage")
  Theta_params <- stan_fit$summary(variables = "Theta")
  if (micar) {
    Theta_params <- Theta_params[seq_len(nrow(Theta_params)) %% 3 == 1, ]
  }

  y_fitted <- inv_logit(Theta_params$mean[data$basin_cwi_tr] +
    area_params$mean[data$basin_cwi_tr] * data$area_cwi_tr +
    drainage_params$mean[data$basin_cwi_tr] * data$dd_cwi_tr)

  y_q5 <- inv_logit(Theta_params$q5[data$basin_cwi_tr] +
    area_params$q5[data$basin_cwi_tr] * data$area_cwi_tr +
    drainage_params$q5[data$basin_cwi_tr] * data$dd_cwi_tr)

  y_q95 <- inv_logit(Theta_params$q95[data$basin_cwi_tr] +
  area_params$q95[data$basin_cwi_tr] * data$area_cwi_tr +
  drainage_params$q95[data$basin_cwi_tr] * data$dd_cwi_tr)
  
  return(data.frame(y_fitted = y_fitted, y_q5 = y_q5, y_q95 = y_q95))
}