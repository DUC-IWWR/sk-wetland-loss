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

    int <lower = 0> n_cwi_p;
    array[n_cwi_p] int impact_cwi_p;
    array[n_cwi_p] int basin_cwi_p;
    vector [n_cwi_p] area_cwi_p;

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
  array [n_cwi_p] real area_cwi_p_sqrt;
  
  area_cwi_sqrt = to_array_1d(sqrt(area_cwi));
  area_cd_sqrt = to_array_1d(sqrt(area_cd));
  area_cwi_p_sqrt = to_array_1d(sqrt(area_cwi_p));
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
    matrix [n_datasets, n_basins] shape;
    // ICAR sampling
    target += lkj_corr_cholesky_lupdf(L | 1);
    target += std_normal_lupdf(alpha);
    for (i in 1:n_datasets) {
        target += -0.5 * dot_self(u[node1, i] - u[node2,i]);
        target += normal_lupdf(sum(u[, i]) | 0, 0.01 * n_basins);
        
        //target += exponential_lupdf(shape[i, ] | 5);
    }
    
    shape = rep_matrix(5, n_datasets, n_basins);
    
    target += reduce_sum(
        partial_sum_lupdf,
        area_cwi_sqrt,
        grainsize,
        basin_cwi,
        shape[1,],
        exp(Theta[1,])
    );

    target += reduce_sum(
        partial_sum_lupdf,
        area_cd_sqrt,
        grainsize,
        basin_cd,
        shape[2,],
        exp(Theta[2,])
    );

    target += reduce_sum(
        partial_sum_lupdf,
        area_cwi_p_sqrt,
        grainsize,
        basin_cwi_p,
        shape[3,],
        exp(Theta[3,])
    );
}
