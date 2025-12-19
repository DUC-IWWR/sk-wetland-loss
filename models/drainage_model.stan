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
    real alpha_cwi;
    real alpha_cd;
    real alpha_cwi_p;

    real BETA_drains_raw;
    real <lower = 0> sigma_drains;
    row_vector[n_datasets] beta_drains_raw;

    real BETA_area_raw;
    real <lower = 0> sigma_area;
    row_vector[n_datasets] beta_area_raw;

    vector <lower = 0>[n_datasets] alpha;
    matrix[n_basins, n_datasets] u;
    cholesky_factor_corr[n_datasets] L;
}

transformed parameters {
   matrix[n_datasets, n_basins] Theta;

   real BETA_drains;
   row_vector[n_datasets] beta_drains;

   real BETA_area;
   row_vector[n_datasets] beta_area;

   BETA_drains = BETA_drains_raw * sigma_drains;
   beta_drains = BETA_drains + (beta_drains_raw * 10);

   BETA_area = BETA_area_raw * sigma_area;
   beta_area = BETA_area + (beta_area_raw * 10);

   Theta = diag_pre_multiply(alpha, L) * u';
}

model {
    // ICAR sampling
    target += lkj_corr_cholesky_lupdf(L | 1);
    target += std_normal_lupdf(alpha);
    for (i in 1:n_datasets) {
        target += -0.5 * dot_self(u[node1, i] - u[node2,i]);
        target += normal_lupdf(sum(u[, i]) | 0, 0.01 * n_basins);
        //sum(u[, i]) ~ normal(0, 0.01 * n_basins);
    }

    // covariates sampling
    target += std_normal_lupdf(BETA_drains_raw);
    target += std_normal_lupdf(beta_drains_raw);
    target += exponential_lpdf(sigma_drains | 1);

    target += std_normal_lupdf(BETA_area_raw);
    target += std_normal_lupdf(beta_area_raw);
    target += exponential_lpdf(sigma_area | 1);


    target += std_normal_lupdf(alpha_cwi);
    target += reduce_sum(
        partial_sum_lupmf,
        impact_cwi,
        grainsize,
        basin_cwi,
        Theta[1,],
        alpha_cwi,
        beta_drains[1],
        n_drains,
        beta_area[1],
        area_cwi
    );
    //target += bernoulli_logit_lpmf(impact_cwi | alpha_cwi + Theta[1, basin_cwi]);

    target += std_normal_lupdf(alpha_cd);
        target += reduce_sum(
        partial_sum_lupmf,
        impact_cd,
        grainsize,
        basin_cd,
        Theta[2,],
        alpha_cd,
        beta_drains[2],
        n_drains,
        beta_area[2],
        area_cd
    );
    //target += bernoulli_logit_lpmf(impact_cd | alpha_cd + Theta[2, basin_cd]);

    target += std_normal_lupdf(alpha_cwi_p);
        target += reduce_sum(
        partial_sum_lupmf,
        impact_cwi_p,
        grainsize,
        basin_cwi_p,
        Theta[3,],
        alpha_cwi_p,
        beta_drains[3],
        n_drains,
        beta_area[3],
        area_cwi_p
    );
    //target += bernoulli_logit_lpmf(impact_cwi_p | alpha_cwi_p + Theta[3, basin_cwi_p]);
}
