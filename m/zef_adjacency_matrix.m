function [A, I, J] = zef_adjacency_matrix(nodes, tetra)

    % Constructs a sparse square adjacency matrix or stensil A for a given set
    % of nodes and tetrahedra constructed from them. Also returns the nonzero
    % indices I and J of A.

    arguments
        nodes (:,3) double {mustBeNonNan}
        tetra (:,4) double {mustBeInteger, mustBePositive}
    end

    % Initialization.

    n_of_nodes = size(nodes,1);
    A = spalloc(n_of_nodes,n_of_nodes,0);

    % Waitbar and its cleanup object, which closes the waitbar in case of
    % termination.

    wbtitle = 'Adjacency matrix';
    wb = waitbar(0, wbtitle);

    cleanupfn = @(wb) close(wb);
    cleanupobj = onCleanup(@() cleanupfn(wb));

    % Begin iteration.

    n_of_iters = 3 + 2 + 1;

    for i = 1 : 4

        for j = i + 1 : 4

            ind = i + j - 1;
            progress_num = ind / n_of_iters;
            progress_str = [wbtitle, ': neighbours ', num2str(ind), ' / ', num2str(n_of_iters)];

            waitbar(progress_num, wb, progress_str);

            A = A + sparse(            ...
                tetra(:,i),            ...
                tetra(:,j),            ...
                ones(size(tetra,1),1), ...
                n_of_nodes,            ...
                n_of_nodes             ...
            );

        end
    end

    % Stensils are symmetric, as they describe an undirected graph.

    waitbar(0, wb, strcat(wbtitle, ': take care of symmetricity'));

    A = A + A';

    waitbar(1, wb);

    % Take care of the diagonal.

    init_progress_str = strcat(wbtitle, ': the diagonal ');
    waitbar(0, wb, progress_str);

    n_of_iters = 4;

    for i = 1 : 4

        progress_num = i / n_of_iters;
        progress_str = [init_progress_str, ' ', num2str(i), ' / ', num2str(n_of_iters)];
        waitbar(progress_num, wb, progress_str);

        A = A + sparse(            ...
            tetra(:,i),            ...
            tetra(:,i),            ...
            ones(size(tetra,1),1), ...
            n_of_nodes,            ...
            n_of_nodes             ...
        );

    end

    % Find indices and values of nonzero elements and force them into ones.

    [I,J,K] = find(A);

    K = ones(size(K));

    A = sparse(I,J,K);

end
