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
    command = plot_spatial_effects(
        shapefile = combined_fitted_shapefile,
        parameter = "theta", 
        title = ""
      )
  ),

  tar_target(
    name = spatial_effects_sd_plot,
    command = 
      plot_spatial_effects(
        shapefile = combined_fitted_shapefile,
        parameter = "theta", 
        metric = "sd",
        title = ""
      )
  ),

  tar_target(
    name = icarcwi_vs_micarcwi_sd,
    command = 
      plot_spatial_effects(
        shapefile = tidyterra::filter(
          combined_fitted_shapefile,
          Model %in% c("ICAR CWI", "MICAR CWI")
        ),
        parameter = "theta", 
        metric = "sd", title = " ",
        nrow = 1
      ) +tidyterra::geom_spatvector(
          data = fitted_shapefile_micar_cwi |>
            tidyterra::rename(sd_theta_micar = sd_theta) |>
            tidyterra::bind_spat_cols(tidyterra::select(fitted_shapefile_icar_cwi, sd_theta)) |>
            tidyterra::mutate(sd_diff = sd_theta_micar - sd_theta) |>
            tidyterra::filter(sd_diff < 0) |>
            tidyterra::mutate(Model = "MICAR CWI"),
          color = "green", fill = NA, linewidth = 1
      )
  ),

  tar_target(
    name = icarlidar_vs_micarlidar_sd,
    command = 
      plot_spatial_effects(
        shapefile = tidyterra::filter(
          combined_fitted_shapefile,
          Model %in% c("ICAR LiDAR", "MICAR LiDAR")
        ),
        parameter = "theta", 
        metric = "sd", title = " ",
        nrow = 1
      )  + tidyterra::geom_spatvector(
        data = fitted_shapefile_micar_lidar |>
          tidyterra::rename(sd_theta_micar = sd_theta) |>
          tidyterra::bind_spat_cols(tidyterra::select(fitted_shapefile_icar_lidar, sd_theta)) |>
          tidyterra::mutate(sd_diff = sd_theta_micar - sd_theta) |>
          tidyterra::filter(sd_diff < 0) |>
            tidyterra::mutate(Model = "MICAR LiDAR"),
        color = "green", fill = NA, linewidth = 1
      )
  ),

  tar_target(
    name = micarcwi_vs_micarlidar_sd,
    command = 
      plot_spatial_effects(
        shapefile = tidyterra::filter(
          combined_fitted_shapefile,
          Model %in% c("MICAR CWI", "MICAR LiDAR")
        ),
        parameter = "theta", 
        metric = "sd", title = " ",
        nrow = 1
      )  + tidyterra::geom_spatvector(
        data = fitted_shapefile_micar_lidar |>
          tidyterra::rename(sd_theta_micar = sd_theta) |>
          tidyterra::bind_spat_cols(tidyterra::select(fitted_shapefile_micar_cwi, sd_theta)) |>
          tidyterra::mutate(sd_diff = sd_theta_micar - sd_theta) |>
          tidyterra::filter(sd_diff < 0) |>
            tidyterra::mutate(Model = "MICAR LiDAR"),
        color = "green", fill = NA, linewidth = 1
      )
  ),

  tar_target(
    name = drainage_scenarios_plot_cwi,
    command = 
      ggarrange(
        ggplot(
          data = dplyr::filter(drainage_scenarios_cwi, Scenario == "High"),
          aes(x = Year)
        ) +
          geom_line(aes(group = HYBAS_ID_Factor, y = 1- Drainage_mean_prop), alpha = 0.3) +
          geom_line(
            data = drainage_scenarios_cwi |>
              dplyr::filter(Scenario == "High") |>
              dplyr::group_by(Year) |>
              dplyr::summarise(Drainage_mean_prop = sum(Drainage_mean) / sum(wetland_area_cwi$Area)) |>
              dplyr::ungroup(),
            aes(y = 1-Drainage_mean_prop),
            linewidth = 2
          ) + 
          geom_ribbon(
            data = drainage_scenarios_cwi |>
              dplyr::filter(Scenario == "High") |>
              dplyr::group_by(Year) |>
              dplyr::summarise(
                Drainage_q5_prop = sum(Drainage_q5) / sum(wetland_area_cwi$Area),
                Drainage_q95_prop = sum(Drainage_q95) / sum(wetland_area_cwi$Area)
              ) |>
              dplyr::ungroup(),
            aes(ymin = 1-Drainage_q5_prop, ymax = 1-Drainage_q95_prop),
            alpha = 0.3
          ) +
          geom_hline(yintercept = 0.4, color = "red") + 
          geom_hline(yintercept = 0.6, color = "red") + 
          ylab("Proportion of Wetland Area Retained") +
          ggtitle(paste0("High Scenario -- ", round(drainage_rate_high * 100, 2),"% DD Increase/Year")) +
          ylim(0,1) +
          NULL
        ,
        ggplot(
          data = dplyr::filter(drainage_scenarios_cwi, Scenario == "Low"),
          aes(x = Year)
        ) +
          geom_line(aes(y = 1-Drainage_mean_prop, group = HYBAS_ID_Factor), alpha = 0.3) +
          geom_line(
            data = drainage_scenarios_cwi |>
              dplyr::filter(Scenario == "Low") |>
              dplyr::group_by(Year) |>
              dplyr::summarise(Drainage_mean_prop = sum(Drainage_mean) / sum(wetland_area_cwi$Area)) |>
              dplyr::ungroup(),
            aes(y = 1-Drainage_mean_prop),
            linewidth = 2
          ) + 
          geom_ribbon(
            data = drainage_scenarios_cwi |>
              dplyr::filter(Scenario == "Low") |>
              dplyr::group_by(Year) |>
              dplyr::summarise(
                Drainage_q5_prop = sum(Drainage_q5) / sum(wetland_area_cwi$Area),
                Drainage_q95_prop = sum(Drainage_q95) / sum(wetland_area_cwi$Area)
              ) |>
              dplyr::ungroup(),
            aes(ymin = 1-Drainage_q5_prop, ymax = 1-Drainage_q95_prop),
            alpha = 0.3
          ) +
          geom_hline(yintercept = 0.4, color = "red") + 
          geom_hline(yintercept = 0.6, color = "red") + 
          ylab("Proportion of Wetland Area Retained") +
          ggtitle(paste0("Low Scenario -- ", round(drainage_rate_low * 100,2),"% DD Increase/Year")) +
          ylim(0,1) +
          NULL
      )
  ),

  tar_target(
    name = drainage_scenarios_plot_lidar,
    command = 
      ggarrange(
        ggplot(
          data = dplyr::filter(drainage_scenarios_lidar, Scenario == "High"),
          aes(x = Year)
        ) +
          geom_line(aes(group = HYBAS_ID_Factor, y = 1- Drainage_mean_prop), alpha = 0.3) +
          geom_line(
            data = drainage_scenarios_lidar |>
              dplyr::filter(Scenario == "High") |>
              dplyr::group_by(Year) |>
              dplyr::summarise(Drainage_mean_prop = sum(Drainage_mean) / sum(wetland_area_cwi$Area)) |>
              dplyr::ungroup(),
            aes(y = 1-Drainage_mean_prop),
            linewidth = 2
          ) + 
          geom_ribbon(
            data = drainage_scenarios_lidar |>
              dplyr::filter(Scenario == "High") |>
              dplyr::group_by(Year) |>
              dplyr::summarise(
                Drainage_q5_prop = sum(Drainage_q5) / sum(wetland_area_cwi$Area),
                Drainage_q95_prop = sum(Drainage_q95) / sum(wetland_area_cwi$Area)
              ) |>
              dplyr::ungroup(),
            aes(ymin = 1-Drainage_q5_prop, ymax = 1-Drainage_q95_prop),
            alpha = 0.3
          ) +
          geom_hline(yintercept = 0.4, color = "red") + 
          geom_hline(yintercept = 0.6, color = "red") + 
          ylab("Proportion of Wetland Area Retained") +
          ggtitle(paste0("High Scenario -- ", round(drainage_rate_high * 100, 2),"% DD Increase/Year")) +
          ylim(0,1) +
          NULL
        ,
        ggplot(
          data = dplyr::filter(drainage_scenarios_lidar, Scenario == "Low"),
          aes(x = Year)
        ) +
          geom_line(aes(y = 1-Drainage_mean_prop, group = HYBAS_ID_Factor), alpha = 0.3) +
          geom_line(
            data = drainage_scenarios_lidar |>
              dplyr::filter(Scenario == "Low") |>
              dplyr::group_by(Year) |>
              dplyr::summarise(Drainage_mean_prop = sum(Drainage_mean) / sum(wetland_area_cwi$Area)) |>
              dplyr::ungroup(),
            aes(y = 1-Drainage_mean_prop),
            linewidth = 2
          ) + 
          geom_ribbon(
            data = drainage_scenarios_lidar |>
              dplyr::filter(Scenario == "Low") |>
              dplyr::group_by(Year) |>
              dplyr::summarise(
                Drainage_q5_prop = sum(Drainage_q5) / sum(wetland_area_cwi$Area),
                Drainage_q95_prop = sum(Drainage_q95) / sum(wetland_area_cwi$Area)
              ) |>
              dplyr::ungroup(),
            aes(ymin = 1-Drainage_q5_prop, ymax = 1-Drainage_q95_prop),
            alpha = 0.3
          ) +
          geom_hline(yintercept = 0.4, color = "red") + 
          geom_hline(yintercept = 0.6, color = "red") + 
          ylab("Proportion of Wetland Area Retained") +
          ggtitle(paste0("Low Scenario -- ", round(drainage_rate_low * 100,2),"% DD Increase/Year")) +
          ylim(0,1) +
          NULL
      )
  ),

  # tar_target(
  #   name = drainage_scenarios_spatial_plot,
  #   command = 
  #     ggarrange(
  #       ggplot() +
  #         geom_spatvector(
  #           data = drainage_scenarios |>
  #             dplyr::filter(Scenario == "High" & Year == 1) |>
  #             tidyterra::left_join(x = smith_creek, y = _, by = "HYBAS_ID_Factor"),
  #           aes(fill = Drainage_mean_prop)
  #         ) +
  #         NULL
  #       ,
  #       ggplot() +
  #         geom_spatvector(
  #           data = drainage_scenarios |>
  #             dplyr::filter(Scenario == "High" & Year == 50) |>
  #             tidyterra::left_join(x = smith_creek, y = _, by = "HYBAS_ID_Factor"),
  #           aes(fill = Drainage_mean_prop)
  #         ) +
  #         NULL
  #     )
  # ),

  tar_target(
    name = class_separation_plot_cwi,
    command = 
      ggplot(data = fitted_impact_micar_cwi, aes(y = y_fitted, x = '', color = factor(stan_data_cwi$impact_cwi_tr, levels = c("1", "0")))) +
       # geom_hline(yintercept = chosen_threshold, linetype = "dashed", color = "blue") +
        facet_wrap(~stan_data_cwi$basin_cwi_tr) +
        geom_jitter() +
        scale_color_manual(values = c("0" = "#1A242F",
                                        "1"="red")) +
        theme(legend.position = "top")
  ),

  tar_target(
    name = class_separation_plot_lidar,
    command = 
      ggplot(data = fitted_impact_micar_lidar, aes(y = y_fitted, x = '', color = factor(stan_data_lidar$impact_cwi_tr, levels = c("1", "0")))) +
       # geom_hline(yintercept = chosen_threshold, linetype = "dashed", color = "blue") +
        facet_wrap(~stan_data_lidar$basin_cwi_tr) +
        geom_jitter() +
        scale_color_manual(values = c("0" = "#1A242F",
                                        "1"="red")) +
        theme(legend.position = "top")
  )


)