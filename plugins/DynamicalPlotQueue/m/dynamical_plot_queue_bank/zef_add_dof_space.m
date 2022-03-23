function zef_add_dof_space
%This function plots the degrees of freedom

h_axes = evalin('base','zef.h_axes1'); 
axes(h_axes);
hold on
source_positions = evalin('base','zef.source_positions');
scatter3(source_positions(:,1),source_positions(:,2),source_positions(:,3),'filled')

end
