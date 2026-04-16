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
    ggplot2::ggtitle(title)
  
  return(plot)
}
