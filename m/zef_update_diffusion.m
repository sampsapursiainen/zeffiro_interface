function  diffusion_val = zef_update_diffusion(varargin)

diffusion_val = evalin('base','zef.h_update_diffusion.Value');

if not(isempty(varargin))
      h = varargin{1}.Children;
else
    h = evalin('base','zef.h_axes1.Children');
end

if not(isempty(varargin))
if length(varargin) > 1
diffusion_val = varargin{2};
end
end


for i = 1 : length(h)

if not(isempty(find(ismember(properties(h(i)),'DiffuseStrength'))))
h(i).DiffuseStrength = diffusion_val;
end

end