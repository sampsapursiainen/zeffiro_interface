function  ambience_val = zef_update_ambience(varargin)

ambience_val = evalin('base','zef.h_update_ambience.Value');

if not(isempty(varargin))
    h = varargin{1}.Children;
else
    h = evalin('base','zef.h_axes1.Children');
end


if not(isempty(varargin))
if length(varargin) > 1
ambience_val = varargin{1};
end
end


for i = 1 : length(h)
if not(isempty(find(ismember(properties(h(i)),'AmbientStrength'))))
h(i).AmbientStrength = ambience_val;
end

end