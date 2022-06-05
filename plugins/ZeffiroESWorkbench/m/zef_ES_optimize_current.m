function [y_ES, ES_optimized_current_density, residual, flag_val, source_magnitude, source_position_index, source_directions] = zef_ES_optimize_current(zef_data,varargin)
%% varargin

if nargin >= 3
    [alpha, TolFun] = deal(varargin{1:2});
end
%% Source properties

source_position_index       = zeros(size(zef_data.source_positions,1),1);


for i = 1:size(zef_data.source_positions,1)
    [~,aux_index] = min(sqrt(sum((zef_data.source_positions_aux - zef_data.source_positions(i,:)).^2,2)));
    source_position_index(i) = aux_index;
end


zef_data.source_directions           = zef_data.source_directions./sqrt(sum(zef_data.source_directions.^2,2));
L_ES_projection             = zeros(length(source_position_index),size(zef_data.L_aux,2));
x_ES_projection             = zeros(length(source_position_index),1);
J_x_ES = [];

for running_index = 1:length(source_position_index)
    J_x_ES = [J_x_ES ; [3*(source_position_index(running_index)-1)+1:3*source_position_index(running_index)]'];  %#ok<NBRAK,AGROW>
    for ell_ind = 1:3
        L_ES_projection(running_index,:) = L_ES_projection(running_index,:) + zef_data.L_aux(3*(source_position_index(running_index)-1)+ell_ind,:).*zef_data.source_directions(running_index,ell_ind);
    end
    x_ES_projection(running_index) = zef_data.relative_source_amplitude.*zef_data.inv_synth_source(running_index,7).*zef_data.source_density./zef_data.cortex_thickness;
end

source_magnitude  = max(abs(x_ES_projection));


J_x_ES                  = setdiff((1:size(zef_data.L_aux,1))',J_x_ES);
%% Active Electrodes and L_ES_projection
if ismember(zef_data.search_method,[1 2])
    alpha = norm(zef_data.L_aux,1)*alpha;
    L_ES_projection   = [zef_data.L_aux(J_x_ES,:)  ; L_ES_projection];
elseif ismember(zef_data.search_method,3)
    singular_value_max = svds(zef_data.L_aux,1);
    L_ES_projection   = [alpha*TolFun*zef_data.L_aux(J_x_ES,:)  ; L_ES_projection];
alpha = singular_value_max*alpha;
end
x_ES_projection   = [zeros(length(J_x_ES),1) ; x_ES_projection];

if not(isempty(zef_data.active_electrodes))
    L_ES_projection   = L_ES_projection(:,zef_data.active_electrodes);
else
    zef_data.active_electrodes = 1:size(L_ES_projection,2);
    L_ES_projection   = L_ES_projection(:,zef_data.active_electrodes);
end

M_mat = eye(size(L_ES_projection,2)) - ones(size(L_ES_projection,2))/size(L_ES_projection,2);
L_ES_projection = L_ES_projection*M_mat;

%% Search
switch zef_data.search_method
    case 1
        %% LP setup
        opts = optimset('linprog');
        if isfloat(TolFun)
            TolFun = round(TolFun,10);
        end
        opts.TolFun     = 1E-10;            %TolFun;
        opts.TolX = 1E-10;
        opts.TolCon = 1E-9;
        opts.Algorithm  = 'dual-simplex';
        opts.Display    = 'off';


       
            L_ES_projection = [L_ES_projection; eye(size(L_ES_projection,2))];
            x_ES_projection = [x_ES_projection; zeros(size(L_ES_projection,2),1)];
            
            g = [zeros(size(L_ES_projection,2),1); ones(size(L_ES_projection,1)-size(L_ES_projection,2),1) ; alpha*ones(size(L_ES_projection,2),1) ];
            
                 [y_ES,~,flag_val] = zef_cvx_linprog(g, ...
                    [-L_ES_projection -eye(size(L_ES_projection,1))  ; L_ES_projection -eye(size(L_ES_projection,1)); zeros(1, size(L_ES_projection,1)) ones(1, size(L_ES_projection,2)) ], ...
                    [-x_ES_projection ; x_ES_projection; zef_data.total_max_current], ...
                    [], ...
                    [], ...
                    [-zef_data.max_current_channel*ones(size(L_ES_projection,2),1); TolFun*max(source_magnitude)*ones(size(L_ES_projection,1)-size(L_ES_projection,2)-length(source_position_index),1); zeros(size(L_ES_projection,2)+length(source_position_index),1) ], ...
                    [ zef_data.max_current_channel*ones(size(L_ES_projection,2),1); max(source_magnitude)*ones(size(L_ES_projection,1)-size(L_ES_projection,2),1); zef_data.max_current_channel*ones(size(L_ES_projection,2),1) ],...
                    opts);
     
            y_ES = y_ES(1:size(L_ES_projection,2));
            
             if flag_val ~= 1
                 y_ES = zeros(size(L_ES_projection,2),1);
             end
            
    case 2  
  
        %% SDP setup
        opts = optimset('linprog');
        if isfloat(TolFun)
            TolFun = round(TolFun,10);
        end
        opts.TolFun     = 1E-10;            %TolFun;
        opts.TolX = 1E-10;
        opts.TolCon = 1E-9;
        opts.Algorithm  = 'dual-simplex';
        opts.Display    = 'off';

   
            L_ES_projection = [L_ES_projection; eye(size(L_ES_projection,2))];
            x_ES_projection = [x_ES_projection; zeros(size(L_ES_projection,2),1)];
            
            g_1 = [zeros(size(L_ES_projection,2),1); zeros(size(L_ES_projection,1)-size(L_ES_projection,2),1) ; alpha*ones(size(L_ES_projection,2),1) ];
            g_2 = [zeros(size(L_ES_projection,2),1); ones(size(L_ES_projection,1)-size(L_ES_projection,2),1) ; zeros(size(L_ES_projection,2),1) ];
            
                 [y_ES,~,flag_val] = zef_cvx_semidefprog(g_1,g_2, ...
                    [-L_ES_projection -eye(size(L_ES_projection,1))  ; L_ES_projection -eye(size(L_ES_projection,1)); zeros(1, size(L_ES_projection,1)) ones(1, size(L_ES_projection,2)) ], ...
                    [-x_ES_projection ; x_ES_projection; zef_data.total_max_current], ...
                    [], ...
                    [], ...
                    [-zef_data.max_current_channel*ones(size(L_ES_projection,2),1); TolFun*max(source_magnitude)*ones(size(L_ES_projection,1)-size(L_ES_projection,2)-length(source_position_index),1); zeros(size(L_ES_projection,2)+length(source_position_index),1) ], ...
                    [ zef_data.max_current_channel*ones(size(L_ES_projection,2),1); max(source_magnitude)*ones(size(L_ES_projection,1)-size(L_ES_projection,2),1); zef_data.max_current_channel*ones(size(L_ES_projection,2),1) ],...
                    opts);
     
            y_ES = y_ES(1:size(L_ES_projection,2));
            
             if flag_val ~= 1
                 y_ES = zeros(size(L_ES_projection,2),1);
             end
            
    case 3

     y_ES = ((L_ES_projection)' * (L_ES_projection) + alpha^2*eye(size(L_ES_projection,2))) \ L_ES_projection'*x_ES_projection;

     flag_val = 1;
        
end
%% Postprocess
y_ES = M_mat*y_ES;

[~, y_ES] = zef_ES_rwnnz(y_ES, zef_data.relative_weight_nnz, zef_data.score_dose);

y_idx = y_ES ~= 0;
y_ES(y_idx) = y_ES(y_idx)-mean(y_ES(y_idx));

 y_ES = zef_data.total_max_current * y_ES ./ sum(abs(y_ES));

if max(abs(y_ES))      >= zef_data.max_current_channel
   y_ES = zef_data.max_current_channel * y_ES ./ max(abs(y_ES));
end


if not(isempty(zef_data.active_electrodes))
    y_ES_aux = zeros(size(zef_data.L_aux,2),1);
        y_ES_aux(zef_data.active_electrodes) = y_ES;
    y_ES = y_ES_aux;
end

%% Flag value from LP solver
if ismember(flag_val,[1 3])
        ES_optimized_current_density  = reshape(zef_data.L_aux*y_ES,3,size(zef_data.L_aux,1)/3);
        if not(isempty(zef_data.active_electrodes))
            residual = norm(L_ES_projection*y_ES(zef_data.active_electrodes)-x_ES_projection,1);
        else
            residual = norm(L_ES_projection*y_ES-x_ES_projection,1);
        end
else
    y_ES = zeros(size(zef_data.L_aux,2),1);
    ES_optimized_current_density = zeros(size(zef_data.L_aux,2),1);
    residual = 0;
end

source_directions = zef_data.source_directions;

end




