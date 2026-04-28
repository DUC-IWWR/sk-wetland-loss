projection_targets <- list(
  tar_target(
    name = current_drainage,
    command = fitted_impact_micar_cwi |>
      dplyr::mutate(
        y_fitted = ifelse(y_fitted >= chosen_threshold, 1, 0),
        y_q5 = ifelse(y_q5 >= chosen_threshold, 1, 0),
        y_q95 = ifelse(y_q95 >= chosen_threshold, 1, 0)
      ) |>
        dplyr::bind_cols(
            dplyr::bind_cols(
              dplyr::select(
                data.frame(point_data_subset),
                Model
              ),
              dplyr::select(
                covariate_df_cwi,
                Area,
                HYBAS_ID,
                HYBAS_ID_Factor
              )
            ) |>
              dplyr::filter(Model == "CWI")
        ) %>%
    c(
      sum(
        dplyr::filter(.,y_fitted == 1) |>
          dplyr::select(Area)
      ),
      sum(
        dplyr::filter(.,y_q5 == 1) |>
          dplyr::select(Area)
      ),
      sum(
        dplyr::filter(.,y_q95 == 1) |>
          dplyr::select(Area)
      )
    )
  ) 
)