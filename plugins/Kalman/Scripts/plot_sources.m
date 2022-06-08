full_address = 'exportImage';
file_name = 'sources_plot2';
file_full = fullfile(full_address, file_name);
%% Deep Component
f1 = gcf;
f2 = figure();
copyobj(findobj(f1.Children, 'tag','axes1'), f2);

f2.Children.Position(2) = 60;
grid off
axis off
%view(-120,25)
%view(-90,0)
f2.Children.Children(end).FaceAlpha = 0.45;
f2.Children.Children(end-1).FaceAlpha = 0.45;


set(gcf, 'color', 'w')
%%
print(f2,'-dpng','-r150',[file_full '.png'])
savefig(f2, [file_full, '.fig'])

%% Cortex component
f1 = gcf;
f2 = figure();
copyobj(findobj(f1.Children, 'tag','axes1'), f2);

f2.Children.Position(2) = 35;
grid off
axis off
%view(-180,0)

%f2.Children.View = [-110 40];
file_full = fullfile(full_address, file_name);
set(gcf, 'color', 'w')
f2.Children.Children(end).FaceAlpha = 0.35;
f2.Children.Children(end-1).FaceAlpha = 0.35;
f2.Children.Children(end-2).FaceAlpha = 0.35;


%%
print(f2,'-dpng','-r150',[file_full '.png'])
savefig(f2, [file_full, '.fig'])
