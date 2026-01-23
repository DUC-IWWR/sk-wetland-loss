log_lik <- function(draws = NULL, stan_data = NULL, drains_cwi = FALSE, drains_lidar = FALSE, area = FALSE) {
  
  inv_logit <- function(x) exp(x)/(1+exp(x))
  n_cores <- detectCores()
  cluster <- makeCluster(n_cores - 1)
  registerDoParallel(cluster)
  
  y <- stan_data$impact_cwi
  basin <- stan_data$basin_cwi
  
  theta_draws <- draws[, which(grepl("Theta", names(draws)))]
  
  loglik_list <- list()
  
  loglik_list <- foreach (i = 1:nrow(draws)) %dopar% {

    loglik_list[i] <- dbinom(x = y, size = 1, prob = inv_logit(unname(unlist(as.vector(theta_draws[i,basin])))), log = TRUE)
  }
  
  stopCluster(cl = cluster)
  
 # loglik_matrix <- 
  
  loo_1 <- loo(matrix(unlist(loglik_list), ncol = length(y), byrow = TRUE), cores = 13)
  
  return(loo1)
}