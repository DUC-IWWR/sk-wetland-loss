data {
  int<lower=0> N;
  vector[N] y;
  
  int<lower = 0> n_wsa;
  vector[N] wsa;
}

parameters {
  vector [n_wsa] theta;
  real <lower = 0> phi;
}

model {
  vector[N] mu;
  vector[N] A;
  vector[N] B;
  
  theta ~ std_normal();
  phi ~ cauchy(0, 5);
  
  mu = inv_logit(beta * n_drains);
  
  
  A = mu * phi;
  B = (1.0 - mu) * phi;
  
  y ~ beta(A, B);
}

