plot_spatial_effects <- function(shapefile, parameter, metric = "median", title) {

  plot <- ggplot2::ggplot() +
    tidyterra::geom_spatvector(
      data = shapefile,
      tidyterra::aes(
        fill = eval(
          parse(
            text = paste0(
              metric, 
              "_", 
              parameter
            )
          )
        )
      )
    ) +
    ggplot2::labs(fill=paste0(
              metric, 
              " ", 
              parameter
            )) +
    ggplot2::ggtitle(title) +
    ggplot2::scale_color_viridis_d() +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90, vjust = 1, hjust=1))
  
  return(plot)
}
