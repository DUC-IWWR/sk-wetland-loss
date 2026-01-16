generate_prediction_list <- function(
  data = NULL, 
  drains_per_basin = NULL,
  shapefile = NULL)
{
  # Filter the shapefile to ONLY the polygons where we have drain info
  shapefile <- tidyterra::filter(shapefile,
  HYBAS_ID %in% drains_per_basin$HYBAS_ID) %>%
  tidyterra::mutate(HYBAS_ID_Factor = seq(1, nrow(.)))
  
  # Order the drains in each polygon based on factor
  drains_per_basin_vector <- dplyr::left_join(
    drains_per_basin,
    dplyr::select(
      data.frame(
        shapefile
      ),
      HYBAS_ID, HYBAS_ID_Factor
    ),
    by = "HYBAS_ID"
  ) |>
  dplyr::arrange(HYBAS_ID_Factor) |>
  dplyr::pull(n_drains)

  # Put together the polygon factors iwth the data, filter out data not associated with drains, and numerically assign impact
  df <- tidyterra::bind_spat_cols(
    data,
    terra::extract(
      tidyterra::select(
        shapefile, HYBAS_ID, HYBAS_ID_Factor
      ),
      data
    )
  ) |>
  tidyterra::filter(!is.na(HYBAS_ID)) |>
  data.frame() |>
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
      basin_cwi_string = dplyr::filter(df, Model == "CWI") |>
        dplyr::pull(HYBAS_ID),
      area_cwi = dplyr::filter(df, Model == "CWI") |>
        dplyr::pull(Area),


      # CD-related Data
      n_cd = dplyr::filter(df, Model == "CD") |>
        nrow(x = _),
      impact_cd = dplyr::filter(df, Model == "CD") |>
        dplyr::pull(Impact_Code),
      basin_cd = dplyr::filter(df, Model == "CD") |> 
        dplyr::pull(HYBAS_ID_Factor),
      basin_cd_string = dplyr::filter(df, Model == "CD") |>
        dplyr::pull(HYBAS_ID),
      area_cd = dplyr::filter(df, Model == "CD") |>
        dplyr::pull(Area),

      #CWI Point-only data
      n_cwi_p = dplyr::filter(df, Model == "CWI_Point") |>
        nrow(x = _),
      impact_cwi_p = dplyr::filter(df, Model == "CWI_Point") |>
        dplyr::pull(Impact_Code),
      basin_cwi_p = dplyr::filter(df, Model == "CWI_Point") |> 
        dplyr::pull(HYBAS_ID_Factor),
      basin_cwi_p_string = dplyr::filter(df, Model == "CWI_Point") |>
        dplyr::pull(HYBAS_ID),
      area_cwi_p = dplyr::filter(df, Model == "CWI_Point") |> 
        dplyr::pull(Area),

      # Basin-related covariates
      n_drains_unscaled = drains_per_basin_vector,
      n_drains = scale(drains_per_basin_vector)[,1],

      # Multi-threading
      grainsize = 1

    )
  )
}