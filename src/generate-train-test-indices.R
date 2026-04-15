generate_train_test_indices <- function(df) {
  df$HYBAS_Impact <- paste0(df$HYBAS_ID, "-", df$Impact)
  folds <- data.frame(HYBAS_Impact = df[which(df$Model == "CWI"), "HYBAS_Impact"])
  folds$index <- which(df$Model == "CWI")
  folds$Test <- 0
  
  for (f in unique(folds$HYBAS_Impact)) {
    temp <- folds[which(folds$HYBAS_Impact == f),]
    if (nrow(temp) >= 10) {
      temp$Test[sample(.2 * seq_len(nrow(temp)))] <- 1
      folds[which(folds$index %in% temp$index), "Test"] <- temp$Test
    }
  }
  
  return(folds)
}