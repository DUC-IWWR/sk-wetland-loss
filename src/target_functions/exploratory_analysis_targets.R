exploratory_analysis_targets <- list(
  tar_target(
    name = drainage_distribution_plot,
    command = ggplot() +
      geom_spatvector(
        data = tidyterra::filter(
          .data = combined_point_data,
          Impact == "Drained" & Model == "CWI"
        ),
        aes(
          color = "CWI"
        ),
        size = 0.2
      ) + 
      geom_spatvector(
        data = tidyterra::filter(
          .data = combined_point_data,
          Impact == "Drained" & Model == "CD"
        ),
        aes(
          color = "CD"
        ),
        size = 0.2
      ) +  
      geom_spatvector(
        data = tidyterra::filter(
          .data = combined_point_data,
          Impact == "Drained" & Model == "CWI_Point"
        ),
        aes(
          color = "CWI_Point"
        ),
        size = 0.2
      ) +  
      geom_spatvector(data = hydro_basins, fill = NA) 
  ),
  
  tar_target(
    name = sc_spatial_coverage_map,
    command = ggplot() + 
      geom_spatvector(
        data = tidyterra::filter(
          .data = terra::mask(combined_point_data, smith_creek),
          Impact == "Drained",
          Model %in% c("CWI", "CD")), 
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