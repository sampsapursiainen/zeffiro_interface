function angles_list = zef_ES_find_valid_separation_angle
% Function that evaluates all possible separation angles in order to obtain
% 5 different electrodes for a HD-TDCS 4+1 montage.
% Returns a list in the form of a table.

ell = zeros(360,6);
for i = 0:359;
    ell(i+1) = i;
    ell(i+1,2:6) = zef_ES_4x1_sensors(i);
    ell(i+1,7) = length(ell(i+1,2:6)) == length(unique(ell(i+1,2:6)));
end
angles_list = ell(find(ell(:,7)),1:6); %#ok<FNDSB>
angles_list = array2table(angles_list(:,1:6),'Variablenames',{'Separation Angle','O','P1','P2','P3','P4'});
end