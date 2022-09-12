function self = build_initial_mesh(self, initial_mesh_mode, mesh_labeling_approach)

    % Zef.build_initial_mesh
    %
    % Builds an initial finite element mesh from a segmentation.
    %
    % Inputs:
    %
    % - self
    %
    %   The instance of Zef calling this method.
    %
    % - initial_mesh_mode (optional)
    %
    %   Defines the mode in which the mesh is built in. Must be one of 1 or 2.
    %
    %   default = 1
    %
    % - mesh_labeling_approach (optional)
    %
    %   Defines how the mesh is to be labeled later on. Needed here in
    %   preparation for labeling. Must be one of 1 or 2.
    %
    %   default = 1
    %
    % Outputs:
    %
    % - self
    %
    %   The instance of Zef that called this method.

    arguments

        self zef_as_class.Zef

        initial_mesh_mode (1,1) double { mustBeMember(initial_mesh_mode, [1,2]) } = 1;

        mesh_labeling_approach (1,1) double { mustBeMember(mesh_labeling_approach, [1,2]) } = 1;

    end

    % Set initial values.

    self.initial_mesh_mode = initial_mesh_mode;

    self.mesh_labeling_approach = mesh_labeling_approach;

    % Perform segmentation count.

    self = self.segmentation_counter_step();

    % Determine mesh limits in a Cartesian system.

    x_lim = [0 0];
    y_lim = [0 0];
    z_lim = [0 0];

    n_compartments = 0;

    for k = 1 : length(self.compartments)

        compartment = self.compartments(k);

        n_compartments = n_compartments + max(1,length(compartment.submesh_ind));

        reuna_p = compartment.points;

        if not(isequal(compartment.sources,-1))
            x_lim = [min(x_lim(1),min(reuna_p(:,1))) max(x_lim(2),max(reuna_p(:,1)))];
            y_lim = [min(y_lim(1),min(reuna_p(:,2))) max(y_lim(2),max(reuna_p(:,2)))];
            z_lim = [min(z_lim(1),min(reuna_p(:,3))) max(z_lim(2),max(reuna_p(:,3)))];
        end

    end % for

    % Generate a grid based on the limits and the mesh resolution, either as
    % cubes or perfectly matched layers (PML).

    mesh_res = self.mesh_resolution;

    if isempty(self.data.pml_ind_aux)

        x_vec = [x_lim(1):mesh_res:x_lim(2)];
        y_vec = [y_lim(1):mesh_res:y_lim(2)];
        z_vec = [z_lim(1):mesh_res:z_lim(2)];

        [X, Y, Z] = meshgrid(x_vec,y_vec,z_vec);

        n_cubes = (length(x_vec)-1)*(length(y_vec)-1)*(length(z_vec)-1);

    else

        pml_inner_radius = max(abs([x_lim(:); y_lim(:); z_lim(:)]));
        pml_outer_radius_unit = self.pml_outer_radius_unit;
        pml_outer_radius = self.pml_outer_radius;
        pml_max_size_unit = self.pml_max_size_unit;
        pml_max_size = self.pml_max_size;

        if isequal(pml_outer_radius_unit,1)
            pml_outer_radius = pml_inner_radius*pml_outer_radius;
        end

        if isequal(pml_max_size_unit,1)
            pml_max_size = mesh_res*pml_max_size;
        end

        [X, Y, Z, pml_ind] = pml_mesh(pml_inner_radius,pml_outer_radius,mesh_res,pml_max_size);

        n_cubes = prod(size(X)-1);

    end % if

    if self.use_gui

        wb = waitbar(0,'Initial mesh.');

        cleanup_fn = @(h) close(h);

        cleanup_obj = onCleanup(@() cleanup_fn(wb));

    else

        wb = zef_as_class.TerminalWaitbar("Initial mesh", size(X,2) - 1);

    end

    size_xyz = size(X);

    % Initialize waitbar and cleanup object.

    % Routine start.

    if self.initial_mesh_mode == 1

        ind_mat_1{1}{2}{1} = [ 2 5 6 7 ; 7 5 4 2 ; 2 3 4 7 ; 1 2 4 5 ; 4 7 8 5 ];
        ind_mat_1{1}{2}{2} = [ 6 2 1 3 ; 1 3 8 6 ; 8 7 6 3 ; 5 8 6 1 ; 3 8 4 1 ];
        ind_mat_1{2}{2}{2} = [ 5 2 1 4 ; 4 2 7 5 ; 5 8 7 4 ; 5 7 6 2 ; 3 7 4 2 ];
        ind_mat_1{2}{2}{1} = [ 1 5 6 8 ; 6 8 3 1 ; 3 4 1 8 ; 2 3 1 6 ; 3 7 8 6 ];
        ind_mat_1{1}{1}{2} = [ 4 3 7 2 ; 2 7 4 5 ; 5 7 6 2 ; 1 5 2 4 ; 8 7 5 4 ];
        ind_mat_1{2}{1}{2} = [ 3 6 8 1 ; 1 3 4 8 ; 5 8 6 1 ; 1 6 2 3 ; 8 7 6 3 ];
        ind_mat_1{1}{1}{1} = [ 7 8 3 6 ; 8 1 3 6 ; 2 3 1 6 ; 1 5 6 8 ; 1 3 4 8 ];
        ind_mat_1{2}{1}{1} = [ 7 8 4 5 ; 5 4 7 2 ; 2 4 1 5 ; 2 5 6 7 ; 2 3 4 7 ];

        tetra = zeros(5*n_cubes,4);

        if isequal(self.mesh_labeling_approach,1)

            label_ind = zeros(5*n_cubes,8);

        elseif isequal(self.mesh_labeling_approach, 2)

            label_ind = zeros(5*n_cubes,4);

        else

            error("Unknown mesh labeling approach.");

        end

    elseif self.initial_mesh_mode == 2

        ind_mat_1 = [
            3     4     1     7 ;
            2     3     1     7 ;
            1     2     7     6 ;
            7     1     6     5 ;
            7     4     1     8 ;
            7     8     1     5
        ];

        tetra = zeros(6*n_cubes,4);

        if isequal(self.mesh_labeling_approach,1)

            label_ind = zeros(6*n_cubes,8);

        elseif isequal(self.mesh_labeling_approach, 2)

            label_ind = zeros(6*n_cubes,4);

        else

            error("Unknown mesh labeling approach.");

        end

    else

        error("Unknown initial mesh mode.")

    end

    nodes = [X(:) Y(:) Z(:)];

    i = 1;

    size_xyz = size(X);

    for i_x = 1 : size(X,2) - 1

        if self.use_gui

            waitbar(i_x/(size(X,2)-1),wb,'Initial mesh.');

        else

            wb = wb.progress();

        end

        for i_y = 1 : size(X,1) - 1

            for i_z = 1 : size(X,3) - 1

                x_ind = [i_x   i_x+1  i_x+1  i_x    i_x    i_x+1  i_x+1  i_x]';
                y_ind = [i_y   i_y    i_y+1  i_y+1  i_y    i_y    i_y+1  i_y+1]';
                z_ind = [i_z   i_z    i_z    i_z    i_z+1  i_z+1  i_z+1  i_z+1]';

                ind_mat_2 = sub2ind(size_xyz,y_ind,x_ind,z_ind);

                if self.initial_mesh_mode == 1

                    tetra(i:i+4,:) = ind_mat_2(ind_mat_1{2-mod(i_x,2)}{2-mod(i_y,2)}{2-mod(i_z,2)});

                    if isequal(self.mesh_labeling_approach, 1)

                        label_ind(i:i+4,:) = ind_mat_2(:,ones(5,1))';

                    elseif isequal(self.mesh_labeling_approach, 2)

                        label_ind(i:i+4,:) = ind_mat_2(ind_mat_1{2-mod(i_x,2)}{2-mod(i_y,2)}{2-mod(i_z,2)});

                    else

                        error("Unknown mesh labeling approach.");

                    end

                    i = i + 5;

                elseif self.initial_mesh_mode == 2

                    tetra(i:i+5,:) = ind_mat_2(ind_mat_1);

                    if isequal(self.mesh_labeling_approach, 1)

                        label_ind(i:i+5,:) = ind_mat_2(:,ones(6,1))';

                    elseif isequal(self.mesh_labeling_approach, 2)

                        label_ind(i:i+5,:) = ind_mat_2(ind_mat_1);

                    else

                        error("Unknown mesh labeling approach.");

                    end;

                    i = i + 6;

                else

                    error("Unknown initial mesh mode.");

                end

            end % for

        end % for

    end % for

    self.nodes = nodes;

    self.tetra = tetra;

    self.label_ind = label_ind;

    self.pml_ind = pml_ind;

