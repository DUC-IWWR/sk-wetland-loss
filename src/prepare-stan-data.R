prepare_stan_data <- function(
    data = NULL, 
    cwi_drainage = NULL,
    lidar_drainage = NULL,
    shapefile = NULL) {
  
  shapefile <- tidyterra::mutate(shapefile, HYBAS_ID_Factor = seq(1, nrow(shapefile)))
  
  # numerically assign impact
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
    dplyr::mutate(Impact_Code = dplyr::if_else(Impact == "Drained", 1, 0))
  
  df <- tidyterra::bind_spat_cols(
    data_basins,
    terra::extract(
      lidar_drainage,
      terra::buffer(data_basins, 500),
      fun = sum
    ),
  ) |> data.frame() |>
    dplyr::filter(!is.na(UA_DD_2023)) |>
    dplyr::mutate(
      DD_Scaled = scale(UA_DD_2023)[,1]
    ) |> 
    dplyr::mutate(HYBAS_Impact = paste0(HYBAS_ID_Factor, "-", Impact_Code)) 
  
  folds <- data.frame(HYBAS_Impact = df[which(df$Model == "CWI"), "HYBAS_Impact"])
  folds$index <- which(df$Model == "CWI")
  folds$Test <- 0
  
  for (f in unique(folds$HYBAS_Impact)) {
    temp <- folds[which(folds$HYBAS_Impact == f),]
    if (nrow(temp) >= 10) {
      temp$Test[sample(.2 * seq_len(nrow(temp)))] <- 1
      folds[which(folds$index %in% temp$index), "Test"] <- temp$Test
    }
  }
  
  df$Test <- 0
  df[folds$index, "Test"] <- folds$Test
  
  icar_matrix <- generate_icar_matrix(shapefile)
  
  return(
    list(
      # Overall data
      n_basins = length(unique(shapefile$HYBAS_ID_Factor)),
      n_datasets = 2,
      
      # CWI-training Data
      n_cwi_tr = dplyr::filter(df, Model == "CWI" & Test == 0) |>
        nrow(x = _),
      impact_cwi_tr = dplyr::filter(df, Model == "CWI" & Test == 0) |> 
        dplyr::pull(Impact_Code),
      basin_cwi_tr = dplyr::filter(df, Model == "CWI" & Test == 0) |> 
        dplyr::pull(HYBAS_ID_Factor),
      area_cwi_tr = dplyr::filter(df, Model == "CWI" & Test == 0) |>
        dplyr::pull(Area_Scaled),
      area_unscaled_cwi_tr = dplyr::filter(df, Model == "CWI" & Test == 0) |>
        dplyr::pull(Area),
      dd_cwi_tr = dplyr::filter(df, Model == "CWI" & Test == 0) |>
        dplyr::pull(DD_Scaled),
      dd_cwi_unscaled_tr = dplyr::filter(df, Model == "CWI" & Test == 0) |>
        dplyr::pull(UA_DD_2023),
      
      # CWI-testing Data
      n_cwi_te = dplyr::filter(df, Model == "CWI" & Test == 1) |>
        nrow(x = _),
      impact_cwi_te = dplyr::filter(df, Model == "CWI" & Test == 1) |> 
        dplyr::pull(Impact_Code),
      basin_cwi_te = dplyr::filter(df, Model == "CWI" & Test == 1) |> 
        dplyr::pull(HYBAS_ID_Factor),
      area_cwi_te = dplyr::filter(df, Model == "CWI" & Test == 1) |>
        dplyr::pull(Area_Scaled),
      area_unscaled_cwi_te = dplyr::filter(df, Model == "CWI" & Test == 1) |>
        dplyr::pull(Area),
      dd_cwi_te = dplyr::filter(df, Model == "CWI" & Test == 1) |>
        dplyr::pull(DD_Scaled),
      dd_cwi_unscaled_te = dplyr::filter(df, Model == "CWI" & Test == 1) |>
        dplyr::pull(UA_DD_2023),
      
      
      # CD-related Data
      n_cd = dplyr::filter(df, Model == "CD") |>
        nrow(x = _),
      impact_cd = dplyr::filter(df, Model == "CD") |>
        dplyr::pull(Impact_Code),
      basin_cd = dplyr::filter(df, Model == "CD") |> 
        dplyr::pull(HYBAS_ID_Factor),
      area_cd = dplyr::filter(df, Model == "CD") |>
        dplyr::pull(Area_Scaled),
      area_unscaled_cd = dplyr::filter(df, Model == "CD") |>
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