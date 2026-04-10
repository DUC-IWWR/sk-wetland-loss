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

  tar_target(
    name = icar_vs_micar_plot,
    command = ggplot(
      data = data.frame(
        diff = abs(
          inv_logit(
          model_mcmc_icar$summary(variables = "score")$mean
        ) - 
        inv_logit(
          model_mcmc_micar$summary(variables = "score")$mean
        )),
        area = sqrt(stan_data$area_unscaled_cwi_te),
        dd = stan_data$dd_cwi_te
      ),
      aes(x = area, y = diff)
    ) + 
      geom_point()
  ),

  tar_target(
    name = prf1_plot_icar,
    command = plot_prf1(prf1_icar)
  ),

  tar_target(
    name = prf1_plot_micar,
    command = plot_prf1(prf1_micar)
  ),

  tar_target(
    name = spatial_effects_plot,
    command = ggarrange(
      ggarrange(
      plot_spatial_effects(
        shapefile = fitted_shapefile_micar,
        parameter = "theta"
      ),
      plot_spatial_effects(
        shapefile = fitted_shapefile_icar,
        parameter = "theta"
      ),
      common.legend = TRUE
      ),
      plot_spatial_effects(
        shapefile = tidyterra::mutate(
          fitted_shapefile_micar,
          median_difference = fitted_shapefile_micar$median_theta - fitted_shapefile_icar$median_theta
        ),
        parameter = "difference"
      ),
      widths = c(2,1)

    )
  ),

    tar_target(
    name = spatial_effects_sd_plot,
    command = ggarrange(
      ggarrange(
      plot_spatial_effects(
        shapefile = fitted_shapefile_micar,
        parameter = "theta",
        metric = "sd"
      ),
      plot_spatial_effects(
        shapefile = fitted_shapefile_icar,
        parameter = "theta",
        metric = "sd"
      ),
      common.legend = TRUE
      ),
      plot_spatial_effects(
        shapefile = tidyterra::mutate(
          fitted_shapefile_micar,
          sd_difference = fitted_shapefile_micar$sd_theta - fitted_shapefile_icar$sd_theta
        ),
        parameter = "difference",
        metric = "sd"
      ),
      widths = c(2,1)

    )
  )
  

)