function [ reA, imA ] = stiffnessMat(nodes, tetra, tetraV, tensor)
%
% [ reA, imA ] = stiffnessMat(nodes, tetra, tetraV, tensor)
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
% - tensor
%
%   The conductivities of the tetrahedra. This can be a vector, if the
%   conductivity is isotrophic (σxx = σyy = σzz) and constant across a
%   tetrahedron. If conductivity is anisotrophic, then this needs to be a
%   6 × Ntetra matrix, where each column contains the conductivity components
%   σxx, σyy, σzz, σxy, σxz and σyz.
%

    arguments
        nodes  (:,3) double { mustBeFinite }
        tetra  (:,4) double { mustBeFinite, mustBePositive, mustBeInteger }
        tetraV (1,:) double { mustBeFinite, mustBePositive }
        tensor (:,:) double { mustBeFinite }
    end

    % Abbreviations of matrix sizes.

    Nn = size (nodes,1) ;

    Ntet = size (tetra,1) ;

    Nten = size (tensor,2) ;

    Ntenr = size (tensor,1) ;

    % Check size compatibility and adjust tensor size, if conductivity is
    % isotrphic across each tetrahedon.

    assert ( Ntet == Nten, "The number of conductivities needs to match the number of tetrahedra." ) ;

    if isvector (tensor)

        % Make sure input is a row vector, so broadcasting works later down the line.

        if ~ isrow (tensor)
            tensor = transpose (tensor) ;
        end

        tensor = cat ( 1, repmat (tensor,3,1), zeros (3,Ntet) ) ;

    elseif ismatrix (tensor)

        assert ( Ntenr == 6, "If given as a matrix, the input tensor needs to contain 6 rows, equal to the number of node combinations in a tetrahedron.")

    end

    % Preallocate output.

    reA = spalloc (Nn,Nn,0) ;
    imA = spalloc (Nn,Nn,0) ;

    n_of_tetra_faces = 4;

    % Start constructing the elements of 𝐴 iteratively. Summing the integrands
    % ∇ψⱼ ⋅ (𝑇∇ψᵢ) multiplied by tetraV elements d𝑉 like this corresponds to
    % integration.

    real_integrand = zeros ( 1, size ( tetra, 1 ) ) ;

    real_tensor = real ( tensor ) ;

    % If tissues have a capacitance, we also have an imaginary part in our stiffness matrix.

    tensorIsNotReal = not ( isreal ( tensor ) ) ;

    if tensorIsNotReal
        imag_integrand = zeros ( 1, size ( tetra, 1 ) ) ;
        imag_tensor = imag ( tensor ) ;
    else
        imag_integrand = [] ;
        imag_tensor = [] ;
    end

    % Start integration.

    for i = 1 : n_of_tetra_faces

        grad_1 = core.tetraVolumeGradient(nodes, tetra, i);

        for j = i : n_of_tetra_faces

            if i == j
                grad_2 = grad_1;
            else
                grad_2 = core.tetraVolumeGradient(nodes, tetra, j);
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

                % Calculate the real_integrand times a tetraV element ∇ψⱼ⋅(σ∇ψᵢ) d𝑉

                if k <= 3
                    tensor_coeff = grad_1(k_1,:) .* grad_2(k_2,:) ./ (9 * tetraV);
                else
                    tensor_coeff = ( grad_1(k_1,:) .* grad_2(k_2,:) + grad_1(k_2,:) .* grad_2(k_1,:) ) ./ (9 * tetraV);
                end

                real_integrand = real_integrand + real_tensor(k,:) .* tensor_coeff ;

                if tensorIsNotReal
                    imag_integrand = imag_integrand + imag_tensor(k,:) .* tensor_coeff ;
                end

            end

            % Construct a part of 𝐴 by mapping the indices of the tetra to the
            % real integrand.

            reA_part = sparse(tetra(:,i),tetra(:,j), real_integrand',Nn,Nn);

            % Sum the integrand to 𝐴 iteratively. A is symmetric, and hence we
            % operate differently if we are on the diagonal.

            if i == j
                reA = reA + reA_part;
            else
                reA = reA + reA_part + reA_part';
            end % if

            if tensorIsNotReal

                imA_part = sparse(tetra(:,i),tetra(:,j), imag_integrand',Nn,Nn);

                if i == j
                    imA = imA + imA_part;
                else
                    imA = imA + imA_part + imA_part';
                end % if

            end % if

        end % for

        % Reset integrand vectors for the next round.

        real_integrand ( : ) = 0 ;
        imag_integrand ( : ) = 0 ;

    end % for

end % function
