function self = segmentation_counter_step(self)

    arguments
        self app.Zef
    end

    pml_ind_aux = [];
    pml_ind = [];

    mesh_res = self.mesh_resolution;
    reuna_p = self.data.reuna_p;
    reuna_t = self.data.reuna_t;
    reuna_type = self.data.reuna_type;
    sensors = self.sensors;

    i = 0;

    sigma_vec = [];
    priority_vec = [];
    submesh_cell = cell(0);
    aux_brain_ind = [];
    compartment_tags = self.compartment_tags;

    for k = 1 : length(compartment_tags)

        var_0 = [compartment_tags{k} '_on'];
        var_1 = [compartment_tags{k} '_sigma'];
        var_2 = [compartment_tags{k} '_priority'];
        var_3 = [compartment_tags{k} '_submesh_ind'];
        var_4 = [compartment_tags{k} '_name'];
        var_5 = [compartment_tags{k} '_sources'];

        on_val = self.data.(var_0);
        sigma_val = self.data.(var_1);
        priority_val = self.data.(var_2);

        if on_val

            i = i + 1;

            sigma_vec(i,1) = sigma_val;
            priority_vec(i,1) = priority_val;
            submesh_cell{i} = self.data.(var_3);
            name_tags{i} = self.data.(var_4);

            if isequal(self.data.(var_5),-1)
                pml_ind_aux = i;
            end

            if ismember(self.data.(var_5),[1 2])
                aux_brain_ind = [aux_brain_ind i];
            end

        end % if

    end % for

    n_compartments = 0;

    for k = 1 : length(reuna_p)
        n_compartments = n_compartments + max(1,length(submesh_cell{k}));
    end

    priority_vec_aux = zeros(n_compartments,1);
    compartment_counter = 0;
    submesh_ind_1 = ones(n_compartments,1);
    submesh_ind_2 = ones(n_compartments,1);

    for i = 1 : length(reuna_p)

        for k = 1 : max(1,length(submesh_cell{i}))

            compartment_counter = compartment_counter + 1;
            priority_vec_aux(compartment_counter) = priority_vec(i);
            submesh_ind_1(compartment_counter) = i;
            submesh_ind_2(compartment_counter) = k;

        end % for

    end % for

    self.data.submesh_ind_1 = submesh_ind_1;

    self.data.submesh_ind_2 = submesh_ind_2;

    self.data.submesh_cell = submesh_cell;

    self.data.pml_ind_aux = pml_ind_aux;

    self.data.pml_ind = pml_ind;

end % function
