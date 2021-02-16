function [y_ES, ES_optimized_current_density, residual, flag_val] = zef_ES_optimize_current(TolFun, reg_param)

% Preallocation for L_ES & x_ES
L_aux                   = evalin('base','zef.L');
source_positions_ES     = evalin('base','zef.inv_synth_source(:,1:3)');
source_position_index   = zeros(size(source_positions_ES,1),1);
for i = 1 : size(source_positions_ES,1)
    [~,aux_index] = min(sqrt(sum((evalin('base','zef.source_positions') - source_positions_ES(i,:)).^2,2)));
    source_position_index(i) = aux_index; 
end

source_directions           = evalin('base','zef.inv_synth_source(:,4:6)');
source_directions           = source_directions./sqrt(sum(source_directions.^2,2));
relative_source_amplitude   = evalin('base','zef.ES_relative_source_amplitude');
L_ES_projection             = zeros(length(source_position_index),size(L_aux,2));
x_ES_projection             = zeros(length(source_position_index),1);

J_x_ES = [];
for running_index = 1:length(source_position_index)
    J_x_ES = [J_x_ES ; [3*(source_position_index(running_index)-1)+1:3*source_position_index(running_index)]'];  %#ok<NBRAK,AGROW>
    for ell_ind = 1:3
        L_ES_projection(running_index,:) = L_ES_projection(running_index,:) + L_aux(3*(source_position_index(running_index)-1)+ell_ind,:).*source_directions(running_index,ell_ind);
    end
    if length(relative_source_amplitude) > 1
        x_ES_projection(running_index) = relative_source_amplitude(running_index).*evalin('base','zef.ES_source_density')./evalin('base','zef.ES_cortex_thickness');
    else
        x_ES_projection(running_index) = relative_source_amplitude.*evalin('base','zef.ES_source_density')./evalin('base','zef.ES_cortex_thickness');
    end
end

J_x_ES                  = setdiff([1:size(L_aux,1)]',J_x_ES);
L_ES_projection         = [L_aux(J_x_ES,:) ; L_ES_projection];
x_ES_projection         = [zeros(length(J_x_ES),1) ; x_ES_projection]; 

active_electrodes       = evalin('base','zef.ES_active_electrodes');
if not(isempty(evalin('base','zef.ES_active_electrodes')))
    L_ES_projection   = L_ES_projection(:,active_electrodes);
else
    active_electrodes = [1:size(L_ES_projection,2)];
    L_ES_projection   = L_ES_projection(:,active_electrodes);
end

% Linear Programming Solver
opts = optimset('linprog');

lower_bound           = - evalin('base','zef.ES_maximum_current');
upper_bound             = evalin('base','zef.ES_maximum_current');
if lower_bound == 0
    lower_bound = -Inf;
end
if upper_bound == 0
    upper_bound = Inf;
end
if length(lower_bound) <= 1
    lower_bound = lower_bound*ones(size(L_ES_projection,2),1);
end
if length(upper_bound) <= 1
    upper_bound = upper_bound*ones(size(L_ES_projection,2),1);
end

constaint_tolerance     = 1e-3;
variable_tolerance      = 1e-3;
algorithm               = 'dual-simplex';

positivity_constraint   = evalin('base','zef.ES_positivity_constraint');
negativity_constraint   = evalin('base','zef.ES_negativity_constraint');
if not(isempty(positivity_constraint))
    p_c_ind = sub2ind([length(positivity_constraint) size(L_ES_projection,2)],[1:length(positivity_constraint)]',positivity_constraint(:)); %#ok<NBRAK>
    p_c_aux = zeros(length(positivity_constraint),size(L_ES_projection,2));
    p_c_aux(p_c_ind) = -1;
    L_ES_projection = [L_ES_projection; p_c_aux];
    x_ES_projection = [x_ES_projection ; zeros(length(positivity_constraint),1)];
end
if not(isempty(negativity_constraint))
    n_c_ind = sub2ind([length(negativity_constraint) size(L_ES_projection,2)],[1:length(negativity_constraint)]',negativity_constraint(:)); %#ok<NBRAK>
    n_c_aux = zeros(length(negativity_constraint),size(L_ES_projection,2));
    n_c_aux(n_c_ind) = 1;
    L_ES_projection = [L_ES_projection; n_c_aux];
    x_ES_projection = [x_ES_projection ; zeros(length(negativity_constraint),1)];
end 

opts.TolCon     = constaint_tolerance;
opts.TolX       = variable_tolerance;
opts.Algorithm  = algorithm;
opts.Display    = 'off';
opts.TolFun     = TolFun;

if reg_param <= 0
    [y_ES,~,flag_val] = linprog(sum(L_ES_projection)', -L_ES_projection, -x_ES_projection, ones(1,size(L_ES_projection,2)), 0, lower_bound, upper_bound, opts);
else
    L_ES_projection = [L_ES_projection ; reg_param*ones(1,size(L_ES_projection,2))];
    x_ES_projection = [x_ES_projection; 0];
    
    [y_ES,~,flag_val] = linprog(sum(L_ES_projection)'+reg_param, -L_ES_projection, -x_ES_projection, ones(1,size(L_ES_projection,2)), 0, lower_bound, upper_bound, opts);
end
if ismember(flag_val,[1 3])
    residual = norm(L_ES_projection*y_ES-x_ES_projection,1);
else
    residual = 0;
    'No solution found' %#ok<NOPRT>
end

if not(isempty(evalin('base','zef.ES_active_electrodes')))
    y_ES_aux = zeros(size(L_aux,2),1);
    y_ES_aux(active_electrodes) = y_ES;
    y_ES = y_ES_aux;
end

ES_optimized_current_density  = reshape(L_aux*y_ES,3,size(L_aux,1)/3);
end