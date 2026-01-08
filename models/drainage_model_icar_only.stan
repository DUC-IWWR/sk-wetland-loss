functions {
    real partial_sum_lpmf(
        array [] int slice_impact,
        int start,
        int end,
        array [] int basin,
        row_vector Theta
    ) {
        return bernoulli_logit_lupmf(slice_impact | Theta[basin[start:end]]);
    }
}

data {
    int <lower = 0> n_cwi;
    array[n_cwi] int impact_cwi;
    array[n_cwi] int basin_cwi;
    vector[n_cwi] area_cwi;

    int <lower = 0> n_cd;
    array[n_cd] int impact_cd;
    array[n_cd] int basin_cd;
    vector[n_cd] area_cd;

    int <lower = 0> n_cwi_p;
    array[n_cwi_p] int impact_cwi_p;
    array[n_cwi_p] int basin_cwi_p;
    vector[n_cwi_p] area_cwi_p;

    int <lower = 0> n_basins;
    int <lower = 0> n_datasets;
    
    row_vector[n_basins] n_drains;

    int <lower = 0> N_icar;
    int <lower = 0> N_icar_edges;
    array [N_icar_edges] int node1;
    array [N_icar_edges] int node2;

    int <lower = 0> grainsize;
}

parameters {
    vector <lower = 0>[n_datasets] alpha;
    matrix[n_basins, n_datasets] u;
    cholesky_factor_corr[n_datasets] L;
}

transformed parameters {
   matrix[n_datasets, n_basins] Theta;

   Theta = diag_pre_multiply(alpha, L) * u';
}

model {
    // ICAR sampling
    target += lkj_corr_cholesky_lupdf(L | 1);
    target += std_normal_lupdf(alpha);
    for (i in 1:n_datasets) {
        target += -0.5 * dot_self(u[node1, i] - u[node2,i]);
        target += normal_lupdf(sum(u[, i]) | 0, 0.01 * n_basins);
    }
    target += reduce_sum(
        partial_sum_lupmf,
        impact_cwi,
        grainsize,
        basin_cwi,
        Theta[1,]
    );

    target += reduce_sum(
        partial_sum_lupmf,
        impact_cd,
        grainsize,
        basin_cd,
        Theta[2,]
    );

    target += reduce_sum(
        partial_sum_lupmf,
        impact_cwi_p,
        grainsize,
        basin_cwi_p,
        Theta[3,]
    );
}