end

%% Local helper functions.

function [X, Y, Z, pml_ind] = pml_mesh(inner_radius,outer_radius,lattice_size,max_size)

    % pml_mesh
    %
    % TODO
    %
    % Inputs:
    %
    % - inner_radius
    %
    % - outer_radius
    %
    % - lattice_size
    %
    % - max_size
    %
    % Outputs:
    %
    % - X
    %
    % - Y
    %
    % - Z
    %
    % - pml_ind

    arguments
        inner_radius (1,1) double { mustBePositive }
        outer_radius (1,1) double { mustBePositive }
        lattice_size (1,1) double { mustBePositive }
        max_size     (1,1) double { mustBePositive }
    end

    growth_param = 1 + 1e-15;

    convergence_value = Inf;

    while convergence_value > 1e-5

        extra_layers = round(log(((outer_radius-inner_radius)*(growth_param - 1))/(lattice_size*growth_param) + 1)/log(growth_param));

        growth_param_new = exp(log(max_size/lattice_size)/extra_layers);

        convergence_value = abs(max_size - lattice_size*growth_param^extra_layers)/max_size;

        growth_param = growth_param_new;

    end

    extra_layers = round(log(((outer_radius-inner_radius)*(growth_param - 1))/(lattice_size*growth_param) + 1)/log(growth_param));

    intermediate_radius = extra_layers*lattice_size + inner_radius;

    [X,Y,Z] = meshgrid([-intermediate_radius:2*intermediate_radius/(round(2*intermediate_radius/lattice_size)):intermediate_radius]);

    I_X = find(abs(X) > inner_radius);
    I_Y = find(abs(Y) > inner_radius);
    I_Z = find(abs(Z) > inner_radius);

    pml_ind = unique([I_X(:); I_Y(:) ; I_Z(:)]);

    R_aux = max(abs([X(pml_ind) Y(pml_ind) Z(pml_ind)]),[],2);

    N = round((R_aux - inner_radius)/lattice_size);

    X_inner = inner_radius.*X(pml_ind)./R_aux;
    Y_inner = inner_radius.*Y(pml_ind)./R_aux;
    Z_inner = inner_radius.*Z(pml_ind)./R_aux;

    R_new = inner_radius + lattice_size.*growth_param*(1-growth_param.^N)./(1-growth_param);

    R_old = inner_radius + N*lattice_size;

    X(pml_ind) = R_new.*X(pml_ind)./R_old;
    Y(pml_ind) = R_new.*Y(pml_ind)./R_old;
    Z(pml_ind) = R_new.*Z(pml_ind)./R_old;

    s = max(abs([X(:) ; Y(:); Z(:)]));
    X = outer_radius*X/s;
    Y = outer_radius*Y/s;
    Z = outer_radius*Z/s;

end
