function [colormap_vec] = zef_parcellation_colormap(varargin)

if isfield(evalin('base','zef'),'parcellation_colormap')
colormap_vec = evalin('base','zef.parcellation_colormap');
else
    colormap_vec = [];
end

end
