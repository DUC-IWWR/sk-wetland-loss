functions {
    real partial_sum_lpmf(
        array [] int slice_impact,
        int start,
        int end,
        array [] int basin,
        vector area,
        row_vector Theta,
        vector beta_area
    ) {
        return bernoulli_logit_lupmf(slice_impact | Theta[basin[start:end]]' + beta_area[basin[start:end]] .* area[start:end]);
  }
}

data {
  int <lower = 0> n_cwi;
  array[n_cwi] int impact_cwi;
  array[n_cwi] int basin_cwi;
  vector [n_cwi] area_cwi;
  vector [n_cwi] dd_cwi;
  
  int <lower = 0> n_cd;
  array[n_cd] int impact_cd;
  array[n_cd] int basin_cd;
  vector [n_cd] area_cd;
  vector [n_cd] dd_cd;
  
  int <lower = 0> n_basins;
  int <lower = 0> n_datasets;
  
  int <lower = 0> N_icar;
  int <lower = 0> N_icar_edges;
  array [N_icar_edges] int node1;
  array [N_icar_edges] int node2;
  
  int <lower = 0> grainsize;
}

parameters {
  vector <lower = 0>[n_datasets] alpha;
  sum_to_zero_vector[n_basins] u_cwi;
  sum_to_zero_vector[n_basins] u_cp;
  cholesky_factor_corr[n_datasets] L;
  
  vector[n_basins] beta_area_raw;
  real <lower = 0> sigma_area;
  
}

transformed parameters {
  matrix[n_datasets, n_basins] Theta;
  vector[n_basins] beta_area;
  
  beta_area = beta_area_raw * sigma_area;

  Theta = diag_pre_multiply(alpha, L) * append_col(u_cwi, u_cp)';
}

model {
    // ICAR sampling
    target += lkj_corr_cholesky_lupdf(L | 1);
    target += std_normal_lupdf(alpha);
    target += -0.5 * dot_self(u_cwi[node1] - u_cwi[node2]);
    target += -0.5 * dot_self(u_cp[node1] - u_cp[node2]);
    
    target += std_normal_lupdf(beta_area_raw);
    target += std_normal_lupdf(sigma_area);
    
    target += reduce_sum(
        partial_sum_lupmf,
        impact_cwi,
        grainsize,
        basin_cwi,
        area_cwi,
        Theta[1,],
        beta_area
    );

    target += reduce_sum(
        partial_sum_lupmf,
        impact_cd,
        grainsize,
        basin_cd,
        area_cd,
        Theta[2,],
        beta_area
    );

}
