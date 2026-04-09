calculate_precision <- function(predicted, actual) {
  positive_indices <- which(predicted == 1)
  if (length(positive_indices) == 0) {
    return(0)
  }

  positive_predicted <- predicted[positive_indices]
  positive_actual <- actual[positive_indices]

  tp <- sum(positive_predicted == positive_actual)
  fp <- length(positive_indices) - tp

  precision <- tp / (tp + fp)

  return(precision)
}