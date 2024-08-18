%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function zef = zef_create_fem_mesh(zef)

if nargin == 0
    zef = evalin('base','zef');
end

zef_segmentation_counter_step;

x_lim = [0 0];
y_lim = [0 0];
z_lim = [0 0];
n_compartments = 0;
for k = 1 : length(zef.reuna_p)
    n_compartments = n_compartments + max(1,length(submesh_cell{k}));

    if not(isequal(reuna_type{k},-1))
        x_lim = [min(x_lim(1),min(zef.reuna_p{k}(:,1))) max(x_lim(2),max(zef.reuna_p{k}(:,1)))];
        y_lim = [min(y_lim(1),min(zef.reuna_p{k}(:,2))) max(y_lim(2),max(zef.reuna_p{k}(:,2)))];
        z_lim = [min(z_lim(1),min(zef.reuna_p{k}(:,3))) max(z_lim(2),max(zef.reuna_p{k}(:,3)))];
    end
end

if isempty(pml_ind_aux)
    x_vec = [x_lim(1):mesh_res:x_lim(2)];
    y_vec = [y_lim(1):mesh_res:y_lim(2)];
    z_vec = [z_lim(1):mesh_res:z_lim(2)];
    [X, Y, Z] = meshgrid(x_vec,y_vec,z_vec);
    n_cubes = (length(x_vec)-1)*(length(y_vec)-1)*(length(z_vec)-1);
else

    pml_inner_radius = max(abs([x_lim(:); y_lim(:); z_lim(:)]));
    pml_outer_radius_unit = eval('zef.pml_outer_radius_unit');
    pml_outer_radius = eval('zef.pml_outer_radius');
    pml_max_size_unit = eval('zef.pml_max_size_unit');
    pml_max_size = eval('zef.pml_max_size');

    if isequal(pml_outer_radius_unit,1)
        pml_outer_radius = pml_inner_radius*pml_outer_radius;
    end

    if isequal(pml_max_size_unit,1)
        pml_max_size = mesh_res*pml_max_size;
    end

    [X, Y, Z, pml_ind] = zef_pml_mesh(pml_inner_radius,pml_outer_radius,mesh_res,pml_max_size);
    n_cubes = prod(size(X)-1);
end

size_xyz = size(X);

h = zef_waitbar(0,1,'Initial mesh.');

%************************************************************

if isequal(eval('zef.initial_mesh_mode'),1)

    ind_mat_1{1}{2}{1} = [2 5 6 7; 7 5 4 2;  2 3 4 7; 1 2 4 5 ; 4 7 8 5];
    ind_mat_1{1}{2}{2} = [6 2 1 3; 1 3 8 6; 8 7 6 3;  5 8 6 1; 3 8 4 1 ];
    ind_mat_1{2}{2}{2} = [5 2 1 4; 4 2 7 5; 5 8 7 4;  5 7 6 2;  3 7 4 2];
    ind_mat_1{2}{2}{1} = [1 5 6 8; 6 8 3 1; 3 4 1 8; 2 3 1 6 ; 3 7 8 6  ];
    ind_mat_1{1}{1}{2} = [4 3 7 2; 2 7 4 5;  5 7 6 2; 1 5 2 4;  8 7 5 4 ];
    ind_mat_1{2}{1}{2} = [3 6 8 1; 1 3 4 8; 5 8 6 1; 1 6 2 3  ; 8 7 6 3  ];
    ind_mat_1{1}{1}{1} = [7 8 3 6; 8 1 3 6; 2 3 1 6;  1 5 6 8 ; 1 3 4 8   ];
    ind_mat_1{2}{1}{1} = [ 7 8 4 5; 5 4 7 2;  2 4 1 5; 2 5 6 7   ;  2 3 4 7 ];

    tetra = zeros(5*n_cubes,4);
    if isequal(eval('zef.mesh_labeling_approach'),1)
        label_ind = zeros(5*n_cubes,8);
    elseif isequal(eval('zef.mesh_labeling_approach'),2)
        label_ind = zeros(5*n_cubes,4);
    end
    nodes = [X(:) Y(:) Z(:)];
    i = 1;

    for i_x = 1 : size(X,2) - 1
        zef_waitbar(i_x,(size(X,2)-1),h,'Initial mesh.');
        for i_y = 1 : size(X,1) - 1
            for i_z = 1 : size(X,3) - 1

                x_ind = [i_x   i_x+1  i_x+1  i_x    i_x    i_x+1  i_x+1  i_x]';
                y_ind = [i_y   i_y    i_y+1  i_y+1  i_y    i_y    i_y+1  i_y+1]';
                z_ind = [i_z   i_z    i_z    i_z    i_z+1  i_z+1  i_z+1  i_z+1]';
                ind_mat_2 = sub2ind(size_xyz,y_ind,x_ind,z_ind);

                tetra(i:i+4,:) = ind_mat_2(ind_mat_1{2-mod(i_x,2)}{2-mod(i_y,2)}{2-mod(i_z,2)});
                if isequal(eval('zef.mesh_labeling_approach'),1)
                    label_ind(i:i+4,:) = ind_mat_2(:,ones(5,1))';
                elseif isequal(eval('zef.mesh_labeling_approach'),2)
                    label_ind(i:i+4,:) = ind_mat_2(ind_mat_1{2-mod(i_x,2)}{2-mod(i_y,2)}{2-mod(i_z,2)});
                end
                i = i + 5;

            end
        end
    end

    %************************************************************

