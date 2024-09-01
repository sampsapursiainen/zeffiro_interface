function compartment_settings = zef_bst_compartment_settings(zef_bst,surface_meshes)

n_compartments = length(surface_meshes);
compartment_settings = [repmat({'Compartment name'}, n_compartments,1), {surface_meshes.Name}',...
    repmat({'Compartment type'}, n_compartments,1),{surface_meshes.Type}', ... 
    repmat({'Refine surface'}, n_compartments,1), repmat({0}, n_compartments,1), ...
    repmat({'Refine volume'}, n_compartments,1), repmat({0}, n_compartments,1),...
    repmat({'Electrical conductivity'}, n_compartments,1), repmat({1}, n_compartments,1)...
    repmat({'DOF space'}, n_compartments,1), repmat({0}, n_compartments,1)];

for i = 1 : n_compartments

if ismember(surface_meshes(i).Type, zef_bst.refine_surface)
compartment_settings{i,6} = 1;
end

if ismember(surface_meshes(i).Name, zef_bst.refine_surface)
compartment_settings{i,6} = 1;
end

if ismember(surface_meshes(i).Type, zef_bst.refine_volume)
compartment_settings{i,8} = 1;
end

if ismember(surface_meshes(i).Name, zef_bst.refine_volume)
compartment_settings{i,8} = 1;
end

conductivity_index_1 = find(ismember(zef_bst.electrical_conductivity(1:2:end), surface_meshes(i).Type),1);
conductivity_index_2 = find(ismember(zef_bst.electrical_conductivity(1:2:end), surface_meshes(i).Name),1);

if not(isempty(conductivity_index_1))
compartment_settings{i,10} = zef_bst.electrical_conductivity{2*conductivity_index_1};
end

if not(isempty(conductivity_index_2))
compartment_settings{i,10} = zef_bst.electrical_conductivity{2*conductivity_index_2};
end

dof_space_index_1 = find(ismember(zef_bst.dof_space(1:2:end), surface_meshes(i).Type),1);
dof_space_index_2 = find(ismember(zef_bst.dof_space(1:2:end), surface_meshes(i).Name),1);

if not(isempty(dof_space_index_1))
compartment_settings{i,12} = zef_bst.dof_space{2*conductivity_index_1};
end

if not(isempty(dof_space_index_2))
compartment_settings{i,12} = zef_bst.dof_space{2*conductivity_index_2};
end


end