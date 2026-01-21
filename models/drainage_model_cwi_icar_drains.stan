functions {
    real partial_sum_lpmf(
        array [] int slice_impact,
        int start,
        int end,
        array [] int basin,
        vector drainage,
        row_vector Theta,
        vector beta_drainage
    ) {
        return bernoulli_logit_lupmf(slice_impact | Theta[basin[start:end]]' + beta_drainage[basin[start:end]] .* drainage[start:end]);
  }
}

data {
    int <lower = 0> n_cwi;
    array[n_cwi] int impact_cwi;
    array[n_cwi] int basin_cwi;
    vector [n_cwi] area_cwi;
    vector [n_cwi] dd_cwi;

    int <lower = 0> n_basins;

    int <lower = 0> N_icar;
    int <lower = 0> N_icar_edges;
    array [N_icar_edges] int node1;
    array [N_icar_edges] int node2;

    int <lower = 0> grainsize;
}

parameters {
    sum_to_zero_vector[n_basins] Theta;
    
    vector[n_basins] beta_drainage_raw;
    real <lower = 0> sigma_drainage;
}

transformed parameters {
  vector[n_basins] beta_drainage;
  
  beta_drainage = beta_drainage_raw * sigma_drainage;
}

model {
    // ICAR sampling
    target += -0.5 * dot_self(Theta[node1] - Theta[node2]);
    
    target += std_normal_lupdf(beta_drainage_raw);
    target += std_normal_lupdf(sigma_drainage);

    target += reduce_sum(
        partial_sum_lupmf,
        impact_cwi,
        grainsize,
        basin_cwi,
        dd_cwi,
        Theta',
        beta_drainage
        
    );
}
