generate_fitted_shapefile <- function(shapefile, model, micar = FALSE) {

  theta_df <- model$summary(variables = "Theta")
  if (micar) {
    theta_df <- theta_df[seq_len(nrow(theta_df)) %% 3 == 1, ]
  }
  names(theta_df) <- paste0(names(theta_df), "_theta")

  beta_drainage_df <- model$summary(variables = "beta_drainage")
  names(beta_drainage_df) <- paste0(names(beta_drainage_df), "_drainage")

  beta_area_df <- model$summary(variables = "beta_area")
  names(beta_area_df) <- paste0(names(beta_area_df), "_area")

  shapefile_to_return <- cbind(
    shapefile,
    theta_df[,c(2,3,4,6,7,8)],
    beta_drainage_df[,c(2,3,4,6,7,8)],
    beta_area_df[,c(2,3,4,6,7,8)]
  )

}