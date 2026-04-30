calculate_drainage <- function(
  fitted_data, 
  thres, 
  raw_data, 
  covariates, 
  by_basin = TRUE, 
  calculate_proportion_wetlands = FALSE,
  years = 1, 
  drainage_rate = NULL, 
  stan_data = NULL,
  stan_fit = NULL) {
  
  if (calculate_proportion_wetlands) {
    return(calculate_proportion_drained(
      fitted_data,
      thres,
      raw_data,
      covariates,
      by_basin,
      years,
      drainage_rate,
      stan_data,
      stan_fit
    ))
  }
  
  if (years == 1) {
    combined_data <- combine_data_for_drainage(fitted_data, thres, raw_data, covariates)
    drainage_mean <- dplyr::filter(combined_data, y_fitted == 1) |>
      dplyr::group_by(HYBAS_ID_Factor) |>
      dplyr::summarise(Drainage_mean = sum(Area))

    drainage_q5 <- dplyr::filter(combined_data, y_q5 == 1) |>
      dplyr::group_by(HYBAS_ID_Factor) |>
      dplyr::summarise(Drainage_q5 = sum(Area))

    drainage_q95 <- dplyr::filter(combined_data, y_q95 == 1) |>
      dplyr::group_by(HYBAS_ID_Factor) |>
      dplyr::summarise(Drainage_q95 = sum(Area))

    return(
      dplyr::left_join(drainage_mean, drainage_q5, by = "HYBAS_ID_Factor") |>
        dplyr::left_join(drainage_q95, by = "HYBAS_ID_Factor")
    )
  } else {
    to_return <- vector(mode = "list", length = years)
    centre <- attributes(covariates$DD_Scaled)$`scaled:center`
    scale <- attributes(covariates$DD_Scaled)$`scaled:scale`

    for (y in 1:years) {
      if (y > 1) {
        stan_data$dd_cwi_tr <- (stan_data$dd_cwi_tr * scale) + centre
        stan_data$dd_cwi_tr <- stan_data$dd_cwi_tr * (1 + drainage_rate)
        stan_data$dd_cwi_tr <- (stan_data$dd_cwi_tr - centre) / scale
        fitted_data <- generate_fitted_impact(stan_fit, stan_data, micar = TRUE)
      }
      combined_data <- combine_data_for_drainage(fitted_data, thres, raw_data, covariates)
      drainage_mean <- dplyr::filter(combined_data, y_fitted == 1) |>
        dplyr::group_by(HYBAS_ID_Factor) |>
        dplyr::summarise(Drainage_mean = sum(Area))

      drainage_q5 <- dplyr::filter(combined_data, y_q5 == 1) |>
        dplyr::group_by(HYBAS_ID_Factor) |>
        dplyr::summarise(Drainage_q5 = sum(Area))

      drainage_q95 <- dplyr::filter(combined_data, y_q95 == 1) |>
        dplyr::group_by(HYBAS_ID_Factor) |>
        dplyr::summarise(Drainage_q95 = sum(Area))

      df <- dplyr::left_join(drainage_mean, drainage_q5, by = "HYBAS_ID_Factor") |>
        dplyr::left_join(drainage_q95, by = "HYBAS_ID_Factor")
      df$Year <- rep(y, nrow(df))

      to_return[[y]] <- df

    }

    return(purrr::list_rbind(to_return))
  }

}

