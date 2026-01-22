data {
  int<lower=0> N;
  vector[N] y;
  
  int<lower = 0> n_lcc;
  array[N] int lcc;
}

parameters {
  vector [n_lcc] theta;
  real <lower = 0> phi;
}

model {
  vector[n_lcc] mu;
  vector[n_lcc] A;
  vector[n_lcc] B;
  
  theta ~ std_normal();
  phi ~ cauchy(0, 5);
  
  mu = inv_logit(theta);
  
  A = mu * phi;
  B = (1.0 - mu) * phi;
  
  for (i in 1:N)
  {
    y[i] ~ beta(A[lcc[i]], B[lcc[i]]);
  }
}

generated quantities {
  vector[n_lcc] percent_drained;
  
  for (i in 1:n_lcc)
  {
    percent_drained[i] = beta_rng(inv_logit(theta[i]) * phi,
                                    (1.0-inv_logit(theta[i])) * phi);
  }
  

}

