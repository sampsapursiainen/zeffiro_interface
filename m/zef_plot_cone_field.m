function [h_cone_field,h_colorbar] = zef_plot_cone_field(h_axes, varargin)

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

cone_field = evalin('base','zef.reconstruction');

if iscell(cone_field)
cone_field = cone_field{rec_ind};
end

cone_field = reshape(cone_field,3,size(s_p,1))';
norm_cone_field = sqrt(sum(cone_field.^2,2));

cone_field = cone_field./max(norm_cone_field);

n_colormap = 2048;
cone_colormap = zef_blue_brain_1_colormap(evalin('base','zef.colortune_param'),n_colormap);

min_x = min(s_p(:,1));
max_x = max(s_p(:,1));
min_y = min(s_p(:,2));
max_y = max(s_p(:,2));
min_z = min(s_p(:,3));
max_z = max(s_p(:,3));

[X_lattice, Y_lattice, Z_lattice] = meshgrid(linspace(min_x,max_x,lattice_res),linspace(min_y,max_y,lattice_res),linspace(min_z,max_z,lattice_res));

X_field = zeros(size(X_lattice));
Y_field = zeros(size(Y_lattice));
Z_field = zeros(size(Z_lattice));
C_field = X_lattice;

lattice_ind_aux = max(1,ceil(lattice_res*(s_p-min(s_p))./(max(s_p)-min(s_p))));
lattice_ind_aux = (lattice_ind_aux(:,3)-1)*lattice_res.^2 + (lattice_ind_aux(:,1)-1)*lattice_res + lattice_ind_aux(:,2);

X_field(lattice_ind_aux) = cone_field(:,1);
Y_field(lattice_ind_aux) = cone_field(:,2);
Z_field(lattice_ind_aux) = cone_field(:,3);
C_field(lattice_ind_aux) = norm_cone_field;

axes(h_axes);

s_val = evalin('base','zef.cone_scale');

hold on;
h_cone_field = coneplot(X_lattice,Y_lattice,Z_lattice,X_field,Y_field,Z_field,X_lattice,Y_lattice,Z_lattice,s_val,C_field);

if position_case == 1
position_vec = [0.33 0.37 0.33 0.015];
elseif position_case == 2
position_vec = [0.33 0.05 0.33 0.015];
end

h_colorbar = colorbar('SouthOutside','Position',position_vec);
set(h_colorbar,'limits',[min(norm_cone_field(:)) max(norm_cone_field(:))]);
set(h_cone_field,'edgecolor','none');
axes(h_axes);


end



