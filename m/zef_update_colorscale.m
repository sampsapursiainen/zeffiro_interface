function  colorscale_val = zef_update_colorscale(varargin)

if isequal(evalin('caller','exist(''zef'')'),1)
    zef = evalin('caller','zef');
else
    zef = evalin('base','zef');
end

if not(isempty(varargin))
    h_figure = varargin{1};
else
    h_figure = eval('zef.h_zeffiro');
end

h = findobj(get(h_figure,'Children'),'Tag','axes1');
h_object= findobj(get(h_figure,'Children'),'Tag','colorscaleselection');
if isempty(h_object)
    h_figure = eval('zef.h_zeffiro');
    h_object = findobj(get(h_figure,'Children'),'Tag','colorscaleselection');
end

colorscale_val = h_object.Value;

if isequal(colorscale_val,1)
    h.ColorScale = 'linear';
elseif isequal(colorscale_val,2)
    h.ColorScale = 'log';
end

end
