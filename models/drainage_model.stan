functions {
    // Taken from https://jrnold.github.io/ssmodels-in-stan/
    matrix kronecker_prod(matrix A, matrix B) {
        matrix[rows(A) * rows(B), cols(A) * cols(B)] C;
        int m;
        int n;
        int p;
        int q;
        m = rows(A);
        n = cols(A);
        p = rows(B);
        q = cols(B);
        for (i in 1:m) {
        for (j in 1:n) {
            int row_start;
            int row_end;
            int col_start;
            int col_end;
            row_start = (i - 1) * p + 1;
            row_end = (i - 1) * p + p;
            col_start = (j - 1) * q + 1;
            col_end = (j - 1) * q + 1;
            C[row_start:row_end, col_start:col_end] = A[i, j] * B;
        }
        }
        return C;
    }
}

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
    real alpha_cwi;
    real alpha_cd;
    real alpha_cwi_p;

    vector[n_datasets] theta;

    corr_matrix[n_datasets] Omega;
    vector<lower = 0>[n_datasets] sigma;
}

transformed parameters {
   cov_matrix[n_datasets] Sigma;
   Sigma = quad_form_diag(Omega, sigma);
}

model {
    target += normal_lpdf(alpha_cwi | 0, 1);
    target += bernoulli_logit_lpmf(impact_cwi | alpha_cwi);

    target += normal_lpdf(alpha_cd | 0, 1);
    target += bernoulli_logit_lpmf(impact_cd | alpha_cd);

    target += normal_lpdf(alpha_cwi_p | 0, 1);
    target += bernoulli_logit_lpmf(impact_cwi_p | alpha_cwi_p);

    target += cauchy_lpdf(sigma | 0, 5);
    target += lkj_corr_lpdf(Omega | 1);

    target += multi_normal_lpdf(theta | rep_vector(0, n_datasets), Sigma);

}
