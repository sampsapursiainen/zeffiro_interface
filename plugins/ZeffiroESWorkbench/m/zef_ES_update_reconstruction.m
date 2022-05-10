function [reconstruction] = zef_ES_update_reconstruction(varargin)
switch evalin('base','zef.ES_search_method')
    case {1,2}
        switch evalin('base','zef.ES_search_type')
            case 1
                reconstruction  = evalin('base','zef.y_ES_single.volumetric_current_density');
                if nargin > 1
                    warning('Invalid length of input arguments using Single-Instance. Displaying the latest (single) calculated option...')
                end
            case 2
                reconstruction  = evalin('base','zef.y_ES_interval.volumetric_current_density');
                switch nargin
                    case 0
                        [~,sr, sc] = zef_ES_objective_function;
                        if isempty(sr)
                            sr = 1;
                        end
                        if isempty(sc)
                            sc = 1;
                        end
                        reconstruction = reconstruction{sr, sc};
                    case 2
                        reconstruction = reconstruction{varargin{1},varargin{2}};
                    otherwise
                        error('Invalid length of input arguments.')
                end
        end
    case 3
        reconstruction = evalin('base','zef.y_ES_4x1.volumetric_current_density');
end
try %#ok<*TRYNC>
    delete(findobj(evalin('base','zef.h_zeffiro.Children'),'-class','matlab.graphics.illustration.ColorBar', '-and', 'tag', 'ES_colorbar'))
end
end