calculate_proportion_drained <- function(
  fitted_data, 
  thres, 
  raw_data, 
  covariates, 
  by_basin = TRUE, 
  years = 1, 
  drainage_rate = NULL, 
  stan_data = NULL,
  stan_fit = NULL) {  
  
  if (years == 1) {
    combined_data <- combine_data_for_drainage(fitted_data, thres, raw_data, covariates)
    if (by_basin) {
      drainage_mean <- dplyr::group_by(combined_data, HYBAS_ID_Factor) |>
        dplyr::summarise(Proportion_Drained_Mean = sum(y_fitted) / length(y_fitted))

      drainage_q5 <- dplyr::group_by(combined_data, HYBAS_ID_Factor) |>
        dplyr::summarise(Proportion_Drained_q5 = sum(y_q5) / length(y_q5))

      drainage_q95 <- dplyr::group_by(combined_data, HYBAS_ID_Factor) |>
        dplyr::summarise(Proportion_Drained_q95 = sum(y_q95) / length(y_q95))

      return(
        dplyr::left_join(drainage_mean, drainage_q5, by = "HYBAS_ID_Factor") |>
          dplyr::left_join(drainage_q95, by = "HYBAS_ID_Factor")
      )
      
    } else {
      drainage_mean <- dplyr::summarise(combined_data, Proportion_Drained_Mean = sum(y_fitted) / length(y_fitted))
      drainage_q5 <- dplyr::summarise(combined_data, Proportion_Drained_q5 = sum(y_q5) / length(y_q5))
      drainage_q95 <- dplyr::summarise(combined_data, Proportion_Drained_q95 = sum(y_q95) / length(y_q95))

      return(c(drainage_mean, drainage_q5, drainage_q95))
    }

  } else {
    to_return <- vector(mode = "list", length = years)
    centre <- attributes(covariates$DD_Scaled)$`scaled:center`
    scale <- attributes(covariates$DD_Scaled)$`scaled:scale`

    for (y in 1:years) {
      if (y > 1) {
        stan_data$dd_cwi_tr <- (stan_data$dd_cwi_tr * scale) + centre
        stan_data$dd_cwi_tr <- stan_data$dd_cwi_tr * (1 + drainage_rate)
        stan_data$dd_cwi_tr <- (stan_data$dd_cwi_tr - centre) / scale
        fitted_data <- generate_fitted_impact(stan_fit, stan_data, micar = TRUE)
      }
      combined_data <- combine_data_for_drainage(fitted_data, thres, raw_data, covariates)
      if (by_basin) {
        drainage_mean <- dplyr::group_by(combined_data, HYBAS_ID_Factor) |>
          dplyr::summarise(Proportion_Drained_Mean = sum(y_fitted) / length(y_fitted))

        drainage_q5 <- dplyr::group_by(combined_data, HYBAS_ID_Factor) |>
          dplyr::summarise(Proportion_Drained_q5 = sum(y_q5) / length(y_q5))

        drainage_q95 <- dplyr::group_by(combined_data, HYBAS_ID_Factor) |>
          dplyr::summarise(Proportion_Drained_q95 = sum(y_q95) / length(y_q95))

        
        df <- dplyr::left_join(drainage_mean, drainage_q5, by = "HYBAS_ID_Factor") |>
          dplyr::left_join(drainage_q95, by = "HYBAS_ID_Factor")
        df$Year <- rep(y, nrow(df))
        
        
      } else {
        drainage_mean <- dplyr::summarise(combined_data, Proportion_Drained_Mean = sum(y_fitted) / length(y_fitted))
        drainage_q5 <- dplyr::summarise(combined_data, Proportion_Drained_q5 = sum(y_q5) / length(y_q5))
        drainage_q95 <- dplyr::summarise(combined_data, Proportion_Drained_q95 = sum(y_q95) / length(y_q95))

        df <- data.frame(
          Proportion_Drained_Mean = drainage_mean$Proportion_Drained_Mean,
          Proportion_Drained_q5 = drainage_q5$Proportion_Drained_q5,
          Proportion_Drained_q95 = drainage_q95$Proportion_Drained_q95,
          Year = y
        )
      }

      to_return[[y]] <- df

    }

    return(purrr::list_rbind(to_return))
  }  
}

combine_data_for_drainage <- function(fitted_data, thres, raw_data, covariates) {
  return(fitted_data |>
      dplyr::mutate(
        y_fitted = ifelse(y_fitted >= thres, 1, 0),
        y_q5 = ifelse(y_q5 >= thres, 1, 0),
        y_q95 = ifelse(y_q95 >= thres, 1, 0)
      ) |>
        dplyr::bind_cols(
            dplyr::bind_cols(
              dplyr::select(
                data.frame(raw_data),
                Model
              ),
              dplyr::select(
                covariates,
                HYBAS_ID,
                HYBAS_ID_Factor,
                Area
              )
            ) |>
              dplyr::filter(Model == "CWI")
        ))
}
