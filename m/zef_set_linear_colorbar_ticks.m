function zef_set_linear_colorbar_ticks(zef,n_ticks,n_digits,max_val)

h_c = findobj(zef.h_zeffiro.Children,'Tag','rightColorbar');

h_c.Ticks = linspace(h_c.Limits(1),h_c.Limits(2),n_ticks);
TicksLabels = round(max_val.*10.^((h_c.Ticks - h_c.Limits(2))./20),n_digits);
h_c.TickLabels = cellstr(num2str(TicksLabels(:)));


end