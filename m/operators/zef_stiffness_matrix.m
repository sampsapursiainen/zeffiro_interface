function A = zef_stiffness_matrix(nodes, tetrahedra, volume, tensor)

% The stiffness matrix 𝐴 of a discretized scalar function 𝑢ₕ = ∑ᵢ𝑧ᵢψᵢ, with
% each 𝑧ᵢ being a coordinate and ψᵢ a linear basis function, is defined by
%
%   𝐴[i,j] = ∫[Ω] ∇ψⱼ ⋅ (𝑇∇ψᵢ) d𝑉 ,
%
% where Ω is the entire domain and d𝑉 is a finite volume element from which
% the domain consists of. Here 𝑇 is a tensor, for which the equation
%
%   (𝑇∇u)⋅𝑛⃗ = 0
%
% holds with 𝑢 being the non-discretized scalar function 𝑢 on the boundary ∂Ω
% of the domain and 𝑛⃗ is an outward-pointing surface normal on ∂Ω.

% Wait bar and its progress index

wb = zef_waitbar(0,1,'Stiffness matrix.');

% Automatic closing of waitbar.

fn = @(h) close(h);

cuo = onCleanup(@() fn(wb));

wbi = 0;

N = size(nodes,1);

reA = spalloc(N,N,0);

n_of_tetra_faces = 4;

% Start constructing the elements of 𝐴 iteratively. Summing the integrands
% ∇ψⱼ ⋅ (𝑇∇ψᵢ) multiplied by volume elements d𝑉 like this corresponds to
% integration.

real_integrand = zeros ( 1, size ( tetrahedra, 1 ) ) ;

real_tensor = real ( tensor ) ;

% If tissues have a capacitance, we also have an imaginary part in our stiffness matrix.

tensorIsNotReal = not ( isreal ( tensor ) ) ;

if tensorIsNotReal
    imag_integrand = zeros ( 1, size ( tetrahedra, 1 ) ) ;
    imag_tensor = imag ( tensor ) ;
    imA = spalloc(N,N,0) ;
else
    imag_integrand = [] ;
    imag_tensor = [] ;
    imA = spalloc(0,0,0) ;
end

% Start integration.

for i = 1 : n_of_tetra_faces

    grad_1 = zef_volume_gradient(nodes, tetrahedra, i);

    for j = i : n_of_tetra_faces

        if i == j
            grad_2 = grad_1;
        else
            grad_2 = zef_volume_gradient(nodes, tetrahedra, j);
        end

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

            % Calculate the real_integrand times a volume element ∇ψⱼ⋅(σ∇ψᵢ) d𝑉

            if k <= 3
                tensor_coeff = grad_1(k_1,:) .* grad_2(k_2,:) ./ (9 * volume);
            else
                tensor_coeff = ( grad_1(k_1,:) .* grad_2(k_2,:) + grad_1(k_2,:) .* grad_2(k_1,:) ) ./ (9 * volume);
            end

            real_integrand = real_integrand + real_tensor(k,:) .* tensor_coeff ;

            if tensorIsNotReal
                imag_integrand = real_integrand + imag_tensor(k,:) .* tensor_coeff ;
            end

        end

        % Construct a part of 𝐴 by mapping the indices of the tetrahedra to the
        % real integrand.

        reA_part = sparse(tetrahedra(:,i),tetrahedra(:,j), real_integrand',N,N);

        % Sum the integrand to 𝐴 iteratively. A is symmetric, and hence we
        % operate differently if we are on the diagonal.

        if i == j
            reA = reA + reA_part;
        else
            reA = reA + reA_part + reA_part';
        end % if

        if tensorIsNotReal

            imA_part = sparse(tetrahedra(:,i),tetrahedra(:,j), imag_integrand',N,N);

            if i == j
                imA = imA + imA_part;
            else
                imA = imA + imA_part + imA_part';
            end % if

        end % if

    end % for

    wbi = wbi + 1;

    zef_waitbar(wbi , n_of_tetra_faces, wb);

    % Reset integrand vectors for the next round.

    real_integrand ( : ) = 0 ;
    imag_integrand ( : ) = 0 ;

end % for

zeromat = zeros(size(reA)) ;

if tensorIsNotReal
    A = [ reA, zeromat ; zeromat, rimA ] ;
else
    A = reA ;
end

zef_waitbar(1,1,wb);

end
