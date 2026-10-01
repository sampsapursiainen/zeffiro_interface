%ZEF_ES_INIT_PARAMETER_TABLE  Fill h_ES_parameter_table from current ES_alpha, epsilon, current caps.
%
%   Zeffiro Interface.
%   Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%   See: https://github.com/sampsapursiainen/zeffiro_interface
%   Licensed under the GNU General Public License v3.0 (see LICENSE).
%
%   Script (local function assign_common_parameters). Called from the
%   window constructor and from zef_ES_optimization_update. Restricts
%   method/algorithm dropdown Items by ES_opt_solver (1 Matlab … 5 Gurobi),
%   then fills α/ε (dB), current caps, lattice size, tolerances. Solver 1
%   with method 4 (backpropagation) uses a 6-row table.
%
%   See also zef_ES_update_parameter_values.
%

zef.h_ES_parameter_table.Data = cell(0);

if ismember(zef.ES_opt_solver, 1)

    local_set_dropdown(zef.h_ES_opt_method, zef.ES_opt_method_list([1 3 4]), [1 3 4]);
    local_set_dropdown(zef.h_ES_opt_algorithm, zef.ES_opt_algorithm_list([2 3]), [2 3]);

    if not(isequal(zef.ES_opt_method, 4))
        zef = assign_common_parameters(zef);
        zef.h_ES_parameter_table.Data{18,1} = 'Step tolerance';
        zef.h_ES_parameter_table.Data{18,2} = num2str(zef.ES_step_tolerance);
        zef.h_ES_parameter_table.Data{19,1} = 'Constraint tolerance';
        zef.h_ES_parameter_table.Data{19,2} = num2str(zef.ES_constraint_tolerance);

    else
        zef.h_ES_parameter_table.Data{1,1} = 'Total current in montage';
        zef.h_ES_parameter_table.Data{1,2} = num2str(zef.ES_total_max_current);
        zef.h_ES_parameter_table.Data{2,1} = 'Max current allowed per electrode';
        zef.h_ES_parameter_table.Data{2,2} = num2str(zef.ES_max_current_channel);
        zef.h_ES_parameter_table.Data{3,1} = 'Threshold for non-zero currents';
        zef.h_ES_parameter_table.Data{3,2} = num2str(zef.ES_relative_weight_nnz);
        zef.h_ES_parameter_table.Data{4,1} = 'Maximum non-zero currents';
        zef.h_ES_parameter_table.Data{4,2} = num2str(zef.ES_score_dose);
        zef.h_ES_parameter_table.Data{5,1} = 'Boundary color limit';
        zef.h_ES_parameter_table.Data{5,2} = num2str(zef.ES_boundary_color_limit);
        zef.h_ES_parameter_table.Data{6,1} = 'ROI radius (mm)';
        zef.h_ES_parameter_table.Data{6,2} = num2str(zef.ES_roi_range);
    end

end

if ismember(zef.ES_opt_solver, 2)
    local_set_dropdown(zef.h_ES_opt_method, zef.ES_opt_method_list([1 2]), [1 2]);
    local_set_dropdown(zef.h_ES_opt_algorithm, zef.ES_opt_algorithm_list(1), 1);

    zef = assign_common_parameters(zef);
end

if ismember(zef.ES_opt_solver, 3)
    local_set_dropdown(zef.h_ES_opt_method, zef.ES_opt_method_list([1 2]), [1 2]);
    local_set_dropdown(zef.h_ES_opt_algorithm, zef.ES_opt_algorithm_list(1), 1);

    zef = assign_common_parameters(zef);
end

if ismember(zef.ES_opt_solver, 4)
    local_set_dropdown(zef.h_ES_opt_method, zef.ES_opt_method_list(1), 1);
    local_set_dropdown(zef.h_ES_opt_algorithm, zef.ES_opt_algorithm_list([1 3 4]), [1 3 4]);

    zef = assign_common_parameters(zef);
end

if ismember(zef.ES_opt_solver, 5)

    local_set_dropdown(zef.h_ES_opt_method, zef.ES_opt_method_list(1), 1);
    local_set_dropdown(zef.h_ES_opt_algorithm, zef.ES_opt_algorithm_list([1 3 4]), [1 3 4]);

    zef = assign_common_parameters(zef);
end

