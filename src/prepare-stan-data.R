prepare_stan_data <- function(
    data = NULL,
    covariates = NULL,
    icar_matrix = NULL,
    train_test_indices = NULL
  ) {
  
  data$Test <- 0
  data[train_test_indices$index, "Test"] <- train_test_indices$Test

  data <- data.frame(cbind(data,covariates[,c("DD_Scaled", "Area_Scaled", "Impact_Code", "HYBAS_ID_Factor")]))
  
  return(
    list(
      # Overall data
      n_basins = length(unique(data$HYBAS_ID_Factor)),
      n_datasets = length(unique(data$Model)),
      
      # CWI-training Data
      n_cwi_tr = dplyr::filter(data, Model == "CWI" & Test == 0) |>
        nrow(x = _),
      impact_cwi_tr = dplyr::filter(data, Model == "CWI" & Test == 0) |> 
        dplyr::pull(Impact_Code),
      basin_cwi_tr = dplyr::filter(data, Model == "CWI" & Test == 0) |> 
        dplyr::pull(HYBAS_ID_Factor),
      area_cwi_tr = dplyr::filter(data, Model == "CWI" & Test == 0) |>
        dplyr::pull(Area_Scaled),
      dd_cwi_tr = dplyr::filter(data, Model == "CWI" & Test == 0) |>
        dplyr::pull(DD_Scaled),
      
      # CWI-testing Data
      n_cwi_te = dplyr::filter(data, Model == "CWI" & Test == 1) |>
        nrow(x = _),
      impact_cwi_te = dplyr::filter(data, Model == "CWI" & Test == 1) |> 
        dplyr::pull(Impact_Code),
      basin_cwi_te = dplyr::filter(data, Model == "CWI" & Test == 1) |> 
        dplyr::pull(HYBAS_ID_Factor),
      area_cwi_te = dplyr::filter(data, Model == "CWI" & Test == 1) |>
        dplyr::pull(Area_Scaled),
      dd_cwi_te = dplyr::filter(data, Model == "CWI" & Test == 1) |>
        dplyr::pull(DD_Scaled),
      
      
      # CD-related Data
      n_cd = dplyr::filter(data, Model == "CD") |>
        nrow(x = _),
      impact_cd = dplyr::filter(data, Model == "CD") |>
        dplyr::pull(Impact_Code),
      basin_cd = dplyr::filter(data, Model == "CD") |> 
        dplyr::pull(HYBAS_ID_Factor),
      area_cd = dplyr::filter(data, Model == "CD") |>
        dplyr::pull(Area_Scaled),
      dd_cd = dplyr::filter(data, Model == "CD") |>
        dplyr::pull(DD_Scaled),

      # CWI Point-related Data
      n_cwi_p = dplyr::filter(data, Model == "CWI_Point") |>
        nrow(x = _),
      impact_cwi_p = dplyr::filter(data, Model == "CWI_Point") |>
        dplyr::pull(Impact_Code),
      basin_cwi_p = dplyr::filter(data, Model == "CWI_Point") |> 
        dplyr::pull(HYBAS_ID_Factor),
      area_cwi_p = dplyr::filter(data, Model == "CWI_Point") |>
        dplyr::pull(Area_Scaled),
      dd_cwi_p = dplyr::filter(data, Model == "CWI_Point") |>
        dplyr::pull(DD_Scaled),
      
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