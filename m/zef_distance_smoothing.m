function [nodes] = zef_distance_smoothing(tetra, nodes, distance_vec, smoothing_exponent, smoothing_strength, smoothing_steps_dist) 

N = size(nodes,1);
B = sparse(N,N,0);
distance_smoothing = exp(-smoothing_exponent*mean(distance_vec(tetra),2));

     for i = 1 : 4
                for j = i+1 : 4
                    B_part = sparse(tetra(:,i),tetra(:,j),distance_smoothing,N,N);
                    if i == j
                        B = B + B_part;
                    else
                        B = B + B_part ;
                        B = B + B_part';
                    end
                end

     end

     sum_B = sum(B,2);

     taubin_lambda = 1;
     taubin_mu = -1;

    convergence_criterion = Inf; 
    while convergence_criterion > smoothing_steps_dist
                nodes_aux = B*nodes;
                nodes_aux = nodes_aux./sum_B;
                nodes_aux_1 = nodes_aux - nodes;
                nodes =  nodes + taubin_lambda*smoothing_strength*nodes_aux_1;
                nodes_aux = B*nodes;
                nodes_aux = nodes_aux./sum_B;
                nodes_aux_2 = nodes_aux - nodes;
                nodes = nodes + taubin_mu*smoothing_strength*nodes_aux_2;
 convergence_criterion = norm(nodes_aux_2-nodes_aux_1,'fro')/norm(nodes_aux_1);
end
end