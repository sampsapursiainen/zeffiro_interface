function DA = eitStiffnessMatrixDerivative (nodes, tetra, tetraV, tensor, activeI)
%
% DA = eitStiffnessMatrixDerivative (nodes, tetra, tetraV, tensor, activeI)
%
% Computes the stiffness matrix A of a given finite element system. If the
% given tensor is complex, computes the real and imaginary parts reA and imA of
% the stiffness matrix separately. If tensor is real, imA will be empty.
%
% Inputs:
%
% - nodes
%
%   The finite element nodes of the system.
%
% - tetra
%
%   The tetrahedra related to the finite element system.
%
% - tetraV
%
%   The volumes of the tetrahedra.
%
% - tensor (6,Ntetra) double
%
%   The conductivities of the tetrahedra. This needs to be a 6 × Ntetra matrix,
%   where each column contains the conductivity components σxx, σyy, σzz, σxy,
%   σxz and σyz. If conductivity is isotropic, then the columns should contain
%   the components σ, σ, σ, 0, 0, 0 for the constant coductivity σ.
%
% - activeI
%
%   The indices of the tetra that can contain tensor-related activity.
%

    arguments
        nodes  (:,3) double { mustBeFinite }
        tetra  (:,4) double { mustBeFinite, mustBePositive, mustBeInteger }
        tetraV (1,:) double { mustBeFinite, mustBePositive }
        tensor (6,:) double { mustBeFinite }
        activeI (1,:) double { mustBeInteger, mustBePositive, mustBeFinite }
    end

    disp (newline + "Computing ∂A/∂s…" + newline) ;

    % Abbreviations of matrix sizes.

    Ntet = size (tetra,1) ;

    % Check tensor size.

    Nten = size (tensor,2) ;

    assert ( Ntet == Nten, "The number of conductivities needs to match the number of tetrahedra." ) ;

    tetraFaceN = 4;

    activeN = numel (activeI) ;

    DA = zeros (activeN, 10) ;

    colI = 0 ;

    DAentry = zeros (1,Ntet) ;

    for i = 1 : tetraFaceN

        grad1 = zefCore.tetraVolumeGradient(nodes, tetra, i);

        for j = i : tetraFaceN

            colI = colI + 1 ;

            disp ("  ψ" + i + ", ψ" + j) ;

            if i == j
                grad2 = grad1;
            else
                grad2 = zefCore.tetraVolumeGradient(nodes, tetra, j);
            end

            % Go over the conductivity combinations in a possibly anisotrophic system.

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

                DAentry = DAentry + grad1 (k_1,:) .* grad2 (k_2,:) ./ tetraV / 9 ;

            end % for k

            DA (:, colI) = DA (:, colI) + transpose ( DAentry (activeI) ) ;

            % Reset integrand vectors for the next round.

            DAentry (:) = 0 ;

        end % for j

    end % for i

end % function
