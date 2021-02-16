function [y_tes, residual, flag_val] = zef_optimize_tes_current(L_tes_projection, x_tes_projection, varargin)
opts = optimset('linprog');
opts.Display = 'off';

    if length(varargin) >= 1
        param_struct = varargin{1};
    else
        param_struct = [];
    end
    if isfield(param_struct,'active_electrodes')
        if not(isempty(param_struct.active_electrodes))
            active_electrodes = param_struct.active_electrodes;
        else
            active_electrodes = [1:size(L_tes_projection,2)]; %#ok<NBRAK>
        end
    else
            active_electrodes = [1:size(L_tes_projection,2)]; %#ok<NBRAK>
    end
    if isfield(param_struct,'positivity_constraint')
        if  not(isempty(param_struct.positivity_constraint))
            positivity_constraint = param_struct.positivity_constraint;
        end
        else
            positivity_constraint = [];
    end
    if isfield(param_struct,'negativity_constraint')
        if  not(isempty(param_struct.negativity_constraint))
            negativity_constraint = param_struct.negativity_constraint;
        end
        else
            negativity_constraint = [];
    end
    if isfield(param_struct,'max_amplitude')
        lower_bound = -(param_struct.max_amplitude);
        upper_bound =   param_struct.max_amplitude;
    else
        lower_bound = -Inf;
        upper_bound =  Inf;
    end
    if isfield(param_struct,'reg_param')
        reg_param = param_struct.reg_param;
    else
        reg_param = [];
    end
    if isfield(param_struct,'tolerance')
        opts.TolFun = param_struct.tolerance;
    end
    if isfield(param_struct,'constraint_tolerance')
        opts.TolCon = param_struct.constraint_tolerance;
    end
    if isfield(param_struct,'variable_tolerance')
        opts.TolX = param_struct.variable_tolerance;
    end
    if isfield(param_struct,'algorithm')
        opts.Algorithm = param_struct.algorithm;
    end
    if not(isempty(positivity_constraint))
        p_c_ind = sub2ind([length(positivity_constraint) size(L_tes_projection,2)],[1:length(positivity_constraint)]',positivity_constraint(:));
        p_c_aux = zeros(length(positivity_constraint),size(L_tes_projection,2));
        p_c_aux(p_c_ind) = -1;
        L_tes_projection = [L_tes_projection; p_c_aux];
        x_tes_projection = [x_tes_projection ; zeros(length(positivity_constraint),1)];
    end
    if not(isempty(negativity_constraint))
        n_c_ind = sub2ind([length(negativity_constraint) size(L_tes_projection,2)],[1:length(negativity_constraint)]',negativity_constraint(:));
        n_c_aux = zeros(length(negativity_constraint),size(L_tes_projection,2));
        n_c_aux(n_c_ind) = 1;
        L_tes_projection = [L_tes_projection; n_c_aux];
        x_tes_projection = [x_tes_projection ; zeros(length(negativity_constraint),1)];
    end    

    L_tes_projection = L_tes_projection(:,active_electrodes);
    
    %param_struct.size_L = size(L_tes_projection,1);
    %param_struct.size_ytes = size(L_tes_projection,2);

    if length(lower_bound) <= 1
        lower_bound = lower_bound*ones(size(L_tes_projection,2),1);
    end
    if length(upper_bound) <= 1
        upper_bound = upper_bound*ones(size(L_tes_projection,2),1);
    end

    if isempty(reg_param)
        [y_tes,~,flag_val] = linprog(sum(L_tes_projection)', -L_tes_projection, -x_tes_projection, ones(1,size(L_tes_projection,2)), 0, lower_bound, upper_bound, opts);
    else
        L_tes_projection = [L_tes_projection ; reg_param*ones(1,size(L_tes_projection,2))];
        x_tes_projection = [x_tes_projection; 0];
        [y_tes,~,flag_val] = linprog(sum(L_tes_projection)'+reg_param, -L_tes_projection, -x_tes_projection, ones(1,size(L_tes_projection,2)), 0, lower_bound, upper_bound, opts);
    end
    if ismember(flag_val,[1 3])
        residual = norm(L_tes_projection*y_tes-x_tes_projection,1);
    else
        residual = 0;
    end

end