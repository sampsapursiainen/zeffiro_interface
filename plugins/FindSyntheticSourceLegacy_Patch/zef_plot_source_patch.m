%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function h_source = zef_plot_source_patch(zef, source_type)

use_volume = eval('zef.inv_synth_source(1,11)');
radius = eval('zef.inv_synth_source(:,12)');
use_norm_ori = eval('zef.inv_synth_source(1,13)');
use_cones = eval('zef.inv_synth_source(1,14)');
use_VEP_config = eval('zef.inv_synth_source(1,16)');

if radius == 0
    use_cones = 0;
    use_volume = 0;
end

arrow_scale = 1;
arrow_type = 1;
arrow_color = 0.5*[1 1 1];
arrow_shape = 10;
arrow_length = 1;
arrow_head_size = 2;
arrow_n_polygons = 100;

if source_type == 1
    h_axes1 = eval('zef.h_axes1');
    if isfield(eval('zef'),'h_synth_source')
        h_synth_source = eval('zef.h_synth_source');
        if ishandle(h_synth_source)
            delete(h_synth_source)
        end
    end
    s_width = 3;
    color_cell = {'k','r','g','b','y','m','c'};
    s_length = eval('zef.inv_synth_source(1,9)');
    source_color = color_cell{eval('zef.inv_synth_source(1,10)')};
    s_p = eval('zef.inv_synth_source(:,1:3)');
    s_o = eval('zef.inv_synth_source(:,4:6)');
    s_o = s_o./repmat(sqrt(sum(s_o.^2,2)),1,3);
    s_a = eval('zef.inv_synth_source(:,7)');
    s_a = sqrt(s_a./max(s_a));
    s_o = repmat(s_a,1,3).*s_o;
    s_o = repmat(s_length,1,3).*s_o;
    h_axes1 = eval('zef.h_axes1');
    hold(h_axes1,'on');
    h_synth_source = zeros(size(s_p,1),1);
    axes(h_axes1)
    arrow_scale = 3*sqrt(s_length);

 if use_norm_ori
    zef.source_direction_mode = 2;
    [L,n_interp,procFile] = zef_processLeadfields(zef);
    source_positions = eval('zef.source_positions');
   
end
   if ~use_cones 
   for i = 1 : size(s_p,1)
            %h_synth_source(i) = quiver3(h_axes1,s_p(i,1),s_p(i,2),s_p(i,3),s_length*s_o(i,1),s_length*s_o(i,2),s_length*s_o(i,3), 0, 'linewidth',s_width,'color',source_color,'marker','o');
        
            
        if ~use_volume
            if use_norm_ori
                d = sqrt(sum((source_positions - repmat(s_p(i,:),size(source_positions,1),1)).^2,2));
                [s_min, s_ind] = min(d(procFile.s_ind_0)); %only consider interpolated sources
                norm_ori=procFile.source_directions(s_ind,:);
                s_o(i,:)=norm_ori*s_a(i)*s_length;
                fprintf('\nsource %i orientation changed to normal orientation [%3.2f, %3.2f, %3.2f]',i,norm_ori(1),norm_ori(2),norm_ori(3))
            end
            
            
            h_synth_source(i) = zef_plot_3D_arrow(s_p(i,1),s_p(i,2),s_p(i,3),s_o(i,1),s_o(i,2),s_o(i,3),arrow_scale,arrow_type,source_color,arrow_shape,arrow_length,arrow_head_size,arrow_n_polygons);
        elseif use_volume
            if ~use_VEP_config
                h_synth_source(i) = zef_plot_sphere(s_p(i,:),radius(i),source_color);
            elseif use_VEP_config
                z_axis_length = 4.3;
                if z_axis_length>=radius(i)
                    z_axis_length = radius(i);
                end
               
                sensor_pos =  zef.s2_points;
                sensor_distance = sqrt(sum((sensor_pos - repmat(s_p(i,:),size(sensor_pos,1),1)).^2,2));
                [~,nearest_sensor_ind] = min(sensor_distance); 
                z_axis_ori = sensor_pos(nearest_sensor_ind,:) - s_p(i,:);
                h_synth_source(i) = zef_plot_ellipsoid(s_p(i,:),radius(i),radius(i),z_axis_length,z_axis_ori,source_color);
            end
            
                 
         

        end
        set(h_synth_source(i),'Tag','additional: synthetic source');
    
   end

   elseif use_cones
       h_synth_source = zef_plot_cones_in_roi(zef,s_length);
       set(h_synth_source,'Tag','additional: synthetic source');
   end
    
    hold(h_axes1,'off');
    h_source = h_synth_source;
else
    h_axes1 = eval('zef.h_axes1');
    if isfield(eval('zef'),'h_rec_source')
        h_rec_source = eval('zef.h_rec_source');
        if ishandle(h_rec_source)
            delete(h_rec_source)
        end
    end
    s_width = 3;
    color_cell = {'k','r','g','b','y','m','c'};
    s_length = eval('zef.inv_rec_source(1,8)');
    source_color = color_cell{eval('zef.inv_rec_source(1,9)')};
    s_p = eval('zef.inv_rec_source(:,1:3)');
    s_o = eval('zef.inv_rec_source(:,4:6)');
    s_o = s_o./repmat(sqrt(sum(s_o.^2,2)),1,3);
    s_a = eval('zef.inv_rec_source(:,7)');
    s_a = sqrt(s_a./max(s_a));
    s_o = repmat(s_a,1,3).*s_o;
    s_o = repmat(s_length,1,3).*s_o;
    h_axes1 = eval('zef.h_axes1');
    hold(h_axes1,'on');
    h_rec_source = zeros(size(s_p,1),1);
    for i = 1 : size(s_p,1)
        h_rec_source(i) = quiver3(h_axes1,s_p(i,1),s_p(i,2),s_p(i,3),s_length*s_o(i,1),s_length*s_o(i,2),s_length*s_o(i,3), 0, 'linewidth',s_width,'color',source_color,'marker','o');
    end
    hold(h_axes1,'off');
    h_source = h_rec_source;
end
end

