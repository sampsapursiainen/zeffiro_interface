function zef = zef_downsample_surfaces(zef)

if nargin == 0
    zef = evalin('base','zef');
end

zef.h = zef_waitbar(0,1,'Resampling surfaces.');
zef.temp_time = now;
relative_resolution_vec = zef_find_relative_resolution(zef);
zef.number_of_compartments = length(zef.compartment_tags);
active_compartment_ind = 0;

for zef_k = 1 : zef.number_of_compartments
    zef.temp_var_0 = zef.compartment_tags{zef_k};

    if zef.([zef.temp_var_0 '_on'])

        zef.temp_patch_data.scaling = eval(['zef.' zef.temp_var_0 '_scaling;']);

        if eval(['zef.' zef.temp_var_0 '_on'])
            active_compartment_ind = active_compartment_ind + 1;
            if eval(['isfield(zef,"' zef.temp_var_0 '_points_original_surface_mesh")'])
                if eval(['not(isempty(zef.' zef.temp_var_0 '_points_original_surface_mesh))'])
                    zef.temp_patch_data.vertices_all = eval(['zef.' zef.temp_var_0 '_points_original_surface_mesh;']);
                    zef.temp_patch_data.faces_all = eval(['zef.' zef.temp_var_0 '_triangles_original_surface_mesh;']);
                    zef.temp_patch_data.submesh_ind = eval(['zef.' zef.temp_var_0 '_submesh_ind_original_surface_mesh;']);
                else
                    zef.temp_patch_data.vertices_all = eval(['zef.' zef.temp_var_0 '_points;']);
                    zef.temp_patch_data.faces_all = eval(['zef.' zef.temp_var_0 '_triangles;']);
                    zef.temp_patch_data.submesh_ind = eval(['zef.' zef.temp_var_0 '_submesh_ind;']);
                    eval(['zef.' zef.temp_var_0 '_points_original_surface_mesh = zef.' zef.temp_var_0 '_points;']);
                    eval(['zef.' zef.temp_var_0 '_triangles_original_surface_mesh = zef.' zef.temp_var_0 '_triangles;']);
                    eval(['zef.' zef.temp_var_0 '_submesh_ind_original_surface_mesh = zef.' zef.temp_var_0 '_submesh_ind;']);
                end
            else
                zef.temp_patch_data.vertices_all = eval(['zef.' zef.temp_var_0 '_points;']);
                zef.temp_patch_data.faces_all = eval(['zef.' zef.temp_var_0 '_triangles;']);
                zef.temp_patch_data.submesh_ind = eval(['zef.' zef.temp_var_0 '_submesh_ind;']);
                eval(['zef.' zef.temp_var_0 '_points_original_surface_mesh = zef.' zef.temp_var_0 '_points;']);
                eval(['zef.' zef.temp_var_0 '_triangles_original_surface_mesh = zef.' zef.temp_var_0 '_triangles;']);
                eval(['zef.' zef.temp_var_0 '_submesh_ind_original_surface_mesh = zef.' zef.temp_var_0 '_submesh_ind;']);

            end

            eval(['zef.' zef.temp_var_0 '_points_inf = [];']);
            eval(['zef.' zef.temp_var_0 '_points = [];']);
            eval(['zef.' zef.temp_var_0 '_triangles = [];']);

            if eval(['not(isempty(zef.' zef.temp_var_0 '_submesh_ind));'])
                zef_i = 0;
                for zef_j = 1 : length(zef.temp_patch_data.submesh_ind)
                    zef_i = zef_i + 1;
                    zef.temp_patch_data.faces = zef.temp_patch_data.faces_all(zef_i : zef.temp_patch_data.submesh_ind(zef_j),:);
                    zef.temp_patch_data.vertice_ind_aux = zeros(size(zef.temp_patch_data.vertices_all,1),1);
                    zef.temp_patch_data.unique_faces_ind = unique(zef.temp_patch_data.faces);
                    zef.temp_patch_data.vertice_ind_aux(zef.temp_patch_data.unique_faces_ind) = [1:length(zef.temp_patch_data.unique_faces_ind)];
                    zef.temp_patch_data.faces = zef.temp_patch_data.vertice_ind_aux(zef.temp_patch_data.faces);
                    zef.temp_patch_data.vertices = zef.temp_patch_data.vertices_all(zef.temp_patch_data.unique_faces_ind,:);
                    zef.temp_patch_data_aux = zef_set_surface_resolution(zef,zef.temp_patch_data,zef.max_surface_face_count*relative_resolution_vec(active_compartment_ind));
                    zef.temp_patch_data_aux.vertices = zef_smooth_surface(zef.temp_patch_data_aux.vertices,zef.temp_patch_data_aux.faces,1e-2,1);
                    if eval(['zef.' zef.temp_var_0 '_sources'])
                        if isempty(zef.temp_patch_data_aux.vertices) || zef.bypass_inflate
                            zef.temp_patch_data_aux.vertices_inflated = [];
                        else
                            [zef.temp_patch_data_aux.vertices_inflated] = zef_inflate_surface(zef,zef.temp_patch_data_aux.vertices,zef.temp_patch_data_aux.faces);
                        end
                        eval(['zef.' zef.temp_var_0 '_points_inf = [zef.' zef.temp_var_0 '_points_inf ;  zef.temp_patch_data_aux.vertices_inflated];']);
                    end
                    eval(['zef.' zef.temp_var_0 '_triangles = [zef.' zef.temp_var_0 '_triangles; zef.temp_patch_data_aux.faces+size(zef.' zef.temp_var_0 '_points,1)];']);
                    eval(['zef.' zef.temp_var_0 '_points = [zef.' zef.temp_var_0 '_points ;  zef.temp_patch_data_aux.vertices];']);
                    zef_i = zef.temp_patch_data.submesh_ind(zef_j);
                    eval(['zef.' zef.temp_var_0 '_submesh_ind(' int2str(zef_j) ') = size(zef.' zef.temp_var_0 '_triangles,1);']);
                end
            else
                zef.temp_patch_data.faces = zef.temp_patch_data.faces_all;
                zef.temp_patch_data.vertices = zef.temp_patch_data.vertices_all;
                zef.temp_patch_data_aux = zef_set_surface_resolution(zef,zef.temp_patch_data,zef.max_surface_face_count*relative_resolution_vec(active_compartment_ind));
                zef.temp_patch_data_aux.vertices = zef_smooth_surface(zef.temp_patch_data_aux.vertices,zef.temp_patch_data_aux.faces,1e-2,1);
                if eval(['zef.' zef.temp_var_0 '_sources']) > 0
                    zef.temp_patch_data_aux.vertices_inflated = zef_inflate_surface(zef,zef.temp_patch_data_aux.vertices,zef.temp_patch_data_aux.faces);
                    eval(['zef.' zef.temp_var_0 '_points_inf = [zef.' zef.temp_var_0 '_points_inf ;  zef.temp_patch_data_aux.vertices_inflated];']);
                end
                eval(['zef.' zef.temp_var_0 '_points = [zef.' zef.temp_var_0 '_points ;  zef.temp_patch_data_aux.vertices];']);
                eval(['zef.' zef.temp_var_0 '_triangles = [zef.' zef.temp_var_0 '_triangles; zef.temp_patch_data_aux.faces];']);
            end
        end

        zef_waitbar(zef_k,zef.number_of_compartments,zef.h,['Resampling surfaces. Ready approx.: ' datestr(now + (zef.number_of_compartments-zef_k)*(now-zef.temp_time)/zef_k) '.'] );

    end
end

close(zef.h);

if isfield(zef,'temp_patch_data')
    zef = rmfield(zef,'temp_patch_data');
end

if isfield(zef,'temp_patch_data_aux')
    zef = rmfield(zef,'temp_patch_data_aux');
end

if isfield(zef,'temp_var_0')
    zef = rmfield(zef,'temp_var_0');
end

if isfield(zef,'temp_time')
    zef = rmfield(zef,'temp_time');
end

clear zef_i zef_j zef_k

if nargout == 0
    assignin('base','zef',zef);
end

end
