function slider_value_new = zef_update_transparency_additional(varargin)

slider_value_old = evalin('base','zef.update_transparency_additional');
slider_value_new = evalin('base','zef.h_update_transparency_additional.Value');

if not(isempty(varargin))
      h = varargin{1}.Children;
else
    h = evalin('base','zef.h_axes1.Children');
end


if(not(isempty(varargin)))
if length(varargin) > 1
slider_value_old = varargin{2};
end
if length(varargin) > 2
slider_value_new = varargin{3};
end
end

h = findobj(h,'Tag','additional');

kappa = 1.05.^(-100*(slider_value_new-slider_value_old));

for i = 1 : length(h)

h(i).FaceAlpha = min(1,kappa*h(i).FaceAlpha);


end

end