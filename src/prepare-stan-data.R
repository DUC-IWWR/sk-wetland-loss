prepare_stan_data <- function(data = NULL, shp = NULL)
{
  hybas_extracted <- terra::extract(tidyterra::select(shp, HYBAS_ID_Factor),data) 
  combined <- tidyterra::bind_spat_cols(data, hybas_extracted)

  return(data.frame(combined))
}