function ell_idx = zef_ES_4x1_fun
separation_angle = evalin('base','zef.ES_separation_angle');
sensors    = evalin('base','zef.sensors(:,1:3)');
source_pos = evalin('base','zef.inv_synth_source(1,1:3)'); % Position
source_ori = evalin('base','zef.inv_synth_source(1,4:6)'); % Orientation
'moi'

ell_idx = zef_ES_4x1_sensors(separation_angle, source_pos, source_ori, sensors);
axes(evalin('base','zef.h_axes1'));

quiver3(source_pos(1), source_pos(2), source_pos(3), source_ori(1),source_ori(2),source_ori(3),20,'g','linewidth',1,'marker','o');
hold on
for i = 1:length(sensors)
    if ismember(i,ell_idx(1))
        scatter3(sensors(i,1),sensors(i,2),sensors(i,3),'r','filled');
    elseif ismember(i,ell_idx(2:5))
        scatter3(sensors(i,1),sensors(i,2),sensors(i,3),'b','filled');
     else
        scatter3(sensors(i,1),sensors(i,2),sensors(i,3),'.','k');
    end
end
axis equal
hold off
end
