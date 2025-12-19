generate_spatial_effects_map <- function(hydro_basins, prediction_list, model_summary_drainage_model, model_summary_drainage_model_cwi) {
  data <- data.frame(
    "HYBAS_ID" = prediction_list$basin_cwi_string,
    "HYBAS_ID_Factor" = prediction_list$basin_cwi
  )
  data$Spatial_effect_full <- NA
  data$Spatial_effect_full_sd <- NA
  data$Spatial_effect_cwi <- NA
  data$Spatial_effect_cwi_sd <- NA
  data <- data[-which(duplicated(data$HYBAS_ID)), ]
  for (i in 1:nrow(data)) {
    data$Spatial_effect_full[i] <- as.numeric(model_summary_drainage_model[which(model_summary_drainage_model$variable == paste0("Theta[1,", data$HYBAS_ID_Factor[i], "]")), "mean"])
    data$Spatial_effect_full_sd[i] <- as.numeric(model_summary_drainage_model[which(model_summary_drainage_model$variable == paste0("Theta[1,", data$HYBAS_ID_Factor[i], "]")), "sd"])

    data$Spatial_effect_cwi[i] <- as.numeric(model_summary_drainage_model_cwi[which(model_summary_drainage_model_cwi$variable == paste0("Theta[", data$HYBAS_ID_Factor[i], "]")), "mean"])
    data$Spatial_effect_cwi_sd[i] <- as.numeric(model_summary_drainage_model_cwi[which(model_summary_drainage_model_cwi$variable == paste0("Theta[", data$HYBAS_ID_Factor[i], "]")), "sd"])
  }

  hydro_basins <- tidyterra::left_join(hydro_basins, data, by = "HYBAS_ID")

  full_effect_map <- ggplot() +
    geom_spatvector(data = hydro_basins, aes(fill = Spatial_effect_full))

  full_sd_map <- ggplot() + 
    geom_spatvector(data = hydro_basins, aes(fill = Spatial_effect_full_sd))

  cwi_effect_map <- ggplot() +
    geom_spatvector(data = hydro_basins, aes(fill = Spatial_effect_cwi))

  cwi_sd_map <- ggplot() + 
    geom_spatvector(data = hydro_basins, aes(fill = Spatial_effect_cwi_sd))

  effect_diff_map <- ggplot() +
    geom_spatvector(data = hydro_basins, aes(fill = Spatial_effect_full - Spatial_effect_cwi))

  sd_diff_map <- ggplot() +
    geom_spatvector(data = hydro_basins, aes(fill = Spatial_effect_full_sd - Spatial_effect_cwi_sd))

  combined_map <- ggarrange(full_effect_map, cwi_effect_map, effect_diff_map, full_sd_map, cwi_sd_map, sd_diff_map, ncol = 3, nrow = 2)
  
}