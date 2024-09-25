function [G1, G2, G3] = tensorNodeGradient (nodes, tetra, volume, tensor, sourceElementI)
%
% [G1, G2, G3] = tensorNodeGradient (nodes, tetra, volume, tensor, sourceElementI)
%
% Calculates a gradient field [G1,G2,G3] for a given set of nodes, tetra,
% volume, volume current tensor, gradient field evaluation points.
%
% Inputs:
%
% - nodes (:,3) double
%
%   Finite element nodes.
%
% - tetra (:,4) uint32
%
%   Quadruples of node indices.
%
% - volume (1,:) double
%
%   Volumes of the tetra.
%
% - tensor (6,:) double
%
%   Some quantity σ related to tetra. This needs to be a 6 × Ntetra
%   matrix, where each column contains the quantity components σxx, σyy, σzz,
%   σxy, σxz and σyz. If conductivity is isotropic, then the columns should
%   contain the components σ, σ, σ, 0, 0, 0 for the constant coductivity σ.
%
% - sourceElementI (1,:) uint32
%
%   The indices of tetra where sources can be positioned.
%
% Outputs:
%
% - G{1,2,3}
%
%   The gradient components related to tES.
%

arguments
    nodes          (:,3) double { mustBeFinite }
    tetra          (:,4) double { mustBeInteger, mustBePositive, mustBeFinite }
    volume         (1,:) double { mustBePositive }
    tensor         (6,:) double { mustBeFinite }
    sourceElementI (1,:) uint32 { mustBePositive }
end

    disp ( newline + "Computing σ∇ψi…" + newline) ;

    Nrows = numel (sourceElementI) ;
    Ncols = size (nodes,1) ;

    Ntet = size (tetra,1) ;

    % Check tensor size.

    Nten = size (tensor,2) ;

    assert ( Ntet == Nten, "The number of conductivities needs to match the number of tetra." ) ;

    G1 = spalloc(Nrows,Ncols,0);
    G2 = spalloc(Nrows,Ncols,0);
    G3 = spalloc(Nrows,Ncols,0);

    ind_m = [ 2 3 4 ;
        3 4 1 ;
        4 1 2 ;
        1 2 3 ];

    for i = 1 : 4

        disp ("  ψ" + i) ;

        grad = cross(nodes(tetra(sourceElementI,ind_m(i,2)),:)'-nodes(tetra(sourceElementI,ind_m(i,1)),:)', nodes(tetra(sourceElementI,ind_m(i,3)),:)'-nodes(tetra(sourceElementI,ind_m(i,1)),:)')/6;
        grad = repmat(sign(dot(grad,(nodes(tetra(sourceElementI,i),:)'-nodes(tetra(sourceElementI,ind_m(i,1)),:)'))),3,1).*grad;
        grad = grad ./ volume(sourceElementI);

        entry_vec_1 = zeros(1,size(sourceElementI,1));
        entry_vec_2 = zeros(1,size(sourceElementI,1));
        entry_vec_3 = zeros(1,size(sourceElementI,1));

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
            end % switch k

            if k <= 3

                switch k_1
                    case 1
                        entry_vec_1 = entry_vec_1 + tensor(k,sourceElementI).*grad(k_2,:);
                    case 2
                        entry_vec_2 = entry_vec_2 + tensor(k,sourceElementI).*grad(k_2,:);
                    case 3
                        entry_vec_3 = entry_vec_3 + tensor(k,sourceElementI).*grad(k_2,:);
                end % switch k_1

            else

                switch k_1
                    case 1
                        entry_vec_1 = entry_vec_1 + tensor(k,sourceElementI).*grad(k_2,:);
                    case 2
                        entry_vec_2 = entry_vec_2 + tensor(k,sourceElementI).*grad(k_2,:);
                    case 3
                        entry_vec_3 = entry_vec_3 + tensor(k,sourceElementI).*grad(k_2,:);
                end % switch k_1

                switch k_2
                    case 1
                        entry_vec_1 = entry_vec_1 + tensor(k,sourceElementI).*grad(k_1,:);
                    case 2
                        entry_vec_2 = entry_vec_2 + tensor(k,sourceElementI).*grad(k_1,:);
                    case 3
                        entry_vec_3 = entry_vec_3 + tensor(k,sourceElementI).*grad(k_1,:);
                end % switch k_2

            end % if k

        end % for k

        G1 = G1 + sparse((1:Nrows)',tetra(sourceElementI,i), entry_vec_1,Nrows,Ncols);
        G2 = G2 + sparse((1:Nrows)',tetra(sourceElementI,i), entry_vec_2,Nrows,Ncols);
        G3 = G3 + sparse((1:Nrows)',tetra(sourceElementI,i), entry_vec_3,Nrows,Ncols);

    end % for i

end % function
