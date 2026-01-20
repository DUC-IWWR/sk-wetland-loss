functions {
    real partial_sum_lpdf(
        array [] real slice_area,
        int start,
        int end,
        array [] int basin,
        array [] int impact,
        row_vector shape,
        row_vector Theta,
        vector beta_impact
    ) {
        return gamma_lupdf(slice_area | shape[basin[start:end]], shape[basin[start:end]] ./ exp(Theta[basin[start:end]] + beta_impact[impact[start:end]]'));
    }
}

data {
  int <lower = 0> n_cwi;
  array[n_cwi] int impact_cwi;
  array[n_cwi] int basin_cwi;
  vector [n_cwi] area_cwi;
  
  int <lower = 0> n_cd;
  array[n_cd] int impact_cd;
  array[n_cd] int basin_cd;
  vector [n_cd] area_cd;
  
  int <lower = 0> n_basins;
  int <lower = 0> n_datasets;
  
  int <lower = 0> N_icar;
  int <lower = 0> N_icar_edges;
  array [N_icar_edges] int node1;
  array [N_icar_edges] int node2;
  
  int <lower = 0> grainsize;
}

transformed data {
  array [n_cwi] real area_cwi_sqrt;
  array [n_cd] real area_cd_sqrt;
  
  area_cwi_sqrt = to_array_1d(sqrt(area_cwi));
  area_cd_sqrt = to_array_1d(sqrt(area_cd));
}

parameters {
  vector <lower = 0>[n_datasets-1] alpha;
  sum_to_zero_vector[n_basins] u_cwi;
  sum_to_zero_vector[n_basins] u_cp;
  cholesky_factor_corr[n_datasets-1] L;
  
  vector<lower = 0> [n_basins] shape_cwi;
  vector<lower = 0> [n_basins] shape_cd;
  
    sum_to_zero_vector[2] beta_impact;
    real <lower = 0> sigma_impact;
}

transformed parameters {
  matrix[n_datasets-1, n_basins] Theta;
  
  Theta = diag_pre_multiply(alpha, L) * append_col(u_cwi, u_cp)';
}

model {
    // ICAR sampling
    target += lkj_corr_cholesky_lupdf(L | 1);
    target += std_normal_lupdf(alpha);
    target += -0.5 * dot_self(u_cwi[node1] - u_cwi[node2]);
    target += -0.5 * dot_self(u_cp[node1] - u_cp[node2]);
    
    target += exponential_lupdf(shape_cwi | 5);
    target += exponential_lupdf(shape_cd | 5);
    
    // Scale sigma_impact by sqrt(n_impact / (n_impact - 1)) = sqrt(2) 
    target += normal_lupdf(beta_impact | 0, sigma_impact * sqrt(2));
    target += std_normal_lupdf(sigma_impact);
    
    target += reduce_sum(
        partial_sum_lupdf,
        area_cwi_sqrt,
        grainsize,
        basin_cwi,
        impact_cwi,
        shape_cwi',
        Theta[1,],
        beta_impact
      );

    target += reduce_sum(
      partial_sum_lupdf,
      area_cd_sqrt,
      grainsize,
      basin_cd,
      impact_cd,
      shape_cd',
      Theta[2,],
      beta_impact
    );

}

generated quantities {
  matrix [n_basins, 2] mean_drainage;
  
  for (i in 1:n_basins) {
    for (j in 1:2) {
      mean_drainage[i,j] = exp(Theta[1,i] + beta_impact[j]) ^ 2;
    }
  }
}
