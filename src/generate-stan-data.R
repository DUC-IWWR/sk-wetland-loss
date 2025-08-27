generate_stan_data <- function(data = NULL)
{
  data_df <- data.frame(data)
  data_df$Percent_drained <- (data_df$CWI_1 + data_df$CWI_5) / data_df$CWI_Total
  data_df <- data_df[-which(is.na(data_df$Percent_drained)), ]
  
  y <- data_df$Percent_drained
  n_drains <- scale(data_df$Polyline_C)[,1]
  N <- length(y)
  
  return(list(N = N, y = y, n_drains = n_drains))
}