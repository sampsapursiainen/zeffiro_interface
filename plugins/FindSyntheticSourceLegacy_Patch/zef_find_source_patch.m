%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface

function [meas_data,all_roi_sources,orientations,n_multiple_sources] = zef_find_source_patch(zef)
source_positions = eval('zef.source_positions');
noise_level = eval('zef.inv_synth_source(1,8)');
s_p = eval('zef.inv_synth_source(:,1:3)');
s_o = eval('zef.inv_synth_source(:,4:6)');
s_o = s_o./repmat(sqrt(sum(s_o.^2,2)),1,3);
s_a = eval('zef.inv_synth_source(:,7)');
s_f = 1e-3*repmat(s_a,1,3).*s_o;
L = eval('zef.L');
use_volume = eval('zef.inv_synth_source(1,11)');
radius = eval('zef.inv_synth_source(:,12)');
use_norm_ori = eval('zef.inv_synth_source(1,13)');
fix_amp = eval('zef.inv_synth_source(1,15)');
use_VEP_config = eval('zef.inv_synth_source(1,16)');



[s_ind_1] = unique(eval('zef.source_interpolation_ind{1}'));

if use_norm_ori
    zef.source_direction_mode = 2;
    [L,n_interp,procFile] = zef_processLeadfields(zef);
end

meas_data = zeros(size(L(:,1),1),1);
all_roi_sources = [];
n_multiple_sources = ones(size(s_p,1),1);
for i = 1 : size(s_p,1)


    %determine distance from position to source points
    d = sqrt(sum((source_positions - repmat(s_p(i,:),size(source_positions,1),1)).^2,2));
    [s_min, s_ind] = min(d(s_ind_1)); %only consider interpolated sources
    s_roi = s_ind_1(s_ind); 
    
    if use_volume
        if ~use_VEP_config
            for k = 1:length(s_ind_1)
                if d(s_ind_1(k)) < radius(i) %determine sources within radius
                    s_roi = [s_roi; s_ind_1(k)];
                end
            end
        elseif use_VEP_config
            sensor_pos =  zef.s2_points;
            sensor_distance = sqrt(sum((sensor_pos - repmat(s_p(i,:),size(sensor_pos,1),1)).^2,2));
            [~,nearest_sensor_ind] = min(sensor_distance); 
            radial_direction = sensor_pos(nearest_sensor_ind,:) - s_p(i,:);

            source_directions = source_positions - repmat(s_p(i,:),size(source_positions,1),1);
            
            a= radius(i);
            b = radius(i);

            c= 4.3;
            if c>=radius(i)
                c=radius(i);
            end
            z = radial_direction'/norm(radial_direction);
            x = 1/sqrt(z(1)^2+z(2)^2)* [z(2) -z(1) 0]';
            y = cross(z,x);
            T_ellipsoid_to_lab = [x y z];
            trans_d =source_directions * inv(T_ellipsoid_to_lab');

            for k = 1:length(s_ind_1)
                if trans_d(s_ind_1(k),1)^2/a^2+trans_d(s_ind_1(k),2)^2/b^2+trans_d(s_ind_1(k),3)^2/c^2 <= 1
                    s_roi = [s_roi; s_ind_1(k)];
                end
            end

        end

    end
    
    s_roi = unique(s_roi);

    %remove sources already in previous roi
    s_roi_unique = setdiff(s_roi,all_roi_sources);
    
    
    if length(s_roi_unique)<length(s_roi)
        fprintf('\nOverlapping ROIs: Using only sources in first ROI that contains them!');
        s_roi = s_roi_unique;
    end

    all_roi_sources = [all_roi_sources; s_roi];

    %calculate measurement data...

    %scale 
    if fix_amp
        scale_amp = size(s_roi,1); %fixed amplitude for whole ROI
    else
        scale_amp = 1; %larger ROIS = larger amplitudes (fixed amplitude per source point)
    end
     
    if ~use_norm_ori %...using one source or many in sphere with same orientation
        for j = 1:size(s_roi,1)
            meas_data = meas_data + 1/scale_amp*(s_f(i,1)*L(:,3*(s_roi(j)-1)+1) + s_f(i,2)*L(:,3*(s_roi(j)-1)+2) + s_f(i,3)*L(:,3*(s_roi(j)-1)+3)); 
        end

    elseif use_norm_ori %...using normal orientation for restricted sources
        [interp_ind, L_projected] = zef_project_L_in_roi(s_roi,s_o(i,:),L,n_interp,procFile);   
        for j=1:size(s_roi,1)
            added_source = 1/scale_amp*1e-3*s_a(i)*(L_projected(:,interp_ind(j)));
            %added_source = added_source + noise_level*max(abs(added_source)).*randn(size(added_source));
            %meas_data = meas_data + 1/scale_amp*1e-3*s_a(i)*(L_projected(:,interp_ind(j))); 
            meas_data = meas_data + added_source;
        end
    end
    
    
    n_multiple_sources(i+1) = n_multiple_sources(i)+size(s_roi,1);
    
end


n_val = max(abs(meas_data));

%noise
meas_data = meas_data + noise_level*max(abs(meas_data)).*randn(size(meas_data));

%to output source positions in roi and orientations in case of norm
orientations = s_o;
if use_norm_ori
    for j=1:length(all_roi_sources)
        s_ind = find(s_ind_1(:)==all_roi_sources(j));
        orientations(j,:)=procFile.source_directions(s_ind,:);            
    end
else
 



end
