merge_vb_datasets <- function(drains_data = NULL,
                              cwi_data = NULL,
                              vb_shp = NULL)
{
  drains_data$HYBAS_ID <- vb_shp$HYBAS_ID
  cwi_data$CWI_Impact <- paste0("CWI_", cwi_data$CWI_Impact)
  cwi_data_red <- cwi_data[, c("BasinID", "CWI_Impact", "Area_km2")]
  cwi_data_red_wide <- reshape2::dcast(cwi_data_red,
                                       BasinID ~ CWI_Impact,
                                       value.var = "Area_km2")
                                       
  # Create a matrix of CWI impact areas for quicker function calls
  cwi_mat <- as.matrix(cwi_data_red_wide[,2:ncol(cwi_data_red_wide)])
  CWI_Total <- rowSums(cwi_mat, na.rm = TRUE)
  cwi_data_red_wide$CWI_Total <- CWI_Total
  drains_data <- merge(drains_data, cwi_data_red_wide, by = "BasinID")
  vb_final <- terra::merge(vb_shp, drains_data[, c("HYBAS_ID", "BasinID", 
                                                   "CWI_0", "CWI_1", "CWI_2", 
                                                   "CWI_3", "CWI_4", "CWI_5",
                                                   "CWI_Total")],
                    by = "HYBAS_ID")
  
  return(vb_final)
}