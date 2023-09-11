if size(zef.resection_points,1) > 1
    A=alphaShape(zef.resection_points(:,1), zef.resection_points(:,2), zef.resection_points(:,3),3.4);
    [AF, AP]=alphaTriangulation(A);
    dist_resection = zef_distance_to_resection(z_ref_points,AP,AF);
    dist_final_resection_max = zef_distance_to_resection(z_final_max_point,AP,AF);
else
    dist_resection = zef_distance_to_resection(z_ref_points,zef.resection_points);
    dist_final_resection_max = zef_distance_to_resection(z_final_max_point,zef.resection_points);
end

dist_vec = sqrt(sum((z_ref_points - z_final_max_point).^2,2));
[~,I] = sort(dist_vec);


result_cell = [z_inverse_info(I,:) mat2cell(dist_vec(I),ones(length(z_inverse_results),1))  mat2cell(dist_resection(I),ones(length(z_inverse_results),1))  mat2cell(z_max_deviations(I),ones(length(z_inverse_results),1)) mat2cell(z_mean_deviations(I),ones(length(z_inverse_results),1))];
result_cell = [ {'cluster'} {'Final result'}  {'Max Point'} {0} {dist_final_resection_max} {z_final_max_deviation} {z_final_mean_deviation}; result_cell];


h_f_1 = uifigure('Visible',zef.use_display);
h_f_1.Name = 'ZEFFIRO Interface: Clustering table';
h_f_1.Units = 'normalized';
h_t = uitable('Parent',h_f_1);
h_t.Units = 'normalized';
h_t.Position = [0.05 0.05 0.9 0.9];
h_t.Units = 'pixels';
h_t.RowName = '';
h_t.ColumnWidth = repmat({h_t.Position(3)/size(result_cell,2)},1,size(result_cell,2));
h_t.Units = 'normalized';
h_t.Data = result_cell;
h_t.ColumnName = [{'Data'} {'Method'} {'Type'} {'Dist. reference'} {'Dist. resection'} {'Max. deviation'} {'Mean deviation'}];
zef_set_size_change_function(h_f_1,1,0)

h_f_2 = uifigure('Visible',zef.use_display);
h_f_2.Name = 'ZEFFIRO Interface: Clustering plot';
h_a = axes(h_f_2);
I = [2:size(h_t.Data,1)];
plot(h_a,I,cell2mat(h_t.Data(I,4)));
deviation_data = cell2mat(h_t.Data(I,7));
for i = 2 : length(deviation_data)
    deviation_data(i) = max(deviation_data(i-1),deviation_data(i));
end
hold(h_a,'on');
h_fill = fill(h_a,[I fliplr(I)]',[cell2mat(h_t.Data(I,4)) ;flipud(cell2mat(h_t.Data(I,4))+deviation_data)],'b');
h_fill.FaceAlpha = 0.2;
h_fill.EdgeColor = 'none';
h_fill = fill(h_a,[I fliplr(I)]',[cell2mat(h_t.Data(I,4)) ;flipud(cell2mat(h_t.Data(I,4))-deviation_data)],'b','HandleVisibility','off');
h_fill.FaceAlpha = 0.2;
h_fill.EdgeColor = 'none';
h_fill = fill(h_a,[I fliplr(I)]',[cell2mat(h_t.Data(I,4)) ;flipud(cell2mat(h_t.Data(I,4))+2*deviation_data)],'m');
h_fill.FaceAlpha = 0.1;
h_fill.EdgeColor = 'none';
h_fill = fill(h_a,[I fliplr(I)]',[cell2mat(h_t.Data(I,4)) ;flipud(cell2mat(h_t.Data(I,4))-2*deviation_data)],'m','HandleVisibility','off');
h_fill.FaceAlpha = 0.1;
h_fill.EdgeColor = 'none';
J = find(ismember(h_t.Data(:,3),'Cluster centre'));
plot(h_a,J,cell2mat(h_t.Data(J,5)),'rs-');
J = setdiff(I,J);
plot(h_a,J,cell2mat(h_t.Data(J,5)),'kd--');
set(h_a,'ylim',[0 1.05*max(cell2mat(h_t.Data(I,4))+2*deviation_data)]);
set(h_a,'xlim',[2 length(I)]);
pbaspect(h_a,[1 1 1]);
h_a.XGrid = 'on'
h_a.YGrid = 'on'
h_legend = legend(h_a,'Distance to centre','68 % credibility','90 % credibility','Distance to resection (cluster)','Distance to resection (maximum point)','Location','NorthWest');