function zef = assign_common_parameters(zef)
%ASSIGN_COMMON_PARAMETERS  Rows 1–17 of the parameter table (α/ε, caps, lattice).
zef.h_ES_parameter_table.Data{1,1} = 'Alpha minimum (dB)';
zef.h_ES_parameter_table.Data{1,2} = num2str(db(zef.ES_alpha));
zef.h_ES_parameter_table.Data{2,1} = 'Alpha maximum (dB)';
zef.h_ES_parameter_table.Data{2,2} = num2str(db(zef.ES_alpha_max));
zef.h_ES_parameter_table.Data{3,1} = 'Nuisance field weight minimum (dB)';
zef.h_ES_parameter_table.Data{3,2} = num2str(db(zef.ES_epsilon_min));
zef.h_ES_parameter_table.Data{4,1} = 'Nuisance field weight maximum (dB)';
zef.h_ES_parameter_table.Data{4,2}  = num2str(db(zef.ES_epsilon));
zef.h_ES_parameter_table.Data{5,1} = 'Total current in montage';
zef.h_ES_parameter_table.Data{5,2} = num2str(zef.ES_total_max_current);
zef.h_ES_parameter_table.Data{6,1} = 'Max current allowed per electrode';
zef.h_ES_parameter_table.Data{6,2} = num2str(zef.ES_max_current_channel);
zef.h_ES_parameter_table.Data{7,1} = 'Threshold for non-zero currents';
zef.h_ES_parameter_table.Data{7,2} = num2str(zef.ES_relative_weight_nnz);
zef.h_ES_parameter_table.Data{8,1} = 'Maximum non-zero currents';
zef.h_ES_parameter_table.Data{8,2} = num2str(zef.ES_score_dose);
zef.h_ES_parameter_table.Data{9,1} = 'Lattice size';
zef.h_ES_parameter_table.Data{9,2} = num2str(zef.ES_step_size);
zef.h_ES_parameter_table.Data{10,1} = 'Targeted current density (A/m2)';
zef.h_ES_parameter_table.Data{10,2} = num2str(zef.ES_source_density);
zef.h_ES_parameter_table.Data{11,1} = 'Second-stage search threshold';
zef.h_ES_parameter_table.Data{11,2} = num2str(zef.ES_acceptable_threshold);
zef.h_ES_parameter_table.Data{12,1} = 'Boundary color limit';
zef.h_ES_parameter_table.Data{12,2} = num2str(zef.ES_boundary_color_limit);
zef.h_ES_parameter_table.Data{13,1} = 'ROI radius (mm)';
zef.h_ES_parameter_table.Data{13,2} = num2str(zef.ES_roi_range);
zef.h_ES_parameter_table.Data{14,1} = 'Solver tolerance';
zef.h_ES_parameter_table.Data{14,2} = num2str(zef.ES_solver_tolerance);
zef.h_ES_parameter_table.Data{15,1} = 'Display';
zef.h_ES_parameter_table.Data{15,2} = num2str(zef.ES_display);

if ismember(zef.ES_opt_solver, [1 4 5])
    zef.h_ES_parameter_table.Data{16,1} = 'Maximum number of iterations';
    zef.h_ES_parameter_table.Data{16,2} = num2str(zef.ES_max_n_iterations);
    zef.h_ES_parameter_table.Data{17,1} = 'Maximum time (s)';
    zef.h_ES_parameter_table.Data{17,2} = num2str(zef.ES_max_time);
end
end

function local_set_dropdown(h, items, itemsData)
%LOCAL_SET_DROPDOWN  Replace Items/ItemsData without an illegal Value.
%   uidropdown rejects ItemsData that does not contain Value, and a
%   ValueChangedFcn error reverts the control the user just changed.
    items = cellstr(string(items));
    items = items(:)';
    itemsData = reshape(double(itemsData), 1, []);
    keep = [];
    try
        cur = h.Value;
        if isnumeric(cur) && ismember(cur, itemsData)
            keep = cur;
        end
    catch
    end
    prev = [];
    try
        prev = h.ValueChangedFcn;
        h.ValueChangedFcn = '';
    catch
    end
    restore_cb = onCleanup(@() local_restore_callback(h, prev)); %#ok<NASGU>
    h.ItemsData = [];
    h.Items = items;
    h.ItemsData = itemsData;
    if isempty(keep)
        keep = itemsData(1);
    end
    h.Value = keep;
end

function local_restore_callback(h, prev)
    try
        if isgraphics(h) && isvalid(h)
            h.ValueChangedFcn = prev;
        end
    catch
    end
end
