function self = downsample_surfaces(self)

    % downsample_surfaces
    %
    % Downsamples the surfaces of a contained finite element mesh.

    arguments
        self zef_as_class.Zef
    end

    % Initialize waitbar and add a cleanup object to make it disappear in case
    % of an interruption.

    number_of_compartments = length(self.compartments);

    if self.use_gui

        wb = waitbar(0,'Resampling surfaces.');

        cu_fn = @(h) close(h);

        cu_obj = onCleanup(@() cu_fn(wb));

    else

        wb = zef_as_class.TerminalWaitbar('Resampling surfaces', number_of_compartments);

    end

    % Start actual downsampling.

    temp_time = now;

    for zef_k = 1 : number_of_compartments

        compartment = self.compartments(zef_k);

        temp_patch_data = struct;

        if compartment.is_on

            if not(isempty(compartment.points_original_surface_mesh))

                temp_patch_data.vertices_all = compartment.points_original_surface_mesh;
                temp_patch_data.faces_all = compartment.triangles_original_surface_mesh;
                temp_patch_data.submesh_ind = compartment.submesh_ind_original_surface_mesh;

            else

                temp_patch_data.vertices_all = compartment.points;
                temp_patch_data.faces_all = compartment.triangles;
                temp_patch_data.submesh_ind = compartment.submesh_ind;

                self.compartments(zef_k).points_original_surface_mesh = ...
                    compartment.points;
                self.compartments(zef_k).triangles_original_surface_mesh = ...
                    compartment.triangles;
                self.compartments(zef_k).submesh_ind_original_surface_mesh = ...
                    compartmment.submesh_ind;

            end % if

            compartment.points_inf = [];
            compartment.points = [];
            compartment.triangles = [];

            if not(isempty(compartment.submesh_ind))

                zef_i = 0;

                for zef_j = 1 : length(temp_patch_data.submesh_ind)

                    zef_i = zef_i + 1;

                    temp_patch_data.faces = temp_patch_data.faces_all(zef_i : temp_patch_data.submesh_ind(zef_j),:);

                    temp_patch_data.vertice_ind_aux = zeros(size(temp_patch_data.vertices_all,1),1);

                    temp_patch_data.unique_faces_ind = unique(temp_patch_data.faces);

                    temp_patch_data.vertice_ind_aux(temp_patch_data.unique_faces_ind) = [1:length(temp_patch_data.unique_faces_ind)];

                    temp_patch_data.faces = temp_patch_data.vertice_ind_aux(temp_patch_data.faces);

                    temp_patch_data.vertices = temp_patch_data.vertices_all(temp_patch_data.unique_faces_ind,:);

                    temp_patch_data_aux = zef_as_class.Zef.set_surface_resolution( ...
                        self, ...
                        temp_patch_data, ...
                        self.data.max_surface_face_count ...
                    );

                    temp_patch_data_aux.vertices = zef_as_class.Zef.smooth_surface( ...
                        temp_patch_data_aux.vertices, ...
                        temp_patch_data_aux.faces, ...
                        1e-2, 1 ...
                    );

                    if compartment.sources

                        if isempty(temp_patch_data_aux.vertices) || self.bypass_inflate

                            temp_patch_data_aux.vertices_inflated = [];

                        else

                            [temp_patch_data_aux.vertices_inflated] = self.inflate_surface( ...
                                temp_patch_data_aux.vertices, ...
                                temp_patch_data_aux.faces ...
                            );

                        end

                        self.compartments(zef_k).points_inf = [
                            compartment.points_inf ;
                            temp_patch_data_aux.vertices_inflated
                        ];

                    end

                    self.compartments(zef_k).triangles = [
                        compartment.triangles ;
                        temp_patch_data_aux.faces + size(compartment.points,1)
                    ];

                    self.compartments(zef_k).points = [
                        compartment.points ;
                        temp_patch_data_aux.vertices
                    ];

                    zef_i = temp_patch_data.submesh_ind(zef_j);

                    self.compartments(zef_k).submesh_ind(zef_j) = ...
                        size(self.compartments(zef_k).triangles, 1);

                end % for

            else

                temp_patch_data.faces = temp_patch_data.faces_all;

                temp_patch_data.vertices = temp_patch_data.vertices_all;

                temp_patch_data_aux = zef_as_class.Zef.set_surface_resolution(temp_patch_data,self.max_surface_face_count);

                temp_patch_data_aux.vertices = zef_as_class.Zef.smooth_surface(temp_patch_data_aux.vertices,temp_patch_data_aux.faces,1e-2,1);

                if self.data.(sources_name) > 0

                    temp_patch_data_aux.vertices_inflated = self.inflate_surface( ...
                        temp_patch_data_aux.vertices, ...
                        temp_patch_data_aux.faces ...
                    );

                    self.compartments(zef_k).points_inf = [
                        compartment.points_inf ;
                        temp_patch_data_aux.vertices_inflated
                    ];

                end

                self.compartments(zef_k).points = [
                    compartment.points ;
                    temp_patch_data_aux.vertices
                ];

                self.compartments(zef_k).triangles = [
                    compartment.triangles ;
                    temp_patch_data_aux.faces
                ];

            end % if

        end % if

        % Update waitbar.

        if self.use_gui

            waitbar( ...
                zef_k / number_of_compartments, ...
                wb, ...
                ['Resampling surfaces. Ready approx.: ' datestr(now + (number_of_compartments-zef_k)*(now-temp_time)/zef_k) '.'] ...
            );

        else

            wb = wb.progress();

        end

    end % for

end
