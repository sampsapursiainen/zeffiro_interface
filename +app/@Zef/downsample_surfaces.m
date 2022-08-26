function self = downsample_surfaces(self)

    % downsample_surfaces
    %
    % Downsamples the surfaces of a contained finite element mesh.

    arguments
        self app.Zef
    end

    % Initialize waitbar and add a cleanup object to make it disappear in case
    % of an interruption.

    wb = waitbar(0,'Resampling surfaces.');

    cu_fn = @(h) close(h);

    cu_obj = onCleanup(@() cu_fn(wb));

    % Start actual downsampling.

    temp_time = now;

    number_of_compartments = length(self.compartment_tags);

    for zef_k = 1 : number_of_compartments

        temp_patch_data = struct;

        current_compartment_tag = self.compartment_tags{zef_k};

        compartment_on_name = [ current_compartment_tag '_on' ];

        if self.data.(compartment_on_name)

            % Construct field names for querying self.data.

            orig_points_name = [current_compartment_tag '_points_original_surface_mesh'];

            orig_triangles_name = [current_compartment_tag '_triangles_original_surface_mesh'];

            orig_submesh_name = [current_compartment_tag '_submesh_ind_original_surface_mesh'];

            points_name = [current_compartment_tag '_points'];

            triangles_name = [current_compartment_tag '_triangles'];

            submesh_ind_name = [current_compartment_tag '_submesh_ind'];

            points_inf_name = [current_compartment_tag '_points_inf'];

            sources_name = [current_compartment_tag '_sources'];

            % Index into self.data with the names.

            if isfield(self.data, orig_points_name)

                if not(isempty(self.data.(orig_points_name)))

                    temp_patch_data.vertices_all = self.data.(orig_points_name);
                    temp_patch_data.faces_all = self.data.(orig_triangles_name);
                    temp_patch_data.submesh_ind = self.data.(orig_submesh_name);

                else

                    temp_patch_data.vertices_all = self.data.(points_name);
                    temp_patch_data.faces_all = self.data.(triangles_name);
                    temp_patch_data.submesh_ind = self.data.(submesh_name);

                    self.data(1).(orig_points_name) = self.data(points_name);
                    self.data(1).(orig_triangles_name) = self.data(triangles_name);
                    self.data(1).(orig_submesh_ind_name) = self.data.(submesh_ind_name);

                end % if

            else

                temp_patch_data.vertices_all = self.data.(points_name);
                temp_patch_data.faces_all = self.data.(triangles_name);
                temp_patch_data.submesh_ind = self.data.(submesh_ind_name);

                self.data(1).(orig_points_name) = self.data(points_name);
                self.data(1).(orig_triangles_name) = self.data(triangles_name);
                self.data(1).(orig_submesh_ind_name) = self.data.(submesh_ind_name);

            end % if

            self.data(1).(points_inf_name) = [];
            self.data(1).(points_name) = [];
            self.data(1).(triangles_name) = [];

            if not(isempty(self.data.(submesh_ind_name)))

                zef_i = 0;

                for zef_j = 1 : length(temp_patch_data.submesh_ind)

                    zef_i = zef_i + 1;

                    temp_patch_data.faces = temp_patch_data.faces_all(zef_i : temp_patch_data.submesh_ind(zef_j),:);

                    temp_patch_data.vertice_ind_aux = zeros(size(temp_patch_data.vertices_all,1),1);

                    temp_patch_data.unique_faces_ind = unique(temp_patch_data.faces);

                    temp_patch_data.vertice_ind_aux(temp_patch_data.unique_faces_ind) = [1:length(temp_patch_data.unique_faces_ind)];

                    temp_patch_data.faces = temp_patch_data.vertice_ind_aux(temp_patch_data.faces);

                    temp_patch_data.vertices = temp_patch_data.vertices_all(temp_patch_data.unique_faces_ind,:);

                    temp_patch_data_aux = app.Zef.set_surface_resolution( ...
                        self, ...
                        temp_patch_data, ...
                        self.data.max_surface_face_count ...
                    );

                    temp_patch_data_aux.vertices = zef_smooth_surface( ...
                        temp_patch_data_aux.vertices, ...
                        temp_patch_data_aux.faces, ...
                        1e-2, 1 ...
                    );

                    if self.data.(sources_name)

                        if isempty(temp_patch_data_aux.vertices) || self.bypass_inflate

                            temp_patch_data_aux.vertices_inflated = [];

                        else

                            [temp_patch_data_aux.vertices_inflated] = self.inflate_surface( ...
                                temp_patch_data_aux.vertices, ...
                                temp_patch_data_aux.faces ...
                            );

                        end

                        evalin('base',['self.' current_compartment_tag '_points_inf = [self.' current_compartment_tag '_points_inf ;  temp_patch_data_aux.vertices_inflated];']);

                        self.data.(points_inf_name) = [
                            self.data.(points_inf_name) ;
                            temp_patch_data_aux.vertices_inflated
                        ];

                    end

                    self.data.(triangles_name) = [
                        self.data.(triangles_name) ;
                        temp_patch_data_aux.faces + size(self.data.(points_name),1)
                    ];

                    self.data.(points_name) = [
                        self.data.(points_name) ;
                        temp_patch_data_aux.vertices
                    ];

                    zef_i = temp_patch_data.submesh_ind(zef_j);

                    self.data.(submesh_ind_name)(zef_j) = size(self.data.(triangles_name),1);

                end % for

            else

                temp_patch_data.faces = temp_patch_data.faces_all;

                temp_patch_data.vertices = temp_patch_data.vertices_all;

                temp_patch_data_aux = app.Zef.set_surface_resolution(temp_patch_data,self.max_surface_face_count);

                temp_patch_data_aux.vertices = app.Zef.smooth_surface(temp_patch_data_aux.vertices,temp_patch_data_aux.faces,1e-2,1);

                if self.data.(sources_name) > 0

                    temp_patch_data_aux.vertices_inflated = app.Zef.inflate_surface( ...
                        temp_patch_data_aux.vertices, ...
                        temp_patch_data_aux.faces ...
                    );

                    self.data.(points_inf_name) = [
                        self.data.(points_inf_name) ;
                        temp_patch_data_aux.vertices_inflated
                    ];

                end

                self.data.(points_name) = [
                    self.data.(points_name) ;
                    temp_patch_data_aux.vertices
                ];

                self.data.(triangles_name) = [
                    self.data.(triangles_name) ;
                    temp_patch_data_aux.faces
                ];

            end % if

        end % if

        % Update waitbar.

        waitbar( ...
            zef_k / number_of_compartments, ...
            wb, ...
            ['Resampling surfaces. Ready approx.: ' datestr(now + (number_of_compartments-zef_k)*(now-temp_time)/zef_k) '.'] ...
        );

    end % for

end
