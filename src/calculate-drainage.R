calculate_drainage <- function(
  fitted_data, 
  thres, 
  raw_data, 
  covariates, 
  dataset = "CWI",
  wetland_area = NULL,
  years = 1, 
  drainage_rate = NULL, 
  stan_data = NULL,
  stan_fit = NULL) {

  to_return <- vector(mode = "list", length = years)
  centre <- attributes(covariates$DD_Scaled)$`scaled:center`
  scale <- attributes(covariates$DD_Scaled)$`scaled:scale`

  for (y in 1:years) {
    if (y > 1) {
      if (dataset == "CWI") {
        stan_data$dd_cwi_tr <- (stan_data$dd_cwi_tr * scale) + centre
        stan_data$dd_cwi_tr <- stan_data$dd_cwi_tr * (1 + drainage_rate)
        stan_data$dd_cwi_tr <- (stan_data$dd_cwi_tr - centre) / scale
      } else {
        stan_data$dd_cd <- (stan_data$dd_cd * scale) + centre
        stan_data$dd_cd <- stan_data$dd_cd * (1 + drainage_rate)
        stan_data$dd_cd <- (stan_data$dd_cd - centre) / scale          
      }

      fitted_data <- generate_fitted_impact(stan_fit, stan_data, micar = TRUE, dataset = tolower(dataset))
    }
    combined_data <- combine_data_for_drainage(fitted_data, thres, raw_data, covariates, dataset)
    drainage_mean <- dplyr::filter(combined_data, y_fitted == 1) |>
      dplyr::group_by(HYBAS_ID_Factor) |>
      dplyr::summarise(Drainage_mean = sum(Area)) |>
      dplyr::ungroup()

    drainage_q5 <- dplyr::filter(combined_data, y_q5 == 1) |>
      dplyr::group_by(HYBAS_ID_Factor) |>
      dplyr::summarise(Drainage_q5 = sum(Area)) |>
      dplyr::ungroup()

    drainage_q95 <- dplyr::filter(combined_data, y_q95 == 1) |>
      dplyr::group_by(HYBAS_ID_Factor) |>
      dplyr::summarise(Drainage_q95 = sum(Area)) |>
      dplyr::ungroup()

    df <- dplyr::left_join(drainage_mean, drainage_q5, by = "HYBAS_ID_Factor") |>
      dplyr::left_join(drainage_q95, by = "HYBAS_ID_Factor")  |>
      dplyr::left_join(wetland_area, by = "HYBAS_ID_Factor") |>
      dplyr::mutate(Drainage_mean_prop = Drainage_mean / Area) |>
      dplyr::mutate(Drainage_q5_prop = Drainage_q5 / Area) |>
      dplyr::mutate(Drainage_q95_prop = Drainage_q95 / Area) %>%
      dplyr::mutate(Year = rep(y, nrow(.)))

    to_return[[y]] <- df

  }

  return(
    purrr::list_rbind(to_return)
  )

}

combine_data_for_drainage <- function(fitted_data, thres, raw_data, covariates, dataset) {
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
              dplyr::filter(Model == dataset)
        ))
}
