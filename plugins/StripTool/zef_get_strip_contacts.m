function [contacts, sensor_info, triangle_ind] = zef_get_strip_contacts(contact_index,strip_struct,zef,domain_type,global_index)
%ZEF_GET_STRIP_CONTACTS  Contact triangles or points for one strip_model index.
%
%   Zeffiro Interface.
%   Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%   See: https://github.com/sampsapursiainen/zeffiro_interface
%   Licensed under the GNU General Public License v3.0 (see LICENSE).
%
%   [contacts, sensor_info, triangle_ind] = zef_get_strip_contacts(...)
%       contact_index, strip_struct, zef, domain_type, global_index)
%
%   domain_type default 'model_geometry'. 'points'/'model_points': xyz;
%   'sensor_info': empty contacts plus strip_id. Models 1/2/3 keep their
%   layouts. Models 4/5 place an 8-column DiSC lattice. Called from plot,
%   add_contacts, and sensor get_functions. Does not write zef.
%
%   See also zef_get_strip_parameters.

if nargin < 4
    domain_type = 'model_geometry';
end

if nargin < 5
    global_index = [];
end

contacts = [];
sensor_info = struct;
triangle_ind = [];
sensor_info.strip_id = strip_struct.strip_id;
sensor_info.compartment_index = [];
if isfield(strip_struct,'compartment_tag')
sensor_info.compartment_index = find(ismember(zef.compartment_tags,strip_struct.compartment_tag(1)),1);
end

if not(isequal(domain_type,'sensor_info'))

if ismember(domain_type,{'model_points','points'})

    contacts = zeros(1,3);

if isequal(strip_struct.strip_model,1)
contacts(3) = 2.25+2.0*(contact_index-1);
end

if isequal(strip_struct.strip_model,2)
    if contact_index == 1
        contact_index_aux = 1;
contacts(3) = 2.25+2.0*(contact_index_aux-1);
    elseif contact_index == 8
            contact_index_aux = 4;
contacts(3)=2.25+2.0*(contact_index_aux-1);
    elseif ismember(contact_index,[2:7])   
    if ismember(contact_index,[2 3 4])
            contact_index_aux = 2;
            direction_index_aux = contact_index - 1;
      elseif ismember(contact_index,[5 6 7])
            contact_index_aux = 3;
            direction_index_aux = contact_index - 4;
    end
contacts(3) = 2.25+2.0*(contact_index_aux-1);
[contacts(1), contacts(2)] = pol2cart(-pi/2 + + 2*pi/3*(direction_index_aux - 1), strip_struct.strip_radius);

if isequal(domain_type,{'points'})
compartment_ind = find(ismember(zef.compartment_tags,strip_struct.compartment_tag{1}),1);
I = find(zef.domain_labels <= compartment_ind);
triangles = zef_surface_mesh(tetra, nodes, I, gpu_mode);
[points_aux,triangles_aux] = zef_get_submesh(zef.nodes,triangles);
contacts = knnsearch(points_aux , contacts);
end

        end
end

if isequal(strip_struct.strip_model,3)
row_ind_aux = ceil(contact_index/4);
contacts(3) = 0.75+0.75*(row_ind_aux-1);
angle_aux = (2*pi/4)*mod(contact_index,4) + (pi/4)*mod(row_ind_aux,2);
[contacts(1), contacts(2)] = pol2cart(angle_aux,strip_struct.strip_radius);
end

if ismember(strip_struct.strip_model,[4 5])
% Shores et al. 2026 Fig. 1C / Fig. 8: 8 columns on a 0.8 mm shaft.
% Alternate rows shift by half a column (diamond). Row centers run from
% one pitch above the tip across a 7.5 mm span. Roll is strip_angle in
% zef_strip_coordinate_transform, not here.
[angle_aux, z_center_aux] = local_disc_site(contact_index, strip_struct.strip_model);
contacts(3) = z_center_aux;
[contacts(1), contacts(2)] = pol2cart(angle_aux,strip_struct.strip_radius);
end

contacts(1:3) = zef_strip_coordinate_transform(strip_struct,'forward',contacts(1:3));

end


if isequal(domain_type,'model_geometry')
triangles = strip_struct.triangles{1};
end

if isequal(domain_type,'geometry')
compartment_ind = find(ismember(zef.compartment_tags,strip_struct.compartment_tag{1}),1);
strip_struct.points{1} = zef.reuna_p{compartment_ind}; 
strip_struct.triangles{1} = zef.reuna_t{compartment_ind}; 
strip_struct.points = zef_strip_coordinate_transform(strip_struct,'reverse');
triangles = zef.reuna_t{compartment_ind};
end

if isequal(domain_type,'mesh')

compartment_ind = find(ismember(zef.compartment_tags,strip_struct.compartment_tag{1}),1);
triangles_flag_aux = 0;
if iscell(zef.surface_triangles)
    if length(zef.surface_triangles) >= compartment_ind
