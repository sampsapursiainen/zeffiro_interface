function zef_set_timepointline(h_axes)

h_line = findobj(h_axes.Children,'Tag','timepointline');
delete(h_line);
h_line = line(h_axes.CurrentPoint([1 1]),[h_axes.YLim]);
h_line.Color = 0.5*[1 1 1];
h_line.Tag = 'timepointline';
h_axes.Title.String = ['Time value = ' num2str(h_axes.CurrentPoint(1))];
h_line.LineWidth = 1;

end
