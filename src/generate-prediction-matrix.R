generate_prediction_matrix <- function(draws = NULL, threshold = NULL, data = NULL) {
  inv_logit <- function(x) exp(x)/(1+exp(x))
  n_cores <- detectCores()
  cluster <- makeCluster(n_cores - 1)
  registerDoParallel(cluster)
  
  score_matrix <- as.matrix(draws[,1:(ncol(draws) - 3)])
  score_matrix <- inv_logit(score_matrix)
  predictions <- ifelse(score_matrix > threshold, 1, 0)
  correct <- list()
  
  correct <- foreach (i = 1:nrow(predictions)) %dopar% {
    correct[i] <- ifelse(predictions[i,] == data$impact_cwi_te, 1, 0)
  }
  
  stopCluster(cl = cluster)
  
  rm(score_matrix)
  rm(predictions)
  gc()
  
  correct_mat <- matrix(unlist(correct), ncol = data$n_cwi_te, byrow = TRUE)
  

  return(correct_mat)
}