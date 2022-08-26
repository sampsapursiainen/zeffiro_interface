function self = inflate_surface(self)

    % inflate_surface
    %
    % Post-processes a given finite element mesh.

    arguments
        self app.Zef
    end

    N = size(self.nodes,1);

    smoothing_steps_surf = self.data.inflate_n_iterations;

    smoothing_param = self.data.inflate_strength;

    A = sparse(N, N, 0);

    for i = 1 : 3

        for j = i+1 : 3

            A_part = sparse(surface_triangles(:,i),surface_triangles(:,j),double(ones(size(surface_triangles,1),1)),N,N);

            if i == j

                A = A + A_part;

            else

                A = A + A_part ;
                A = A + A_part';

            end
        end
    end

    A = spones(A);

    sum_A = full(sum(A))';

    sum_A = sum_A(:,[1 1 1]);

    taubin_lambda = 1;

    taubin_mu = -1;

    if self.data.use_gpu && self.data.gpu_count > 0

        A = gpuArray(A);

        sum_A = gpuArray(sum_A);

        taubin_lambda = gpuArray(taubin_lambda);

        smoothing_param = gpuArray(smoothing_param);

        self.nodes = gpuArray(self.nodes);

    end

    for iter_ind_aux_1 = 1 : smoothing_steps_surf

        nodes_aux = A * self.nodes;

        nodes_aux = nodes_aux./sum_A;

        nodes_aux = nodes_aux - self.nodes;

        self.nodes =  self.nodes + taubin_lambda * smoothing_param * nodes_aux;

        nodes_aux = A * self.nodes;

        nodes_aux = nodes_aux ./ sum_A;

        nodes_aux = nodes_aux - self.nodes;

        self.nodes =  self.nodes + taubin_mu * smoothing_param * nodes_aux;

    end

    self.nodes = gather(nodes);

end
