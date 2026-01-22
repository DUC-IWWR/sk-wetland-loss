functions {
    real partial_sum_lpmf(
        array [] int slice_impact,
        int start,
        int end,
        array [] int basin,
        row_vector Theta,
        real alpha,
        real beta_drains,
        row_vector n_drains,
        real beta_area,
        vector area
    ) {
        return bernoulli_logit_lupmf(slice_impact | alpha + (beta_area * area[start:end])' + (beta_drains * n_drains[basin[start:end]]) + Theta[basin[start:end]]);
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
    real alpha_cwi;

    real beta_drains_raw;
    real <lower = 0> sigma_drains;

    real beta_area_raw;
    real <lower = 0> sigma_area;

    vector[n_basins] Theta;
}

transformed parameters {
   real beta_drains;
   real beta_area;

   beta_drains = beta_drains_raw * sigma_drains;
   beta_area = beta_area_raw * sigma_area;
}

model {
    // ICAR sampling
    target += -0.5 * dot_self(Theta[node1] - Theta[node2]) + normal_lupdf(sum(Theta) | 0, 0.01 * n_basins);

    // covariates sampling
    target += std_normal_lupdf(beta_drains_raw);
    target += exponential_lpdf(sigma_drains | 1);

    target += std_normal_lupdf(beta_area_raw);
    target += exponential_lpdf(sigma_area | 1);

    target += std_normal_lupdf(alpha_cwi);
    target += reduce_sum(
        partial_sum_lupmf,
        impact_cwi,
        grainsize,
        basin_cwi,
        Theta',
        alpha_cwi,
        beta_drains,
        n_drains,
        beta_area,
        area_cwi
    );
}
