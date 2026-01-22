functions {
    real partial_sum_lpdf(
        array [] real slice_area,
        int start,
        int end,
        array [] int basin,
        row_vector shape,
        row_vector Theta
    ) {
        return gamma_lupdf(slice_area | shape[basin[start:end]], shape[basin[start:end]] ./ Theta[basin[start:end]]);
    }
}

data {
    int <lower = 0> n_cwi;
    array[n_cwi] int impact_cwi;
    array[n_cwi] int basin_cwi;
    vector [n_cwi] area_cwi;

    int <lower = 0> n_cd;
    array[n_cd] int impact_cd;
    array[n_cd] int basin_cd;
    vector [n_cd] area_cd;

    int <lower = 0> n_basins;
    int <lower = 0> n_datasets;

    int <lower = 0> N_icar;
    int <lower = 0> N_icar_edges;
    array [N_icar_edges] int node1;
    array [N_icar_edges] int node2;

    int <lower = 0> grainsize;
}

transformed data {
  array [n_cwi] real area_cwi_sqrt;
  array [n_cd] real area_cd_sqrt;
  
  area_cwi_sqrt = to_array_1d(sqrt(area_cwi));
  area_cd_sqrt = to_array_1d(sqrt(area_cd));
}

parameters {
    vector <lower = 0>[n_datasets-1] alpha;
    sum_to_zero_vector[n_basins] u_cwi;
    sum_to_zero_vector[n_basins] u_cp;
    cholesky_factor_corr[n_datasets-1] L;
    
    vector<lower = 0> [n_basins] shape_cwi;
    vector<lower = 0> [n_basins] shape_cd;
}

transformed parameters {
   matrix[n_datasets-1, n_basins] Theta;

   Theta = diag_pre_multiply(alpha, L) * append_col(u_cwi, u_cp)';
}

model {
    // ICAR sampling
    target += lkj_corr_cholesky_lupdf(L | 1);
    target += std_normal_lupdf(alpha);
    target += -0.5 * dot_self(u_cwi[node1] - u_cwi[node2]);
    target += -0.5 * dot_self(u_cp[node1] - u_cp[node2]);
    
    target += exponential_lupdf(shape_cwi | 5);
    target += exponential_lupdf(shape_cd | 5);
    
    target += reduce_sum(
        partial_sum_lupdf,
        area_cwi_sqrt,
        grainsize,
        basin_cwi,
        shape_cwi',
        exp(Theta[1,])
    );

    target += reduce_sum(
        partial_sum_lupdf,
        area_cd_sqrt,
        grainsize,
        basin_cd,
        shape_cd',
        exp(Theta[2,])
    );

}
