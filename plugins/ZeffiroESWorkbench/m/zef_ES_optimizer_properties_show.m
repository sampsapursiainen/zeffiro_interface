function zef = zef_ES_optimizer_properties_show(zef)

if nargin == 0
    zef = evalin('base','zef');
end
    
zef = zef_ES_optimizer_properties(zef);

    zef.table_aux = zef_ES_table(zef);

        [zef_i, zef_j] = zef_ES_objective_function(zef);
        
        for zef_k = 1 : size(zef.table_aux,2)
        
        zef.h_ES_optimizer_properties_table.Data{zef_k,1} = zef.table_aux.Properties.VariableNames{zef_k};
        if not(isempty(zef.table_aux{1,zef_k}{1}))
        if zef_k == 12
        zef.h_ES_optimizer_properties_table.Data{zef_k,2} = round(zef.table_aux{1,zef_k}{1}(zef_j),4);
        elseif zef_k == 13
        zef.h_ES_optimizer_properties_table.Data{zef_k,2} = round(zef.table_aux{1,zef_k}{1}(zef_i),4);
        else
        zef.h_ES_optimizer_properties_table.Data{zef_k,2} = round(zef.table_aux{1,zef_k}{1}(zef_i,zef_j),4);  
        end
        
        if zef_k <= 11
        zef.h_ES_optimizer_properties_table.Data{zef_k,3} = zef_lattice_deviation(zef.table_aux{1,zef_k}{1},'avg',0.5,zef_i,zef_j);
        zef.h_ES_optimizer_properties_table.Data{zef_k,4} = zef_lattice_deviation(zef.table_aux{1,zef_k}{1},'max',0.5,zef_i,zef_j);
        end
        else
        zef.h_ES_optimizer_properties_table.Data{zef_k,2} = '';
        end
        end
        
        zef_k = zef_k + 1;
        
        zef.h_ES_optimizer_properties_table.Data{zef_k,1} = 'Lattice run time (s)';
        zef.h_ES_optimizer_properties_table.Data{zef_k,2} = sum(zef.table_aux{1,11}{1},'all');
        
        zef.h_ES_optimizer_properties.Name = [zef.h_ES_optimizer_properties.Name ' . ' zef.table_aux.Properties.Description];
        
clear zef_i zef_j zef_k;
zef = rmfield(zef,'table_aux');

zef.h_optimizer_properties.Visible = zef.use_display;

if nargout == 0
assignin('base','zef',zef);
end

end
