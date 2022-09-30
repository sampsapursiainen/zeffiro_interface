
pml_ind_aux = [];
pml_ind = [];

mesh_res = eval('zef.mesh_resolution');
reuna_p = eval('zef.reuna_p');
reuna_t = eval('zef.reuna_t');
reuna_type = eval('zef.reuna_type');
sensors = eval('zef.sensors');

i = 0;
sigma_vec = [];
priority_vec = [];
submesh_cell = cell(0);
aux_active_compartment_ind = [];
compartment_tags = eval('zef.compartment_tags');

for k = 1 : length(compartment_tags)

        var_0 = ['zef.' compartment_tags{k} '_on'];
        var_1 = ['zef.' compartment_tags{k} '_sigma'];
        var_2 = ['zef.' compartment_tags{k} '_priority'];
        var_3 = ['zef.' compartment_tags{k} '_submesh_ind'];
        var_4 = ['zef.' compartment_tags{k} '_name'];
         var_5 = ['zef.' compartment_tags{k} '_sources'];

on_val = eval(var_0);
sigma_val = eval(var_1);
priority_val = eval(var_2);

if on_val
i = i + 1;

sigma_vec(i,1) = sigma_val;
priority_vec(i,1) = priority_val;
submesh_cell{i} = eval(var_3);
name_tags{i} = eval(var_4);

if isequal(eval(var_5),-1)
pml_ind_aux = i;
end

if ismember(eval(var_5),[1 2])
aux_active_compartment_ind = [aux_active_compartment_ind i];
end

end
end

n_compartments = 0;
for k = 1 : length(reuna_p)
n_compartments = n_compartments + max(1,length(submesh_cell{k}));
end

priority_vec_aux_segmentation = zeros(n_compartments,1);
compartment_counter = 0;
submesh_ind_1 = ones(n_compartments,1);
submesh_ind_2 = ones(n_compartments,1);

for i = 1 :  length(reuna_p)

for k = 1 : max(1,length(submesh_cell{i}))

compartment_counter = compartment_counter + 1;
priority_vec_aux_segmentation(compartment_counter) = priority_vec(i);
submesh_ind_1(compartment_counter) = i;
submesh_ind_2(compartment_counter) = k;

end
end

priority_vec_aux = max(submesh_ind_1) +1 - submesh_ind_1;


