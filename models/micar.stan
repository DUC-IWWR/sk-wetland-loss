functions {
    real partial_sum_lpmf(
        array [] int slice_impact,
        int start,
        int end,
        array [] int basin,
        vector drainage,
        vector area,
        row_vector Theta,
        vector beta_drainage,
        vector beta_area,
        int point
    ) {
        if (point == 1) {
          return bernoulli_logit_lupmf(slice_impact | Theta[basin[start:end]]' + beta_drainage[basin[start:end]] .* drainage[start:end]);
        } else {
          return bernoulli_logit_lupmf(slice_impact | Theta[basin[start:end]]' + beta_drainage[basin[start:end]] .* drainage[start:end] + beta_area[basin[start:end]] .* area[start:end]);
        }
        
  }
}

data {
    int <lower = 0> n_cwi_tr;
    array[n_cwi_tr] int impact_cwi_tr;
    array[n_cwi_tr] int basin_cwi_tr;
    vector [n_cwi_tr] dd_cwi_tr;
    vector [n_cwi_tr] area_cwi_tr;
    
    int <lower = 0> n_cwi_te;
    array[n_cwi_te] int basin_cwi_te;
    vector [n_cwi_te] dd_cwi_te;
    vector [n_cwi_te] area_cwi_te;
  
  int <lower = 0> n_cd;
  array[n_cd] int impact_cd;
  array[n_cd] int basin_cd;
  vector [n_cd] area_cd;
  vector [n_cd] dd_cd;

  int <lower = 0> n_cwi_p;
  array[n_cwi_p] int impact_cwi_p;
  array[n_cwi_p] int basin_cwi_p;
  vector [n_cwi_p] area_cwi_p;
  vector [n_cwi_p] dd_cwi_p;
  
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
  sum_to_zero_vector[n_basins] u_cwi_p;
  cholesky_factor_corr[n_datasets] L;

  real mu_drainage;
  real <lower = 0> sigma_drainage;
  vector[n_basins] beta_drainage_raw;

  real mu_area;
  real <lower = 0> sigma_area;  
  vector[n_basins] beta_area_raw;
  
}

transformed parameters {
  matrix[n_datasets, n_basins] Theta;
  vector[n_basins] beta_drainage;
  vector[n_basins] beta_area;
  
  beta_drainage = mu_drainage + beta_drainage_raw * sigma_drainage;
  beta_area = mu_area + beta_area_raw * sigma_area;

  Theta = diag_pre_multiply(alpha, L) * append_col(append_col(u_cwi, u_cp), u_cwi_p)';
}

model {
    // ICAR sampling
    target += lkj_corr_cholesky_lupdf(L | 1);
    target += std_normal_lupdf(alpha);
    target += -0.5 * dot_self(u_cwi[node1] - u_cwi[node2]);
    target += -0.5 * dot_self(u_cp[node1] - u_cp[node2]);
    target += -0.5 * dot_self(u_cwi_p[node1] - u_cwi_p[node2]);
    
    target += normal_lpdf(mu_drainage | 0, 10);
    target += std_normal_lupdf(beta_drainage_raw);
    target += std_normal_lupdf(sigma_drainage);
    
    target += normal_lpdf(mu_area | 0, 10);
    target += std_normal_lupdf(beta_area_raw);
    target += std_normal_lupdf(sigma_area);
    
    // CWI Likelihood contributions
    target += reduce_sum(
        partial_sum_lupmf,
        impact_cwi_tr,
        grainsize,
        basin_cwi_tr,
        dd_cwi_tr,
        area_cwi_tr,
        Theta[1,],
        beta_drainage,
        beta_area,
        0
    );

    // CD Likelihood contributions
    target += reduce_sum(
        partial_sum_lupmf,
        impact_cd,
        grainsize,
        basin_cd,
        dd_cd,
        area_cd,
        Theta[2,],
        beta_drainage,
        beta_area,
        0
    );

    // CWI Point likelihood contributions
    target += reduce_sum(
        partial_sum_lupmf,
        impact_cwi_p,
        grainsize,
        basin_cwi_p,
        dd_cwi_p,
        area_cwi_p,
        Theta[3,],
        beta_drainage,
        beta_area,
        1
    );

}

// generated quantities {
//   vector[n_cwi_te] score;
//   score = Theta[1,basin_cwi_te]' + (beta_area[basin_cwi_te] .* area_cwi_te) + (beta_drainage[basin_cwi_te] .* dd_cwi_te);
// }
