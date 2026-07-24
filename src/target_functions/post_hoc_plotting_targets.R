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
      # plot_spatial_effects(
      #   shapefile = fitted_shapefile_icar_cwi,
      #   parameter = "theta", 
      #   metric = "sd",
      #   title = "ICAR CWI"
      # ),
      plot_spatial_effects(
        shapefile = fitted_shapefile_micar_lidar,
        parameter = "theta", 
        metric = "sd",
        title = "MICAR LIDAR"
      ),
      # plot_spatial_effects(
      #   shapefile = fitted_shapefile_icar_lidar,
      #   parameter = "theta", 
      #   metric = "sd",
      #   title = "ICAR LIDAR"
      # ),
      common.legend = TRUE,
      ncol = 2, nrow = 2
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
  ),

  tar_target(
    name = cwi_vs_lidar_drainage_plot,
    command = 
      data.frame(
        cwi = covariate_df_cwi$cwi_length_km,
        lidar = covariate_df_lidar$ua_length_km,
        basin = covariate_df_cwi$HYBAS_ID_Factor
      ) |>
        ggplot(aes(x = cwi, y = lidar)) +
        geom_point() +
        facet_wrap(~basin)
  )


)