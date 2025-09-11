build_vb_db <- function(drains_data = NULL,
                        cwi_data = NULL,
                        vb_statistics = NULL,
                        vb_shp = NULL,
                        wsa_shp = NULL)
{
  drains_data$HYBAS_ID <- vb_shp$HYBAS_ID
  drains_data <- drains_data[which(drains_data$HYBAS_ID != 0), ]
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
  vb_db <- terra::merge(vb_shp, drains_data[, c("HYBAS_ID", "BasinID", 
                                                   "CWI_0", "CWI_1", "CWI_2", 
                                                   "CWI_3", "CWI_4", "CWI_5",
                                                   "CWI_Total")],
                    by = "HYBAS_ID")
  
  vb_db$Percent_Drained <- rowSums(cbind(vb_db$CWI_1, vb_db$CWI_5), na.rm = TRUE) / vb_db$CWI_Total
  
  # Bring in VB drainage and wetland statistics
  vb_db <- terra::merge(vb_db, vb_statistics[,c("HYBAS_ID",
                                                "SUM_Shape_Area",
                                                "MEAN_Shape_Area",
                                                "MEDIAN_Shape_Area",
                                                "MAX_Shape_Area",
                                                "COUNT_Shape_Area")],
                        by = "HYBAS_ID", all.x = TRUE)

  vb_db$WSA <- terra::extract(wsa_shp,
                              terra::centroids(vb_db))$Name
  
  # Drop all the NAs
  vb_db <- vb_db[-which(is.na(vb_db$Percent_Drained)), ]
  vb_db <- vb_db[-which(is.na(vb_db$WSA)), ]
  
  # Numerical factors for WSA and LCClass
  vb_db$WSA_Factor <- as.numeric(as.factor(vb_db$WSA))
  vb_db$LCClassNam_Factor <- as.numeric(as.factor(vb_db$LCClassNam))
  
  return(vb_db)
}