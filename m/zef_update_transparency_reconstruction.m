function slider_value_new = zef_update_transparency_reconstruction(varargin)

slider_value_old = evalin('base','zef.update_transparency_reconstruction');
slider_value_new = evalin('base','zef.h_update_transparency_reconstruction.Value');

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

h = findobj(h,'Tag','reconstruction');

kappa = 1.05.^(-100*(slider_value_new-slider_value_old));

for i = 1 : length(h)

if not(isnumeric(h(i).FaceAlpha))
h(i).FaceAlpha = min(1,kappa);
else
h(i).FaceAlpha = min(1,kappa*h(i).FaceAlpha);
end



end

end