if zef.nse_field.solver_type == 1
    zef = zef_nse_tool_update(zef);
    zef.nse_field.microcirculation_model = 0;
    zef.nse_field = zef_nse_poisson(zef.nse_field,zef.nodes,zef.tetra,zef.domain_labels,zef.mvd_length);
elseif zef.nse_field.solver_type == 2
    zef = zef_nse_tool_update(zef);
    zef.nse_field.microcirculation_model = 1;
    zef.nse_field = zef_nse_poisson(zef.nse_field,zef.nodes,zef.tetra,zef.domain_labels,zef.mvd_length);
elseif zef.nse_field.solver_type == 3
    zef = zef_nse_tool_update(zef);
    zef.nse_field.nse_type = 1;
    zef.nse_field.microcirculation_model = 0;
    zef.nse_field = zef_nse_poisson_dynamic(zef.nse_field,zef.nodes,zef.tetra,zef.domain_labels,zef.mvd_length);
elseif zef.nse_field.solver_type == 4
    zef = zef_nse_tool_update(zef);
    zef.nse_field.nse_type = 1;
    zef.nse_field.microcirculation_model = 1;
    zef.nse_field = zef_nse_poisson_dynamic(zef.nse_field,zef.nodes,zef.tetra,zef.domain_labels,zef.mvd_length);
elseif zef.nse_field.solver_type == 5
    zef = zef_nse_tool_update(zef);
    zef.nse_field.nse_type = 2;
    zef.nse_field.microcirculation_model = 0;
    zef.nse_field = zef_nse_poisson_dynamic(zef.nse_field,zef.nodes,zef.tetra,zef.domain_labels,zef.mvd_length);
elseif zef.nse_field.solver_type == 6
    zef = zef_nse_tool_update(zef);
    zef.nse_field.nse_type = 2;
    zef.nse_field.microcirculation_model = 1;
    zef.nse_field = zef_nse_poisson_dynamic(zef.nse_field,zef.nodes,zef.tetra,zef.domain_labels,zef.mvd_length);
end
