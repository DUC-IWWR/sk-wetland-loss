plot_drainage_on_map <- function(combined_point_data = NULL, drained = TRUE, base_map = NULL) {
  if (drained) {
    impact_to_plot <- "Drained"
  } else {
    impact_to_plot <- "Undrained"
  }

  combined_point_data <- terra::crop(combined_point_data, base_map)
  return(
    ggplot() +
      geom_spatvector(
        data = tidyterra::filter(
          .data = combined_point_data,
          Impact == impact_to_plot & Model == "CWI"
        ),
        aes(
          color = "CWI"
        ),
        size = 0.2
      ) + 
      geom_spatvector(
        data = tidyterra::filter(
          .data = combined_point_data,
          Impact == impact_to_plot & Model == "CD"
        ),
        aes(
          color = "CD"
        ),
        size = 0.2
      ) +  
      geom_spatvector(
        data = tidyterra::filter(
          .data = combined_point_data,
          Impact == impact_to_plot & Model == "CWI_Point"
        ),
        aes(
          color = "CWI_Point"
        ),
        size = 0.2
      ) +  
      geom_spatvector(data = base_map, fill = NA) 
  )
}