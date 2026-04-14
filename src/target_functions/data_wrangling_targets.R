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
      ) %>%
      
      #' Now we start extracting information from external datasets. This first call is to extract
      #' the HYBAS_ID from the Hydrobasins shapefile
      tidyterra::bind_spat_cols(
        terra::extract(
          x = tidyterra::select(
            hydro_basins, HYBAS_ID
          ),
          y = .
        )
      )
  ),

  tar_terra_vect(
    name = smith_creek,
    command = hydro_basins[which(hydro_basins$HYBAS_ID %in% smith_creek_hybas_id$HYBAS_ID), ]
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
          res = c(0.0003569396, 0.0003569396),
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
          res = c(0.0003569396, 0.0003569396),
          crs = terra::crs(smith_creek)
        ),
        field = "ua_length_km",
        fun = sum
      )
  )
)
