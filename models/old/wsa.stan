data {
  int<lower=0> N;
  vector[N] y;
  
  int<lower = 0> n_wsa;
  array[N] int wsa;
}

parameters {
  vector [n_wsa] theta;
  real <lower = 0> phi;
}

model {
  vector[n_wsa] mu;
  vector[n_wsa] A;
  vector[n_wsa] B;
  
  theta ~ std_normal();
  phi ~ cauchy(0, 5);
  
  mu = inv_logit(theta);
  
  A = mu * phi;
  B = (1.0 - mu) * phi;
  
  for (i in 1:N)
  {
    y[i] ~ beta(A[wsa[i]], B[wsa[i]]);
  }
}

generated quantities {
  vector[n_wsa] percent_drained;
  
  for (i in 1:n_wsa)
  {
    percent_drained[i] = beta_rng(inv_logit(theta[i]) * phi,
                                    (1.0-inv_logit(theta[i])) * phi);
  }
  

}

