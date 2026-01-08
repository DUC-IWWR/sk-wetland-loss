functions {
    real partial_sum_lpmf(
        array [] int slice_impact,
        int start,
        int end,
        array [] int basin,
        row_vector Theta,
        real beta_drains,
        row_vector n_drains
    ) {
        return bernoulli_logit_lupmf(slice_impact | Theta[basin[start:end]] + (beta_drains * n_drains[basin[start:end]]));
    }
}

data {
    int <lower = 0> n_cwi;
    array[n_cwi] int impact_cwi;
    array[n_cwi] int basin_cwi;
    vector[n_cwi] area_cwi;

    int <lower = 0> n_basins;
    
    row_vector[n_basins] n_drains;

    int <lower = 0> N_icar;
    int <lower = 0> N_icar_edges;
    array [N_icar_edges] int node1;
    array [N_icar_edges] int node2;

    int <lower = 0> grainsize;
}

parameters {
    vector[n_basins] Theta;
    
    real beta_drains_raw;
    real <lower = 0> sigma_drains;
}

transformed parameters {
  real beta_drains;
  
  beta_drains = beta_drains_raw * sigma_drains;
}

model {
    // ICAR sampling
    target += -0.5 * dot_self(Theta[node1] - Theta[node2]) + normal_lupdf(sum(Theta) | 0, 0.01 * n_basins);
    
    target += std_normal_lupdf(beta_drains_raw);
    target += exponential_lpdf(sigma_drains | 1);

    target += reduce_sum(
        partial_sum_lupmf,
        impact_cwi,
        grainsize,
        basin_cwi,
        Theta',
        beta_drains,
        n_drains
    );
}
