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
      tidyterra::mutate(dplyr::across(HYBAS_ID, as.character))
  ),
  tar_target(
    name = hydro_basins_shapefile,
    command = "data/raw/hydro_basins/hybas_na_lev12_v1c.shp",
    format = "file"
  ),
  tar_terra_vect(
    name = hydro_basins,
    command = terra::vect(hydro_basins_shapefile) |>
      tidyterra::mutate(dplyr::across(HYBAS_ID, as.character))
  ),
  
  tar_target(
    name = dd_ua_2023_file,
    command = "data/raw/UA_DD_2023.tif",
    format = "file"
  ),
  tar_terra_rast(
    name = dd_ua_2023,
    command = terra::rast(dd_ua_2023_file) |> terra::project(hydro_basins)
  ),
  tar_target(
    name = cwi_drains_file,
    command = "data/raw/cwi_drainage_ditches/cwi_drainage_ditches.shp"
  ),
  tar_terra_vect(
    name = cwi_drains_vect,
    command = terra::vect(
      x = cwi_drains_file) |>
      terra::project(hydro_basins)
  ),

  # HYBAS IDs of Hydro basin subsets
  tar_target(
    name = smith_creek_hybas_id,
    command = read.csv("data/raw/smith_creek_hybas_id.csv")
  )
)