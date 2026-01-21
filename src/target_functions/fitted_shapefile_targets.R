fitted_shapefile_targets <- list(
  ###################### Bernoulli Response Variables ##################

  # tar_terra_vect(
  #   name = fitted_sc_drainage_shp_reduced_icar_only,
  #   command = generate_fitted_shapefile(
  #     response = "bernoulli",
  #     hydro_basins = smith_creek_reduced, 
  #     prediction_list = prediction_list_sc, 
  #     model_summary = sc_model_summary_drainage_model_icar_only, 
  #     model_draws = sc_model_draws_drainage_model_icar_only,
  #     all_data = TRUE
  #   )
  # ),
  # 
  # tar_terra_vect(
  #   name = fitted_sc_drainage_shp_reduced_cwi_icar_only,
  #   command = generate_fitted_shapefile(
  #     response = "bernoulli",
  #     hydro_basins = smith_creek, 
  #     prediction_list = prediction_list_sc, 
  #     model_summary = sc_model_summary_drainage_model_cwi_icar_only, 
  #     model_draws = sc_model_draws_drainage_model_cwi_icar_only,
  #     all_data = FALSE)
  # ),
  
  
  ################## Gamma Response Variables ##########################
  tar_terra_vect(
    name = fitted_sc_drainage_shp_cwi_icar_impact_gamma,
    command = generate_fitted_shapefile(
      response = "gamma",
      hydro_basins = smith_creek,
      prediction_list = prediction_list_sc,
      model_summary = sc_gamma_model_summary_drainage_model_cwi_icar_impact_gamma,
      all_data = FALSE
    )
  ),
  
  tar_terra_vect(
    name = fitted_sc_drainage_shp_icar_impact_gamma,
    command = generate_fitted_shapefile(
      response = "gamma",
      hydro_basins = smith_creek,
      prediction_list = prediction_list_sc,
      model_summary = sc_gamma_model_summary_drainage_model_icar_impact_gamma,
      all_data = FALSE
    )
  )
  
  
)