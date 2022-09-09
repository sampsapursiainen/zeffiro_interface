function zef_ES_update_reconstruction(varargin)
switch nargin
    case 0
        [sr, sc] = zef_ES_objective_function(zef_ES_table);
        evalin('base',['zef.reconstruction = zef.y_ES_interval.volumetric_current_density{' num2str(sr) ',' num2str(sc) '};']);
    case 2
        evalin('base',['zef.reconstruction = zef.y_ES_interval.volumetric_current_density{' num2str(varargin{1}) ',' num2str(varargin{2}) '};']);
    otherwise
        error('Invalid length of input arguments.')
end
try %#ok<*TRYNC>
    delete(findobj(evalin('base','zef.h_zeffiro.Children'),'-class','matlab.graphics.illustration.ColorBar', '-and', 'tag', 'ES_colorbar'))
end
end
