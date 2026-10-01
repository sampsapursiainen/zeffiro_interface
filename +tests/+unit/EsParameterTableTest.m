classdef EsParameterTableTest < matlab.unittest.TestCase
%ESPARAMETERTABLETEST  Solver changes must leave method and algorithm Values legal.
%
%   Zeffiro Interface.
%   Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%   See: https://github.com/sampsapursiainen/zeffiro_interface
%   Licensed under the GNU General Public License v3.0 (see LICENSE).
%
%   Switching ES Workbench from SDPT3 to Matlab used to assign algorithm
%   ItemsData [2 3] while Value was still 1. uidropdown rejects that, the
%   ValueChangedFcn aborts, and the solver dropdown snaps back.

    methods (Test)
        function matlabSolverAcceptsAlgorithmOutsidePreviousCodes(testCase)
            fig = uifigure('Visible', 'off');
            testCase.addTeardown(@() local_delete(fig));
            zef = local_zef(fig);
            zef.h_ES_opt_algorithm.ValueChangedFcn = 'error(''algorithm callback ran'');';
            zef.ES_opt_solver = 1;
            zef.ES_opt_method = 1;
            zef_ES_init_parameter_table; %#ok<NASGU>
            testCase.verifyEqual(zef.h_ES_opt_method.ItemsData, [1 3 4]);
            testCase.verifyEqual(zef.h_ES_opt_algorithm.ItemsData, [2 3]);
            testCase.verifyTrue(ismember(zef.h_ES_opt_algorithm.Value, [2 3]));
            testCase.verifyEqual(char(zef.h_ES_opt_algorithm.ValueChangedFcn), ...
                'error(''algorithm callback ran'');');
            testCase.verifyGreaterThan(size(zef.h_ES_parameter_table.Data, 1), 9);
        end
    end

end

function zef = local_zef(fig)

zef = struct();
zef.ES_opt_method_list = {'L1L1 optimization', 'L1L2 optimization', ...
    'Least squares optimization', 'Backpropagation', 'L2L2 optimization'};
zef.ES_opt_algorithm_list = {'interior-point', 'interior-point-legacy', ...
    'dual-simplex', 'primal-simplex'};
zef.h_ES_opt_method = uidropdown(fig, ...
    'Items', zef.ES_opt_method_list([1 2]), 'ItemsData', [1 2], 'Value', 1);
zef.h_ES_opt_algorithm = uidropdown(fig, ...
    'Items', zef.ES_opt_algorithm_list(1), 'ItemsData', 1, 'Value', 1);
zef.h_ES_parameter_table = uitable(fig);
zef.ES_alpha = 1e-5;
zef.ES_alpha_max = 1e-1;
zef.ES_epsilon_min = 1e-8;
zef.ES_epsilon = 1;
zef.ES_total_max_current = 0.004;
zef.ES_max_current_channel = 0.002;
zef.ES_relative_weight_nnz = 1e-3;
zef.ES_score_dose = 20;
zef.ES_step_size = 15;
zef.ES_source_density = 3.85;
zef.ES_acceptable_threshold = 0.8;
zef.ES_boundary_color_limit = 2.5e-4;
zef.ES_roi_range = 0;
zef.ES_solver_tolerance = 1e-6;
zef.ES_display = 'off';
zef.ES_max_n_iterations = 100;
zef.ES_max_time = 60;
zef.ES_step_tolerance = 1e-6;
zef.ES_constraint_tolerance = 1e-6;

end

function local_delete(fig)

if isgraphics(fig) && isvalid(fig)
    delete(fig);
end

end
