function [G1, G2, G3] = zef_tetra_gradient_field(nodes, tetrahedra, tensor, eval_point_inds, K, N)

% Calculates a gradient field [G1,G2,G3] for a given set of nodes, tetrahedra,
% volume current tensor, gradient field evaluation points and matrix size K
% and N.

    Grad_1 = spalloc(K,N,0);
    Grad_2 = spalloc(K,N,0);
    Grad_3 = spalloc(K,N,0);

    ind_m = [ 2 3 4 ;
              3 4 1 ;
              4 1 2 ;
              1 2 3 ];

     for i = 1 : 4

        grad = cross(nodes(tetrahedra(eval_point_inds,ind_m(i,2)),:)'-nodes(tetrahedra(eval_point_inds,ind_m(i,1)),:)', nodes(tetrahedra(eval_point_inds,ind_m(i,3)),:)'-nodes(tetrahedra(eval_point_inds,ind_m(i,1)),:)')/6;
        grad = repmat(sign(dot(grad,(nodes(tetrahedra(eval_point_inds,i),:)'-nodes(tetrahedra(eval_point_inds,ind_m(i,1)),:)'))),3,1).*grad;
        grad = grad ./ tilavuus(eval_point_inds);

        entry_vec_1 = zeros(1,size(eval_point_inds,1));
        entry_vec_2 = zeros(1,size(eval_point_inds,1));
        entry_vec_3 = zeros(1,size(eval_point_inds,1));
        for k = 1 : 6
            switch k
                case 1
                    k_1 = 1;
                    k_2 = 1;
                case 2
                    k_1 = 2;
                    k_2 = 2;
                case 3
                    k_1 = 3;
                    k_2 = 3;
                case 4
                    k_1 = 1;
                    k_2 = 2;
                case 5
                    k_1 = 1;
                    k_2 = 3;
                case 6
                    k_1 = 2;
                    k_2 = 3;
            end
            if k <= 3
                switch k_1
                    case 1
                        entry_vec_1 = entry_vec_1 + tensor(k,eval_point_inds).*grad(k_2,:);
                    case 2
                        entry_vec_2 = entry_vec_2 + tensor(k,eval_point_inds).*grad(k_2,:);
                    case 3
                        entry_vec_3 = entry_vec_3 + tensor(k,eval_point_inds).*grad(k_2,:);
                end
            else
                switch k_1
                    case 1
                        entry_vec_1 = entry_vec_1 + tensor(k,eval_point_inds).*grad(k_2,:);
                    case 2
                        entry_vec_2 = entry_vec_2 + tensor(k,eval_point_inds).*grad(k_2,:);
                    case 3
                        entry_vec_3 = entry_vec_3 + tensor(k,eval_point_inds).*grad(k_2,:);
                end
                switch k_2
                    case 1
                        entry_vec_1 = entry_vec_1 + tensor(k,eval_point_inds).*grad(k_1,:);
                    case 2
                        entry_vec_2 = entry_vec_2 + tensor(k,eval_point_inds).*grad(k_1,:);
                    case 3
                        entry_vec_3 = entry_vec_3 + tensor(k,eval_point_inds).*grad(k_1,:);
                end
            end
        end
        Grad_1 = Grad_1 + sparse([1:K]',tetrahedra(eval_point_inds,i), entry_vec_1,K,N);
        Grad_2 = Grad_2 + sparse([1:K]',tetrahedra(eval_point_inds,i), entry_vec_2,K,N);
        Grad_3 = Grad_3 + sparse([1:K]',tetrahedra(eval_point_inds,i), entry_vec_3,K,N);
    end
end
