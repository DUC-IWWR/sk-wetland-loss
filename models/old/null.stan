data {
  int<lower=0> N;
  vector[N] y;
}

parameters {
  real<lower = 0> alpha;
  real<lower = 0> beta;
}

model {
  y ~ beta(alpha, beta);
}

