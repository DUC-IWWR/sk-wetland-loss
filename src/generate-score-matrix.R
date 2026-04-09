generate_score_matrix <- function(draws = NULL) {
  score_matrix <- as.matrix(draws[,1:(ncol(draws) - 3)])
  score_matrix <- inv_logit(score_matrix)

  return(score_matrix)
}