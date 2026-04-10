generate_confusion_matrix <- function(predicted, actual) {
  positive_indices <- which(predicted == 1)
  pp <- length(positive_indices)
  if (pp == 0) {
    tp <- 0
    fp <- 0
  } else {
    positive_predicted <- predicted[positive_indices]
    positive_actual <- actual[positive_indices]

    tp <- sum(positive_predicted == positive_actual)
    fp <- length(positive_indices) - tp
  }

  negative_indices <- which(predicted == 0)
  pn <- length(negative_indices)
  if (pn == 0) {
    tn <- 0
    fn <- 0
  } else {
    negative_predicted <- predicted[negative_indices]
    negative_actual <- actual[negative_indices]

    tn <- sum(negative_predicted == negative_actual)
    fn <- length(negative_indices) - tn
  }

  total_population <- length(actual)
  p <- sum(actual)
  n <- total_population - p

  return(
    matrix(
      data = c(total_population, pp, pn,
               p, tp, fn,
               n, fp, tn),
              nrow = 3, ncol = 3,
              byrow = TRUE
    )
  )

}

calculate_recall <- function(cm) {
  tp <- cm[2,2]
  p <- cm[2,1]
  return(tp / p)
}

calculate_precision <- function(cm) {
  tp <- cm[2,2]
  fp <- cm[3,2]
  precision <- tp / (tp + fp)

  return(precision)
}

calculate_f1 <- function(cm) {
  tp <- cm[2,2]
  fp <- cm[3,2]
  fn <- cm[2,3]

  f1 <- (2*tp) / (2*tp + fp + fn)

  return(f1)
}

calculate_mcc <- function(cm) {
  tp <- cm[2,2]
  tn <- cm[3,3]
  fp <- cm[3,2]
  fn <- cm[2,3]

  s1 <- tp + fp
  s2 <- tp + fn
  s3 <- tn + fp
  s4 <- tn + fn

  if (0 %in% c(s1,s2,s3,s4)) {
    return(0)
  } else {
    return(((tp * tn) - (fp * fn))/(sqrt(s1*s2*s3*s4)))
  }

}