elseif isequal(eval('zef.initial_mesh_mode'),2)

    ind_mat_1 = [     3     4     1     7 ;
        2     3     1     7 ;
        1     2     7     6 ;
        7     1     6     5 ;
        7     4     1     8 ;
        7     8     1     5  ];

    tetra = zeros(6*n_cubes,4);
    if isequal(eval('zef.mesh_labeling_approach'),1)
        label_ind = zeros(6*n_cubes,8);
    elseif isequal(eval('zef.mesh_labeling_approach'),2)
        label_ind = zeros(6*n_cubes,4);
    end
    nodes = [X(:) Y(:) Z(:)];
    i = 1;

    for i_x = 1 : size(X,2) - 1
        zef_waitbar(i_x,(size(X,2)-1),h,'Initial mesh.');
        for i_y = 1 : size(X,1) - 1
            for i_z = 1 : size(X,3) - 1

                x_ind = [i_x   i_x+1  i_x+1  i_x    i_x    i_x+1  i_x+1  i_x]';
                y_ind = [i_y   i_y    i_y+1  i_y+1  i_y    i_y    i_y+1  i_y+1]';
                z_ind = [i_z   i_z    i_z    i_z    i_z+1  i_z+1  i_z+1  i_z+1]';
                ind_mat_2 = sub2ind(size_xyz,y_ind,x_ind,z_ind);

                tetra(i:i+5,:) = ind_mat_2(ind_mat_1);
                if isequal(eval('zef.mesh_labeling_approach'),1)
                    label_ind(i:i+5,:) = ind_mat_2(:,ones(6,1))';
                elseif isequal(eval('zef.mesh_labeling_approach'),2)
                    label_ind(i:i+5,:) = ind_mat_2(ind_mat_1);
                end;
                i = i + 6;

            end
        end
    end

end

%************************************************************

clear X Y Z;

n_parallel = zef.parallel_processes;
    if isempty(gcp('nocreate'))
        parpool(n_parallel);
    else
        h_pool = gcp;
        if not(isequal(h_pool.NumWorkers,n_parallel))
            delete(h_pool)
            parpool(n_parallel);
        end
    end

refinement_surface_on = zef.refinement_surface_on;
n_surface_refinement = zef.refinement_surface_number;
refinement_surface_compartments = zef.refinement_surface_compartments;
refinement_volume_on = zef.refinement_volume_on;
n_volume_refinement = zef.refinement_volume_number;
refinement_volume_compartments = zef.refinement_volume_compartments;

refinement_flag = 1;

labeling_flag = 1;
zef_mesh_labeling_step;

refinement_compartments_aux = refinement_surface_compartments;

refinement_compartments = [];
if ismember(-1,refinement_compartments_aux)
    refinement_compartments = aux_active_compartment_ind(:);
end

refinement_compartments_aux = setdiff(refinement_compartments_aux,-1);
refinement_compartments = [refinement_compartments ; refinement_compartments_aux(:)];

if eval('zef.refinement_on')

    if refinement_surface_on
        if length(n_surface_refinement) == 1

            for i_surface_refinement = 1 : n_surface_refinement

                zef_refinement_step;

                if eval('zef.mesh_relabeling')

                    pml_ind = [];
                    label_ind = uint32(tetra);
                    labeling_flag = 2;
                    zef_mesh_labeling_step;

                end
            end

        else

            for j_surface_refinement = 1 : length(n_surface_refinement)
                for i_surface_refinement = 1 : n_surface_refinement(j_surface_refinement)

                    zef_refinement_step;

                    if eval('zef.mesh_relabeling')
                        pml_ind = [];
                        label_ind = uint32(tetra);
                        labeling_flag = 2;
                        zef_mesh_labeling_step;

                    end
                end
            end
        end

else

    if eval('zef.mesh_relabeling')
    pml_ind = [];
    label_ind = uint32(tetra);
    labeling_flag = 2;
    zef_mesh_labeling_step;

    end

end

