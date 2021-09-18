function  specular_val = zef_update_specular(varargin)

specular_val = evalin('base','zef.h_update_specular.Value');


if not(isempty(varargin))
     h = varargin{1}.Children;
else
    h = evalin('base','zef.h_axes1.Children');
end

if not(isempty(varargin))
if length(varargin) > 1
specular_val = varargin{2};
end
end


for i = 1 : length(h)

if not(isempty(find(ismember(properties(h(i)),'SpecularStrength'))))
h(i).SpecularStrength = specular_val;
end

end