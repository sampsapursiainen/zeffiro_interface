function  ambience_val = zef_update_ambience(varargin)

if isequal(evalin('caller','exist(''zef'')'),1)
zef = evalin('caller','zef');
else
zef = eval('base','zef');
end

if not(isempty(varargin))
h_figure = varargin{1};
else
h_figure = eval('zef.h_zeffiro');
end

h = findobj(get(h_figure,'Children'),'Tag','axes1');
h_object = findobj(get(h_figure,'Children'),'Tag','update_ambience_slider');
if isempty(h_object)
h_figure = eval('zef.h_zeffiro');
h_object = findobj(get(h_figure,'Children'),'Tag','update_ambience_slider');
end

ambience_val = h_object.Value;
h = h.Children;

for i = 1 : length(h)

if not(isempty(find(ismember(properties(h(i)),'AmbientStrength'))))
h(i).AmbientStrength = ambience_val;
end

end

end