if eval('zef.refinement_on')
    if refinement_volume_on

        n_refinement = n_volume_refinement;
        refinement_compartments_aux = refinement_volume_compartments;

        refinement_compartments = [];
        if ismember(-1,refinement_compartments_aux)
            refinement_compartments = aux_active_compartment_ind(:);
        end

        refinement_compartments_aux = setdiff(refinement_compartments_aux,-1);
        refinement_compartments = [refinement_compartments ; refinement_compartments_aux(:)];

        if length(n_refinement) == 1

            zef_waitbar(0,1,h,'Volume refinement.');

            for i = 1 : n_refinement

                [nodes,tetra,domain_labels] = zef_mesh_refinement(zef,nodes,tetra,domain_labels,zef_compartment_to_subcompartment(zef,refinement_compartments));
                zef_waitbar(i,n_refinement,h,'Volume refinement.');

                if eval('zef.mesh_relabeling')

                    pml_ind = [];
                    label_ind = uint32(tetra);
                    labeling_flag = 2;
                    zef_mesh_labeling_step;


                end
            end

        else

            zef_waitbar(0,length(n_refinement),h,'Volume refinement.');

            for j = 1 : length(n_refinement)
                for i = 1 : n_refinement(j)

                    [nodes,tetra,domain_labels] = zef_mesh_refinement(zef,nodes,tetra,domain_labels,zef_compartment_to_subcompartment(zef,refinement_compartments(j)));

                    if eval('zef.mesh_relabeling')

                        pml_ind = [];
                        label_ind = uint32(tetra);
                        labeling_flag = 2;
                        zef_mesh_labeling_step;

                    end

                    zef_waitbar(i,length(n_refinement(j)),h,'Volume refinement.');

                end
            end

        end

    end

end

    %*********************
    if eval('zef.adaptive_refinement_on')

        n_refinement = eval('zef.adaptive_refinement_number');
        refinement_compartments_aux = sort(eval('zef.adaptive_refinement_compartments'));

        refinement_compartments = [];
        if ismember(-1,refinement_compartments_aux)
            refinement_compartments = aux_active_compartment_ind(:);
        end

        refinement_compartments_aux = setdiff(refinement_compartments_aux,-1);
        refinement_compartments = [refinement_compartments ; refinement_compartments_aux(:)];

        if length(n_refinement) == 1

            zef_waitbar(0,1,h,'Adaptive volume refinement.');

            for i = 1 : n_refinement
                k_param = eval('zef.adaptive_refinement_k_param');
                thresh_val  = eval('zef.adaptive_refinement_thresh_val');
                tetra_refine_ind = zef_get_tetra_to_refine(refinement_compartments, thresh_val, k_param, nodes, tetra,domain_labels,zef.reuna_p,zef.reuna_t);
                [nodes,tetra,domain_labels,tetra_interp_vec] = zef_mesh_refinement(zef,nodes,tetra,domain_labels,zef_compartment_to_subcompartment(zef,refinement_compartments), tetra_refine_ind);
                tetra_refine_ind = find(ismember(tetra_interp_vec,tetra_refine_ind));
                zef_waitbar(i,n_refinement,h,'Adaptive volume refinement.');
                if eval('zef.mesh_relabeling')

                    pml_ind = [];
                    label_ind = uint32(tetra);
                    labeling_flag = 2;
                    zef_mesh_labeling_step;

                end
            end

        else

            zef_waitbar(0,length(n_refinement),h,'Adaptive volume refinement.');

            for j = 1 : length(n_refinement)
                for i = 1 : n_refinement(j)

                    k_param = eval('zef.adaptive_refinement_k_param');
                    thresh_val  = eval('zef.adaptive_refinement_thresh_val');
                    tetra_refine_ind = zef_get_tetra_to_refine(refinement_compartments(j), thresh_val, k_param, nodes, tetra,domain_labels,zef.reuna_p,zef.reuna_t);
                    [nodes,tetra,domain_labels,tetra_interp_vec] = zef_mesh_refinement(zef,nodes,tetra,domain_labels,zef_compartment_to_subcompartment(zef,refinement_compartments(j)),tetra_refine_ind);
                    tetra_refine_ind = find(ismember(tetra_interp_vec,tetra_refine_ind));

                    if eval('zef.mesh_relabeling')

                        pml_ind = [];
                        label_ind = uint32(tetra);
                        labeling_flag = 2;
                        zef_mesh_labeling_step;

                    end

                    zef_waitbar(i,length(n_refinement(j)),h,'Adaptive volume refinement.');

                end
            end

        end

    end
    %*********************

end

if isequal(zef.priority_mode,3)
    if zef.mesh_relabeling
    pml_ind = [];
    label_ind = uint32(tetra);
    labeling_flag = 3;
    zef_mesh_labeling_step;
    end
end


zef.nodes = nodes;
zef.tetra = double(tetra);
zef.domain_labels = double(domain_labels);
zef.name_tags = name_tags;
zef.domain_labels_with_subdomains = double(domain_labels);

close(h);

if nargout == 0
    assignin('base','zef',zef);
end

end
