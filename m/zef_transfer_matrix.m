function [T, Schur_complement, A] = zef_transfer_matrix( ...
    A                                                    ...
,                                                        ...
    B                                                    ...
,                                                        ...
    C                                                    ...
,                                                        ...
    n_of_fem_nodes                                       ...
,                                                        ...
    n_of_electrodes                                      ...
,                                                        ...
    electrode_model                                      ...
,                                                        ...
    permutation                                          ...
,                                                        ...
    precond                                              ...
,                                                        ...
    impedance_vec                                        ...
,                                                        ...
    impedance_inf                                        ...
,                                                        ...
    tol_val                                              ...
,                                                        ...
    m_max                                                ...
)

% zef_transfer_matrix: builds a transfer matrix T and an auxiliary matrix
% Schur_complement from a given stiffness matrix A, matrices B and C, sizes
% n_of_fem_nodes and n_of_electrodes, a permutation matrix and a precoditioner,
% through preconditioned conjugate gradient (PCG) iteration.

    if isequal(permutation,'symamd')
        perm_vec = symamd(A)';
    elseif isequal(permutation,'symmmd')
        perm_vec = symmmd(A)';
    elseif isequal(permutation,'symrcm')
        perm_vec = symrcm(A)';
    else
        perm_vec = [1:n_of_fem_nodes]';
    end

    iperm_vec = sortrows([ perm_vec [1:n_of_fem_nodes]' ]);
    iperm_vec = iperm_vec(:,2);

    A_aux = A(perm_vec,perm_vec);
    A = A_aux;

    wbtitle = 'Stensil PCG iteration';
    wb = waitbar(0, wbtitle);

    % Initialize transfer matrix T and Schur_complement

    T = zeros(size(B,1), n_of_electrodes);
    Schur_complement = zeros(n_of_electrodes);

    % GPU START

    if evalin('base','zef.use_gpu') == 1 && gpuDeviceCount > 0

        precond_vec = gpuArray(1./full(diag(A)));
        A = gpuArray(A);

        tol_val_eff = tol_val;
        relres_vec = gpuArray(zeros(1, n_of_electrodes));

        tic;

        for i = 1 : n_of_electrodes

            b = full(B(:,i));

            if isequal(electrode_model,'PEM') & impedance_inf == 1 & i==1
                b = zeros(size(b));
            end

            tol_val = min(impedance_vec(i),1)*tol_val_eff;

            x = zeros(n_of_fem_nodes,1);
            norm_b = norm(b);
            r = b(perm_vec);
            p = gpuArray(r);
            m = 0;
            x = gpuArray(x);
            r = gpuArray(r);
            p = gpuArray(p);
            norm_b = gpuArray(norm_b);

            % Optimization loop: iterate until a point close to minimum is
            % found, or number of max iterations are exceeded.

            while( (norm(r)/norm_b > tol_val) && (m < m_max) )
                a = A * p;
                a_dot_p = sum(a.*p);
                aux_val = sum(r.*p);
                lambda = aux_val ./ a_dot_p;
                x = x + lambda * p;
                r = r - lambda * a;
                inv_M_r = precond_vec .* r;
                aux_val = sum(inv_M_r .* a);
                gamma = aux_val ./ a_dot_p;
                p = inv_M_r - gamma * p;
                m = m+1;
            end

            relres_vec(i) = gather(norm(r)/norm_b);
            r = gather(x(iperm_vec));
            x = r;

            T(:,i) = x;

            if impedance_inf == 0
                Schur_complement(:,i) = C(:,i) - B'*x ;
            else
                Schur_complement(:,i) = C(:,i);
            end

            if tol_val < relres_vec(i)
                close(wb);
                'Error: PCG iteration did not converge.'
                T = [];
                return
            end

            time_val = toc;

            waitbar(                                                                                   ...
                i/n_of_electrodes                                                                      ...
            ,                                                                                          ...
                wb                                                                                     ...
            ,                                                                                          ...
                [wbtitle '. Ready: ' datestr(datevec(now+(n_of_electrodes/i - 1)*time_val/86400)) '.'] ...
            );

        end

    else % Use CPU instead of GPU

        % Define preconditioner

        if isequal(precond,'ssor');
            S1 = tril(A)*spdiags(1./sqrt(diag(A)),0,n_of_fem_nodes,n_of_fem_nodes);
            S2 = S1';
        else
            S2 = ichol(A,struct('type','nofill'));
            S1 = S2';
        end

        tol_val_eff = tol_val;

        % Define block size

        delete(gcp('nocreate'))
        parallel_processes = evalin('base','zef.parallel_processes');
        parpool(parallel_processes);
        processes_per_core = evalin('base','zef.processes_per_core');
        tic;
        block_size =  parallel_processes*processes_per_core;

        for i = 1 : block_size : n_of_electrodes

            block_ind = [i : min(n_of_electrodes,i+block_size-1)];

            %Define right hand side

            b = full(B(:,block_ind));
            tol_val = min(impedance_vec(block_ind),1)*tol_val_eff;

            if isequal(electrode_model,'PEM') & impedance_inf == 1 & i==1
                b = zeros(size(b));
            end

            %Iterate

            x_block_cell = cell(0);
            relres_cell = cell(0);
            relres_vec = zeros(1,length(block_ind));
            tol_val = tol_val(:)';
            norm_b = sqrt(sum(b.^2));
            block_iter_end = block_ind(end)-block_ind(1)+1;
            [block_iter_ind] = [1 : processes_per_core : block_iter_end];

            parfor block_iter = 1 : length(block_iter_ind)

                block_iter_sub = [block_iter_ind(block_iter) : min(block_iter_end,block_iter_ind(block_iter)+processes_per_core-1)];
                x = zeros(n_of_fem_nodes, length(block_iter_sub));
                r = b(perm_vec, block_iter_sub);
                aux_vec = S1 \ r;
                p = S2 \ aux_vec;
                m = 0;

                while( not(isempty(find(sqrt(sum(r.^2))./norm_b(block_iter_sub) > tol_val(block_iter_sub)))) & (m < m_max) )
                    a = A * p;
                    a_dot_p = sum(a.*p);
                    aux_val = sum(r.*p);
                    lambda = aux_val ./ a_dot_p;
                    x = x + lambda .* p;
                    r = r - lambda .* a;
                    aux_vec = S1\r;
                    inv_M_r = S2\aux_vec;
                    aux_val = sum(inv_M_r.*a);
                    gamma = aux_val ./ a_dot_p;
                    p = inv_M_r - gamma .* p;
                    m=m+1;
                end

                x_block_cell{block_iter} = x(iperm_vec,:);
                relres_cell{block_iter} = sqrt(sum(r.^2))./norm_b(block_iter_sub);

            end

            for block_iter = 1 : length(block_iter_ind)
                block_iter_sub = [block_iter_ind(block_iter) : min(block_iter_end,block_iter_ind(block_iter)+processes_per_core-1)];
                T(:,block_iter_sub) = x_block_cell{block_iter};
                relres_vec(block_iter_sub) = relres_cell{block_iter};
            end

            % Construct stensil T column by column.

            if impedance_inf == 0
                Schur_complement(:,block_ind) = C(:,block_ind) - B' * x_block;
            else
                Schur_complement(:,block_ind) = C(:,block_ind);
            end

            if not(isempty(find(tol_val < relres_vec)))
                close(wb);
                warning('Error: PCG iteration did not converge. Returning empty transfer matrix...')
                T = [];
                return
            end

            time_val = toc;

            waitbar(                                                                                                ...
                (i+length(block_ind)-1) / n_of_electrodes                                                           ...
            ,                                                                                                       ...
                wb                                                                                                  ...
            ,                                                                                                       ...
                [wbtitle '. Ready: ' datestr(datevec(now+(n_of_electrodes/(i+length(block_ind)-1) - 1)*time_val/86400)) '.'] ...
            );

        end
    end

    waitbar(1,wb);
    close(wb);

end
