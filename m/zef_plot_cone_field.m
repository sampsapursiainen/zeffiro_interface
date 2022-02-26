function [h_cone_field, h_streamlines, h_colorbar] = zef_plot_cone_field(h_axes, varargin)

if evalin('base','zef.cone_draw') || evalin('base','zef.streamline_draw')

rec_ind = 1;
position_case = 1;
if not(isempty(varargin))
    rec_ind = varargin{1};
    if length(varargin) > 1
        position_case = varargin{2};
    end
end

lattice_res = evalin('base','zef.cone_lattice_resolution');
s_p = evalin('base','zef.source_positions');

cone_field_size = size(s_p,1);

aux_ind_1 = unique(evalin('base','zef.source_interpolation_ind{1}'));

clipped = 0;

if evalin('base','zef.cp_on')
cp_a = evalin('base','zef.cp_a');
cp_b = evalin('base','zef.cp_b');
cp_c = evalin('base','zef.cp_c');
cp_d = evalin('base','zef.cp_d');

clipping_plane = {cp_a,cp_b,cp_c,cp_d};

if clipped
aux_ind_1 = zef_clipping_plane(s_p,clipping_plane,aux_ind_1);
else
aux_ind_1 = zef_clipping_plane(s_p,clipping_plane);
end
clipped = 1;
end

if evalin('base','zef.cp2_on')
cp2_a = evalin('base','zef.cp2_a');
cp2_b = evalin('base','zef.cp2_b');
cp2_c = evalin('base','zef.cp2_c');
cp2_d = evalin('base','zef.cp2_d');

clipping_plane = {cp2_a,cp2_b,cp2_c,cp2_d};

if clipped
aux_ind_1 = zef_clipping_plane(s_p,clipping_plane,aux_ind_1);
else
aux_ind_1 = zef_clipping_plane(s_p,clipping_plane);
end
clipped = 1;
end

if evalin('base','zef.cp3_on')
cp3_a = evalin('base','zef.cp3_a');
cp3_b = evalin('base','zef.cp3_b');
cp3_c = evalin('base','zef.cp3_c');
cp3_d = evalin('base','zef.cp3_d');

clipping_plane = {cp3_a,cp3_b,cp3_c,cp3_d};

if clipped
aux_ind_1 =  zef_clipping_plane(s_p,clipping_plane,aux_ind_1);
else
aux_ind_1 = zef_clipping_plane(s_p,clipping_plane);
end
clipped = 1;
end

s_p = s_p(aux_ind_1,:);

cone_field = evalin('base','zef.reconstruction');

if iscell(cone_field)
cone_field = cone_field{rec_ind};
end

cone_field = reshape(cone_field,3,length(cone_field(:))/3)';
norm_cone_field = sqrt(sum(cone_field.^2,2));

cone_field = cone_field(aux_ind_1,:)./max(norm_cone_field);

norm_cone_field = norm_cone_field(aux_ind_1);

n_colormap = evalin('base','zef.colormap_size');
cone_colormap = zef_blue_brain_1_colormap(evalin('base','zef.colortune_param'),n_colormap);

min_x = min(s_p(:,1));
max_x = max(s_p(:,1));
min_y = min(s_p(:,2));
max_y = max(s_p(:,2));
min_z = min(s_p(:,3));
max_z = max(s_p(:,3));

lattice_constant = lattice_res/((max_x - min_x)*(max_y - min_y)*(max_z - min_z))^(1/3);
lattice_res_x = floor(lattice_constant*(max_x - min_x));
lattice_res_y = floor(lattice_constant*(max_y - min_y));
lattice_res_z = floor(lattice_constant*(max_z - min_z));

l_d_x = (max_x - min_x)/(lattice_res_x + 1);
l_d_y = (max_y - min_y)/(lattice_res_y + 1);
l_d_z = (max_z - min_z)/(lattice_res_z + 1);

min_x = min_x + l_d_x;
max_x = max_x - l_d_x;
min_y = min_y + l_d_y;
max_y = max_y - l_d_y;
min_z = min_z + l_d_z;
max_z = max_z - l_d_z;

[X_lattice, Y_lattice, Z_lattice] = meshgrid(linspace(min_x,max_x,lattice_res_x),linspace(min_y,max_y,lattice_res_y),linspace(min_z,max_z,lattice_res_z));

X_field = zeros(size(X_lattice));
Y_field = zeros(size(Y_lattice));
Z_field = zeros(size(Z_lattice));
C_field = X_lattice;

lattice_ind_aux = [max(1,ceil(lattice_res_x*(s_p(:,1)-min(s_p(:,1)))./(max(s_p(:,1))-min(s_p(:,1))))) ...
    max(1,ceil(lattice_res_y*(s_p(:,2)-min(s_p(:,2)))./(max(s_p(:,2))-min(s_p(:,2)))))...
    max(1,ceil(lattice_res_z*(s_p(:,3)-min(s_p(:,3)))./(max(s_p(:,3))-min(s_p(:,3)))))];

lattice_ind_aux = (lattice_ind_aux(:,3)-1)*lattice_res_x*lattice_res_y + (lattice_ind_aux(:,1)-1)*lattice_res_y + lattice_ind_aux(:,2);

X_field(lattice_ind_aux) = cone_field(:,1);
Y_field(lattice_ind_aux) = cone_field(:,2);
Z_field(lattice_ind_aux) = cone_field(:,3);
C_field(lattice_ind_aux) = norm_cone_field;

axes(h_axes);

s_val = evalin('base','zef.cone_scale');

hold on;
I = [1:size(s_p,1)];
I = I(1:round(length(I)/(evalin('base','zef.n_streamline')-1)):end);

if evalin('base','zef.cone_draw')

h_cone_field = coneplot(X_lattice,Y_lattice,Z_lattice,X_field,Y_field,Z_field,X_lattice,Y_lattice,Z_lattice,s_val,C_field);
set(h_cone_field,'facecolor','interp');
set(h_cone_field,'edgecolor','none');
set(h_cone_field,'facealpha',evalin('base','zef.cone_alpha'));
set(h_cone_field,'Tag','cones');

end

if evalin('base','zef.streamline_draw')
h_streamline = streamline(stream3(X_lattice,Y_lattice,Z_lattice,X_field,Y_field,Z_field,s_p(I,1),s_p(I,2),s_p(I,3)));
set(h_streamline,'linewidth',evalin('base','zef.streamline_linewidth'));
set(h_streamline,'linestyle',evalin('base','zef.streamline_linestyle'));
set(h_streamline,'color',evalin('base','zef.streamline_color'));
end

if position_case == 1
position_vec = [0.21 0.30 0.21 0.015];
elseif position_case == 2
position_vec = [0.33 0.05 0.33 0.015];
end

h_colorbar = colorbar('SouthOutside','Position',position_vec);
set(h_colorbar,'limits',[min(norm_cone_field(:)) max(norm_cone_field(:))]);
axes(h_axes);

end
end

