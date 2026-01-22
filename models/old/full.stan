data {
  int<lower=0> N;
  vector[N] y;
  
  int<lower = 0> n_lcc;
  array[N] int lcc;
  
  int<lower = 0> n_wsa;
  array[N] int wsa;
  
  vector[N] n_drains;
}

parameters {
  vector [n_lcc] theta_lcc;
 // real <lower = 0> phi_lcc;
  
  vector [n_wsa] theta_wsa;
  //real <lower = 0> phi_wsa;
  
  real theta_drains;
  //real <lower = 0> phi_drains;
  
  real <lower = 0> phi;
}

model {
  vector[N] mu;
  vector[N] A;
  vector[N] B;
  
  theta_lcc ~ std_normal();
 // phi_lcc ~ cauchy(0, 5);
  
  theta_wsa ~ std_normal();
//  phi_wsa ~ cauchy(0, 5);
  
  theta_drains ~ std_normal();
//  phi_drains ~ cauchy(0, 5);
  
  mu = inv_logit(theta_lcc[lcc] + theta_wsa[wsa] + (theta_drains * n_drains));
  
  A = mu * phi;
  B = (1.0 - mu) * phi;
  
  y ~ beta(A, B);
  
}

generated quantities {
  vector[N] y_pred;
  
  for (i in 1:N)
  {
    real mu;
    real A;
    real B;
    
    y_pred[i] = inv_logit(theta_lcc[lcc[i]] + theta_wsa[wsa[i]] + (theta_drains * n_drains[i]));
    
    //A = mu * phi;
   // B = (1.0 - mu) * phi;
    
   // y_pred[i] = beta_rng(A,B);
  }
}
