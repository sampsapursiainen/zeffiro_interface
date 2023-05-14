full_address = 'exportImage';
file_name = 'butterfly_plot_auditory';

f1 = gcf;
f2 = figure();
copyobj(findobj(f1.Children, 'tag','axes1'), f2);

f2.Children.Position(2) = 40;
f2.Children.Box = 0;
% f2.Children.XTick = [0.1210    0.1220    0.1230    0.1240    0.1250    0.1260    0.1270    0.1280    0.1290    0.1300];
f2.Children.FontSize = 12;
lines = findobj(gcf, 'Type','Line');
for i = 1:numel(lines)
    lines(i).LineWidth = 1.2;
end
%%
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
