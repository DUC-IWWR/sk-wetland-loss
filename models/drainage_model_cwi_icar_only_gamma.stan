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

    int <lower = 0> n_basins;

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
    vector[n_basins] Theta;
}

model {
    // ICAR sampling
    target += -0.5 * dot_self(Theta[node1] - Theta[node2]) + normal_lupdf(sum(Theta) | 0, 0.01 * n_basins);
    target += exponential_lupdf(shape | 5);

    target += reduce_sum(
        partial_sum_lupdf,
        area_sqrt,
        grainsize,
        basin_cwi,
        shape',
        exp(Theta)'
    );
}

generated quantities {
  vector[n_basins] average_area;
  
  average_area = exp(Theta);
}
