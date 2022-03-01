function  diffusion_val = zef_update_diffusion(varargin)

if not(isempty(varargin))
h_figure = varargin{1};
else
h_figure = evalin('base','zef.h_zeffiro');
end

h = findobj(get(h_figure,'Children'),'Tag','axes1');
h_object= findobj(get(h_figure,'Children'),'Tag','update_diffusion_slider');
if isempty(h_object)
h_figure = evalin('base','zef.h_zeffiro');
h_object = findobj(get(h_figure,'Children'),'Tag','update_diffusion_slider');
end

diffusion_val = h_object.Value;
h = h.Children;

for i = 1 : length(h)

if not(isempty(find(ismember(properties(h(i)),'DiffuseStrength'))))
h(i).DiffuseStrength = diffusion_val;
end

end