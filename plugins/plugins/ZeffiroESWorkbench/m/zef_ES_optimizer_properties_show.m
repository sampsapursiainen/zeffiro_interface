function zef = zef_ES_optimizer_properties_show(zef)
if nargin == 0
    zef = evalin('base','zef');
end

zef = zef_ES_optimizer_properties(zef);

vec = zef_ES_table(zef.y_ES_interval);
[sr, sc] = zef_ES_objective_function(zef);

for i_aux = 1 : size(vec, 2)-1 % Last one are the ES channels.
    zef.h_ES_optimizer_properties_table.Data{i_aux, 1} = vec.Properties.VariableNames{i_aux};
    if not(isempty(vec{:, i_aux}))

        if i_aux == 13 % alpha
            zef.h_ES_optimizer_properties_table.Data{i_aux, 2} = round(vec{:, i_aux}{1}(sc),4);
        elseif i_aux == 14 % beta or k-val
            zef.h_ES_optimizer_properties_table.Data{i_aux, 2} = round(vec{:, i_aux}{1}(sr),4);
        else

            zef.h_ES_optimizer_properties_table.Data{i_aux, 2} = vec{:, i_aux}{1}(sr,sc);
        end

        if i_aux <= 12
            zef.h_ES_optimizer_properties_table.Data{i_aux, 3} = zef_lattice_deviation(vec{:, i_aux}{1},'avg',0.5,sr,sc);
            zef.h_ES_optimizer_properties_table.Data{i_aux, 4} = zef_lattice_deviation(vec{:, i_aux}{1},'max',0.5,sr,sc);
        end

    else
        zef.h_ES_optimizer_properties_table.Data{i_aux,2} = '';
    end
end

i_aux = i_aux + 1;

zef.h_ES_optimizer_properties_table.Data{i_aux,1} = 'Lattice run time (s)';
zef.h_ES_optimizer_properties_table.Data{i_aux,2} = sum(vec{:,12}{1},'all');

zef.h_ES_optimizer_properties.Name = [zef.h_ES_optimizer_properties.Name ' . ' vec.Properties.Description];

clear sr sc i_aux;
%zef = rmfield(zef,'table_aux');

zef.h_optimizer_properties.Visible = zef.use_display;

if nargout == 0
    assignin('base','zef',zef);
end

end
