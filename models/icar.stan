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
    int <lower = 0> n_cwi_tr;
    array[n_cwi_tr] int impact_cwi_tr;
    array[n_cwi_tr] int basin_cwi_tr;
    
    int <lower = 0> n_cwi_te;
    array[n_cwi_te] int basin_cwi_te;

    int <lower = 0> n_basins;

    int <lower = 0> N_icar;
    int <lower = 0> N_icar_edges;
    array [N_icar_edges] int node1;
    array [N_icar_edges] int node2;

    int <lower = 0> grainsize;
}

parameters {
    sum_to_zero_vector[n_basins] Theta;
}

model {
    // ICAR sampling
    target += -0.5 * dot_self(Theta[node1] - Theta[node2]);

    target += reduce_sum(
        partial_sum_lupmf,
        impact_cwi_tr,
        grainsize,
        basin_cwi_tr,
        Theta'
    );
}

generated quantities {
  vector[n_cwi_te] score;
  score = Theta[basin_cwi_te];
}
