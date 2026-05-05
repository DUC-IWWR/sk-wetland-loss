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
    command = 
      ggarrange(
        ggplot(
          data = dplyr::filter(drainage_scenarios, Scenario == "High"),
          aes(x = Year, y = Drainage_mean_prop)
        ) +
          geom_line(aes(group = HYBAS_ID_Factor), alpha = 0.3) +
          geom_line(
            data = drainage_scenarios |>
              dplyr::filter(Scenario == "High") |>
              dplyr::group_by(Year) |>
              dplyr::summarise(Drainage_mean_prop = sum(Drainage_mean) / sum(wetland_area_cwi$Area)) |>
              dplyr::ungroup(),
            color = "blue", linewidth = 2
          ) + 
          geom_hline(yintercept = 0.4, color = "red") + 
          ylab("Proportion of Wetland Area Drained") +
          #geom_hline(yintercept = 0.6, color = "red") +
          ylim(0,1) +
          NULL
        ,
        ggplot(
          data = dplyr::filter(drainage_scenarios, Scenario == "Low"),
          aes(x = Year, y = Drainage_mean_prop)
        ) +
          geom_line(aes(group = HYBAS_ID_Factor), alpha = 0.3) +
          geom_line(
            data = drainage_scenarios |>
              dplyr::filter(Scenario == "Low") |>
              dplyr::group_by(Year) |>
              dplyr::summarise(Drainage_mean_prop = sum(Drainage_mean) / sum(wetland_area_cwi$Area)) |>
              dplyr::ungroup(),
            color = "blue", linewidth = 2
          ) + 
          geom_hline(yintercept = 0.4, color = "red") + 
          ylab("Proportion of Wetland Area Drained") +
          #geom_hline(yintercept = 0.6, color = "red") +
          ylim(0,1) +
          NULL
      )
  ),

  tar_target(
    name = drainage_scenarios_spatial_plot,
    command = 
      ggarrange(
        ggplot() +
          geom_spatvector(
            data = drainage_scenarios |>
              dplyr::filter(Scenario == "High" & Year == 1) |>
              tidyterra::left_join(x = smith_creek, y = _, by = "HYBAS_ID_Factor"),
            aes(fill = Drainage_mean_prop)
          ) +
          NULL
        ,
        ggplot() +
          geom_spatvector(
            data = drainage_scenarios |>
              dplyr::filter(Scenario == "High" & Year == 50) |>
              tidyterra::left_join(x = smith_creek, y = _, by = "HYBAS_ID_Factor"),
            aes(fill = Drainage_mean_prop)
          ) +
          NULL
      )
  )
)