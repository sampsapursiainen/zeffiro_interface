function [L,n_interp, procFile] = process_lead_fields(zef)

    % process_lead_fields
    %
    % processes the leadfield in zef and applies all visibility options. l is the
    % leadfield, the procfile has all information needed for the postprocessing
    % step, but should not be needed in the inverse method

    source_directions = zef.source_directions;

    s_ind_2=[];
    s_ind_3=[];
    s_ind_4=[];

    [s_ind_1] = unique(zef.source_interpolation_ind{1});

    n_interp = length(s_ind_1);

    if zef.source_direction_mode == 2

        [s_ind_3] = zef.source_interpolation_ind{3};

        i = 0;
        length_reuna = 0;
        sigma_vec = [];
        priority_vec = [];
        visible_vec = [];
        color_cell = cell(0);
        aux_brain_ind = [];
        aux_dir_mode = [];
        submesh_cell = cell(0);
        compartment_tags = zef.compartment_tags;

        for k = 1 : length(compartment_tags)

            var_0 = ['zef.' compartment_tags{k} '_on'];
            var_1 = ['zef.' compartment_tags{k} '_sigma'];
            var_2 = ['zef.' compartment_tags{k} '_priority'];
            var_3 = ['zef.' compartment_tags{k} '_visible'];
            var_4 = ['zef.' compartment_tags{k} '_submesh_ind'];
            color_str = ['zef.' compartment_tags{k} '_color'];

            on_val = eval(var_0);
            sigma_val = eval(var_1);
            priority_val = eval(var_2);
            visible_val = eval(var_3);
            submesh_ind = eval(var_4);

            if on_val

                i = i + 1;
                sigma_vec(i,1) = sigma_val;
                priority_vec(i,1) = priority_val;
                color_cell{i} = color_str;
                visible_vec(i,1) = i*visible_val;
                submesh_cell{i} = submesh_ind;

                if eval(['zef.' compartment_tags{k} '_sources']);
                    aux_brain_ind = [aux_brain_ind i];
                    aux_dir_mode = [aux_dir_mode eval(['zef.' compartment_tags{k} '_sources'])-1];
                end

            end

        end

        a_d_i_vec = [];
        aux_p = [];
        aux_t = [];

        for ab_ind = 1 : length(aux_brain_ind)

            aux_t = [aux_t ; size(aux_p,1) + eval(['zef.reuna_t{' int2str(aux_brain_ind(ab_ind)) '}'])];
            aux_p = [aux_p ; eval(['zef.reuna_p{' int2str(aux_brain_ind(ab_ind)) '}'])];
            a_d_i_vec = [a_d_i_vec ; aux_dir_mode(ab_ind)*ones(size(eval(['zef.reuna_p{' int2str(aux_brain_ind(ab_ind)) '}']),1),1)];

        end

        a_d_i_vec = a_d_i_vec(aux_t(:,1));
        n_vec_aux = cross(aux_p(aux_t(:,2),:)' - aux_p(aux_t(:,1),:)', aux_p(aux_t(:,3),:)' - aux_p(aux_t(:,1),:)')';
        n_vec_aux = n_vec_aux./repmat(sqrt(sum(n_vec_aux.^2,2)),1,3);

        n_vec_aux(:,1) = zef_smooth_field(aux_t, n_vec_aux(:,1), size(aux_p(:,1),1),7);
        n_vec_aux(:,2) = zef_smooth_field(aux_t, n_vec_aux(:,2), size(aux_p(:,1),1),7);
        n_vec_aux(:,3) = zef_smooth_field(aux_t, n_vec_aux(:,3), size(aux_p(:,1),1),7);

        n_vec_aux =  - n_vec_aux./repmat(sqrt(sum(n_vec_aux.^2,2)),1,3);

        s_ind_4 = find(not(a_d_i_vec(s_ind_3)));
        source_directions = n_vec_aux(s_ind_3,:);

    end

    if zef.source_direction_mode == 3
        source_directions = source_directions(s_ind_1,:);
    end

    s_ind_0=s_ind_1;

    if zef.source_direction_mode == 1  || zef.source_direction_mode == 2
        s_ind_1 = [3*s_ind_1-2 ; 3*s_ind_1-1 ; 3*s_ind_1]; %not triplet anymore
    end

    if  zef.source_direction_mode == 3
        s_ind_2 = [3*s_ind_1-2 ; 3*s_ind_1-1 ; 3*s_ind_1];
    end

    s_ind_1 = s_ind_1(:);

    L = zef.L;
    L = L(:,s_ind_1);

    if zef.source_direction_mode == 2

        L_1 = L(:,1:n_interp);
        L_2 = L(:,n_interp+1:2*n_interp);
        L_3 = L(:,2*n_interp+1:3*n_interp);
        s_1 = source_directions(:,1)';
        s_2 = source_directions(:,2)';
        s_3 = source_directions(:,3)';
        ones_vec = ones(size(L,1),1);
        L_0 = L_1(:,s_ind_4).*s_1(ones_vec,s_ind_4) + L_2(:,s_ind_4).*s_2(ones_vec,s_ind_4) + L_3(:,s_ind_4).*s_3(ones_vec,s_ind_4); %normal matrix
        L(:,s_ind_4) = L_0;
        L(:,n_interp+s_ind_4) = L_0;
        L(:,2*n_interp+s_ind_4) = L_0;
        clear L_0 L_1 L_2 L_3 s_1 s_2 s_3;

    end

    procFile.source_direction_mode = zef.source_direction_mode;
    procFile.source_directions = zef.source_directions;
    procFile.s_ind_1 = s_ind_1;
    procFile.s_ind_2 = s_ind_2;
    procFile.s_ind_3 = s_ind_3;
    procFile.s_ind_4 = s_ind_4;
    procFile.n_interp = n_interp;
    procFile.sizeL2 = size(L,2);
    procFile.s_ind_0 = s_ind_0;

end % function
