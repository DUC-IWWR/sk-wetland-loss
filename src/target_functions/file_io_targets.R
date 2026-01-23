file_io_targets <- list(
  ########### Targets for checking file existence/updates and loading in files #######################
  # The main ones we will probably
  tar_target(
    name = cwi_drainage_file,
    command = "data/raw/CWI_Drained_UnDrained.txt",
    format = "file"
  ),
  tar_target(
    name = cwi_drainage,
    command = read.csv(cwi_drainage_file)
  ),
  tar_target(
    name = cd_drainage_file,
    command = "data/raw/ImpactModels_Drained_UnDrained.txt",
    format = "file"
  ),
  tar_target(
    name = cd_drainage,
    command = read.csv(cd_drainage_file)
  ),
  tar_target(
    name = cwi_points_file,
    command = "data/raw/Points_CWI_Drained_UnDrained.txt",
    format = "file"
  ),
  tar_target(
    name = cwi_points,
    command = read.csv(cwi_points_file)
  ),
  
  # Shapefiles
  tar_target(
    name = drains_vb_shapefile,
    command = "data/raw/Drains_VirtualBasin_summary/Drains_VirtualBasin_summary.shp",
    format = "file"
  ),
  tar_terra_vect(
    name = drains_vb,
    command = terra::vect(drains_vb_shapefile) |> 
      tidyterra::mutate(dplyr::across(HYBAS_ID, as.character)) %>%
      data.frame(.) |>
      terra::vect(
        geom = c("Long", "Lat"),
        crs = "GEOGCRS[\"NAD83\",DATUM[\"North American Datum 1983\",ELLIPSOID[\"GRS 1980\",6378137,298.257222101,LENGTHUNIT[\"metre\",1]]],PRIMEM[\"Greenwich\",0,ANGLEUNIT[\"degree\",0.0174532925199433]],CS[ellipsoidal,2],AXIS[\"geodetic latitude (Lat)\",north,ORDER[1],ANGLEUNIT[\"degree\",0.0174532925199433]],AXIS[\"geodetic longitude (Lon)\",east,ORDER[2],ANGLEUNIT[\"degree\",0.0174532925199433]],USAGE[SCOPE[\"Geodesy.\"],AREA[\"North America - onshore and offshore: Canada - Alberta; British Columbia; Manitoba; New Brunswick; Newfoundland and Labrador; Northwest Territories; Nova Scotia; Nunavut; Ontario; Prince Edward Island; Quebec; Saskatchewan; Yukon. Puerto Rico. United States (USA) - Alabama; Alaska; Arizona; Arkansas; California; Colorado; Connecticut; Delaware; Florida; Georgia; Hawaii; Idaho; Illinois; Indiana; Iowa; Kansas; Kentucky; Louisiana; Maine; Maryland; Massachusetts; Michigan; Minnesota; Mississippi; Missouri; Montana; Nebraska; Nevada; New Hampshire; New Jersey; New Mexico; New York; North Carolina; North Dakota; Ohio; Oklahoma; Oregon; Pennsylvania; Rhode Island; South Carolina; South Dakota; Tennessee; Texas; Utah; Vermont; Virginia; Washington; West Virginia; Wisconsin; Wyoming. US Virgin Islands. British Virgin Islands.\"],BBOX[14.92,167.65,86.45,-40.73]],ID[\"EPSG\",4269]]"
      ) |>
      terra::project(terra::vect(drains_vb_shapefile)) |>
      terra::mask(x = _, mask = terra::hull(combined_point_data))
  ),
  tar_target(
    name = hydro_basins_shapefile,
    command = "data/raw/hydro_basins/hybas_na_lev12_v1c.shp",
    format = "file"
  ),
  tar_terra_vect(
    name = hydro_basins,
    command = terra::vect(hydro_basins_shapefile) |>
      terra::project(drains_vb) |>
      tidyterra::mutate(dplyr::across(HYBAS_ID, as.character)) |>
      terra::mask(x = _, mask = terra::hull(combined_point_data))
  ),
  tar_target(
    name = hydro_basins_reduced_shapefile,
    command = "data/raw/hydro_basins_reduced/hydro_basins_reduced.shp",
    format = "file"
  ),
  tar_terra_vect(
    name = hydro_basins_reduced,
    command = terra::vect(hydro_basins_reduced_shapefile)
  ),
  tar_target(
    name = smith_creek_shapefile,
    command = "data/raw/smith_creek/smith_creek.shp",
    format = "file"
  ),
  tar_terra_vect(
    name = smith_creek,
    command = terra::vect(smith_creek_shapefile)
  ),
  tar_target(
    name = wsa_shapefile,
    command = "data/raw/WSA_Watershed_Planning_Areas/WSA_Watershed_Planning_Areas.shp",
    format = "file"
  ),
  tar_terra_vect(
    name = wsa,
    command = terra::vect(wsa_shapefile) |> terra::project(drains_vb)
  ),
  
  tar_target(
    name = dd_ua_2023_file,
    command = "data/raw/UA_DD_2023.tif",
    format = "file"
  ),
  tar_terra_rast(
    name = dd_ua_2023,
    command = terra::rast(dd_ua_2023_file) |> terra::project(drains_vb)
  ),
  tar_target(
    name = cwi_drains_file,
    command = "data/raw/cwi_drainage_ditches/cwi_drainage_ditches.shp"
  ),
  tar_terra_vect(
    name = cwi_drains_vect,
    command = terra::vect(cwi_drains_file)
  ),
  tar_target(
    name = ua_drainage_file,
    command = "data/raw/UA_Drainage_2024/UA_Drainage2024.shp"
  ),
  tar_terra_vect(
    name = ua_drainage_vect,
    command = terra::vect(ua_drainage_file)
  )
)