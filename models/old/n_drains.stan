data {
  int<lower=0> N;
  vector[N] y;
  vector[N] n_drains;
}

parameters {
  real beta;
  real <lower = 0> phi;
}

model {
  vector[N] mu;
  vector[N] A;
  vector[N] B;
  
  beta ~ std_normal();
  
  mu = inv_logit(beta * n_drains);
  phi ~ cauchy(0, 5);
  
  A = mu * phi;
  B = (1.0 - mu) * phi;
  
  y ~ beta(A, B);
}

