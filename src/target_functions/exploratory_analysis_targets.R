exploratory_analysis_targets <- list(
  tar_target(
    name = drainage_distribution_plot_sc,
    command = plot_drainage_on_map(
      combined_point_data = combined_point_data,
      base_map = smith_creek
    )
  )
  
)