triangles = zef.surface_triangles{compartment_ind};
triangles_flag_aux = 1;
    end
end
if not(triangles_flag_aux)
I_aux = find(zef.domain_labels <= compartment_ind);
triangles = zef_surface_mesh();
end    
[points_aux,triangles_aux] = zef_get_submesh(zef.nodes,triangles);
strip_struct.points{1} = points_aux; 
strip_struct.triangles{1} = triangles_aux; 
strip_struct.points = zef_strip_coordinate_transform(strip_struct,'reverse');

end

if ismember(domain_type, {'geometry','mesh','model_geometry'})

if isequal(strip_struct.strip_model,1)
point_ind = find(strip_struct.points{1}(:,3)>=1.5+2.0*(contact_index-1) & strip_struct.points{1}(:,3)<=3.0+2*(contact_index-1));
end

if isequal(strip_struct.strip_model,2)
    if contact_index == 1
        contact_index_aux = 1;
point_ind = find(strip_struct.points{1}(:,3)>=1.5+2.0*(contact_index_aux-1) & strip_struct.points{1}(:,3)<=3.0+2*(contact_index_aux-1));
    elseif contact_index == 8
            contact_index_aux = 4;
point_ind = find(strip_struct.points{1}(:,3)>=1.5+2.0*(contact_index_aux-1) & strip_struct.points{1}(:,3)<=3.0+2*(contact_index_aux-1));
    elseif ismember(contact_index,[2:7])   
    if ismember(contact_index,[2 3 4])
            contact_index_aux = 2;
            direction_index_aux = contact_index - 1;
      elseif ismember(contact_index,[5 6 7])
            contact_index_aux = 3;
            direction_index_aux = contact_index - 4;
    end
point_ind = find(strip_struct.points{1}(:,3)>=1.5+2.0*(contact_index_aux-1) & strip_struct.points{1}(:,3)<=3.0+2*(contact_index_aux-1));
angle_aux = cart2pol(strip_struct.points{1}(point_ind,1),strip_struct.points{1}(point_ind,2));
angle_ind = find(angle_aux >= -2*pi/3 + 2*pi/3*(direction_index_aux - 1) & angle_aux <= -pi/3 + 2*pi/3*(direction_index_aux - 1));
point_ind = point_ind(angle_ind);    
        end
end

if isequal(strip_struct.strip_model,3)
row_ind_aux = ceil(contact_index/4);
point_ind = find(strip_struct.points{1}(:,3)>=0.75+0.75*(row_ind_aux-1) & strip_struct.points{1}(:,3)<=1.5+0.75*(row_ind_aux-1));
angle_aux = (2*pi/4)*mod(contact_index,4)+ (pi/4)*mod(row_ind_aux,2);
[center_point_x_aux, center_point_y_aux] = pol2cart(angle_aux,strip_struct.strip_radius);
center_point_aux = [center_point_x_aux; center_point_y_aux; 0.75 + 0.5*0.75 + 0.75*(row_ind_aux-1)];
point_ind_aux = find(sqrt(sum((strip_struct.points{1}(point_ind,:)'-center_point_aux).^2))<=0.5*0.75);
point_ind = point_ind(point_ind_aux);
end

if ismember(strip_struct.strip_model,[4 5])
[angle_aux, z_center_aux, pitch_aux] = local_disc_site(contact_index, strip_struct.strip_model);
point_ind = find(strip_struct.points{1}(:,3)>=z_center_aux-0.5*pitch_aux & strip_struct.points{1}(:,3)<=z_center_aux+0.5*pitch_aux);
[center_point_x_aux, center_point_y_aux] = pol2cart(angle_aux,strip_struct.strip_radius);
center_point_aux = [center_point_x_aux; center_point_y_aux; z_center_aux];
if isempty(point_ind)
point_ind_aux = [];
else
point_ind_aux = find(sqrt(sum((strip_struct.points{1}(point_ind,:)'-center_point_aux).^2))<=0.060);
end
point_ind = point_ind(point_ind_aux);
end

triangle_ind = find(sum(ismember(strip_struct.triangles{1},point_ind),2)==3);
contacts = triangles(triangle_ind,:);
if not(isempty(global_index))
contacts = [global_index(ones(size(contacts,1),1),1) contacts];
end

end
end

end

function [angle_aux, z_center_aux, pitch_aux] = local_disc_site(contact_index, strip_model)

n_columns_aux = 8;
if isequal(strip_model, 4)
    n_rows_aux = 8;
else
    n_rows_aux = 16;
end
pitch_aux = 7.5 / (n_rows_aux - 1);
row_ind_aux = ceil(contact_index / n_columns_aux);
column_ind_aux = mod(contact_index - 1, n_columns_aux);
angle_aux = column_ind_aux * (2 * pi / n_columns_aux) + mod(row_ind_aux - 1, 2) * (pi / n_columns_aux);
z_center_aux = pitch_aux * row_ind_aux;

end
