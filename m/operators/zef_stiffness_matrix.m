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

    wb = zef_waitbar(0,'Stiffness matrix.');

    % Automatic closing of waitbar.

    fn = @(h) close(h);

    cuo = onCleanup(@() fn(wb));

    wbi = 0;

    N = size(nodes,1);

    A = spalloc(N,N,0);

    n_of_tetra_faces = 4;

    % Start constructing the elements of 𝐴 iteratively. Summing the integrands
    % ∇ψⱼ ⋅ (𝑇∇ψᵢ) multiplied by volume elements d𝑉 like this corresponds to
    % integration.

    for i = 1 : n_of_tetra_faces

        grad_1 = zef_volume_gradient(nodes, tetrahedra, i);

        for j = i : n_of_tetra_faces

            if i == j
                grad_2 = grad_1;
            else
                grad_2 = zef_volume_gradient(nodes, tetrahedra, j);
            end

            % Preallocate integrand vector

            entry_vec = zeros(1,size(tetrahedra,1));

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

                % Calculate the integrand times a volume element ∇ψⱼ⋅(σ∇ψᵢ) d𝑉

                if k <= 3
                    entry_vec =         ...
                        entry_vec       ...
                        +               ...
                        tensor(k,:)     ...
                        .*              ...
                        grad_1(k_1,:)   ...
                        .*              ...
                        grad_2(k_2,:)   ...
                        ./              ...
                        (9 * volume);
                else
                    entry_vec =             ...
                        entry_vec           ...
                        +                   ...
                        tensor(k,:)         ...
                        .*                  ...
                        (                   ...
                            grad_1(k_1,:)   ...
                            .*              ...
                            grad_2(k_2,:)   ...
                            +               ...
                            grad_1(k_2,:)   ...
                            .*              ...
                            grad_2(k_1,:)   ...
                        )                   ...
                        ./                  ...
                        (9 * volume);
                end
            end

            % Construct a part of 𝐴 by mapping the indices of the tetrahedra to
            % the integrand (a sparse matrix is a hash table).

            A_part = sparse(tetrahedra(:,i),tetrahedra(:,j), entry_vec',N,N);

            % Sum the integrand to 𝐴 iteratively. This corresponds to integration.

            if i == j

                % On the diagonal, no need to do anthing special

                A = A + A_part;

            else

                % Stiffness matrices are symmetric, so what is added to the
                % lower triangle must be added to the upper one. Hence the
                % added transpose.

                A = A + A_part + A_part';

            end
        end

        wbi = wbi + 1;
        zef_waitbar(wbi / n_of_tetra_faces, wb);

    end

    zef_waitbar(1,wb);

end
