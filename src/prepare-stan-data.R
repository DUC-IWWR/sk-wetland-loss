prepare_stan_data <- function(data = NULL, shapefile = NULL)
{
  data <- tidyterra::bind_spat_cols(
    data,
    terra::extract(
      tidyterra::select(
        shapefile, HYBAS_ID_Factor
      ),
      data
    )
  )

  df <- data.frame(data) |>
    dplyr::mutate(Impact_Code = dplyr::if_else(Impact == "Drained", 1, 0))

  return(
    list(
      # Overall data
      n_basins = length(unique(shapefile$HYBAS_ID_Factor)),
      n_datasets = length(unique(df$Model)),

      # CWI-related Data
      n_cwi = dplyr::filter(df, Model == "CWI") |>
        nrow(x = _),
      impact_cwi = dplyr::filter(df, Model == "CWI") |> 
        dplyr::pull(Impact_Code),
      basin_cwi = dplyr::filter(df, Model == "CWI") |> 
        dplyr::pull(HYBAS_ID_Factor),


      # CD-related Data
      n_cd = dplyr::filter(df, Model == "CD") |>
        nrow(x = _),
      impact_cd = dplyr::filter(df, Model == "CD") |>
        dplyr::pull(Impact_Code),
      basin_cd = dplyr::filter(df, Model == "CD") |> 
        dplyr::pull(HYBAS_ID_Factor),

      #CWI Point-only data
      n_cwi_p = dplyr::filter(df, Model == "CWI_Point") |>
        nrow(x = _),
      impact_cwi_p = dplyr::filter(df, Model == "CWI_Point") |>
        dplyr::pull(Impact_Code),
      basin_cwi_p = dplyr::filter(df, Model == "CWI_Point") |> 
        dplyr::pull(HYBAS_ID_Factor)

    )
  )
}