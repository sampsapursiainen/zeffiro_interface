function [stensil, signs, source_moments, source_directions, source_locations, n_of_adj_tetra] = zef_fi_dipoles( ...
    nodes      ...
,              ...
    tetrahedra ...
,              ...
    brain_ind  ...
)

% zef_fi_dipoles: generates the vectors related to face intersecting dipoles
% in the tetrahedral mesh: locations, directions and dipole moments. Also
% returns the adjacent tetrahedra pairs that form the dipoles.


    wb = waitbar(0,'Face intersecting dipoles.');

    % Matrix sizes

    N = size(nodes, 1);
    K = length(brain_ind);
    K2 = size(tetrahedra, 1);

    % An auxiliary matrix for picking up the correct nodes from tetrahedra

    ind_m = [
        2 3 4 ;
        3 4 1 ;
        4 1 2 ;
        1 2 3
    ];

    % Find nodes that share a face

    Ind_cell = cell(1,3);

    for i = 1 : 4

        % Find the global node indices for each tetrahedra that correspond to
        % indices ind_m(i,:) and set them to increasing order

        adjacent_tetra_1 = sort(tetrahedra(brain_ind, ind_m(i,:)), 2);

        for j = i + 1 : 4

            % The same for indices ind_m(j,:)

            adjacent_tetra_2 = sort(tetrahedra(brain_ind, ind_m(j,:)), 2);

            % Set both matrices in one variable, including element index and
            % which node it corresponds to

            adjacent_tetra = sortrows([                     ...
                adjacent_tetra_1 brain_ind(:) i*ones(K,1) ; ...
                adjacent_tetra_2 brain_ind(:) j*ones(K,1)   ...
            ]);

            % Find the rows that have the same node indices, i.e. share a face

            I = find(                               ...
                0 == sum(                           ...
                    abs(                            ...
                        adjacent_tetra(1:end-1,1:3) ...
                        -                           ...
                        adjacent_tetra(2:end,1:3)   ...
                    )                               ...
                ,                                   ...
                    2                               ...
                )                                   ...
            );

            % TODO: make this better

            Ind_cell{i}{j} = [
                adjacent_tetra(I,4) adjacent_tetra(I+1,4)  adjacent_tetra(I,5) adjacent_tetra(I+1,5)
            ];

        end
    end

    % Set the node indices and element indices in one matrix

    adjacent_tetra = [
        Ind_cell{1}{2} ; Ind_cell{1}{3} ; Ind_cell{1}{4} ; ...
        Ind_cell{2}{3} ; Ind_cell{2}{4} ;                  ...
        Ind_cell{3}{4}
    ];

    % Drop the double and triple rows

    [adjacent_tetra_2, I] = unique(adjacent_tetra(:,1:2),'rows');
    adjacent_tetra = adjacent_tetra(I,:);

    % Check that all of the elements were from a brain layer

    adjacent_tetra = adjacent_tetra(find(sum(ismember(adjacent_tetra(:,1:2),brain_ind),2)),:);

    % Set node pairs that share a face

    tetrahedra_aux_ind_1 = sub2ind([K2 4], adjacent_tetra(:,1), adjacent_tetra(:,3));
    nodes_aux_vec_1 = nodes(tetrahedra(tetrahedra_aux_ind_1),:);
    tetrahedra_aux_ind_2 = sub2ind([K2 4], adjacent_tetra(:,2), adjacent_tetra(:,4));
    nodes_aux_vec_2 = nodes(tetrahedra(tetrahedra_aux_ind_2),:);

    % FI source locations, moments and directions

    source_directions = (nodes_aux_vec_2 - nodes_aux_vec_1);
    source_moments = sqrt(sum(source_directions.^2,2));
    source_directions = source_directions./repmat(sqrt(sum(source_directions.^2,2)),1,3);
    source_locations = (1/2)*(nodes_aux_vec_1 + nodes_aux_vec_2);

    % Dipole sign matrix

    n_of_adj_tetra = size(adjacent_tetra,1);

    signs = sparse(                                                                      ...
        [tetrahedra(tetrahedra_aux_ind_1) ; tetrahedra(tetrahedra_aux_ind_2)]            ...
    ,                                                                                    ...
        repmat([1:n_of_adj_tetra]', 2, 1),[1./source_moments(:) ; -1./source_moments(:)] ...
    ,                                                                                    ...
        N                                                                                ...
    ,                                                                                    ...
        n_of_adj_tetra                                                                   ...
    );

    % Dipole arrangement stensil

    stensil = sparse(                                   ...
        repmat(                                         ...
            [1:n_of_adj_tetra]', 2, 1)                  ...
        ,                                               ...
            [adjacent_tetra(:,1) ; adjacent_tetra(:,2)] ...
        ,                                               ...
            ones(2*n_of_adj_tetra, 1)                   ...
    ,                                                   ...
        n_of_adj_tetra                                  ...
    ,                                                   ...
        K2                                              ...
    );

    waitbar(1, wb); close(wb);

end
