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
        vector beta_area
    ) {
        return bernoulli_logit_lupmf(slice_impact | Theta[basin[start:end]]' + beta_drainage[basin[start:end]] .* drainage[start:end] + beta_area[basin[start:end]] .* area[start:end]);
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

    int <lower = 0> n_basins;

    int <lower = 0> N_icar;
    int <lower = 0> N_icar_edges;
    array [N_icar_edges] int node1;
    array [N_icar_edges] int node2;

    int <lower = 0> grainsize;
}

parameters {
    sum_to_zero_vector[n_basins] Theta;
    
    real mu_drainage;
    vector[n_basins] beta_drainage_raw;
    real <lower = 0> sigma_drainage;
    
    real mu_area;
    vector[n_basins] beta_area_raw;
    real <lower = 0> sigma_area;
}

transformed parameters {
  vector[n_basins] beta_drainage;
  vector[n_basins] beta_area;
  
  beta_drainage = mu_drainage + beta_drainage_raw * sigma_drainage;
  beta_area = mu_area + beta_area_raw * sigma_area;
}

model {
    // ICAR sampling
    target += -0.5 * dot_self(Theta[node1] - Theta[node2]);
    
    target += normal_lpdf(mu_drainage | 0, 10);
    target += std_normal_lupdf(beta_drainage_raw);
    target += std_normal_lupdf(sigma_drainage);
    
    target += normal_lpdf(mu_area | 0, 10);
    target += std_normal_lupdf(beta_area_raw);
    target += std_normal_lupdf(sigma_area);

    target += reduce_sum(
        partial_sum_lupmf,
        impact_cwi_tr,
        grainsize,
        basin_cwi_tr,
        dd_cwi_tr,
        area_cwi_tr,
        Theta',
        beta_drainage,
        beta_area
        
    );
}

// generated quantities {
//   vector[n_cwi_te] score;
//   score = Theta[basin_cwi_te] + (beta_area[basin_cwi_te] .* area_cwi_te) + (beta_drainage[basin_cwi_te] .* dd_cwi_te);
// }
