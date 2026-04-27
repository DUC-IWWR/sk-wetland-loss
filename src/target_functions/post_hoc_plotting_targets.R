post_hoc_plotting_targets <- list(

  # tar_target(
  #   name = spatial_effects_sc_fig_reduced_icar_only,
  #   command = ggplot() + 
  #     geom_spatvector(
  #       data = fitted_sc_drainage_shp_reduced_icar_only, 
  #       aes(fill = p_drainage_mean)
  #     )
  # ),
  # 
  # tar_target(
  #   name = spatial_effects_sc_fig_reduced_cwi_icar_only,
  #   command = ggplot() + 
  #     geom_spatvector(
  #       data = fitted_sc_drainage_shp_reduced_cwi_icar_only, 
  #       aes(fill = p_drainage_mean)
  #     )
  # ),
  # 
  # tar_target(
  #   name = spatial_effects_sc_fig_combined,
  #   command = ggarrange(
  #     spatial_effects_sc_fig_reduced_cwi_icar_only,
  #     spatial_effects_sc_fig_reduced_icar_only,
  #     labels = c("CWI Only", "Combined"),
  #     nrow = 1,
  #     common.legend = TRUE)
  # ),
  # 
  # 
  # tar_target(
  #   name = spatial_effects_sc_sd_fig_reduced_icar_only,
  #   command = ggplot() + 
  #     geom_spatvector(
  #       data = fitted_sc_drainage_shp_reduced_icar_only, 
  #       aes(fill = p_drainage_sd)
  #     )
  # ),
  # 
  # tar_target(
  #   name = spatial_effects_sc_sd_fig_reduced_cwi_icar_only,
  #   command = ggplot() + 
  #     geom_spatvector(
  #       data = fitted_sc_drainage_shp_reduced_cwi_icar_only, 
  #       aes(fill = p_drainage_sd)
  #     )
  # ),
  # 
  # tar_target(
  #   name = spatial_effects_sc_sd_fig_combined,
  #   command = ggarrange(
  #     spatial_effects_sc_sd_fig_reduced_cwi_icar_only,
  #     spatial_effects_sc_sd_fig_reduced_icar_only,
  #     labels = c("CWI Only", "Combined"),
  #     nrow = 1,
  #     common.legend = TRUE)
  # ),
  # 
  # tar_target(
  #   name = mean_area_drained,
  #   command = ggplot() +
  #     geom_spatvector(
  #       data = fitted_sc_drainage_shp_icar_impact_gamma,
  #       aes(fill = median)
  #     )
  # ),
  # tar_target(
  #   name = sd_area_drained,
  #   command = ggplot() +
  #     geom_spatvector(
  #       data = fitted_sc_drainage_shp_icar_impact_gamma,
  #       aes(fill = sd)
  #     )
  # ),
  # tar_target(
  #   name = mean_area_drained_cwi,
  #   command = ggplot() +
  #     geom_spatvector(
  #       data = fitted_sc_drainage_shp_cwi_icar_impact_gamma,
  #       aes(fill = median)
  #     )
  # ),
  # tar_target(
  #   name = sd_area_drained_cwi,
  #   command = ggplot() +
  #     geom_spatvector(
  #       data = fitted_sc_drainage_shp_cwi_icar_impact_gamma,
  #       aes(fill = sd)
  #     )
  # ),
  # 
  # tar_target(
  #   name = mean_area_drained_combined,
  #   command = ggarrange(
  #     mean_area_drained_cwi,
  #     mean_area_drained,
  #     labels = c("CWI Only", "Combined"),
  #     nrow = 1,
  #     common.legend = TRUE
  #   )
  # ),
  # 
  # tar_target(
  #   name = sd_area_drained_combined,
  #   command = ggarrange(
  #     sd_area_drained_cwi,
  #     sd_area_drained,
  #     labels = c("CWI Only", "Combined"),
  #     nrow = 1,
  #     common.legend = TRUE
  #   )
  # ),

  # tar_target(
  #   name = icar_vs_micar_plot,
  #   command = ggplot(
  #     data = data.frame(
  #       diff = abs(
  #         inv_logit(
  #         model_mcmc_icar$summary(variables = "score")$mean
  #       ) - 
  #       inv_logit(
  #         model_mcmc_micar$summary(variables = "score")$mean
  #       )),
  #       area = sqrt(stan_data$area_unscaled_cwi_te),
  #       dd = stan_data$dd_cwi_te
  #     ),
  #     aes(x = area, y = diff)
  #   ) + 
  #     geom_point()
  # ),

  # tar_target(
  #   name = prf1_plot_icar_cwi,
  #   command = plot_prf1(prf1_icar_cwi)
  # ),

  # tar_target(
  #   name = prf1_plot_micar_cwi,
  #   command = plot_prf1(prf1_micar_cwi)
  # ),

  # tar_target(
  #   name = prf1_plot_icar_lidar,
  #   command = plot_prf1(prf1_icar_lidar)
  # ),

  # tar_target(
  #   name = prf1_plot_micar_lidar,
  #   command = plot_prf1(prf1_micar_lidar)
  # ),

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