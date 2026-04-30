data_wrangling_targets <- list(

  # Combined_point_data
  tar_terra_vect(
    name = combined_point_data,
    command = dplyr::bind_rows(
      # Change detection drainage dataset
      (
        cd_drainage |>
          dplyr::select(
            c("Impact", "Impact_Lat", "Impact_Long", "ClassNum", "ClassName", "WS_AREA_KM", "WS_PERI_KM", "Shape_Length", "Shape_Area")
          ) |>
          dplyr::rename(
            tidyselect::all_of(
              c(
                Latitude = "Impact_Lat",
                Longitude = "Impact_Long",
                Length = "Shape_Length",
                Area = "Shape_Area"
              )
            )
          ) |>
          dplyr::mutate(
            Model = rep("CD", nrow(cd_drainage))
          )
      ),
      # CWI drainage dataset
      (
        cwi_drainage |>
          dplyr::select(
            c("Impact", "CWI_Lat", "CWI_Long", "ClassNum", "ClassName", "WS_AREA_KM", "WS_PERI_KM", "CWI_Shape_Length", "CWI_Shape_Area")
          ) |>
          dplyr::rename(
            tidyselect::all_of(
              c(
                Latitude = "CWI_Lat",
                Longitude = "CWI_Long",
                Length = "CWI_Shape_Length",
                Area = "CWI_Shape_Area"
              )
            )
          ) |>
          dplyr::mutate(
            Model = rep("CWI", nrow(cwi_drainage))
          )
      ),
      # CWI drainage dataset, points only
      (
        cwi_points |>
          dplyr::select(
            c("Impact", "Point_Lat", "Point_Long", "ClassNum", "ClassName", "WS_AREA_KM", "WS_PERI_KM", "Point_m2")
          ) |>
          dplyr::rename(
            tidyselect::all_of(
              c(
                Latitude = "Point_Lat",
                Longitude = "Point_Long",
                Area = "Point_m2"
              )
            )
          ) |>
          dplyr::mutate(
            Length = rep(NA, nrow(cwi_points)),
            .before = "Area"
          ) |>
          dplyr::mutate(
            Model = rep("CWI_Point", nrow(cwi_points))
          )
      )
    ) |>
      terra::vect(
        geom = c("Longitude", "Latitude"),
        crs = terra::crs(hydro_basins)
      ) |>
      terra::project(cwi_dd) %>%
      
      #' Now we start extracting information from external datasets. This first call is to extract
      #' the HYBAS_ID from the Hydrobasins shapefile
      tidyterra::bind_spat_cols(
        terra::extract(
          x = tidyterra::select(
            terra::project(hydro_basins, cwi_dd), HYBAS_ID
          ),
          y = .
        )
      )
  ),

  tar_terra_vect(
    name = smith_creek,
    command = hydro_basins[which(hydro_basins$HYBAS_ID %in% smith_creek_hybas_id$HYBAS_ID), ] |>
      terra::project(cwi_dd) %>%
      tidyterra::mutate(HYBAS_ID_Factor = seq(1:nrow(.)))
  ),

  tar_terra_vect(
    name = point_data_subset,
    command = combined_point_data[which(combined_point_data$HYBAS_ID %in% smith_creek_hybas_id$HYBAS_ID), ]
  ),

  tar_terra_rast(
    name = cwi_drainage_rast,
    command = cwi_dd |>
      tidyterra::mutate(cwi_length_km = Shape_Leng / 1000) |>
      terra::rasterize(
        y = terra::rast(
          xmin = floor(terra::ext(smith_creek)[1]),
          xmax = ceiling(terra::ext(smith_creek)[2]),
          ymin = floor(terra::ext(smith_creek)[3]),
          ymax = ceiling(terra::ext(smith_creek)[4]),
          res = c(50, 50),
          crs = terra::crs(smith_creek)
        ),
        field = "cwi_length_km",
        fun = sum
      )
  ),

  tar_terra_rast(
    name = ua_drainage_rast,
    command = ua_dd |>
      tidyterra::mutate(ua_length_km = SHAPE_Leng / 1000) |>
      terra::rasterize(
        y = terra::rast(
          xmin = floor(terra::ext(smith_creek)[1]),
          xmax = ceiling(terra::ext(smith_creek)[2]),
          ymin = floor(terra::ext(smith_creek)[3]),
          ymax = ceiling(terra::ext(smith_creek)[4]),
          res = c(50, 50),
          crs = terra::crs(smith_creek)
        ),
        field = "ua_length_km",
        fun = sum
      )
  ),

  tar_target(
    name = covariate_df_cwi,
    command = dplyr::bind_cols(
      terra::extract(
        cwi_drainage_rast,
        terra::buffer(point_data_subset, 500),
        fun = sum, na.rm = TRUE
      ) |>
        dplyr::mutate(cwi_length_km = ifelse(is.nan(cwi_length_km), 0, cwi_length_km)) |>
        dplyr::mutate(DD_Scaled = scale(cwi_length_km)),

      dplyr::select(data.frame(point_data_subset), Area, HYBAS_ID, Impact) |>
        dplyr::mutate(Area_Scaled = scale(Area)) |>
        dplyr::mutate(Impact_Code = dplyr::if_else(Impact == "Drained", 1, 0))
    ) |>
      dplyr::left_join(
        y = dplyr::select(data.frame(smith_creek), HYBAS_ID, HYBAS_ID_Factor),
        by = "HYBAS_ID"
      )
  ),

    tar_target(
    name = covariate_df_lidar,
    command = dplyr::bind_cols(
      terra::extract(
        ua_drainage_rast,
        terra::buffer(point_data_subset, 500),
        fun = sum, na.rm = TRUE
      ) |>
        dplyr::mutate(ua_length_km = ifelse(is.nan(ua_length_km), 0, ua_length_km)) |>
        dplyr::mutate(DD_Scaled = scale(ua_length_km)),

      dplyr::select(data.frame(point_data_subset), Area, HYBAS_ID, Impact) |>
        dplyr::mutate(Area_Scaled = scale(Area)) |>
        dplyr::mutate(Impact_Code = dplyr::if_else(Impact == "Drained", 1, 0))
    ) |>
      dplyr::left_join(
        y = dplyr::select(data.frame(smith_creek), HYBAS_ID, HYBAS_ID_Factor),
        by = "HYBAS_ID"
      )
  ),

  tar_target(
    name = icar_matrix,
    command = generate_icar_matrix(smith_creek)
  ),

  tar_target(
    name = train_test_indices,
    command = generate_train_test_indices(
      df = point_data_subset
    )
  ),

  tar_target(
    name = stan_data_cwi,
    command = prepare_stan_data(
      data = point_data_subset,
      covariates = covariate_df_cwi,
      icar_matrix = icar_matrix,
      train_test_indices = NULL
    )
  ),
  tar_target(
    name = stan_data_lidar,
    command = prepare_stan_data(
      data = point_data_subset,
      covariates = covariate_df_lidar,
      icar_matrix = icar_matrix,
      train_test_indices = NULL
    )
  ),

  tar_target(
    name = wetland_area_cwi,
    command = dplyr::bind_cols(
      dplyr::select(
        data.frame(point_data_subset),
        Model
      ),
      dplyr::select(
        covariate_df_cwi,
        HYBAS_ID,
        HYBAS_ID_Factor,
        Area
      )
    ) |>
      dplyr::filter(Model == "CWI") |>
      dplyr::summarise(Area = sum(Area))
  )

)
