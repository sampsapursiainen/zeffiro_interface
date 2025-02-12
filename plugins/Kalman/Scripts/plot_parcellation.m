full_address = 'exportImage';
file_name = 'parcellation_plot_real_auditoryRH';

f1 = gcf;
f2 = figure();
copyobj(findobj(f1.Children, 'tag','axes1'), f2);

f2.Children.Position(2) = 40; 
f2.Children.Box = 0;
l = legend(gca, 'show');
l.AutoUpdate = 'off';
l.FontSize = 12;
h = xline(0.079, '--','79 ms');
h.FontSize = 12;
h = xline(0.124, '--','124 ms');
h.FontSize = 12;
h = xline(0.159, '--','159 ms');
h.FontSize = 12;
h = xline(0.097, '--','97 ms');
h.FontSize = 12;
h = xline(0.139, '--','139 ms');
h.FontSize = 12;
h = xline(0.184, '--','184 ms');
h.FontSize = 12;
%%
file_full = fullfile(full_address, file_name);
print(f2,'-dpng','-r150',[file_full '.png'])
savefig(f2, [file_full, '.fig'])