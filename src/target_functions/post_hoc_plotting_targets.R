post_hoc_plotting_targets <- list(
  tar_target(
    name = spatial_effects_fig_reduced_icar_only,
    command = ggplot() + 
      geom_spatvector(
        data = fitted_drainage_shp_reduced_icar_only, 
        aes(fill = p_drainage_mean)
      )
  ),
  
  tar_target(
    name = spatial_effects_fig_reduced_cwi_icar_only,
    command = ggplot() + 
      geom_spatvector(
        data = fitted_drainage_shp_reduced_cwi_icar_only, 
        aes(fill = p_drainage_mean)
      )
  ),
  
  tar_target(
    name = spatial_effects_fig_combined,
    command = ggarrange(
      spatial_effects_fig_reduced_cwi_icar_only,
      spatial_effects_fig_reduced_icar_only,
      labels = c("CWI Only", "Combined"),
      nrow = 1,
      common.legend = TRUE)
  ),
  
  tar_target(
    name = spatial_effects_sd_fig_reduced_icar_only,
    command = ggplot() + 
      geom_spatvector(
        data = fitted_drainage_shp_reduced_icar_only, 
        aes(fill = p_drainage_sd)
      )
  ),
  
  tar_target(
    name = spatial_effects_sd_fig_reduced_cwi_icar_only,
    command = ggplot() + 
      geom_spatvector(
        data = fitted_drainage_shp_reduced_cwi_icar_only, 
        aes(fill = p_drainage_sd)
      )
  ),
  
  tar_target(
    name = spatial_effects_sd_fig_combined,
    command = ggarrange(
      spatial_effects_sd_fig_reduced_cwi_icar_only,
      spatial_effects_sd_fig_reduced_icar_only,
      labels = c("CWI Only", "Combined"),
      nrow = 1,
      common.legend = TRUE)
  ),
  
  
  tar_target(
    name = spatial_effects_sc_fig_reduced_icar_only,
    command = ggplot() + 
      geom_spatvector(
        data = fitted_sc_drainage_shp_reduced_icar_only, 
        aes(fill = p_drainage_mean)
      )
  ),
  
  tar_target(
    name = spatial_effects_sc_fig_reduced_cwi_icar_only,
    command = ggplot() + 
      geom_spatvector(
        data = fitted_sc_drainage_shp_reduced_cwi_icar_only, 
        aes(fill = p_drainage_mean)
      )
  ),
  
  tar_target(
    name = spatial_effects_sc_fig_combined,
    command = ggarrange(
      spatial_effects_sc_fig_reduced_cwi_icar_only,
      spatial_effects_sc_fig_reduced_icar_only,
      labels = c("CWI Only", "Combined"),
      nrow = 1,
      common.legend = TRUE)
  ),
  
  
  tar_target(
    name = spatial_effects_sc_sd_fig_reduced_icar_only,
    command = ggplot() + 
      geom_spatvector(
        data = fitted_sc_drainage_shp_reduced_icar_only, 
        aes(fill = p_drainage_sd)
      )
  ),
  
  tar_target(
    name = spatial_effects_sc_sd_fig_reduced_cwi_icar_only,
    command = ggplot() + 
      geom_spatvector(
        data = fitted_sc_drainage_shp_reduced_cwi_icar_only, 
        aes(fill = p_drainage_sd)
      )
  ),
  
  tar_target(
    name = spatial_effects_sc_sd_fig_combined,
    command = ggarrange(
      spatial_effects_sc_sd_fig_reduced_cwi_icar_only,
      spatial_effects_sc_sd_fig_reduced_icar_only,
      labels = c("CWI Only", "Combined"),
      nrow = 1,
      common.legend = TRUE)
  ),
  
  tar_target(
    name = mean_area_drained,
    command = ggplot() +
      geom_spatvector(
        data = fitted_sc_drainage_shp_icar_impact_gamma,
        aes(fill = median)
      )
  ),
  
  tar_target(
    name = sc_spatial_coverage_map,
    command = ggplot() + 
      geom_spatvector(
        data = tidyterra::filter(
          .data = terra::mask(combined_point_data, smith_creek),
          Impact == "Drained"), 
        aes(color = Model), 
        size = 0.5) + geom_spatvector(data = smith_creek, fill = NA)
  ),
  
  tar_target(
    name = sc_spatial_coverage_map_cwi,
    command = ggplot() + 
      geom_spatvector(
        data = tidyterra::filter(
          .data = terra::mask(combined_point_data, smith_creek),
          Impact == "Drained",
          Model == "CWI"), 
        color = "darkgreen", 
        size = 0.5) + geom_spatvector(data = smith_creek, fill = NA)
  )
)