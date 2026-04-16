calculate_holdout_loglik <- function(probs, outcomes) {
  loglik_vector <- dbinom(
    x = outcomes,
    size = 1,
    prob = probs,
    log = TRUE
  )

  loglik_vector[is.infinite(loglik_vector)] <- NA

  return(sum(loglik_vector, na.rm = TRUE))

}