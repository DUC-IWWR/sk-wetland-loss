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
        Drainage_mean = sum(Drainage_mean) / wetland_area_cwi$Area,
        Drainage_q5 = sum(Drainage_q5) / wetland_area_cwi$Area,
        Drainage_q95 = sum(Drainage_q95) / wetland_area_cwi$Area
      ) %>%
      ggplot(
      aes(
        x = Year,
        y = Drainage_mean,
        group = Scenario,
        colour = Scenario
      )
    ) +
      geom_line(linewidth = 2) +
      geom_ribbon(aes(ymin = Drainage_q5, ymax = Drainage_q95), alpha = 0.1) +
      ylab("Proportion Wetland Area Drained") +
      theme_set(theme_pubclean()) +
      ylim(0,1) +
      NULL
  ),

  tar_target(
    name = drainage_scenarios_plot_hybas,
    command = drainage_scenarios %>%
      dplyr::filter(Scenario == "High") %>%
      # dplyr::group_by(Year, Scenario) |>
      # dplyr::summarise(
      #   Drainage_mean = sum(Drainage_mean) / wetland_area_cwi$Area,
      #   Drainage_q5 = sum(Drainage_q5) / wetland_area_cwi$Area,
      #   Drainage_q95 = sum(Drainage_q95) / wetland_area_cwi$Area
      # ) %>%
      ggplot(
      aes(
        x = Year,
        y = Drainage_mean,
        group = HYBAS_ID_Factor
      )
    ) +
      geom_line(linewidth = 1) +
      #geom_ribbon(aes(ymin = Drainage_q5, ymax = Drainage_q95), alpha = 0.1) +
      ylab("Proportion Wetland Area Drained") +
      theme_set(theme_pubclean()) +
      #ylim(0,1) +
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