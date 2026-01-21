prepare_stan_data_dd <- function(
  data = NULL, 
  drainage = NULL,
  shapefile = NULL) {
  
  shapefile <- tidyterra::mutate(shapefile, HYBAS_ID_Factor = seq(1, nrow(shapefile)))
  
  # Put together the polygon factors iwth the data, filter out data not associated with drains, and numerically assign impact
  data_basins <- tidyterra::bind_spat_cols(
    data,
    terra::extract(
      tidyterra::select(
        shapefile, HYBAS_ID, HYBAS_ID_Factor
      ),
      data
    )
  ) |>
    tidyterra::filter(!is.na(HYBAS_ID)) |>
    dplyr::mutate(Impact_Code = dplyr::if_else(Impact == "Drained", 1, 2))

  df <- tidyterra::bind_spat_cols(
    data_basins,
    terra::extract(
      drainage, data_basins
    )
  ) |> data.frame() |>
    dplyr::mutate(UA_DD_2023 = ifelse(is.na(UA_DD_2023), 0, UA_DD_2023)) |>
    dplyr::mutate(
      DD_Scaled = scale(UA_DD_2023)[,1]
    )
    
  icar_matrix <- generate_icar_matrix(shapefile)

  return(
    list(
      # Overall data
      n_basins = length(unique(shapefile$HYBAS_ID_Factor)),
      n_datasets = 2,
      
      # CWI-related Data
      n_cwi = dplyr::filter(df, Model == "CWI") |>
        nrow(x = _),
      impact_cwi = dplyr::filter(df, Model == "CWI") |> 
        dplyr::pull(Impact_Code),
      basin_cwi = dplyr::filter(df, Model == "CWI") |> 
        dplyr::pull(HYBAS_ID_Factor),
      area_cwi = dplyr::filter(df, Model == "CWI") |>
        dplyr::pull(Area),
      dd_cwi = dplyr::filter(df, Model == "CWI") |>
        dplyr::pull(DD_Scaled),
      dd_cwi_unscaled = dplyr::filter(df, Model == "CWI") |>
        dplyr::pull(UA_DD_2023),
      
      
      # CD-related Data
      n_cd = dplyr::filter(df, Model == "CD") |>
        nrow(x = _),
      impact_cd = dplyr::filter(df, Model == "CD") |>
        dplyr::pull(Impact_Code),
      basin_cd = dplyr::filter(df, Model == "CD") |> 
        dplyr::pull(HYBAS_ID_Factor),
      area_cd = dplyr::filter(df, Model == "CD") |>
        dplyr::pull(Area),
      dd_cd = dplyr::filter(df, Model == "CD") |>
        dplyr::pull(DD_Scaled),
      dd_cd_unscaled = dplyr::filter(df, Model == "CD") |>
        dplyr::pull(UA_DD_2023),
      
      # ICAR related things
      N_icar = icar_matrix$N,
      N_icar_edges = as.integer(floor(icar_matrix$N_edges)),
      node1 = icar_matrix$node1,
      node2 = icar_matrix$node2,
      
      # Multi-threading
      grainsize = 1
      
    )
  )
}