generate_stan_data <- function(data = NULL)
{
  data_df <- data.frame(data)
 # data_df <- data_df[-which(is.na(data_df$Percent_Drained)), ]
 # data_df <- data_df[-which(is.na(data_df$WSA)), ]
  
  y <- data_df$Percent_Drained + 1e-8
  n_drains <- scale(data_df$Polyline_C)[,1]
  N <- length(y)
  n_wsa <- length(unique(data_df$WSA))
  wsa <- data_df$WSA_Factor
  n_lcc <- length(unique(data_df$LCClassNam))
  lcc <- data_df$LCClassNam_Factor
  
  return(list(N = N,
              y = y, 
              n_drains = n_drains, 
              n_wsa = n_wsa, 
              wsa = wsa,
              n_lcc = n_lcc,
              lcc = lcc))
}