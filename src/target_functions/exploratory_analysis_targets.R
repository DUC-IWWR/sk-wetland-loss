exploratory_analysis_targets <- list(
  tar_target(
    name = drains_by_vb_plot,
    command = ggplot() +
      geom_spatvector(data = drains_vb, aes(fill = Polyline_C))
  ),
  
  
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
  )
)