data {
    int <lower = 0> n_cwi;
    array[n_cwi] int impact_cwi;
    array[n_cwi] int basin_cwi;

    int <lower = 0> n_cd;
    array[n_cd] int impact_cd;
    array[n_cd] int basin_cd;

    int <lower = 0> n_cwi_p;
    array[n_cwi_p] int impact_cwi_p;
    array[n_cwi_p] int basin_cwi_p;

    int <lower = 0> n_basins;
    int <lower = 0> n_datasets;

}

parameters {
    real alpha_cwi_p;
}

model {
    target += normal_lpdf(alpha_cwi_p | 0, 1);
    target += bernoulli_logit_lpmf(impact_cwi_p | alpha_cwi_p);

}
