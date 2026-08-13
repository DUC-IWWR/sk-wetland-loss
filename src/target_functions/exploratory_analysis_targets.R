exploratory_analysis_targets <- list(
  tar_target(
    name = drainage_distribution_plot_sc,
    command = plot_drainage_on_map(
      combined_point_data = combined_point_data,
      base_map = smith_creek
    )
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
  ),

  tar_target(
    name = omitted_vs_intensity_plot,
    command = terra::extract(
      smith_creek,
      ua_dd |>
      terra::project(smith_creek) |>
      terra::crop(smith_creek) |>
      tidyterra::filter(DClassPres %in% c("EnhancedAgricultural", "EnhancedSkeleton", "EnhancedChannelized")) |>
      tidyterra::select(LengthKM)
    ) |>
      dplyr::select(HYBAS_ID_Factor) |>
      dplyr::bind_cols(
        ua_dd |>
        terra::project(smith_creek) |>
        terra::crop(smith_creek) |>
        tidyterra::filter(DClassPres %in% c("EnhancedAgricultural", "EnhancedSkeleton", "EnhancedChannelized")) |>
        tidyterra::select(LengthKM) |>
        data.frame()
      ) |>
        dplyr::group_by(HYBAS_ID_Factor) |>
        dplyr::summarise(omitted = sum(LengthKM)) |>
        dplyr::left_join(
          y = terra::extract(
                smith_creek,
                ua_dd |>
                terra::project(smith_creek) |>
                terra::crop(smith_creek) |>
                tidyterra::filter(DClassPres %in% c("Agricultural", "Skeleton", "Channelized")) |>
                tidyterra::select(LengthKM)
              ) |>
                dplyr::select(HYBAS_ID_Factor) |>
                dplyr::bind_cols(
                  ua_dd |>
                  terra::project(smith_creek) |>
                  terra::crop(smith_creek) |>
                  tidyterra::filter(DClassPres %in% c("Agricultural", "Skeleton", "Channelized")) |>
                  tidyterra::select(LengthKM) |>
                  data.frame()
                ) |>
                  dplyr::group_by(HYBAS_ID_Factor) |>
                  dplyr::summarise(intensity = sum(LengthKM)),
          by = "HYBAS_ID_Factor"
        ) |>
          ggplot(aes(x = (intensity + omitted), y = omitted)) + 
            geom_point() + 
            geom_smooth(method = 'lm') +
            labs(x = "Total Drain Length (km)", y = "CWI-Omitted Total Drain Length (km)")
  ),

  tar_target(
    name = omitted_new_vs_intensity_plot,
    command = terra::project(ua_dd, smith_creek) |>
      terra::crop(smith_creek) |>
      terra::extract(x = smith_creek, y = _) |>
      dplyr::select(HYBAS_ID_Factor) |>
      dplyr::bind_cols(
        terra::project(ua_dd, smith_creek) |>
          terra::crop(smith_creek) |>
          data.frame()
      ) |>
      reshape2::dcast(
        formula = HYBAS_ID_Factor ~ DClassPres,
        fun.aggregate = sum,
        value.var = "LengthKM"
      ) |>
      dplyr::mutate(
        CWI = rowSums(dplyr::across(c(Agricultural, Channelized, Skeleton))),
        Omitted = rowSums(dplyr::across(c(EnhancedAgricultural, EnhancedChannelized, EnhancedSkeleton))),
        New = rowSums(dplyr::across(c(NewAgricultural, NewChannelized, NewSkeleton)))
      ) |>
      dplyr::mutate(
        Total = rowSums(dplyr::across(c(CWI, Omitted, New)))
      ) |>
      ggplot(aes(x = Total, y = Omitted + New)) + geom_point() + geom_smooth(method = 'lm')
  ),

  tar_target(
    name = total_vs_cwi_plot,
    command = terra::project(ua_dd, smith_creek) |>
      terra::crop(smith_creek) |>
      terra::extract(x = smith_creek, y = _) |>
      dplyr::select(HYBAS_ID_Factor) |>
      dplyr::bind_cols(
        terra::project(ua_dd, smith_creek) |>
          terra::crop(smith_creek) |>
          data.frame()
      ) |>
      reshape2::dcast(
        formula = HYBAS_ID_Factor ~ DClassPres,
        fun.aggregate = sum,
        value.var = "LengthKM"
      ) |>
      dplyr::mutate(
        CWI = rowSums(dplyr::across(c(Agricultural, Channelized, Skeleton))),
        Omitted = rowSums(dplyr::across(c(EnhancedAgricultural, EnhancedChannelized, EnhancedSkeleton))),
        New = rowSums(dplyr::across(c(NewAgricultural, NewChannelized, NewSkeleton)))
      ) |>
      dplyr::mutate(
        Total = rowSums(dplyr::across(c(CWI, Omitted, New)))
      ) |>
      ggplot(aes(x = CWI, y = Total)) + geom_point() + geom_smooth(method = 'lm') + 
       labs(x = "CWI Detected Drains (km)", y = "Total Present Drains (km)")
  ),

  tar_target(
    name = prop_omitted_vs_intensity_plot,
    command = terra::extract(
      smith_creek,
      ua_dd |>
      terra::project(smith_creek) |>
      terra::crop(smith_creek) |>
      tidyterra::filter(DClassPres %in% c("EnhancedAgricultural", "EnhancedSkeleton", "EnhancedChannelized")) |>
      tidyterra::select(LengthKM)
    ) |>
      dplyr::select(HYBAS_ID_Factor) |>
      dplyr::bind_cols(
        ua_dd |>
        terra::project(smith_creek) |>
        terra::crop(smith_creek) |>
        tidyterra::filter(DClassPres %in% c("EnhancedAgricultural", "EnhancedSkeleton", "EnhancedChannelized")) |>
        tidyterra::select(LengthKM) |>
        data.frame()
      ) |>
        dplyr::group_by(HYBAS_ID_Factor) |>
        dplyr::summarise(omitted = sum(LengthKM)) |>
        dplyr::left_join(
          y = terra::extract(
                smith_creek,
                ua_dd |>
                terra::project(smith_creek) |>
                terra::crop(smith_creek) |>
                tidyterra::filter(DClassPres %in% c("Agricultural", "Skeleton", "Channelized")) |>
                tidyterra::select(LengthKM)
              ) |>
                dplyr::select(HYBAS_ID_Factor) |>
                dplyr::bind_cols(
                  ua_dd |>
                  terra::project(smith_creek) |>
                  terra::crop(smith_creek) |>
                  tidyterra::filter(DClassPres %in% c("Agricultural", "Skeleton", "Channelized")) |>
                  tidyterra::select(LengthKM) |>
                  data.frame()
                ) |>
                  dplyr::group_by(HYBAS_ID_Factor) |>
                  dplyr::summarise(intensity = sum(LengthKM)),
          by = "HYBAS_ID_Factor"
        ) |>
          ggplot(aes(x = intensity, y = omitted / (omitted + intensity))) + 
            geom_point() + 
            geom_smooth(method = 'lm') +
            ylim(0,1)
  ),

  tar_target(
    name = omitted_vs_drainage_plot,
    command = terra::extract(
      smith_creek,
      ua_dd |>
      terra::project(smith_creek) |>
      terra::crop(smith_creek) |>
      tidyterra::filter(DClassPres %in% c("EnhancedAgricultural", "EnhancedSkeleton", "EnhancedChannelized")) |>
      tidyterra::select(LengthKM)
    ) |>
      dplyr::select(HYBAS_ID_Factor) |>
      dplyr::bind_cols(
        ua_dd |>
        terra::project(smith_creek) |>
        terra::crop(smith_creek) |>
        tidyterra::filter(DClassPres %in% c("EnhancedAgricultural", "EnhancedSkeleton", "EnhancedChannelized")) |>
        tidyterra::select(LengthKM) |>
        data.frame()
      ) |>
        dplyr::group_by(HYBAS_ID_Factor) |>
        dplyr::summarise(omitted = sum(LengthKM)) |>
        dplyr::left_join(
          data.frame(
            tidyterra::left_join(point_data_subset, data.frame(smith_creek), by = "HYBAS_ID")
          ) |>
            dplyr::filter(Impact == "Drained") |>
            dplyr::group_by(HYBAS_ID_Factor) |>
            dplyr::summarise(drained_area = sum(Area)) |>
            dplyr::ungroup(),
          by = "HYBAS_ID_Factor"
        ) |>
          ggplot(aes(x = drained_area, y = omitted)) + geom_point() + geom_smooth(method = 'lm')

  )
  
)