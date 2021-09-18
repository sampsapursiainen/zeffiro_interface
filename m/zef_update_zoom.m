function kappa = zef_update_zoom(varargin)

kappa = evalin('base','zef.h_update_zoom.Value');


if not(isempty(varargin))
    h = varargin{1};
else
    h = evalin('base','zef.h_axes1');
end


if not(isempty(varargin))
if length(varargin) > 1
kappa = varargin{1};
end
end


h.CameraViewAngle = kappa;


end