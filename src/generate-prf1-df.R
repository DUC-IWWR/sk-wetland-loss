generate_prf1_df <- function(score_matrix, data, increment) {

  thresholds <- seq(0, 1, increment)
  df <- data.frame(
    draw = rep(
      seq(
        1,
        nrow(score_matrix)
      ),
      each = length(thresholds)
    ),

    threshold = rep(
      thresholds,
      nrow(score_matrix)
    ),

    precision = NA,

    recall = NA,

    f1 = NA,

    mcc = NA
  )

  predictions_list <- vector(mode = "list", length = length(thresholds))
  names(predictions_list) <- as.character(thresholds)

  for (t in thresholds) {
    predictions_list[[as.character(t)]] <- ifelse(score_matrix > t, 1, 0)
  }

  for (i in 1:nrow(df)) {
    #' First get the appropriate prediction matrix based on the threshold,
    #' then get the particular draw for this row of the data frame.
    #' Should return a vector of the same length of the held out data
    pred_vector <- unlist(predictions_list[[as.character(df$threshold[i])]][df$draw[i],])

    confusion_matrix <- generate_confusion_matrix(pred_vector, data$impact_cwi_te)

    df$precision[i] <- calculate_precision(confusion_matrix)

    df$recall[i] <- calculate_recall(confusion_matrix)

    df$f1[i] <- calculate_f1(confusion_matrix)

    df$mcc[i] <- calculate_mcc(confusion_matrix)
    
  }

  return(df)
}