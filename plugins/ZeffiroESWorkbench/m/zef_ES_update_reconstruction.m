function zef = zef_ES_update_reconstruction
switch nargin
    case 0
        zef = evalin('base','zef');
        [sr, sc] = zef_ES_objective_function(zef);
        zef.reconstruction = zef.y_ES_interval.volumetric_current_density{sr,sc};
    case 2
        zef.reconstruction = zef.y_ES_interval.volumetric_current_density{sc,sr};
    otherwise
        error('Invalid length of input arguments.')
end
try %#ok<*TRYNC>
    delete(findobj(zef.h_zeffiro.Children,'-class','matlab.graphics.illustration.ColorBar', '-and', 'tag', 'ES_colorbar'));
end

if nargout == 0
    assignin('base','zef',zef);
end

end
