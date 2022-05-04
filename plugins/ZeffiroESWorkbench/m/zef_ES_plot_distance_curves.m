function zef_ES_plot_distance_curves

    f = figure('Name','ZEFFIRO Interface: ES distance curves','NumberTitle','off', ...
        'ToolBar','figure','MenuBar','none');

distance_window = 10;
n_distances = 2000;
max_distance = 100;
quantile_val = 0.90;
smooth_range = 50;
font_size = 14;

rec_vec_aux = zeros(3,size(evalin('base','zef.source_positions'),1));
rec_vec_aux(1:evalin('base','length(zef.reconstruction(:))')) = evalin('base','zef.reconstruction');
amplitude_vec_aux = rec_vec_aux;
rec_vec_aux = rec_vec_aux./repmat(sqrt(sum(rec_vec_aux.^2)),3,1);
amplitude_vec_aux = sqrt(sum(amplitude_vec_aux.^2));
distance_vec_aux = sqrt(sum((evalin('base','zef.source_positions')-evalin('base','zef.inv_synth_source(ones(size(zef.source_positions,1),1),1:3)')).^2,2));
dipole_vec_aux = evalin('base','zef.inv_synth_source(1,4:6)');
dipole_vec_aux = dipole_vec_aux(:)./norm(dipole_vec_aux,2);
distance_vec = linspace(0,max_distance,n_distances)';
amplitude_vec = zeros(size(distance_vec));

for i = 1 : n_distances

[position_ind] = find(distance_vec_aux >= distance_vec(i) & distance_vec_aux <= distance_vec(i)+distance_window);
amplitude_vec(i) = mean(amplitude_vec_aux(position_ind));
angle_vec(i) = mean(180/pi*acos(sum(dipole_vec_aux(:,ones(1,length(position_ind))).*rec_vec_aux(:,position_ind))));

end

subplot(2,1,1); 
amplitude_vec = smooth(amplitude_vec,smooth_range);
pbaspect([3 1 1])
hold on;
quantile_aux_1 = quantile(amplitude_vec(find(amplitude_vec<=amplitude_vec(1))),0.25);
quantile_aux_2 = quantile(amplitude_vec(find(amplitude_vec<=amplitude_vec(1))),0.5);
quantile_aux_3 = quantile(amplitude_vec(find(amplitude_vec<=amplitude_vec(1))),0.75);

vert_pos_1 = distance_vec(find(amplitude_vec <= quantile_aux_1,1));
vert_pos_2 = distance_vec(find(amplitude_vec <= quantile_aux_2,1));
vert_pos_3 = distance_vec(find(amplitude_vec <= quantile_aux_3,1));

I1 = find(distance_vec <= vert_pos_3);
fill([distance_vec(I1) ;distance_vec(I1(end)) ;distance_vec(I1(1)) ;distance_vec(I1(1))],[amplitude_vec(I1); 0; 0 ;amplitude_vec(I1(1))],'m') 

I2 = find(distance_vec <= vert_pos_2);
I2 = setdiff(I2,I1);
fill([distance_vec(I2) ;distance_vec(I2(end)) ;distance_vec(I2(1)) ;distance_vec(I2(1))],[amplitude_vec(I2); 0; 0 ;amplitude_vec(I2(1))],'c') 


I3 = find(distance_vec <= vert_pos_1);
I3 = setdiff(I3, I1);
I3 = setdiff(I3, I2);
fill([distance_vec(I3) ;distance_vec(I3(end)) ;distance_vec(I3(1)) ;distance_vec(I3(1))],[amplitude_vec(I3); 0; 0 ;amplitude_vec(I3(1))],'g') 

I4 = [1:length(distance_vec)];
I4 = setdiff(I4, I1);
I4 = setdiff(I4, I2);
I4 = setdiff(I4, I3);
fill([distance_vec(I4) ;distance_vec(I4(end)) ;distance_vec(I4(1)) ;distance_vec(I4(1))],[amplitude_vec(I4); 0; 0 ;amplitude_vec(I4(1))],'y') 


set(gca,'ylim',[0 1.25*max(amplitude_vec)])
set(gca,'xlim',[0 max_distance])
set(gca,'xgrid','on')
set(gca,'ygrid','on')
set(gca,'fontsize',font_size)
set(gca,'fontname','Helvetica');

legend({'0-25 %','25-50 %','50-75 %','75-100 %'},'Location','NorthEast','Orientation','Horizontal')
ylabel('Current density (A/m^2)')
xlabel('Distance (mm)')

title('Distance vs. amplitude')

hold off

subplot(2,1,2); 
angle_vec = smooth(angle_vec,smooth_range);
pbaspect([3 1 1])
hold on;
quantile_aux_1 = quantile(angle_vec(find(angle_vec>=angle_vec(1))),0.75);
quantile_aux_2 = quantile(angle_vec(find(angle_vec>=angle_vec(1))),0.5);
quantile_aux_3 = quantile(angle_vec(find(angle_vec>=angle_vec(1))),0.25);

vert_pos_1 = distance_vec(find(angle_vec >= quantile_aux_1,1));
vert_pos_2 = distance_vec(find(angle_vec >= quantile_aux_2,1));
vert_pos_3 = distance_vec(find(angle_vec >= quantile_aux_3,1));

I1 = find(distance_vec <= vert_pos_3);
fill([distance_vec(I1) ;distance_vec(I1(end)) ;distance_vec(I1(1)) ;distance_vec(I1(1))],[angle_vec(I1); 0; 0 ;angle_vec(I1(1))],'m') 

I2 = find(distance_vec <= vert_pos_2);
I2 = setdiff(I2,I1);
fill([distance_vec(I2) ;distance_vec(I2(end)) ;distance_vec(I2(1)) ;distance_vec(I2(1))],[angle_vec(I2); 0; 0 ;angle_vec(I2(1))],'c') 

I3 = find(distance_vec <= vert_pos_1);
I3 = setdiff(I3, I1);
I3 = setdiff(I3, I2);
fill([distance_vec(I3) ;distance_vec(I3(end)) ;distance_vec(I3(1)) ;distance_vec(I3(1))],[angle_vec(I3); 0; 0 ;angle_vec(I3(1))],'g') 

I4 = [1:length(distance_vec)];
I4 = setdiff(I4, I1);
I4 = setdiff(I4, I2);
I4 = setdiff(I4, I3);
fill([distance_vec(I4) ;distance_vec(I4(end)) ;distance_vec(I4(1)) ;distance_vec(I4(1))],[angle_vec(I4); 0; 0 ;angle_vec(I4(1))],'y') 


set(gca,'ylim',[0 1.25*max(angle_vec)])
set(gca,'xlim',[0 max_distance])
set(gca,'xgrid','on')
set(gca,'ygrid','on')
set(gca,'fontsize',font_size)
set(gca,'fontname','Helvetica');

legend({'0-25 %','25-50 %','50-75 %','75-100 %'},'Location','NorthEast','Orientation','Horizontal')
ylabel('Angle (deg)')
xlabel('Distance (mm)')


title('Distance vs. angle difference')

hold off

end
