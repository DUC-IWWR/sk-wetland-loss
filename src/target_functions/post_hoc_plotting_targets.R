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
  ),

  tar_target(
    name = drainage_scenarios_plot,
    command = drainage_scenarios |>
      dplyr::group_by(Year, Scenario) |>
      dplyr::summarise(
        Drainage_mean = sum(Drainage_mean),
        Drainage_q5 = sum(Drainage_q5),
        Drainage_q95 = sum(Drainage_q95)
      ) %>%
      ggplot(
      aes(
        x = Year,
        y = Drainage_mean/100,
        group = Scenario,
        colour = Scenario
      )
    ) +
      geom_line(linewidth = 2) +
      geom_ribbon(aes(ymin = Drainage_q5/100, ymax = Drainage_q95/100), alpha = 0.1) +
      ylab("Amount of Wetland Drained (ha)") +
      theme_set(theme_pubclean()) +
      NULL
  ),

  tar_target(
    name = drainage_scenarios_prop_plot,
    command = ggplot(drainage_scenarios_prop,
      aes(
        x = Year,
        y = Proportion_Drained_Mean,
        group = Scenario,
        colour = Scenario
      )
    ) +
      geom_line(linewidth = 2) +
      geom_ribbon(aes(ymin = Proportion_Drained_q5, ymax = Proportion_Drained_q95), alpha = 0.1) +
      ylab("Proportion of Wetlands Drained") +
      theme_set(theme_pubclean()) +
      NULL
  )
)