function [A, B, C] = zef_build_electrodes(nodes, electrode_model, impedance_vec, impedance_inf, ele_ind, A)

% zef_build_elecrodes: constructs the matrices B and C [*] from given nodes,
% impedances, a stiffness matrix A and electrode indices. Notice that the
% stiffness matrix A is also returned from the function, to avoid the
% copy-on-write behaviour of Matlab functions due to assignment in place [†].
% In other words, the function needs to be called with
%
%     [A, B, C] = zef_build_elecrodes(A, ele_ind, n_of_nodes, n_of_electrodes);
%
% to possibly prevent the copying of the stiffness matrix A.
%
% [*]: https://iopscience.iop.org/article/10.1088/0031-9155/57/4/999/meta#pmb407475app1
%
% [†]: MathWorks, Avoid unnecessary copies of data,
% URL: https://se.mathworks.com/help/matlab/matlab_prog/avoid-unnecessary-copies-of-data.html

    % Wait bar and its progress index

    funtitle = 'Electrode matrices';

    wb = zef_waitbar(0,funtitle);
    wbi = 0;

    % Cleanup operations

    cleanup_fn = @(h) close(h);
    cleanup_obj = onCleanup(@() cleanup_fn(wb));

    % Consider the PEM case

    if impedance_inf
        impedance_vec = ones(size(impedance_vec));
    end

    % Preallocate electrode matrices

    n_of_nodes = size(nodes, 1);
    n_of_electrodes = size(impedance_vec, 1);

    B = spalloc(n_of_nodes,n_of_electrodes,0);
    C = spalloc(n_of_electrodes,n_of_electrodes,0);

    % Choose electrode model

    cemtitle = strcat(funtitle, ' (CEM)');
    pemtitle = strcat(funtitle, ' (PEM)');

    if isequal(electrode_model, 'CEM')

        zef_waitbar(0, wb, strcat(cemtitle, ': current triangles'));

        I_triangles = find(ele_ind(:,4)>0);
        ala = zeros(1,size(ele_ind,1));

        ala(I_triangles) = 1/2 * sqrt(               ...
            sum(                                     ...
                cross(                               ...
                    nodes(ele_ind(I_triangles,3),:)' ...
                    -                                ...
                    nodes(ele_ind(I_triangles,2),:)' ...
                ,                                    ...
                    nodes(ele_ind(I_triangles,4),:)' ...
                    -                                ...
                    nodes(ele_ind(I_triangles,2),:)' ...
                ).^2                                 ...
            )                                        ...
        );

        zef_waitbar(1, wb);
        zef_waitbar(0,wb, strcat(cemtitle, ': initial B and C'));

        for ele_loop_ind = 1 : n_of_electrodes

            I = find(ele_ind(:,1) == ele_loop_ind);
            sum_ala = sum(ala(I));

            if sum_ala > 0

                impedance_vec(ele_loop_ind) = impedance_vec(ele_loop_ind) * sum_ala;

            else

                for i = 1 : length(I)

                    B(ele_ind(I(i),2), ele_ind(I(i),1)) ...
                    =                                   ...
                    B(ele_ind(I(i),2), ele_ind(I(i),1)) ...
                    +                                   ...
                    ele_ind(I(i),3)                     ...
                    ./                                  ...
                    impedance_vec(ele_loop_ind);

                    for j = 1 : length(I)

                        % TODO: Check if this indexing into A induces the
                        % copy-on-write behaviour of Matlab. If this was just
                        % A = something, there would not be an issue, as A is
                        % returned from the function.

                        A(ele_ind(I(i),2),ele_ind(I(j),2)) ...
                        =                                  ...
                        A(ele_ind(I(i),2),ele_ind(I(j),2)) ...
                        +                                  ...
                        ele_ind(I(i),3)                    ...
                        *                                  ...
                        ele_ind(I(j),3)                    ...
                        ./                                 ...
                        impedance_vec(ele_loop_ind);

                    end
                end

                C(ele_loop_ind, ele_loop_ind) = 1 ./ impedance_vec(ele_loop_ind);

            end

            wbi = wbi + 1;
            zef_waitbar(wbi / n_of_electrodes, wb);

        end

        wbi = 0;

        zef_waitbar(wbi, wb, strcat(cemtitle, ': updating B at active electrodes'));

        entry_vec = (1./impedance_vec(ele_ind(I_triangles,1))) .* ala(I_triangles)';

        for i = 1 : 3

            B = B + sparse(              ...
                ele_ind(I_triangles,i+1) ...
            ,                            ...
                ele_ind(I_triangles,1)   ...
            ,                            ...
                (1/3) * entry_vec        ...
            ,                            ...
                n_of_nodes               ...
            ,                            ...
                n_of_electrodes          ...
            );

            zef_waitbar(wbi / 3, wb);

        end

        wbi = 0;

        if impedance_inf == 0

            zef_waitbar(wbi, wb, strcat(cemtitle, ': modifying stiffness matrix at active electrodes'));

            for i = 1 : 3

                for j = i : 3

                    if i == j

                        A_part = sparse(                ...
                            ele_ind(I_triangles,i+1)    ...
                        ,                               ...
                            ele_ind(I_triangles,j+1)    ...
                        ,                               ...
                            (1/6) * entry_vec           ...
                        ,                               ...
                            n_of_nodes                  ...
                        ,                               ...
                            n_of_nodes                  ...
                        );

                        A = A + A_part;

                    else

                        A_part = sparse(                ...
                            ele_ind(I_triangles,i+1)    ...
                        ,                               ...
                            ele_ind(I_triangles,j+1)    ...
                        ,                               ...
                            (1/12) * entry_vec          ...
                        ,                               ...
                            n_of_nodes                  ...
                        ,                               ...
                            n_of_nodes                  ...
                        );

                        A = A + A_part + A_part';

                    end
                end

                wbi = wbi + 1;
                zef_waitbar(wbi / 3, wb);

            end

        else

            'Cannot use infinite impedance for stimulation'
            return

        end

        wbi = 0;
        zef_waitbar(wbi, wb, strcat(cemtitle, ': updating C at active electrodes.'));

        % Update triangle patches

        C = C + sparse(            ...
            ele_ind(I_triangles,1) ...
        ,                          ...
            ele_ind(I_triangles,1) ...
        ,                          ...
            entry_vec              ...
        ,                          ...
            n_of_electrodes        ...
        ,                          ...
            n_of_electrodes        ...
        );

        zef_waitbar(1,wb);

    elseif isequal(electrode_model, 'PEM')

        zef_waitbar(0, wb, pemtitle);

        if impedance_inf == 0

            entry_vec = (1./impedance_vec(ele_ind(:,1)));

            for i = 1 : n_of_electrodes
                B(ele_ind(i),i) = entry_vec;
                A(ele_ind(i),ele_ind(i)) = A(ele_ind(i),ele_ind(i)) + entry_vec;
            end

            C = sparse(ele_ind(:,1), ele_ind(:,1), entry_vec, n_of_electrodes, n_of_electrodes);

        else

            for i = 1 : n_of_electrodes
                B(ele_ind(i),i) = 1;
            end

            % Dirichlet boundary condition for a single node.

            A(ele_ind(1),:) = 0;
            A(:,ele_ind(1)) = 0;
            A(ele_ind(1),ele_ind(1)) = 1;

            C = eye(n_of_electrodes);

        end

        zef_waitbar(1, wb);

    else

        warning('Unrecognised electrode model in zef_build_electrodes. Returning empty electrode matrices B and C...')

        B = [];
        C = [];
        return

    end

    zef_waitbar(1,wb);

end
