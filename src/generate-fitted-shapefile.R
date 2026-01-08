generate_fitted_shapefile <- function(hydro_basins, prediction_list, model_summary, model_draws, all_data) {

  inv_logit <- function(x) exp(x)/(1+exp(x))

  data <- data.frame(
    "HYBAS_ID" = prediction_list$basin_cwi_string,
    "HYBAS_ID_Factor" = prediction_list$basin_cwi
  )

  data <- data[-which(duplicated(data$HYBAS_ID)), ]
  df_to_populate <- NULL
  for (i in 1:nrow(data)) {

    if (is.null(df_to_populate)) {
      if (all_data) {
        df_to_populate <- model_summary[which(model_summary$variable == paste0("Theta[1,", data$HYBAS_ID_Factor[i], "]")), ]
      } else {
        df_to_populate <- model_summary[which(model_summary$variable == paste0("Theta[", data$HYBAS_ID_Factor[i], "]")), ]
      }
    } else {
      if (all_data) {
        df_to_populate <- rbind(
          df_to_populate,
          model_summary[which(model_summary$variable == paste0("Theta[1,", data$HYBAS_ID_Factor[i], "]")), ]
        )
      } else {
        df_to_populate <- rbind(
          df_to_populate,
          model_summary[which(model_summary$variable == paste0("Theta[", data$HYBAS_ID_Factor[i], "]")), ]
        )        
      }

    }
  }

  # Take inverse logit of the means and median here
  df_to_populate$p_drainage_mean <- NA
  df_to_populate$p_drainage_median <- NA
  df_to_populate$p_drainage_sd <- NA
  df_to_populate$p_drainage_q5 <- NA
  df_to_populate$p_drainage_q95 <- NA
  for (i in 1:nrow(df_to_populate)) {
    var <- df_to_populate$variable[i]
    var_draws <- unlist(unname(as.vector(model_draws[, var])))
    var_draws_il <- inv_logit(var_draws)

    df_to_populate$p_drainage_mean[i] <- mean(var_draws_il)
    df_to_populate$p_drainage_median[i] <- median(var_draws_il)
    df_to_populate$p_drainage_sd[i] <- sd(var_draws_il)
    df_to_populate$p_drainage_q5[i] <- quantile(var_draws_il, 0.05) 
    df_to_populate$p_drainage_q95[i] <- quantile(var_draws_il, 0.95)
  }

  data <- cbind(
    data[,"HYBAS_ID"],
    df_to_populate[,c(
      "p_drainage_mean",
      "p_drainage_median",
      "p_drainage_sd",
      "p_drainage_q5",
      "p_drainage_q95",
      "rhat",
      "ess_bulk",
      "ess_tail"
    )]
  )
  names(data)[1] <- "HYBAS_ID"

  hydro_basins <- tidyterra::left_join(
    hydro_basins, 
    data,
    by = "HYBAS_ID")
  
  return(hydro_basins)
}