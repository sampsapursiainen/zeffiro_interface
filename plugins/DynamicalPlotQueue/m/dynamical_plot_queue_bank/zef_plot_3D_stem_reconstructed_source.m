function zef_plot_3D_stem_reconstructed_source(varargin)
%A static plot showing the active synthetic sources

arrow_scale = 100;
arrow_type = 1;
arrow_color = 0.5*[1 1 1];
arrow_shape = 10;
arrow_length = 1;
arrow_head_size = 2;
arrow_n_polygons = 100;

if not(isempty(varargin))
    arrow_scale = varargin{1};
    if length(varargin)>1
        arrow_type = varargin{2};
    end
    if length(varargin)>2
        arrow_color = varargin{3};
    end
    if length(varargin)>3
        arrow_shape= varargin{4};
    end
    if length(varargin)>4
        arrow_length = varargin{5};
    end
    if length(varargin)>5
        arrow_head_size = varargin{6};
    end
    if length(varargin)>6
        arrow_n_polygons = varargin{7};
    end
end

color_cell = {'k','r','g','b','y','m','c'};
h_axes_image = evalin('caller','h_axes_image');
axes(h_axes_image);
s = evalin('caller','zef.inv_rec_source');
s_length = sqrt(sum(s(:,4:6).^2,2));
s_o = s(:,4:6)./repmat(s_length,1,3);
h_source = findobj(allchild(h_axes_image),'Tag','additional: reconstructed source');
delete(h_source);
for i = 1 : size(s,1)
    arrow_scale = 3*s_length(i)*s(1,8);
    h_arrow = zef_plot_3D_arrow(s(i,1),s(i,2),s(i,3),s_o(i,1),s_o(i,2),s_o(i,3),arrow_scale,arrow_type,color_cell{s(i,9)},arrow_shape,arrow_length,arrow_head_size,arrow_n_polygons);
    set(h_arrow,'Tag','additional: reconstructed source');
end

end
