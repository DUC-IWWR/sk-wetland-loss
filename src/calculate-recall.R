calculate_recall <- function(predicted, actual) {
  positive_indices <- which(predicted == 1)
  if (length(positive_indices) == 0) {
    return(0)
  }

  positive_predicted <- predicted[positive_indices]
  positive_actual <- actual[positive_indices]

  tp <- sum(positive_predicted == positive_actual)
  p <- sum(actual)

  return(tp / p)
}