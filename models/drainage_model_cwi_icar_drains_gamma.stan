functions {
    real partial_sum_lpdf(
        array [] real slice_area,
        int start,
        int end,
        array [] int basin,
        vector drainage,
        row_vector shape,
        row_vector Theta,
        real beta_drainage
    ) {
        return gamma_lupdf(slice_area | shape[basin[start:end]], shape[basin[start:end]] ./ exp(Theta[basin[start:end]] + beta_drainage * drainage[start:end]'));
    }
}

data {
    int <lower = 0> n_cwi;
    array[n_cwi] int impact_cwi;
    array[n_cwi] int basin_cwi;
    vector [n_cwi] area_cwi;
    vector [n_cwi] dd_cwi;

    int <lower = 0> n_basins;
    row_vector[n_basins] n_drains;

    int <lower = 0> N_icar;
    int <lower = 0> N_icar_edges;
    array [N_icar_edges] int node1;
    array [N_icar_edges] int node2;

    int <lower = 0> grainsize;
}

transformed data {
  array [n_cwi] real area_sqrt;
  
  area_sqrt = to_array_1d(sqrt(area_cwi));
}

parameters {
    vector<lower = 0> [n_basins] shape;
    sum_to_zero_vector[n_basins] Theta;
    
    real beta_drainage_raw;
    real <lower = 0> sigma_drainage;
}

transformed parameters {
  real beta_drainage;
  
  beta_drainage = beta_drainage_raw * sigma_drainage;
}

model {
    // ICAR sampling
    target += -0.5 * dot_self(Theta[node1] - Theta[node2]);// + normal_lupdf(sum(Theta) | 0, 0.01 * n_basins);
    target += exponential_lupdf(shape | 5);
    
    // Scale sigma_impact by sqrt(n_impact / (n_impact - 1)) = sqrt(2) 
    target += std_normal_lupdf(beta_drainage_raw);
    target += std_normal_lupdf(sigma_drainage);

    target += reduce_sum(
        partial_sum_lupdf,
        area_sqrt,
        grainsize,
        basin_cwi,
        dd_cwi,
        shape',
        Theta',
        beta_drainage
        
    );
}

generated quantities {
  matrix [n_basins, 2] mean_drainage;
  
  for (i in 1:n_basins) {
    for (j in 1:2) {
      mean_drainage[i,j] = exp(Theta[i] + beta_impact[j]) ^ 2;
    }
  }
}