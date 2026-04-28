post_hoc_plotting_targets <- list(
  tar_target(
    name = prf1_plot,
    command =
      ggarrange(
        plot_prf1(prf1_icar_cwi, title = "ICAR CWI"),
        plot_prf1(prf1_micar_cwi, title = "MICAR CWI"),
        plot_prf1(prf1_icar_lidar, title = "ICAR LIDAR"),
        plot_prf1(prf1_micar_lidar, title = "MICAR LIDAR"),
        nrow = 2, ncol = 2,
        common.legend = TRUE
      )

  ),

  tar_target(
    name = spatial_effects_plot,
    command = 
      ggarrange(
      plot_spatial_effects(
        shapefile = fitted_shapefile_micar_cwi,
        parameter = "theta", 
        title = "MICAR CWI"
      ),
      plot_spatial_effects(
        shapefile = fitted_shapefile_icar_cwi,
        parameter = "theta", 
        title = "ICAR CWI"
      ),
      plot_spatial_effects(
        shapefile = fitted_shapefile_micar_lidar,
        parameter = "theta", 
        title = "MICAR LIDAR"
      ),
      plot_spatial_effects(
        shapefile = fitted_shapefile_icar_lidar,
        parameter = "theta", 
        title = "ICAR LIDAR"
      ),
      common.legend = TRUE,
      ncol = 2, nrow = 2
      )
  ),

  tar_target(
    name = spatial_effects_sd_plot,
    command = 
      ggarrange(
      plot_spatial_effects(
        shapefile = fitted_shapefile_micar_cwi,
        parameter = "theta", 
        metric = "sd",
        title = "MICAR CWI"
      ),
      plot_spatial_effects(
        shapefile = fitted_shapefile_icar_cwi,
        parameter = "theta", 
        metric = "sd",
        title = "ICAR CWI"
      ),
      plot_spatial_effects(
        shapefile = fitted_shapefile_micar_lidar,
        parameter = "theta", 
        metric = "sd",
        title = "MICAR LIDAR"
      ),
      plot_spatial_effects(
        shapefile = fitted_shapefile_icar_lidar,
        parameter = "theta", 
        metric = "sd",
        title = "ICAR LIDAR"
      ),
      common.legend = TRUE,
      ncol = 2, nrow = 2
      )
  )
)